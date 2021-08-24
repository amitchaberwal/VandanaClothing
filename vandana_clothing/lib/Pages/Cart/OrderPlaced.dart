import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vandana_clothing/Pages/HomePage/HomePage.dart';

class OrderPlaced extends StatefulWidget {
  final String mamount,dtype;
  final Map<String,dynamic> adress;

  const OrderPlaced({Key key, this.mamount, this.dtype, this.adress}) : super(key: key);
  @override
  _OrderPlacedState createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  String mtime;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    mtime = DateFormat('dd-MM-yyyy, HH:mm').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Placed',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        children: [
          Padding(
            padding:  EdgeInsets.only(top:30.h),
            child: CircleAvatar(backgroundColor: Colors.green[600],radius:100.r,child: Icon(Icons.done,color: Theme.of(context).primaryColor,size: 50.r,),),
          ),
          Padding(
            padding:  EdgeInsets.only(top:30.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Amount: ',
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  '₹' + widget.mamount,
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(top:10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ordered On: ',
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  mtime,
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          (widget.dtype == 'Deliver')?
          Padding(
            padding: EdgeInsets.fromLTRB(15.w, 30.h, 15.w, 0),
            child: Column(
              children: [
                Text(
                  'Delivery Address',
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10.h,),
                Container(
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
                            child: Text(widget.adress['Title'],
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
                                    widget.adress['Name'],
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
                                  child: Text(widget.adress['AddressLineA'] + ',' + widget.adress['AddressLineB'], style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500))),
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
                              Flexible(child: Text(widget.adress['City'],
                                style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500), overflow: TextOverflow.fade,)),
                              SizedBox(
                                width: 30.w,
                              ),
                              Text('State: ',
                                style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300), overflow: TextOverflow.fade,),
                              Flexible(
                                  child: Text(widget.adress['State'], style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500), overflow: TextOverflow.fade,)),
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
                                  child: Text(widget.adress['PinCode'], style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500), overflow: TextOverflow.fade,)),
                              SizedBox(
                                width: 30.w,
                              ),
                              Text(
                                'Phone No.: ', style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14.sp, fontWeight: FontWeight.w300), overflow: TextOverflow.fade,
                              ),
                              Flexible(
                                  child: Text(widget.adress['PhoneNumber'],
                                    style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.sp, fontWeight: FontWeight.w500), overflow: TextOverflow.fade,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
          :
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
            child: Column(
              children: [
                Text(
                  'PickUp Address',
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10.h,),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Text('Store Location',style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.sp,fontWeight: FontWeight.w700),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:5.h),
                        child: Container(width:300.w,child: Center(child: Text(widget.adress['AddressLineA'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w600),overflow: TextOverflow.visible,))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:5.h),
                        child: Container(width:300.w,child: Center(child: Text(widget.adress['AddressLineB'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.visible,))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:5.h),
                        child: Container(width:300.w,child: Center(child: Text(widget.adress['AddressLineC'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.visible,))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:5.h,bottom:10.h),
                        child: Container(width:300.w,child: Center(child: Text(widget.adress['Contact'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.visible,))),
                      ),

                    ],

                  )),
              ],
            ),
          ),

          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 120.w,vertical: 40.h),
            child: SizedBox(
              height: 70.h,
              width: 120.w,
              child: MaterialButton(
                onPressed:(){
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home,color: Colors.black),
                      SizedBox(width: 10.w,),
                      Text("Home",style: TextStyle(color: Colors.black,fontSize: 16.sp,fontWeight: FontWeight.w800 ),),
                    ],
                  ),
                ),
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }


}


