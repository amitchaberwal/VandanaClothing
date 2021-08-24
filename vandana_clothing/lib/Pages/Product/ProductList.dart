import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vandana_clothing/Pages/Cart/CartPage.dart';
import 'package:vandana_clothing/Pages/HomePage/HomePage.dart';
import 'package:vandana_clothing/Pages/Product/CustomProduct.dart';
import 'package:vandana_clothing/Pages/Product/ProductView.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductList extends StatefulWidget {
  final String SubCatName;
  final int st_price;
  const ProductList({Key key, this.SubCatName, this.st_price}) : super(key: key);
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          widget.SubCatName,
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
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Products').where("SubCategoryName",isEqualTo: widget.SubCatName).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Wrap(
                  children: [
                    if(HomePage.uProfile['PinCode'] == '125050')
                    Padding(
                      padding:  EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 15.h),
                      child: Container(
                        width: 170.w,
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) => new CustomProduct(subcat: widget.SubCatName,)));
                          },
                          child: Center(
                              child: Column(
                                  children: [
                                    Padding(
                                      padding:  EdgeInsets.only(top:5.h),
                                      child: Container(
                                        width: 160.w,
                                        height: 210.h,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.circular(15)),
                                        child: Hero(
                                          tag: 'customfabric',
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15.0),
                                              child:Image.asset('images/CustomDress.png',
                                                fit: BoxFit.cover,
                                              )
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding:  EdgeInsets.only(top: 5.h),
                                          child: Center(
                                              child: Text('Custom Fabric',
                                                  style: TextStyle(
                                                      color: Theme.of(context).secondaryHeaderColor,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w600))),
                                        ),
                                        Padding(
                                          padding:  EdgeInsets.only(top:5.h,bottom: 5.h),
                                          child: Center(
                                              child: Text('₹' + widget.st_price.toString(),
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w600))),
                                        ),
                                      ],
                                    ),
                                  ])
                          ),
                        ),

                      ),
                    ),
                    Wrap(
                      children: snapshot.data.docs.map((document) => Padding(
                        padding:  EdgeInsets.fromLTRB(10.w,10.h,10.w,15.h),
                        child: ProductTile(
                          pro_name: document['ProductName'],
                          pro_img: document['ProductImage'],
                          pro_price: document['ProductPrice'],
                          pro_discount: document['ProductDiscount'],
                          pro_id: document.id,
                        ),
                      ),).toList()
                  ),]
                );
              } else {
                return  Padding(
                  padding:  EdgeInsets.only(top:10.h),
                  child: Center(child: Image.asset("images/DualBall.gif",height: 100,)),
                );
              }
            }),
      ),
    );
  }
}
class ProductTile extends StatelessWidget {
  final String pro_name,pro_img,pro_id;
  final int pro_price,pro_discount;

  const ProductTile({Key key, this.pro_name, this.pro_img, this.pro_price, this.pro_discount, this.pro_id,})
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
                    ],
                  ),
                ])
        ),
      ),

    );
  }
}
