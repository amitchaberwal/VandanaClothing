import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vandana_clothing/Pages/Order/OrderPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class OrderView extends StatefulWidget {
  final String orderID,status;
  const OrderView({Key key, this.orderID, this.status}) : super(key: key);
  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  ProgressDialog pr;
  Color c0 = Colors.grey;
  Color c1 = Colors.grey;
  Color c2 = Colors.grey;
  Color c3 = Colors.grey;
  Color c4 = Colors.grey;
  Color c5 = Colors.grey;
  Future CancelOrder (BuildContext context) async {
    await pr.show();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy, HH:mm').format(now);
    await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Orders').doc(widget.orderID).update(
        {'Status':'Canceled',
        'StatusUpdateTime':formattedDate});
    await FirebaseFirestore.instance.collection('Admin').doc('Orders').collection('New Orders').doc(widget.orderID).update(
        {'Status':'Canceled',
          'StatusUpdateTime':formattedDate});
    DocumentSnapshot cOrder =   await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Orders').doc(widget.orderID).get();
    await FirebaseFirestore.instance.collection('Admin').doc('Orders').collection('Canceled Orders').doc(widget.orderID).set(cOrder.data());
    await FirebaseFirestore.instance.collection('Admin').doc('Orders').collection('New Orders').doc(widget.orderID).delete();
    await pr.hide();
    Fluttertoast.showToast(
        msg: "Order Canceled...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).secondaryHeaderColor,
        fontSize: 16.0
    );
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Orders()));
  }
  @override
  Widget build(BuildContext context) {
    double mHeight(double inputHeight) {
      double screenHeight = MediaQuery.of(context).size.height;
      return (inputHeight / 834.90) * screenHeight;
    }
    double mWidth(double inputWidth) {
      double screenWidth = MediaQuery.of(context).size.width;
      return (inputWidth / 392.72) * screenWidth;
    }
    switch(widget.status){
      case "Awaiting Confirmation":c0 = Colors.green;
      break;
      case "Order Confirmed":c0 = Colors.green;
        c1 = Colors.green;
      break;
      case "Order Preparing":c0 = Colors.green;
      c1 = Colors.green;
      c2 = Colors.green;
      break;
      case "Order Ready":c0 = Colors.green;
      c1 = Colors.green;
      c2 = Colors.green;
      c3 = Colors.green;
      break;
      case "Dispached":c0 = Colors.green;
      c1 = Colors.green;
      c2 = Colors.green;
      c3 = Colors.green;
      c4 = Colors.green;
      break;
      case "Delivered":c0 = Colors.green;
      c1 = Colors.green;
      c2 = Colors.green;
      c3 = Colors.green;
      c4 = Colors.green;
      c5 = Colors.green;
      break;
    }
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Canceling...',
        borderRadius: 10.0,
        backgroundColor: Theme.of(context).primaryColor,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Theme.of(context).secondaryHeaderColor, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          widget.orderID,
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,

      ),
      body: SingleChildScrollView(
        child: Container(
          child:  FutureBuilder(
        future:  FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Orders').doc(widget.orderID).get(),
    builder: (context,AsyncSnapshot<DocumentSnapshot> mdata){
          if(mdata.hasData){
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(top:10),
                          child: Row(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    width: mWidth(120),
                                    height: mHeight(140),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: CachedNetworkImage(
                                        imageUrl:mdata.data['ProductImage'],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                            height:mHeight(120),
                                            width:mWidth(120),
                                            child: CircularProgressIndicator()),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:15),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: Text(mdata.data['ProductName'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w400,),softWrap: true),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5),
                                          child: Row(
                                            //mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Price : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w300,),softWrap: true),
                                              Text('₹ ' + mdata.data['ProductPrice'].toString(),style: TextStyle(color: Theme.of(context).accentColor,fontSize: 16,fontWeight: FontWeight.w600,),softWrap: true),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5),
                                          child: Row(
                                            //mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Lining Charges : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w300,),softWrap: true),
                                              Text('₹ ' + mdata.data['ProductLining'].toString(),style: TextStyle(color: Theme.of(context).accentColor,fontSize: 16,fontWeight: FontWeight.w600,),softWrap: true),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5),
                                          child: Row(
                                            //mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Piping Charges : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w300,),softWrap: true),
                                              Text('₹ ' + mdata.data['ProductPiping'].toString(),style: TextStyle(color: Theme.of(context).accentColor,fontSize: 16,fontWeight: FontWeight.w600,),softWrap: true),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5),
                                          child: Row(
                                            //mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Ordered On : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w300,),softWrap: true),
                                              Text(mdata.data['OrderDate'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w300,),softWrap: true),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),

                      SizedBox(height: mHeight(5),),
                      Padding(
                        padding: const EdgeInsets.only(top:5),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Delivery Type : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 16,fontWeight: FontWeight.w400,),softWrap: true),
                            Text(mdata.data['Delivery'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 16,fontWeight: FontWeight.w400,),softWrap: true),
                          ],
                        ),
                      ),
                      (mdata.data['Delivery'] == 'Deliver')?
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 20, 30),
                        child: Container(
                          width: double.infinity,
                          height: mHeight(150),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(mdata.data['Address']['Title'],style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18,fontWeight: FontWeight.w700),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Name: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14,fontWeight: FontWeight.w400),),
                                    Flexible(child: Text(mdata.data['Address']['Name'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w500),)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Address: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14,fontWeight: FontWeight.w400),overflow: TextOverflow.fade,),
                                    Flexible(flex:3,child: Text(mdata.data['Address']['AddressLineA'] + ',' + mdata.data['Address']['AddressLineB'] ,style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w500))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('City: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14,fontWeight: FontWeight.w400),overflow: TextOverflow.fade,),
                                    Flexible(child: Text(mdata.data['Address']['City'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w500),overflow: TextOverflow.fade,)),
                                    SizedBox(width: mWidth(30),),
                                    Text('State: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14,fontWeight: FontWeight.w400),overflow: TextOverflow.fade,),
                                    Flexible(child: Text(mdata.data['Address']['State'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w500),overflow: TextOverflow.fade,)),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('PinCode: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14,fontWeight: FontWeight.w400),overflow: TextOverflow.fade,),
                                    Flexible(child: Text(mdata.data['Address']['PinCode'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w500),overflow: TextOverflow.fade,)),
                                    SizedBox(width: mWidth(30),),
                                    Text('Phone No.: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14,fontWeight: FontWeight.w400),overflow: TextOverflow.fade,),
                                    Flexible(child: Text(mdata.data['Address']['PhoneNumber'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w500),overflow: TextOverflow.fade,)),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      )
                      :SizedBox(height: mHeight(30),),
                      (mdata.data['Status'] != 'Canceled')?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Progress :',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 18,fontWeight: FontWeight.w600,),softWrap: true),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                child: Text('Last Updated (' + mdata.data['StatusUpdateTime'] + ')',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 13,fontWeight: FontWeight.w300,)),
                              ),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: mWidth(7),
                                backgroundColor:
                                c0,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Text('Awaiting Confirmation',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w300,)),
                              ),
                            ],
                          ),

                          SizedBox(height:mHeight(30),child: VerticalDivider(thickness: 2,
                            color: c1,)),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: mWidth(7),
                                backgroundColor:
                                c1,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Text('Order Confirmed',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w300,)),
                              ),
                            ],
                          ),

                          SizedBox(height:mHeight(30),child: VerticalDivider(thickness: 2,
                            color: c2,)),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: mWidth(7),
                                backgroundColor:
                                c2,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Text('Order Preparing',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w300,)),
                              ),
                            ],
                          ),

                          SizedBox(height:mHeight(30),child: VerticalDivider(thickness: 2,
                            color: c3,)),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: mWidth(7),
                                backgroundColor:
                                c3,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Text('Order Ready',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w300,)),
                              ),
                            ],
                          ),

                          SizedBox(height:mHeight(30),child: VerticalDivider(thickness: 2,
                            color: c4,)),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: mWidth(7),
                                backgroundColor:
                                c4,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Text('Dispached',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w300,)),
                              ),
                            ],
                          ),


                          SizedBox(height:mHeight(30),child: VerticalDivider(thickness: 2,
                            color: c5,)),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: mWidth(7),
                                backgroundColor:
                                c5,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Text('Delivered',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w300,)),
                              ),
                            ],
                          ),
                          (mdata.data['Status'] == 'Awaiting Confirmation' || mdata.data['Status'] == 'Order Confirmed')?
                          Padding(
                            padding: const EdgeInsets.fromLTRB(70, 20, 70, 20),
                            child: FlatButton(
                              onPressed: () {
                                CancelOrder(context);
                              },
                              child: Center(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.black,
                                  ),
                                  title: Text(
                                    "Cancel Order",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                            ),
                          )
                              :
                              SizedBox(height: mHeight(20),)
                        ],
                      )
                          :Center(child: Text('Order Canceled',style: TextStyle(color: Colors.red,fontSize: 25,fontWeight: FontWeight.w600,))),
                    ],
                  ),
                ),
              ],
            );
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
    }),
        ),
      )
    );
  }
}
