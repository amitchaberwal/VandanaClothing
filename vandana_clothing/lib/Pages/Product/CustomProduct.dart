import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vandana_clothing/Pages/Cart/CartPage.dart';
import 'package:vandana_clothing/Pages/Product/ProductView.dart';
class CustomProduct extends StatefulWidget {
  final String subcat;
  const CustomProduct({Key key, this.subcat}) : super(key: key);

  @override
  _CustomProductState createState() => _CustomProductState();
}

class _CustomProductState extends State<CustomProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Custom Fabric',
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
                child: Hero(
                  tag: 'customfabric',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).cardColor,
                    ),
                    width: 300.w,
                    height: 450.h,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 40.w,vertical: 40.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset('images/CustomDress.png',
                          fit: BoxFit.cover,
                        )
                      ),
                    ),
                  ),
                ),),
          ),
          FutureBuilder(
              future: FirebaseFirestore.instance.collection('SubCategories').doc(widget.subcat).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> mdata) {
                if (mdata.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 10.h, 5.w, 0),
                        child: Center(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text("Product: ",
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w300)),
                                Text(
                                    widget.subcat,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600)),
                              ],
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 10.h, 5.w, 0),
                        child: Center(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text("Stitching Price: ",
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w300)),
                                Text(
                                    '₹ ' + mdata.data["StitchingPrice"].toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600)),
                              ],
                            )),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top:10.h),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top:5.h),
                              child: Text('Choose custom fabric.',
                                  style: TextStyle(
                                      color:
                                      Theme.of(context).secondaryHeaderColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top:5.h),
                              child: Text('Choose custom designs.',
                                  style: TextStyle(
                                      color:
                                      Theme.of(context).secondaryHeaderColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top:5.h),
                              child: Text('Order the dress.',
                                  style: TextStyle(
                                      color:
                                      Theme.of(context).secondaryHeaderColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top:5.h),
                              child: Text('Drop at our store.',
                                  style: TextStyle(
                                      color:
                                      Theme.of(context).secondaryHeaderColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top:10.h),
                              child: Text('Get it stitched.',
                                  style: TextStyle(
                                      color:
                                      Theme.of(context).secondaryHeaderColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300)),
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
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 90.w,vertical: 20.h),
              child: SizedBox(
                height: 70.h,
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddToCart(apro_id: 'CustomFabric',subcatName: widget.subcat,);
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
        ],
      ),
    );
  }
}
