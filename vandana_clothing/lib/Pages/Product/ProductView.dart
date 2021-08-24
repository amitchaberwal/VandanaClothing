import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vandana_clothing/Pages/AccountPage/Utils/NewMeasurement.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vandana_clothing/Pages/Cart/CartPage.dart';
import 'package:share/share.dart';
class ProductView extends StatefulWidget {
  final String pro_id, pro_name, pro_img;

  const ProductView({Key key, this.pro_id, this.pro_name, this.pro_img})
      : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  Color faviconcolor = Colors.grey;
  String im1, im2, im3, im4;
  @override

  Future<String> shareProduct(String productID) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://v4tech.page.link',
      link: Uri.parse('https://v4tech.page.link/product?id=$productID'),
      androidParameters: AndroidParameters(
        packageName: 'com.v4tech.vandana_clothing',
        fallbackUrl: Uri.parse('www.google.com'),
      ),
      iosParameters: IosParameters(
        bundleId: 'com.v4tech.vandana_clothing',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
    );

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;

    final Uri dynamicUrl = await parameters.buildUrl();
    Share.share(shortUrl.toString());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          widget.pro_name,
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        //toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          FutureBuilder(
            future: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Favourites').doc(widget.pro_id).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> fdata) {
              if (fdata.hasData) {
                if (fdata.data.exists) {
                  faviconcolor = Colors.pink;
                  return IconButton(
                      icon: Icon(Icons.favorite, color: faviconcolor, size: 35.r,
                      ),
                      onPressed: () async {
                        var fav = await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Favourites').doc(widget.pro_id).get();
                        if (fav.exists) {
                          await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Favourites').doc(widget.pro_id).delete();
                          Fluttertoast.showToast(
                              msg: "Removed from Favourites",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Theme.of(context).cardColor,
                              textColor: Theme.of(context).secondaryHeaderColor,
                              fontSize: 16);
                        } else {
                          await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Favourites').doc(widget.pro_id).set({
                            'ProductName': widget.pro_name,
                          });
                          Fluttertoast.showToast(
                              msg: "Added to Favourites",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Theme.of(context).cardColor,
                              textColor: Theme.of(context).secondaryHeaderColor,
                              fontSize: 16);
                        }
                        setState(() {
                          if (faviconcolor == Colors.grey) {
                            faviconcolor = Colors.pink;
                          } else {
                            faviconcolor = Colors.grey;
                          }
                        });
                      });
                } else {
                  faviconcolor = Colors.grey;
                  return IconButton(
                      icon: Icon(Icons.favorite, color: faviconcolor, size: 35.r,
                      ),
                      onPressed: () async {
                        var fav = await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Favourites').doc(widget.pro_id).get();
                        if (fav.exists) {
                          await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Favourites').doc(widget.pro_id).delete();
                          Fluttertoast.showToast(
                              msg: "Removed from Favourites",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Theme.of(context).cardColor,
                              textColor: Theme.of(context).secondaryHeaderColor,
                              fontSize: 16.0);
                        } else {
                          await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Favourites').doc(widget.pro_id).set({
                            'ProductName': widget.pro_name,
                          });
                          Fluttertoast.showToast(
                              msg: "Added to Favourites",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Theme.of(context).cardColor,
                              textColor: Theme.of(context).secondaryHeaderColor,
                              fontSize: 16.0);
                        }
                        setState(() {
                          if (faviconcolor == Colors.grey) {
                            faviconcolor = Colors.pink;
                          } else {
                            faviconcolor = Colors.grey;
                          }
                        });
                      });
                }
              } else {
                return Icon(Icons.favorite, color: Theme.of(context).primaryColor, size: 35.r,
                );
              }
            },
          ),
          IconButton(
              icon: SvgPicture.asset(
                "images/icons/bag.svg",
                height: 22.r,
                color: Theme.of(context).accentColor, //20
              ),
              onPressed: () => Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.topToBottom, child: MyCart()))),

          IconButton(
              icon: Icon(Icons.share_rounded,color: Theme.of(context).accentColor,size: 30.r,),
              onPressed: () {
                shareProduct(widget.pro_id);
              }),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 300.w,
                height: 450.h,
                child: FutureBuilder(
                    future: FirebaseFirestore.instance.collection('Products').doc(widget.pro_id).get(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> pdata) {
                      if (pdata.hasData) {
                        return Carousel(
                          borderRadius: true,
                          radius: Radius.circular(15),
                          boxFit: BoxFit.cover,
                          images: [
                            Hero(
                              tag: widget.pro_id,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: CachedNetworkImage(
                                  imageUrl: widget.pro_img,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                      child: Image.asset(
                                          "images/Ripple2.gif")),
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                imageUrl: pdata.data['Images']['ImageA'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                    child: Image.asset(
                                        "images/Ripple2.gif")),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                imageUrl: pdata.data['Images']['ImageB'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                    child: Image.asset(
                                        "images/Ripple2.gif")),
                              ),
                            ),
                            if(pdata.data['Images']['ImageC']!= null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                imageUrl: pdata.data['Images']['ImageC'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                    child: Image.asset(
                                        "images/Ripple2.gif")),
                              ),
                            ),
                            if(pdata.data['Images']['ImageC']!= null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                imageUrl: pdata.data['Images']['ImageD'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                    child: Image.asset(
                                        "images/Ripple2.gif")),
                              ),
                            )],
                          autoplay: false,
                          animationCurve: Curves.fastOutSlowIn,
                          animationDuration: Duration(milliseconds: 1000),
                          indicatorBgPadding: 6,
                          dotSize: 4,
                          dotIncreasedColor: Theme.of(context).accentColor,
                          dotColor: Colors.black,
                        );
                      } else {
                        return Carousel(
                          borderRadius: true,
                          radius: Radius.circular(15),
                          boxFit: BoxFit.cover,
                          images: [Hero(
                            tag: widget.pro_id,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                imageUrl: widget.pro_img,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                    child: Image.asset(
                                        "images/Ripple2.gif")),
                              ),
                            ),
                          ),],
                          autoplay: false,
                          animationCurve: Curves.fastOutSlowIn,
                          animationDuration: Duration(milliseconds: 1000),
                          indicatorBgPadding: 6,
                          dotSize: 4,
                          dotIncreasedColor: Theme.of(context).accentColor,
                          dotColor: Colors.black,
                        );
                      }
                    })),
          ),
          FutureBuilder(
              future: FirebaseFirestore.instance.collection('Products').doc(widget.pro_id).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> mdata) {
                if (mdata.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 15.h, 5.w, 5.h),
                        child: Center(
                            child: (mdata.data["ProductDiscount"] == 0)
                                ? Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text("Price: ",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w300)),
                                Text(
                                    '₹ ' + mdata.data["ProductPrice"].toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w800)),
                              ],
                            )
                                : Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text("Price: ",
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w300)),
                                Column(
                                  children: [
                                    Text(
                                        '₹ ' + mdata.data["ProductPrice"].toString(),
                                        style: TextStyle(decoration:
                                            TextDecoration.lineThrough,
                                            color: Theme.of(context).secondaryHeaderColor,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w400)),
                                    Text(mdata.data["ProductDiscount"].toString() + '% off',
                                        style: TextStyle(color: Colors.red,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w800)),
                                  ],
                                ),

                                Text(
                                    '  ₹ ' + (mdata.data["ProductPrice"] - (mdata.data["ProductPrice"] * mdata.data["ProductDiscount"]) / 100).round().toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w800)),
                              ],
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 10.h),
                        child: Center(
                          child: Text(mdata.data["ProductDescription"],
                              style: TextStyle(
                                  color:
                                  Theme.of(context).secondaryHeaderColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w300)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.h),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Fabric: ',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300)),
                              Text(mdata.data["ProductFabric"],
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ),
                      FutureBuilder(
                          future: FirebaseFirestore.instance.collection('Fabric').doc(mdata.data['FabricID']).get(),
                          builder: (context, AsyncSnapshot<DocumentSnapshot>mdataa) {
                            if (mdataa.hasData) {
                              return Column(
                                children: [
                                  (mdataa.data['FabricStock'] != 0)
                                      ? Padding(
                                      padding: EdgeInsets.symmetric(vertical: 20.h),
                                      child: SizedBox(
                                        height: 70.h,
                                        width: 220.w,
                                        child: MaterialButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AddToCart(apro_id: mdata.data.id,subcatName: mdata.data['SubCategoryName']);
                                                });
                                          },
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Add to Cart",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18.sp,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                SizedBox(width: 20.w,),
                                                Icon(
                                                  Icons.add_shopping_cart_rounded,
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                          ),
                                          color: Theme.of(context).accentColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(15.0)),
                                        ),
                                      ))
                                      : Padding(
                                    padding: EdgeInsets.only(top: 40.h),
                                    child: Center(
                                        child: Text(
                                          'Out Of Stock',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w700),
                                        )),
                                  ),
                                ],
                              );
                            } else {
                              return Center(
                                  child: Image.asset(
                                    "images/DualBall.gif",
                                    height: 80,
                                  ));
                            }
                          }),
                    ],
                  );
                } else {
                  return Center(
                      child: Image.asset(
                        "images/DualBall.gif",
                        height: 80,
                      ));
                }
              })
        ],
      ),
    );
  }
}

class AddToCart extends StatefulWidget {
  final String apro_id,subcatName;

  const AddToCart({Key key, this.apro_id, this.subcatName,}) : super(key: key);

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  String sSize;
  List<dynamic> NeckID=[null,null,null,null],SleeveID=[null,null,null,null],SleeveLengthID=[null,null,null,null],PipingID=[null,null,null,null],PonchaID=[null,null,null,null],CollarID=[null,null,null,null];
  Map<String,dynamic> sDesigns = {'NeckDesign':null,'SleeveDesign':null,'PipingDesign':null,'PonchaDesign':null,'SleeveLength':null,'CollarDesign':null,'Lining':null};
  Map<String,dynamic> sPrices = {'NeckDesign':null,'SleeveDesign':null,'PipingDesign':null,'PonchaDesign':null,'SleeveLength':null,'CollarDesign':null,'Lining':null};

  bool liningEnabled = false;

  int initCharges = 0;
  int initPrice = 0;
  int totalPrice = 0;
  int finalCharges = 0;
  ProgressDialog pr;
  bool processed = false;
  int discount = 0;

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  void updatePrice(){
    totalPrice = 0;
    finalCharges = 0;
    var lPrice = sPrices.values;
    lPrice.forEach((element) {
      if(element != null){
        finalCharges += element;
      }
    });
    int tPrice = initPrice + finalCharges;
    setState(() {
      totalPrice = (tPrice - (tPrice * discount)/100).round();
    });
  }

  getProduct()async{
    if(widget.apro_id == 'CustomFabric'){
      DocumentSnapshot dsub = await FirebaseFirestore.instance.collection('SubCategories').doc(widget.subcatName).get();
      initPrice = dsub.data()['StitchingPrice'];
      totalPrice = initPrice + initCharges;
      setState(() {
        processed = true;
      });
    }
    else{
      DocumentSnapshot ds = await FirebaseFirestore.instance.collection('Products').doc(widget.apro_id).get();
      if(ds.data()['ProductType'] == 'Dress'){
        if(ds.data()['Designs']['CollarDesign']!= null){
          DocumentSnapshot dss = await FirebaseFirestore.instance.collection('Designs').doc(ds.data()['Designs']['CollarDesign']).get();
          CollarID[0] = dss.id;
          CollarID[1] = dss.data()['Name'];
          CollarID[2] = dss.data()['Image'];
          CollarID[3] = dss.data()['Price'];
          sDesigns['CollarDesign'] = dss.id;
          sPrices['CollarDesign'] = dss.data()['Price'];
        }

        if(ds.data()['Designs']['NeckDesign']!= null){
          DocumentSnapshot dss = await FirebaseFirestore.instance.collection('Designs').doc(ds.data()['Designs']['NeckDesign']).get();
          NeckID[0] = dss.id;
          NeckID[1] = dss.data()['Name'];
          NeckID[2] = dss.data()['Image'];
          NeckID[3] = dss.data()['Price'];
          sDesigns['NeckDesign'] = dss.id;
          sPrices['NeckDesign'] = dss.data()['Price'];
        }

        if(ds.data()['Designs']['SleeveDesign']!= null){
          DocumentSnapshot dss = await FirebaseFirestore.instance.collection('Designs').doc(ds.data()['Designs']['SleeveDesign']).get();
          SleeveID[0] = dss.id;
          SleeveID[1] = dss.data()['Name'];
          SleeveID[2] = dss.data()['Image'];
          SleeveID[3] = dss.data()['Price'];
          sDesigns['SleeveDesign'] = dss.id;
          sPrices['SleeveDesign'] = dss.data()['Price'];
        }

        if(ds.data()['Designs']['PipingDesign']!= null){
          DocumentSnapshot dss = await FirebaseFirestore.instance.collection('Designs').doc(ds.data()['Designs']['PipingDesign']).get();
          PipingID[0] = dss.id;
          PipingID[1] = dss.data()['Name'];
          PipingID[2] = dss.data()['Image'];
          PipingID[3] = dss.data()['Price'];
          sDesigns['PipingDesign'] = dss.id;
          sPrices['PipingDesign'] = dss.data()['Price'];
        }

        if(ds.data()['Designs']['PonchaDesign']!= null){
          DocumentSnapshot dss = await FirebaseFirestore.instance.collection('Designs').doc(ds.data()['Designs']['PonchaDesign']).get();
          PonchaID[0] = dss.id;
          PonchaID[1] = dss.data()['Name'];
          PonchaID[2] = dss.data()['Image'];
          PonchaID[3] = dss.data()['Price'];
          sDesigns['PonchaDesign'] = dss.id;
          sPrices['PonchaDesign'] = dss.data()['Price'];
        }

        if(ds.data()['Designs']['SleeveLength']!= null){
          SleeveLengthID[0] = ds.data()['Designs']['SleeveLength'];
          sDesigns['SleeveLength'] = ds.data()['Designs']['SleeveLength'];
        }

        if(ds.data()['Designs']['Lining']!= null){
          liningEnabled = true;
          sDesigns['Lining'] = ds.data()['Designs']['Lining'];
          sPrices['Lining'] = ds.data()['Designs']['Lining'];
        }
      }
      discount = ds.data()['ProductDiscount'];
      totalPrice = (ds.data()['ProductPrice'] - (ds.data()['ProductPrice'] * ds.data()['ProductDiscount'])/100).round();
      var lPrice = sPrices.values;
      lPrice.forEach((element) {
        if(element != null){
          initCharges += element;
        }
      });
      int basePrice = ds.data()['ProductPrice'];
      initPrice = basePrice - initCharges;
      setState(() {
        processed = true;
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Adding to Cart...',
        borderRadius: 10.0,
        backgroundColor: Theme.of(context).primaryColor,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 19.sp,
            fontWeight: FontWeight.w600));

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 630.h,
        margin: EdgeInsets.only(top: 1.h),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Center(
                child: Text(
                  'Add To Cart',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 15.h),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Measurement').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.isNotEmpty) {
                        return DropdownButtonFormField(
                          hint: Text(
                            'Choose Body Size',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor),
                          ),
                          style: TextStyle(color: Colors.white),
                          value: sSize,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ),
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              sSize = newValue;
                            });
                          },
                          items: snapshot.data.docs.map((document) {
                            return DropdownMenuItem(
                              child: new Text(
                                document.id,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Theme.of(context).secondaryHeaderColor),
                              ),
                              value: document.id,
                            );
                          }).toList(),
                        );
                      } else {
                        return FlatButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return NewMeasurement();
                                });
                          },
                          child: Center(
                            child: ListTile(
                              leading: Icon(
                                Icons.add_rounded,
                                color: Colors.black,
                              ),
                              title: Text(
                                "Add Measurement",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          color: Theme.of(context).accentColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                        );
                      }
                    } else {
                      return Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Getting Body Measurements...',
                                style: TextStyle(
                                    color: Theme.of(context).secondaryHeaderColor),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Image.asset("images/Spinner1.gif",height: 20.h,width: 20.w,),
                            ],
                          ));
                    }
                  }),
            ),
            Center(
              child: Text(
                "Customize",
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800),
              ),
            ),
            (processed == true)?
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 15.w),
              child: FutureBuilder(
                  future: FirebaseFirestore.instance.collection('SubCategories').doc(widget.subcatName).get(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> mdata) {
                    if (mdata.hasData) {
                      return Column(
                        children: [
                          Container(
                            height: 400.h,
                            width: 290.w,
                            child: SingleChildScrollView(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                direction: Axis.horizontal,
                                children: [
                                  if(mdata.data['Features']['NeckDesign'] == true)
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
                                      child: Column(
                                        children: [
                                          Text(
                                              'Neck',
                                              style: TextStyle(
                                                  color: Theme.of(context).secondaryHeaderColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400)
                                          ),
                                          Container(
                                            height: 150.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: InkWell(
                                              onTap: () async{
                                                var neckData = await showDialog(context: context,
                                                    builder: (BuildContext context) {
                                                      return ChooseDesign(designType: 'NeckDesign',designID: NeckID,);
                                                    });
                                                if(neckData != null){
                                                  setState(() {
                                                    if(neckData[0] == 'None'){
                                                      NeckID = [null,null,null,null];
                                                    }
                                                    else{
                                                      NeckID = neckData;
                                                    }
                                                  });
                                                  sDesigns['NeckDesign'] = NeckID[0];
                                                  sPrices['NeckDesign'] = NeckID[3];
                                                  updatePrice();
                                                }
                                              },
                                              child: NeckID[0] != null
                                                  ? Column(
                                                children: [
                                                  Padding(
                                                    padding:  EdgeInsets.only(top:5.h,bottom: 5.h),
                                                    child: Container(
                                                      height:120.h,
                                                      width:90.w,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: CachedNetworkImage(
                                                          imageUrl:NeckID[2],
                                                          fit: BoxFit.cover,
                                                          placeholder: (context, url) => Center(child: Image.asset("images/Ripple2.gif")),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      '₹ '+ NeckID[3].toString(),
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w400)
                                                  )
                                                ],
                                              )
                                                  :
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.color_lens_rounded,
                                                    size: 40.r,
                                                    color: Theme.of(context).accentColor,
                                                  ),
                                                  Text(
                                                      'Choose\nNeck\nDesign',
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w300)
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(mdata.data['Features']['SleeveDesign'] == true)
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
                                      child: Column(
                                        children: [
                                          Text(
                                              'Sleeve',
                                              style: TextStyle(
                                                  color: Theme.of(context).secondaryHeaderColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400)
                                          ),
                                          Container(
                                            height: 150.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),

                                            child: InkWell(
                                              onTap: () async{
                                                var sleeveData = await showDialog(context: context,
                                                    builder: (BuildContext context) {
                                                      return ChooseDesign(designType: 'SleeveDesign',designID: SleeveID,);
                                                    });
                                                if(sleeveData != null){
                                                  setState(() {
                                                    if(sleeveData[0] == 'None'){
                                                      SleeveID = [null,null,null,null];
                                                    }
                                                    else{
                                                      SleeveID = sleeveData;
                                                    }
                                                  });
                                                  sDesigns['SleeveDesign'] = SleeveID[0];
                                                  sPrices['SleeveDesign'] = SleeveID[3];
                                                  updatePrice();
                                                }
                                              },
                                              child: SleeveID[0] != null
                                                  ? Column(
                                                children: [
                                                  Padding(
                                                    padding:  EdgeInsets.only(top:5.h,bottom: 5.h),
                                                    child: Container(
                                                      height:120.h,
                                                      width:90.w,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: CachedNetworkImage(
                                                          imageUrl:SleeveID[2],
                                                          fit: BoxFit.cover,
                                                          placeholder: (context, url) => Center(child: Image.asset("images/Ripple2.gif")),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      '₹ '+ SleeveID[3].toString(),
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w400)
                                                  )
                                                ],
                                              )
                                                  :
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.color_lens_rounded,
                                                    size: 40.r,
                                                    color: Theme.of(context).accentColor,
                                                  ),
                                                  Text(
                                                      'Choose\nSleeve\nDesign',
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w300)
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(mdata.data['Features']['PipingDesign'] == true)
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
                                      child: Column(
                                        children: [
                                          Text(
                                              'Piping',
                                              style: TextStyle(
                                                  color: Theme.of(context).secondaryHeaderColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400)
                                          ),
                                          Container(
                                            height: 150.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: InkWell(
                                              onTap: () async{
                                                var pipingData = await showDialog(context: context,
                                                    builder: (BuildContext context) {
                                                      return ChooseDesign(designType: 'PipingDesign',designID:PipingID);
                                                    });
                                                if(pipingData != null){
                                                  setState(() {
                                                    PipingID = pipingData;

                                                    if(pipingData[0] == 'None'){
                                                      PipingID = [null,null,null,null];
                                                    }
                                                    else{
                                                      PipingID = pipingData;
                                                    }
                                                  });
                                                  sDesigns['PipingDesign'] = PipingID[0];
                                                  sPrices['PipingDesign'] = PipingID[3];
                                                  updatePrice();
                                                }
                                              },
                                              child: PipingID[0] != null
                                                  ? Column(
                                                children: [
                                                  Padding(
                                                    padding:  EdgeInsets.only(top:5.h,bottom: 5.h),
                                                    child: Container(
                                                      height:120.h,
                                                      width:90.w,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: CachedNetworkImage(
                                                          imageUrl:PipingID[2],
                                                          fit: BoxFit.cover,
                                                          placeholder: (context, url) => Center(child: Image.asset("images/Ripple2.gif")),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      '₹ '+ PipingID[3].toString(),
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w400)
                                                  )
                                                ],
                                              )
                                                  :
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.color_lens_rounded,
                                                    size: 40.r,
                                                    color: Theme.of(context).accentColor,
                                                  ),
                                                  Text(
                                                      'Choose\nPiping\nDesign',
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w300)
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(mdata.data['Features']['PonchaDesign'] == true)
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
                                      child: Column(
                                        children: [
                                          Text(
                                              'Poncha',
                                              style: TextStyle(
                                                  color: Theme.of(context).secondaryHeaderColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400)
                                          ),
                                          Container(
                                            height: 150.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: InkWell(
                                              onTap: () async{
                                                var ponchaData = await showDialog(context: context,
                                                    builder: (BuildContext context) {
                                                      return ChooseDesign(designType: 'PonchaDesign',designID:PonchaID);
                                                    });
                                                if(ponchaData!= null){
                                                  setState(() {
                                                    PonchaID = ponchaData;
                                                    if(ponchaData[0] == 'None'){
                                                      PonchaID = [null,null,null,null];
                                                    }
                                                    else{
                                                      PonchaID = ponchaData;
                                                    }
                                                  });
                                                  sDesigns['PonchaDesign'] = PonchaID[0];
                                                  sPrices['PonchaDesign'] = PonchaID[3];
                                                  updatePrice();
                                                }
                                              },
                                              child: PonchaID[0] != null
                                                  ? Column(
                                                children: [
                                                  Padding(
                                                    padding:  EdgeInsets.only(top:5.h,bottom: 5.h),
                                                    child: Container(
                                                      height:120.h,
                                                      width:90.w,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: CachedNetworkImage(
                                                          imageUrl:PonchaID[2],
                                                          fit: BoxFit.cover,
                                                          placeholder: (context, url) => Center(child: Image.asset("images/Ripple2.gif")),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      '₹ '+ PonchaID[3].toString(),
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w400)
                                                  )
                                                ],
                                              )
                                                  :
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.color_lens_rounded,
                                                    size: 40.r,
                                                    color: Theme.of(context).accentColor,
                                                  ),
                                                  Text(
                                                      'Choose\nPoncha\nDesign',
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w300)
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(mdata.data['Features']['CollarDesign'] == true)
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
                                      child: Column(
                                        children: [
                                          Text(
                                              'Collar',
                                              style: TextStyle(
                                                  color: Theme.of(context).secondaryHeaderColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400)
                                          ),
                                          Container(
                                            height: 150.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: InkWell(

                                              onTap: () async{
                                                var collarData = await showDialog(context: context,
                                                    builder: (BuildContext context) {
                                                      return ChooseDesign(designType: 'CollarDesign',designID:CollarID);
                                                    });
                                                if(collarData!=null){
                                                  setState(() {
                                                    CollarID = collarData;

                                                    if(collarData[0] == 'None'){
                                                      CollarID = [null,null,null,null];
                                                    }
                                                    else{
                                                      CollarID = collarData;
                                                    }
                                                  });
                                                  sDesigns['CollarDesign'] = CollarID[0];
                                                  sPrices['CollarDesign'] = CollarID[3];
                                                  updatePrice();
                                                }
                                              },
                                              child: CollarID[0] != null
                                                  ? Column(
                                                children: [
                                                  Padding(
                                                    padding:  EdgeInsets.only(top:5.h,bottom: 5.h),
                                                    child: Container(
                                                      height:120.h,
                                                      width:90.w,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: CachedNetworkImage(
                                                          imageUrl:CollarID[2],
                                                          fit: BoxFit.cover,
                                                          placeholder: (context, url) => Center(child: Image.asset("images/Ripple2.gif")),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      '₹ '+ CollarID[3].toString(),
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w400)
                                                  )
                                                ],
                                              )
                                                  :
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.color_lens_rounded,
                                                    size: 40.r,
                                                    color: Theme.of(context).accentColor,
                                                  ),
                                                  Text(
                                                      'Choose\nCollar\nDesign',
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w300)
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(mdata.data['Features']['SleeveLength'] == true)
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
                                      child: Column(
                                        children: [
                                          Text(
                                              'Sleeve Length',
                                              style: TextStyle(
                                                  color: Theme.of(context).secondaryHeaderColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400)
                                          ),
                                          Container(
                                            height: 150.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: InkWell(
                                              onTap: () async{
                                                var sleevelengthData = await showDialog(context: context,
                                                    builder: (BuildContext context) {
                                                      return ChooseDesign(designType: 'SleeveLength',designID:SleeveLengthID);
                                                    });
                                                if(sleevelengthData!=null){
                                                  setState(() {
                                                    SleeveLengthID = sleevelengthData;

                                                    if(sleevelengthData[0] == 'None'){
                                                      SleeveLengthID = [null,null,null,null];
                                                    }
                                                    else{
                                                      SleeveLengthID = sleevelengthData;
                                                    }
                                                  });
                                                  sDesigns['SleeveLength'] = SleeveLengthID[0];
                                                }
                                              },
                                              child: SleeveLengthID[0] != null
                                                  ? Column(
                                                mainAxisAlignment:MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      SleeveLengthID[0].toString(),
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w400)
                                                  )
                                                ],
                                              )
                                                  :
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.zoom_out_map_rounded,
                                                    size: 40.r,
                                                    color: Theme.of(context).accentColor,
                                                  ),
                                                  Text(
                                                      'Choose\nSleeve\nLength',
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w300)
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(mdata.data['Lining'] != false)
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
                                      child: Column(
                                        children: [
                                          Text(
                                              'Lining',
                                              style: TextStyle(
                                                  color: Theme.of(context).secondaryHeaderColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400)
                                          ),
                                          Container(
                                            height: 150.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: InkWell(
                                              onTap: () async{
                                                setState(() {
                                                  liningEnabled = !liningEnabled;
                                                });
                                                if(liningEnabled == true){
                                                  sPrices['Lining'] = mdata.data['Lining'];
                                                  sDesigns['Lining'] = mdata.data['Lining'];
                                                }
                                                else{
                                                  sPrices['Lining'] = null;
                                                  sDesigns['Lining'] = null;
                                                }
                                                updatePrice();
                                              },
                                              child: Stack(
                                                  children:[
                                                    Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            Icons.line_weight,
                                                            size: 40.r,
                                                            color: Theme.of(context).accentColor,
                                                          ),
                                                          Text(
                                                              'Set\nLining',
                                                              style: TextStyle(
                                                                  color: Theme.of(context).secondaryHeaderColor,
                                                                  fontSize: 14.sp,
                                                                  fontWeight: FontWeight.w300)
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    if (liningEnabled == true)
                                                      Container(
                                                        width: 100.w,
                                                        height: 150.h,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15.0),
                                                            color: Theme.of(context).accentColor.withOpacity(0.7)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(
                                                              Icons.done,
                                                              color: Colors.black,
                                                              size: 40.r,
                                                            ),
                                                            Text(
                                                                '₹' + mdata.data['Lining'].toString(),
                                                                style: TextStyle(
                                                                    color: Theme.of(context).secondaryHeaderColor,
                                                                    fontSize: 16.sp,
                                                                    fontWeight: FontWeight.w900)
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                  ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(top:10.h,left: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Total Price: ',
                                      style: TextStyle(
                                          color: Theme.of(context).secondaryHeaderColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text('₹' + totalPrice.toString(),
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 60.h,
                                  child: FlatButton(
                                    shape: CircleBorder(
                                    ),
                                    onPressed: () async{
                                      if (sSize != null) {
                                        totalPrice = 0;
                                        int finalCharges = 0;
                                        var lPrice = sPrices.values;
                                        lPrice.forEach((element) {
                                          if(element != null){
                                            finalCharges += element;
                                          }
                                        });
                                        totalPrice = initPrice + finalCharges;
                                        await pr.show();
                                        Map<String,dynamic> cartData = new Map();
                                        cartData['ProductID'] = widget.apro_id;
                                        cartData['InitCharges'] = initCharges;
                                        cartData['FinalCharges'] = finalCharges;
                                        cartData['SubCategory'] = widget.subcatName;
                                        cartData['Designs'] = sDesigns;
                                        cartData['DesignPrice'] = sPrices;
                                        cartData['MeasurementTitle'] = sSize;
                                        if(widget.apro_id == 'CustomFabric'){
                                          cartData['ProductPrice'] = initPrice;
                                        }

                                          await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Cart').doc().set(cartData);
                                          await pr.hide();
                                          Navigator.of(context).pop();
                                          Fluttertoast.showToast(
                                              msg: "Added to Cart",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor:
                                              Theme.of(context).cardColor,
                                              textColor: Theme.of(context).secondaryHeaderColor,
                                              fontSize: 16.0);
                                        } else {
                                        Fluttertoast.showToast(
                                            msg: "Select Body Size!!!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Theme.of(context).cardColor,
                                            textColor: Theme.of(context).secondaryHeaderColor,
                                            fontSize: 16.0);
                                      }
                                    },
                                    child: Icon(Icons.add_shopping_cart_rounded,color: Colors.black,size: 30.r,),
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                          child: Image.asset(
                            "images/DualBall.gif",
                            height: 80,
                          ));
                    }
                  }),
            ):
            Center(
                child: Image.asset(
                  "images/DualBall.gif",
                  height: 80,
                )),
          ],
        ),
      ),
    );
  }
}


class ChooseDesign extends StatefulWidget {
  final String designType;
  final List designID;

  const ChooseDesign({Key key, this.designType, this.designID}) : super(key: key);
  @override
  _ChooseDesignState createState() => _ChooseDesignState();
}

class _ChooseDesignState extends State<ChooseDesign> {
  List<dynamic> selectedID = [null,null,null,null];
  List<bool> isSelected = [false, false, false,false,false];
  List<String> SLength = ['0','1/4','1/2','3/4','1'];
  @override
  void initState() {
    super.initState();
      setState(() {
        if (widget.designID[0] != null) {
        if (widget.designType == 'SleeveLength') {
          if (widget.designID[0] == '0') {
            isSelected[0] = true;
            selectedID[0] = '0';
          }
          if (widget.designID[0] == '1/4') {
            isSelected[1] = true;
            selectedID[0] = '1/4';
          }
          if (widget.designID[0] == '1/2') {
            isSelected[2] = true;
            selectedID[0] = '1/2';
          }
          if (widget.designID[0] == '3/4') {
            isSelected[3] = true;
            selectedID[0] = '3/4';
          }
          if (widget.designID[0] == '1') {
            isSelected[4] = true;
            selectedID[0] = '1';
          }
        } else {
          selectedID = widget.designID;
        }
      }
        else{
          selectedID = ['None','None','None','None'];
        }
      });
  }
  @override

  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
          height: 610.h,
          margin: EdgeInsets.only(top: 1.h),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Center(
                child: Text(
                  'Choose Design',
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Text(
                'Long Press To Enlarge Image',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              height: 510.h,
              child: (widget.designType == 'SleeveLength')?
              Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Choose Length', style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:10.h),
                    child: SizedBox(
                      height: 55.h,
                      child: ToggleButtons(
                        children: <Widget>[
                          Text(
                            '0',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            '1/4',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            '1/2',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            '3/4',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            '1',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                        fillColor: Theme.of(context).accentColor,
                        isSelected: isSelected,
                        borderColor: Theme.of(context).secondaryHeaderColor,
                        borderRadius: BorderRadius.circular(10),
                        onPressed: (int index) {
                          setState(() {
                            for (int indexBtn = 0;indexBtn < isSelected.length;indexBtn++) {
                              if (indexBtn == index) {
                                isSelected[indexBtn] = !isSelected[indexBtn];
                              } else {
                                isSelected[indexBtn] = false;
                              }
                              if(isSelected[indexBtn] == true){
                                selectedID[0] = SLength[index];
                              }
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),)
                  :SingleChildScrollView(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Designs').where('Type',isEqualTo: widget.designType).snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(snapshot.hasData){
                        return Wrap(
                          children: [
                            Padding(
                              padding:  EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
                              child: Container(
                                width: 120.w,
                                height: 120.h,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap:(){
                                        setState(() {
                                          selectedID[0] = 'None';
                                          selectedID[1] = 'None';
                                          selectedID[2] = 'None';
                                          selectedID[3] = 'None';
                                        });
                                      },
                                      child: Stack(
                                          children:[
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.h, 0),
                                              child: Container(
                                                width:110.w,
                                                height: 80.h,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                  child: Icon(Icons.block,size: 35.r,color: Theme.of(context).secondaryHeaderColor,),
                                                ),
                                              ),
                                            ),
                                            if(selectedID[0] == 'None')
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.h, 0),
                                                child: Container(
                                                  width:100.w,
                                                  height: 80.h,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15.0),
                                                      color: Theme.of(context).accentColor.withOpacity(0.7)
                                                  ),
                                                  child: Icon(Icons.done,color: Colors.black,size: 40.r,),
                                                ),
                                              )
                                          ]
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:  EdgeInsets.only(top:5.h),
                                          child: Text('None',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w400),),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Wrap(
                            children:
                              snapshot.data.docs.map((document) => Padding(
                              padding:  EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
                              child: new
                              Container(
                                width: 120.w,
                                height: 195.h,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onLongPress: (){
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ShowImage(imageurl: document['Image'],);
                                            });
                                      },
                                      onTap:(){
                                        setState(() {
                                          selectedID[0] = document.id;
                                          selectedID[1] = document['Name'];
                                          selectedID[2] = document['Image'];
                                          selectedID[3] = document['Price'];
                                        });
                                      },
                                      child: Stack(
                                          children:[
                                            Container(
                                              padding: EdgeInsets.fromLTRB(5.w, 10.h, 5.w, 0),
                                              width:110.w,
                                              height: 150.h,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(15.0),
                                                child: CachedNetworkImage(
                                                  imageUrl:document['Image'],
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Center(child: Image.asset("images/Ripple2.gif")),
                                                ),
                                              ),
                                            ),
                                            if(selectedID[0] == document.id)
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(5.w, 10.h, 5.w, 0),
                                                child: Container(
                                                  width:100.w,
                                                  height: 140.h,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15.0),
                                                      color: Theme.of(context).accentColor.withOpacity(0.7)
                                                  ),
                                                  child: Icon(Icons.done,color: Colors.black,size: 40.r,),
                                                ),
                                              )
                                          ]
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:  EdgeInsets.only(top: 5.h),
                                          child: Container(width:110.w,child: Center(child: Text(document['Name'],style: TextStyle(color: Theme.of(context).accentColor,fontSize: 14.sp,fontWeight: FontWeight.w800),overflow: TextOverflow.ellipsis,))),
                                        ),
                                        Padding(
                                          padding:  EdgeInsets.only(top:2.h),
                                          child: Text('₹' + document['Price'].toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 12.sp,fontWeight: FontWeight.w300),),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                            ).toList(),
                          ),
                          ]
                        );
                      }
                      else{
                        return Container(height: 50.h,width: 50.w,);
                      }
                    }
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                FlatButton(
                  minWidth: 150.w,
                  child: Text('Cancel',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                    minWidth: 150.w,
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                    onPressed: () {if(selectedID[0] !=null){
                      Navigator.of(context).pop(selectedID);
                    }
                    else{
                      Navigator.of(context).pop();
                    }
                    }),
              ],
            ),
          ])),
    );
  }
}
class ShowImage extends StatelessWidget {
  final String imageurl;
  const ShowImage({Key key, this.imageurl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
            height: 410.5.h,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 400.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        imageUrl: imageurl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: Image.asset("images/Ripple2.gif")),
                      ),
                    ),
                  ),
                ),
              ],
            )
        ));
  }
}


