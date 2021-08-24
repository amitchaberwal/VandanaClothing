import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vandana_clothing/Pages/Cart/DeliveryAddress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vandana_clothing/Pages/Product/CustomProduct.dart';
import 'package:vandana_clothing/Pages/Product/ProductView.dart';

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}
class _MyCartState extends State<MyCart> {
  Map<String,dynamic> mAmount = new Map();
  int totalAmount = 0;
  int tempPrice = 0;
  bool pr = false;
  bool hasCustomFab = false;
  @override
  void initState() {
    super.initState();
    getAllData();
    checkCustomFab();
  }
  getAllData()async{
    await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Cart').get().then((value) => Future.wait(value.docs.map((cdoc)async {
      if(cdoc['ProductID'] == 'CustomFabric'){
          mAmount[cdoc.id] = cdoc['ProductPrice'] + cdoc['FinalCharges'];
      }
      else{
        await FirebaseFirestore.instance.collection('Products').doc(cdoc['ProductID']).get().then((dsPro) {
          int tempPrice = ((dsPro['ProductPrice'] - cdoc['InitCharges']) + cdoc['FinalCharges']);
          mAmount[cdoc.id] = (tempPrice - (tempPrice * dsPro['ProductDiscount'])/100).round();
        });
      }
    })));
    updatePrice();
    pr = true;
  }
  checkCustomFab()async{
    QuerySnapshot csPro = await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Cart').where('ProductID',isEqualTo: 'CustomFabric').get();
    if(csPro.docs.isNotEmpty){
      print(1);
      hasCustomFab = true;
    }
    else{
      hasCustomFab = false;
    }
    /*
    await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Cart').where('ProductID',isEqualTo: 'CustomFabric').get().then((value) => Future.wait(value.docs.map((cdoc)async {
      if(cdoc['ProductID'] == 'CustomFabric'){
        hasCustomFab = true;
        mAmount[cdoc.id] = cdoc['ProductPrice'] + cdoc['FinalCharges'];
      }
    })));

     */
  }

    void updatePrice(){
    int totalPrice = 0;
    var lPrice = mAmount.values;
    lPrice.forEach((element) {
      if(element != null){
        totalPrice += element;
      }
    });
        setState(() {
          totalAmount = totalPrice;
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'My Cart',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Cart').snapshots(),
            builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasData){
                if(snapshot.data.docs.isNotEmpty){
                      return ListView(
                        shrinkWrap: true,
                        children: snapshot.data.docs.map((document) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
                              child: new
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: (document['ProductID'] == 'CustomFabric')?
                                Stack(
                              children: [
                              Align(
                              alignment:Alignment.topRight,
                                child: IconButton(
                                  onPressed:()async{
                                    await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Cart').doc(document.id).delete();
                                    await mAmount.remove(document.id);
                                    updatePrice();
                                    checkCustomFab();
                                  },
                                  icon: Icon(Icons.delete_outline_rounded,size: 25.r,),
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                                Padding(
                                  padding: EdgeInsets.only(top:8.h),
                                  child: Row(
                                      children: [
                                        Padding(
                                          padding:  EdgeInsets.only(left: 8.w,bottom: 8.h),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(new MaterialPageRoute(
                                                  builder: (context) => new CustomProduct(subcat: document['SubCategory'])));
                                            },
                                            child: Container(
                                              width: 120.w,
                                              height: 170.h,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(15.0),
                                                child: Image.asset('images/CustomDress.png',
                                                  fit: BoxFit.cover,
                                                )
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height:160.h,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(width:200.w,child: Center(child: Text('Custom Fabric',style: TextStyle(color: Theme.of(context).accentColor,fontSize: 16.sp,fontWeight: FontWeight.w800,),overflow: TextOverflow.ellipsis,))),
                                                Padding(
                                                  padding: EdgeInsets.only(top:5.h),
                                                  child: Container(
                                                    width:200.w,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text('Size : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300,),overflow: TextOverflow.ellipsis,),
                                                        Text(document['MeasurementTitle'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500,),overflow: TextOverflow.ellipsis,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top:5.h),
                                                  child: Container(
                                                    width:200.w,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text('Base Price : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300,),overflow: TextOverflow.ellipsis,),
                                                        Text('₹ ' + (document['ProductPrice']).toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500,),overflow: TextOverflow.ellipsis,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top:5.h),
                                                  child: Container(
                                                    width:200.w,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text('Design Charges : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300,),overflow: TextOverflow.ellipsis,),
                                                        Text('₹ ' + (document['FinalCharges']).toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500,),overflow: TextOverflow.ellipsis,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top:5.h,),
                                                  child: Container(
                                                    width:200.w,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text('Final Price : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300,),overflow: TextOverflow.ellipsis,),
                                                        Text('₹ ' + (mAmount[document.id]).toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500,),overflow: TextOverflow.ellipsis,),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                Padding(
                                                  padding: EdgeInsets.only(top:5.h),
                                                  child: Container(
                                                    width:200.w,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text('Product : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300,),overflow: TextOverflow.ellipsis,),
                                                        Text(document['SubCategory'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500,),overflow: TextOverflow.ellipsis,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                                ])
                                    :FutureBuilder(
                                    future: FirebaseFirestore.instance.collection('Products').doc(document['ProductID']).get(),
                                    builder: (context, AsyncSnapshot<DocumentSnapshot>mdata) {
                                      if (mdata.hasData) {
                                        return Stack(
                                            children: [
                                              Align(
                                                alignment:Alignment.topRight,
                                                child: IconButton(
                                                  onPressed:()async{
                                                    await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Cart').doc(document.id).delete();
                                                    await mAmount.remove(document.id);
                                                    updatePrice();
                                                  },
                                                  icon: Icon(Icons.delete_outline_rounded,size: 25.r,),
                                                  color: Theme.of(context).accentColor,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top:8.h),
                                                child: Row(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.fromLTRB(8.w, 0, 0, 8.h),
                                                        width: 120.w,
                                                        height: 170.h,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.of(context).push(new MaterialPageRoute(
                                                                builder: (context) => new ProductView(pro_id: mdata.data.id,pro_img: mdata.data['ProductImage'],pro_name: mdata.data['ProductName'],)));
                                                          } ,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(15.0),
                                                            child: CachedNetworkImage(
                                                              imageUrl:mdata.data['ProductImage'],
                                                              fit: BoxFit.cover,
                                                              placeholder: (context, url) => Center(child: Image.asset("images/Ripple2.gif")),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          height:160.h,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Container(width:200.w,child: Center(child: Text(mdata.data['ProductName'],style: TextStyle(color: Theme.of(context).accentColor,fontSize: 16.sp,fontWeight: FontWeight.w800,),overflow: TextOverflow.ellipsis,))),
                                                              Padding(
                                                                padding: EdgeInsets.only(top:5.h),
                                                                child: Container(
                                                                  width:200.w,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text('Size : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300,),overflow: TextOverflow.ellipsis,),
                                                                      Text(document['MeasurementTitle'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500,),overflow: TextOverflow.ellipsis,),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(top:5.h),
                                                                child: Container(
                                                                  width:200.w,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text('Base Price : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300,),overflow: TextOverflow.ellipsis,),
                                                                      Text('₹ ' + (mdata.data['ProductPrice']-document['InitCharges']).toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500,),overflow: TextOverflow.ellipsis,),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(top:5.h),
                                                                child: Container(
                                                                  width:200.w,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text('Design Charges : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300,),overflow: TextOverflow.ellipsis,),
                                                                      Text('₹ ' + (document['FinalCharges']).toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500,),overflow: TextOverflow.ellipsis,),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              (mdata.data['ProductDiscount'] != 0)?
                                                              Padding(
                                                                padding: EdgeInsets.only(top:5.h),
                                                                child: Container(
                                                                  width:200.w,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text('Final Price : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300,),overflow: TextOverflow.ellipsis,),
                                                                      Column(
                                                                        children: [
                                                                          Text('₹ ' + ((mdata.data['ProductPrice']-document['InitCharges']) + document['FinalCharges']).toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500,decoration: TextDecoration.lineThrough,),overflow: TextOverflow.ellipsis,),
                                                                          Text(mdata.data["ProductDiscount"].toString() + '% off', style: TextStyle(color: Colors.red, fontSize: 10.sp, fontWeight: FontWeight.w800)),
                                                                        ],
                                                                      ),
                                                                      SizedBox(width: 10.w,),
                                                                      Text('₹ ' + (mAmount[document.id]).toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500,),overflow: TextOverflow.ellipsis,),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ):
                                                              Padding(
                                                                padding: EdgeInsets.only(top:5.h,),
                                                                child: Container(
                                                                  width:200.w,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text('Final Price : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300,),overflow: TextOverflow.ellipsis,),
                                                                      Text('₹ ' + (mAmount[document.id]).toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500,),overflow: TextOverflow.ellipsis,),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),

                                                              Padding(
                                                                padding: EdgeInsets.only(top:5.h),
                                                                child: Container(
                                                                  width:200.w,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text('Product : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300,),overflow: TextOverflow.ellipsis,),
                                                                      Text(mdata.data['SubCategoryName'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500,),overflow: TextOverflow.ellipsis,),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ]);
                                      } else {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(vertical: 50.h),
                                          child: Center(
                                              child: Image.asset(
                                                "images/DualBall.gif",
                                                height: 80,
                                              )),
                                        );
                                      }
                                    }),
                              ),
                            );
                        }).toList(),
                        );
                }
                else{
                  return Center(child: Text('No Items in Cart',style: TextStyle(color:Theme.of(context).secondaryHeaderColor,fontSize: 20.sp,fontWeight: FontWeight.w300 ),));
                }
              }
              else{
                return Center(
                    child: Image.asset(
                      "images/DualBall.gif",
                      height: 80,
                    ));
              }
            }
          ),
      ),
      bottomNavigationBar:
      new Container(
        height: 80.h,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Text('Total Amount : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 16.sp,fontWeight: FontWeight.w300,),softWrap: true),
                  Text('₹ ' + totalAmount.toString(),style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.sp,fontWeight: FontWeight.w800,),softWrap: true),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding:  EdgeInsets.only(right: 15.w),
                child: SizedBox(
                  height: 60.h,
                  child: MaterialButton(
                    onPressed:(){
                      if(pr == true){
                        Navigator.of(context).push(
                            new MaterialPageRoute(builder: (context) => new DeliveryAddress(hasCustomFab: hasCustomFab,)));
                      }
                      else{
                        Fluttertoast.showToast(
                            msg: "Please Wait...",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Theme.of(context).cardColor,
                            textColor: Theme.of(context).secondaryHeaderColor,
                            fontSize: 16.0
                        );
                      }
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Proceed",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16.sp,fontWeight: FontWeight.w800 ),),
                          SizedBox(width: 10.w,),
                          Icon(Icons.double_arrow_rounded,color: Theme.of(context).primaryColor,),
                        ],
                      ),
                    ),
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
