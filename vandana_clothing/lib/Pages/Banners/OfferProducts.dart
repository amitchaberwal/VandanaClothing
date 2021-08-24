import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vandana_clothing/Pages/Cart/CartPage.dart';
import 'package:vandana_clothing/Pages/Product/ProductView.dart';

class OfferProducts extends StatefulWidget {
  final String bannerID;

  const OfferProducts({Key key, this.bannerID}) : super(key: key);
  @override
  _OfferProductsState createState() => _OfferProductsState();
}

class _OfferProductsState extends State<OfferProducts> {

  String offerCat,offerField;
  dynamic minValue,maxValue;

  List<DocumentSnapshot> products = [];
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 10;
  DocumentSnapshot lastDocument;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getBannerDetail();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= 0) {
        getProducts();
      }
    });
  }

  getBannerDetail()async{
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('Banners').doc(widget.bannerID).get();
    offerCat = ds.data()['OfferCategory'];
    if(ds.data()['Discount'] == true){
      offerField = 'ProductDiscount';
      minValue = ds.data()['MinimumDiscount'];
      maxValue = ds.data()['MaximumDiscount'];
    }
    else if(ds.data()['Price'] == true){
      offerField = 'ProductPrice';
      minValue = ds.data()['MinimumPrice'];
      maxValue = ds.data()['MaximumPrice'];
    }
    getProducts();

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
      querySnapshot = await FirebaseFirestore.instance.collection('Products').where('SubCategoryName',isEqualTo: offerCat).where(offerField,isGreaterThanOrEqualTo: minValue).where(offerField,isLessThanOrEqualTo: maxValue).limit(documentLimit).get();
    } else {
      querySnapshot = await FirebaseFirestore.instance.collection('Products').where('SubCategoryName',isEqualTo: offerCat).where(offerField,isGreaterThanOrEqualTo: minValue).where(offerField,isLessThanOrEqualTo: maxValue).startAfterDocument(lastDocument).limit(documentLimit).get();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Offer',
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
          new IconButton(
              icon: SvgPicture.asset(
                "images/icons/bag.svg",
                height: 20.r,
                color: Theme.of(context).accentColor, //20
              ),
              onPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.topToBottom, child: MyCart()))
          ),
        ],
      ),
      body: ListView(
        children: [
          if(products.length != 0)
            Wrap(
              children: products.map((mProduct) => Padding(
                padding:  EdgeInsets.fromLTRB(10.w,10.h,10.w,15.h),
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
