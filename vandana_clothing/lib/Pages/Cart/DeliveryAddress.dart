import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vandana_clothing/Pages/AccountPage/Utils/NewAddress.dart';
import 'package:vandana_clothing/Pages/Cart/PaymentMethod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vandana_clothing/Pages/HomePage/HomePage.dart';

class DeliveryAddress extends StatefulWidget {
  final bool hasCustomFab;


  const DeliveryAddress({Key key, this.hasCustomFab,}) : super(key: key);

  @override
  _DeliveryAddressState createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  String sAddress;
  String groupValue = "Deliver";

  valueChanged(e) {
    setState(() {
      switch (e) {
        case "Deliver":
          groupValue = e;
          break;
        case "Pickup":
          groupValue = e;
          break;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: new AppBar(
          title: Text(
            'Delivery Address',
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 25.sp,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(
          children: [
            SingleChildScrollView(
                child: (HomePage.uProfile['PinCode'] == "125050")?
                Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    title: Text(
                                      'Deliver to Address',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context).secondaryHeaderColor),
                                    ),
                                    leading: Radio(
                                      value: "Deliver",
                                      groupValue: groupValue,
                                      onChanged: (e) => valueChanged(e),
                                    ))),
                            Expanded(
                                child: ListTile(
                                    title: Text(
                                      'Pickup from Store',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context).secondaryHeaderColor),
                                    ),
                                    leading: Radio(
                                      value: "Pickup",
                                      groupValue: groupValue,
                                      onChanged: (e) => valueChanged(e),
                                    ))),
                          ],
                        ),
                        (groupValue == "Deliver")
                            ? StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Address').snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.docs.isNotEmpty) {
                                  return Column(
                                    children: [
                                      Padding(padding: EdgeInsets.symmetric(vertical: 10.h),
                                        child: SizedBox(
                                          width:230.w,
                                          height:60.h,
                                          child: FlatButton(
                                            onPressed: () {
                                              showDialog(context: context, builder: (BuildContext context) {
                                                return NewAddress();
                                              });
                                            },
                                            child: Center(
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.home,
                                                  color: Colors.black,
                                                ),
                                                title: Text(
                                                  "Add Address",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            color: Theme.of(context).accentColor,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:  EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
                                        child: DropdownButtonFormField(
                                          hint: Text(
                                            'Choose Delivery Address',
                                            style: TextStyle(
                                                color: Theme.of(context).secondaryHeaderColor),
                                          ),
                                          style: TextStyle(
                                              color: Colors.white),
                                          value: sAddress,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(const Radius.circular(30.0),
                                              ),
                                            ),
                                          ),
                                          onChanged: (newValue) {
                                            setState(() {
                                              sAddress = newValue;
                                            });
                                          },
                                          items: snapshot.data.docs.map((document) {
                                            return DropdownMenuItem(
                                              child: new Text(document.id,
                                                style: TextStyle(
                                                    color: Theme.of(context).secondaryHeaderColor),
                                              ),
                                              value: document.id,
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      if(sAddress != null)
                                        FutureBuilder(
                                            future: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Address').doc(sAddress).get(),
                                            builder: (context, AsyncSnapshot<DocumentSnapshot>mdata) {
                                              if (mdata.hasData) {
                                                return Padding(
                                                  padding: EdgeInsets.fromLTRB(15.w, 30.h, 15.w, 0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).cardColor,
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(top: 5.h),
                                                          child: Container(
                                                            width: 330.w,
                                                            child: Center(
                                                              child: Text(mdata.data.id,
                                                                style: TextStyle(
                                                                    color: Theme.of(context).accentColor,
                                                                    fontSize: 18.sp,
                                                                    fontWeight: FontWeight.w700),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:  EdgeInsets.only(top: 5.h),
                                                          child: Container(
                                                            width: 330.w,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text('Name: ',
                                                                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300),
                                                                ),
                                                                Flexible(
                                                                    child: Text(
                                                                      mdata.data['Name'],
                                                                      style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:  EdgeInsets.only(top: 5.h),
                                                          child: Container(
                                                            width: 330.w,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  'Address: ',
                                                                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300), overflow: TextOverflow.fade,
                                                                ),
                                                                Flexible(
                                                                    flex: 3,
                                                                    child: Text(mdata.data['AddressLineA'] + ',' + mdata.data['AddressLineB'], style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500))),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(top: 5.h),
                                                          child: Container(
                                                            width: 330.w,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  'City: ',
                                                                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300), overflow: TextOverflow.fade,
                                                                ),
                                                                Flexible(child: Text(mdata.data['City'],
                                                                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500), overflow: TextOverflow.fade,)),
                                                                SizedBox(
                                                                  width: 30.w,
                                                                ),
                                                                Text('State: ',
                                                                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300), overflow: TextOverflow.fade,),
                                                                Flexible(
                                                                    child: Text(mdata.data['State'], style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500), overflow: TextOverflow.fade,)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:  EdgeInsets.only(top: 5.h,bottom: 10.h),
                                                          child: Container(
                                                            width: 330.w,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text('PinCode: ', style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300), overflow: TextOverflow.fade,),
                                                                Flexible(
                                                                    child: Text(mdata.data['PinCode'], style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500), overflow: TextOverflow.fade,)),
                                                                SizedBox(
                                                                  width: 30.w,
                                                                ),
                                                                Text(
                                                                  'Phone No.: ', style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300), overflow: TextOverflow.fade,
                                                                ),
                                                                Flexible(
                                                                    child: Text(mdata.data['PhoneNumber'],
                                                                      style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500), overflow: TextOverflow.fade,
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return Center(
                                                    child: Text(
                                                        "Loading"));
                                              }
                                            })

                                    ],
                                  );
                                } else {
                                  return Center(
                                      child: Text('No Addressess in List...'));
                                }
                              } else {
                                return Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Getting Address List...',
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
                            })
                            : Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: FutureBuilder(
                                future: FirebaseFirestore.instance.collection('Admin').doc('Stores').get(),
                                builder: (context, AsyncSnapshot<DocumentSnapshot>mdataa) {
                                  if (mdataa.hasData) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.h),
                                          child: Text('Store Location',style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.sp,fontWeight: FontWeight.w700),),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top:5.h),
                                          child: Container(width:300.w,child: Center(child: Text(mdataa.data[HomePage.uProfile['PinCode']]['AddressLineA'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w600),overflow: TextOverflow.visible,))),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top:5.h),
                                          child: Container(width:300.w,child: Center(child: Text(mdataa.data[HomePage.uProfile['PinCode']]['AddressLineB'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.visible,))),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top:5.h),
                                          child: Container(width:300.w,child: Center(child: Text(mdataa.data[HomePage.uProfile['PinCode']]['AddressLineC'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.visible,))),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top:5.h,bottom:10.h),
                                          child: Container(width:300.w,child: Center(child: Text(mdataa.data[HomePage.uProfile['PinCode']]['Contact'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.visible,))),
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
                                }),),
                        )
                      ],
                    ),
                  ],
                )
                    :Column(
                  children: [
                    Container(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Address').snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.docs.isNotEmpty) {
                                return Column(
                                  children: [
                                    Padding(padding: EdgeInsets.symmetric(vertical: 10.h),
                                      child: SizedBox(
                                        width:230.w,
                                        height:60.h,
                                        child: FlatButton(
                                          onPressed: () {
                                            showDialog(context: context, builder: (BuildContext context) {
                                              return NewAddress();
                                            });
                                          },
                                          child: Center(
                                            child: ListTile(
                                              leading: Icon(
                                                Icons.home,
                                                color: Colors.black,
                                              ),
                                              title: Text(
                                                "Add Address",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          color: Theme.of(context).accentColor,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
                                      child: DropdownButtonFormField(
                                        hint: Text(
                                          'Choose Delivery Address',
                                          style: TextStyle(
                                              color: Theme.of(context).secondaryHeaderColor),
                                        ),
                                        style: TextStyle(
                                            color: Colors.white),
                                        value: sAddress,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(const Radius.circular(30.0),
                                            ),
                                          ),
                                        ),
                                        onChanged: (newValue) {
                                          setState(() {
                                            sAddress = newValue;
                                          });
                                        },
                                        items: snapshot.data.docs.map((document) {
                                          return DropdownMenuItem(
                                            child: new Text(document.id,
                                              style: TextStyle(
                                                  color: Theme.of(context).secondaryHeaderColor),
                                            ),
                                            value: document.id,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    if(sAddress != null)
                                      FutureBuilder(
                                          future: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Address').doc(sAddress).get(),
                                          builder: (context, AsyncSnapshot<DocumentSnapshot>mdata) {
                                            if (mdata.hasData) {
                                              return Padding(
                                                padding: EdgeInsets.fromLTRB(15.w, 30.h, 15.w, 0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).cardColor,
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 5.h),
                                                        child: Container(
                                                          width: 330.w,
                                                          child: Center(
                                                            child: Text(mdata.data.id,
                                                              style: TextStyle(
                                                                  color: Theme.of(context).accentColor,
                                                                  fontSize: 18.sp,
                                                                  fontWeight: FontWeight.w700),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:  EdgeInsets.only(top: 5.h),
                                                        child: Container(
                                                          width: 330.w,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text('Name: ',
                                                                style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300),
                                                              ),
                                                              Flexible(
                                                                  child: Text(
                                                                    mdata.data['Name'],
                                                                    style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500),
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:  EdgeInsets.only(top: 5.h),
                                                        child: Container(
                                                          width: 330.w,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                'Address: ',
                                                                style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300), overflow: TextOverflow.fade,
                                                              ),
                                                              Flexible(
                                                                  flex: 3,
                                                                  child: Text(mdata.data['AddressLineA'] + ',' + mdata.data['AddressLineB'], style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500))),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 5.h),
                                                        child: Container(
                                                          width: 330.w,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                'City: ',
                                                                style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300), overflow: TextOverflow.fade,
                                                              ),
                                                              Flexible(child: Text(mdata.data['City'],
                                                                style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500), overflow: TextOverflow.fade,)),
                                                              SizedBox(
                                                                width: 30.w,
                                                              ),
                                                              Text('State: ',
                                                                style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300), overflow: TextOverflow.fade,),
                                                              Flexible(
                                                                  child: Text(mdata.data['State'], style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500), overflow: TextOverflow.fade,)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:  EdgeInsets.only(top: 5.h,bottom: 10.h),
                                                        child: Container(
                                                          width: 330.w,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text('PinCode: ', style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300), overflow: TextOverflow.fade,),
                                                              Flexible(
                                                                  child: Text(mdata.data['PinCode'], style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500), overflow: TextOverflow.fade,)),
                                                              SizedBox(
                                                                width: 30.w,
                                                              ),
                                                              Text(
                                                                'Phone No.: ', style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300), overflow: TextOverflow.fade,
                                                              ),
                                                              Flexible(
                                                                  child: Text(mdata.data['PhoneNumber'],
                                                                    style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500), overflow: TextOverflow.fade,
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Center(
                                                  child: Text(
                                                      "Loading"));
                                            }
                                          })
                                  ],
                                );
                              } else {
                                return Center(
                                    child: Text('No Addresses in List...'));
                              }
                            } else {
                              return Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Getting Address List...',
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
                  ],
                )
            ),
            if(groupValue == 'Deliver')
              Padding(
                padding:  EdgeInsets.only(top:20.h),
                child: FutureBuilder(
                    future: FirebaseFirestore.instance.collection('Admin').doc('Profile').get(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot>mdatab) {
                      if (mdatab.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Delivery Charges: ',
                              style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w300),
                            ),
                            Text(
                              '₹'+mdatab.data['DeliveryCharges'].toString(),
                              style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
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
              ),
            if(widget.hasCustomFab == true)
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 0),
                child: Column(
                  children: [
                    Center(child: Text('Custom Fabric Drop Location',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w400),overflow: TextOverflow.visible,)),
                    Padding(
                      padding: EdgeInsets.only(top:5.h),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: FutureBuilder(
                            future: FirebaseFirestore.instance.collection('Admin').doc('Stores').get(),
                            builder: (context, AsyncSnapshot<DocumentSnapshot>mdataa) {
                              if (mdataa.hasData) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 5.h),
                                      child: Text('Store Location',style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.sp,fontWeight: FontWeight.w700),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top:5.h),
                                      child: Container(width:300.w,child: Center(child: Text(mdataa.data[HomePage.uProfile['PinCode']]['AddressLineA'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w600),overflow: TextOverflow.visible,))),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top:5.h),
                                      child: Container(width:300.w,child: Center(child: Text(mdataa.data[HomePage.uProfile['PinCode']]['AddressLineB'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.visible,))),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top:5.h),
                                      child: Container(width:300.w,child: Center(child: Text(mdataa.data[HomePage.uProfile['PinCode']]['AddressLineC'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.visible,))),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top:5.h,bottom:10.h),
                                      child: Container(width:300.w,child: Center(child: Text(mdataa.data[HomePage.uProfile['PinCode']]['Contact'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.visible,))),
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
                            }),),
                    ),
                  ],
                ),
              )

          ],
        ),
      bottomNavigationBar: new Container(
          height: 60.h,
          child: MaterialButton(
            onPressed: () {
              if(groupValue == 'Deliver' && sAddress == null){
                Fluttertoast.showToast(
                    msg: "Select Delivery Address...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Theme.of(context).cardColor,
                    textColor: Theme.of(context).secondaryHeaderColor,
                    fontSize: 16.0
                );
              }
              else{
                Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new PaymentMethod(
                      deliveryMethod: groupValue,
                      deliveryAddress: sAddress,
                    )));
              }

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Proceed For Payment",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(width: 10.w,),
                Icon(
                  Icons.double_arrow_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            color: Theme.of(context).accentColor,

          )
      ),
    );
  }
}
