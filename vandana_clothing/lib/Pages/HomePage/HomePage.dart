import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vandana_clothing/Pages/Banners/Advertisement.dart';
import 'package:vandana_clothing/Pages/Banners/OfferProducts.dart';
import 'package:vandana_clothing/Pages/Cart/OrderPlaced.dart';
import 'package:vandana_clothing/Pages/Catagory/SubCatagory.dart';
import 'package:vandana_clothing/Pages/Login/LoginPageA.dart';
import 'package:vandana_clothing/Pages/AccountPage/AccountPage.dart';
import 'package:vandana_clothing/Pages/Cart/CartPage.dart';
import 'package:vandana_clothing/Pages/Catagory/CatPage.dart';
import 'package:vandana_clothing/Pages/Favourite/FavouritePage.dart';
import 'package:vandana_clothing/Pages/Notifications/Notification.dart';
import 'package:vandana_clothing/Pages/Order/OrderPage.dart';
import 'package:vandana_clothing/Pages/Product/ProductView.dart';
import 'package:vandana_clothing/Pages/Search/Search.dart';
import 'package:vandana_clothing/Pages/Setting/SettingPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

import '../testpage.dart';

class HomePage extends StatefulWidget {
  static Map<String,dynamic> uProfile;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    getProfile();
    getProducts();
    getBanners();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= 0) {
        getProducts();
      }
    });
  }
  Future<void> initDynamicLinks() async {
    await Future.delayed(Duration(seconds: 1));
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      DocumentSnapshot uPro = await FirebaseFirestore.instance.collection('Products').doc(deepLink.queryParameters['id']).get();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) => ProductView(pro_id: uPro.id,pro_img: uPro.data()['ProductImage'],pro_name: uPro.data()['ProductName'],)));
    }
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;
          if (deepLink != null) {
            DocumentSnapshot uPro = await FirebaseFirestore.instance.collection('Products').doc(deepLink.queryParameters['id']).get();
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) => ProductView(pro_id: uPro.id,pro_img: uPro.data()['ProductImage'],pro_name: uPro.data()['ProductName'],)));
          }
        },
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        }
    );

  }
  List<DocumentSnapshot> banners = [];
  bool bprocessed = false;

  List<DocumentSnapshot> products = [];
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 3;
  DocumentSnapshot lastDocument;
  ScrollController _scrollController = ScrollController();

  bool processed = false;


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  getProfile()async{
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Account').doc('Profile').get();
    HomePage.uProfile = ds.data();
    setState(() {
      processed = true;
    });
  }
  getBanners() async {
    QuerySnapshot querySnapshot;
    querySnapshot = await FirebaseFirestore.instance.collection('Banners').orderBy('PostDate',descending: true).get();
    banners.addAll(querySnapshot.docs);
    setState(() {
      bprocessed = true;
    });
  }
  getProducts() async {
    if (!hasMore) {
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await FirebaseFirestore.instance.collection('Products').where('Featured',isEqualTo: true).orderBy('PostDate',descending: true).limit(documentLimit).get();
    } else {
      querySnapshot = await FirebaseFirestore.instance.collection('Products').where('Featured',isEqualTo: true).orderBy('PostDate',descending: true).startAfterDocument(lastDocument).limit(documentLimit).get();
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    products.addAll(querySnapshot.docs);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(
          msg: "Logged Out...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      height: 200.h,
      child: (bprocessed == true)?
              (banners.isNotEmpty)?
                Carousel(
                  borderRadius: true,
                  radius: Radius.circular(20),
                  boxFit: BoxFit.cover,
                  images: banners.map((document) => GestureDetector(
                    onTap: ()async{
                      if(document.data()['BannerType'] == 'Advertisement'){
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => new Advertisement(
                              adtitle: document.data()['Title'],
                              addesc: document.data()['Description'],
                              adimage: document.data()['Image'],
                            )));
                      }
                      else if(document.data()['BannerType'] == 'Link'){
                        String url = document.data()['Link'];
                        if (await canLaunch(url))
                      await launch(url);
                      else
                      throw "Could not launch $url";
                      }
                      else if(document.data()['BannerType'] == 'Offer'){
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => new OfferProducts(bannerID: document.id,)));
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: CachedNetworkImage(
                        imageUrl:document.data()['Image'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: Image.asset("images/Ripple2.gif")),
                      ),
                    ),
                  ),).toList(),
                  autoplay: true,
                  autoplayDuration: Duration(milliseconds: 4000),
                  animationCurve: Curves.fastOutSlowIn,
                  animationDuration: Duration(milliseconds: 1000),
                  indicatorBgPadding: 6,
                  dotSize: 4,
                  dotIncreasedColor: Theme.of(context).accentColor,
                  dotColor: Colors.black,
                )
              :Image.asset("images/VC_bright.png")
            :Center(child: Image.asset("images/Spinner2.gif"))

    );
    Widget drawerHeader = SizedBox(
      child: Column(
        children: [
          (processed == true)?
          Column(
                  children: [
                    Hero(
                      tag:'pimg',
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: HomePage.uProfile['ProfileImage'],
                          placeholder: (context, url) =>
                              Center(child: Image.asset("images/Spinner2.gif")),
                          fit: BoxFit.cover,
                          width: 120.w,
                          height: 120.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      HomePage.uProfile['Name'],
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp),
                    )
                  ],
                )
                :Center(child: Image.asset("images/DualBall.gif",height: 100)),
          Padding(
            padding:  EdgeInsets.fromLTRB(0, 4.h, 0, 0),
            child: Text(
              FirebaseAuth.instance.currentUser.phoneNumber,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'HOME',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            "images/icons/menu.svg",
            height: 17.r,
            color: Theme.of(context).accentColor, //20
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        elevation: 0,
        //toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          new IconButton(
              icon: SvgPicture.asset(
                "images/icons/bag.svg",
                height: 20.r,
                color: Theme.of(context).accentColor, //20
              ),
              onPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.topToBottom, child: MyCart()))
          ),
          new IconButton(
              icon: Icon(
                Icons.notifications_none_rounded,
                color: Theme.of(context).accentColor,
                size: 25.r,
              ),
              onPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.topToBottom, child: MyNotifications()))),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: ListView(
            children: [
              Padding(
                padding:  EdgeInsets.fromLTRB(10.w, 30.h, 10.w, 15.h),
                child: drawerHeader,
              ),
              Divider(
                thickness: 1.h,
                color: Theme.of(context).accentColor,
                indent: 15.w,
                endIndent: 30.w,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: ListTile(
                  title: Text('Home',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: SvgPicture.asset(
                    "images/icons/home.svg",
                    height: 20.r,
                    color: Theme.of(context).accentColor, //20
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: MyAccount(Pimg: HomePage.uProfile['ProfileImage'],Pname: HomePage.uProfile['Name'],))),
                child: ListTile(
                  title: Text('Account',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.account_circle,
                      color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: Orders())),
                child: ListTile(
                  title: Text('Orders',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.shopping_basket,
                      color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: AllCatagories())),
                child: ListTile(
                  title: Text('Categories',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.category,
                      color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: FavouriteItems()));
                } ,
                child: ListTile(
                  title: Text('Favourites',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.favorite,
                      color: Theme.of(context).accentColor),
                ),
              ),
              Divider(
                thickness: 1.h,
                color: Theme.of(context).accentColor,
                indent: 15.w,
                endIndent: 30.w,
              ),
              InkWell(
                onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: MySetting())),
                child: ListTile(
                  title: Text('Setting',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(Icons.settings,
                      color: Theme.of(context).accentColor),
                ),
              ),
              InkWell(
                onTap: logout,
                child: ListTile(
                  title: Text('Sign Out',
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: new ListView(
        controller: _scrollController,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: InkWell(
              onTap: ()=> Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => Search())),
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(left: 20.w),
                      child: Text('Search Here...',
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w300)),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(right: 10.w),
                      child: Icon(Icons.search_rounded,color: Theme.of(context).accentColor,size: 25.r,),
                    )
                  ],

                ),
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(8.w, 20.h, 8.w, 8.h),
            child: image_carousel,
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 8.h),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(8.w, 8.h, 0, 0),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        //letterSpacing: 1.0
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    height: 250.h,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return ListView(
                                scrollDirection: Axis.horizontal,
                                children: snapshot.data.docs.map((document) => Padding(
                                  padding:  EdgeInsets.fromLTRB(0.w,10.h,0,15.h),
                                  child: Container(
                                    width: 130.w,
                                    child: InkWell(
                                      onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                                          builder: (context) => new SubCatagory(doc_id: document.id,doc_name: document['Name'],))),
                                      child: Center(
                                          child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(top:10.h),
                                                  width: 110.w,
                                                  height: 160.h,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(15.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl: document['Image'],
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) => Center(child: Image.asset("images/Ripple2.gif")),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:EdgeInsets.fromLTRB(5.w,5.h,5.w,0),
                                                  child: Container(
                                                    width: 120.w,
                                                    child: Center(
                                                        child: Text(document['Name'],
                                                            style: TextStyle(
                                                                color: Theme.of(context).secondaryHeaderColor,
                                                                fontSize: 15.sp,
                                                                fontWeight: FontWeight.w500))),
                                                  ),
                                                ),
                                              ])
                                      ),
                                    ),

                                  ),
                                ),).toList()
                            );
                          } else {
                            return Center(child: Image.asset("images/Spinner2.gif"));
                          }
                        }),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(bottom: 20.h),
                    child: Text(
                      'Featured Products',
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        //letterSpacing: 1.0
                      ),
                    ),
                  ),
                  if(products.length != 0)
                    Wrap(
                      children: products.map((mProduct) => Padding(
                        padding:  EdgeInsets.fromLTRB(5.w,10.h,5.w,15.h),
                        child: ProductTile(
                          pro_name: mProduct.data()['ProductName'],
                          pro_img: mProduct.data()['ProductImage'],
                          pro_price: mProduct.data()['ProductPrice'],
                          pro_discount: mProduct.data()['ProductDiscount'],
                          pro_subcat: mProduct.data()['SubCategoryName'],
                          pro_id: mProduct.id,
                        ),
                      )).toList(),
                    ),
                  if(isLoading && hasMore)
                    Padding(
                        padding:  EdgeInsets.only(top:5.h),
                        child: Center(
                            child: Image.asset(
                              "images/DualBall.gif",
                              height: 70,
                            )))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final String pro_name,pro_img,pro_id,pro_subcat;
  final int pro_price,pro_discount;

  const ProductTile({Key key, this.pro_name, this.pro_img, this.pro_price, this.pro_discount, this.pro_id, this.pro_subcat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170.w,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new ProductView(pro_id: pro_id,pro_img: pro_img,pro_name: pro_name,)));
        } ,
        child: Center(
            child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top:5.h),
                    width: 160.w,
                    height: 210.h,
                    child: Hero(
                      tag: pro_id,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: (pro_discount == 0)?CachedNetworkImage(
                            imageUrl:pro_img,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(child: Image.asset("images/Ripple2.gif")),
                          )
                              :
                          Stack(
                              fit:StackFit.expand,
                              children: [CachedNetworkImage(
                                imageUrl:pro_img,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(child: Image.asset("images/Ripple2.gif")),
                              ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: CircleAvatar(
                                    radius: 15.r,
                                    backgroundColor: Theme.of(context).accentColor,
                                    child: Text(pro_discount.toString() + '%',style: TextStyle(color: Colors.black,fontSize: 10.sp,fontWeight: FontWeight.w500),),
                                  ),
                                )

                              ]
                          )
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.fromLTRB(5.w,5.h,5.w,5.h),
                        child: Center(
                            child: Text(pro_name,
                                style: TextStyle(
                                    color: Theme.of(context).secondaryHeaderColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600))),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.w,0,5.w,5.h),
                        child: Center(
                            child: (pro_discount == 0)?
                            Text('₹ ' + pro_price.toString(),
                                style: TextStyle(
                                    color: Theme.of(context).secondaryHeaderColor,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600))

                                :
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('₹ ' + pro_price.toString(),
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w300)),
                                Text('  ₹ ' + (pro_price - (pro_price * pro_discount)/100).round().toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600)),
                              ],
                            )),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(bottom: 10.h),
                        child: Container(width:150.w,child: Center(child: Text(pro_subcat,style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 12.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,))),
                      ),
                    ],
                  ),

                ])
        ),
      ),

    );
  }
}

