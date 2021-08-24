import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vandana_clothing/Pages/Cart/OrderPlaced.dart';
import 'package:vandana_clothing/Pages/HomePage/HomePage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
class PaymentMethod extends StatefulWidget {
  final int ammount;
  final String deliveryMethod,deliveryAddress;

  const PaymentMethod({Key key, this.ammount, this.deliveryMethod, this.deliveryAddress}) : super(key: key);
  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  Razorpay _razorpay = Razorpay();
  String groupValue = "Online";
  ProgressDialog pr;
  int dCharges = 0;
  Map<String,dynamic> mAmount = new Map();
  int totalAmount = 0;
  int finalAmount = 0;
  String stotal = 'Loading';
  String sfinal = 'Loading';


  @override
  void initState() {
    super.initState();
    getAllData();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response)async {
    placeOrder(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) async{

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  getAllData()async{
    dCharges = 0;
    if(widget.deliveryMethod == 'Deliver'){
      DocumentSnapshot dss = await FirebaseFirestore.instance.collection('Admin').doc('Profile').get();
      dCharges = dss['DeliveryCharges'];
    }
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
    totalAmount = 0;
    var lPrice = mAmount.values;
    lPrice.forEach((element) {
      if(element != null){
        totalAmount += element;
      }
    });
    finalAmount = totalAmount + dCharges;
    setState(() {
      stotal = '₹ ' +  totalAmount.toString();
      sfinal = '₹ ' +  finalAmount.toString();
    });
  }
  Future placeOrder (BuildContext context) async {
    await pr.show();
    Map<String,dynamic> opaddress = new Map();
    if(widget.deliveryMethod == 'Deliver'){
      DocumentSnapshot dsAddress =   await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Address').doc(widget.deliveryAddress).get();
      opaddress = {
        'Title' :dsAddress.id,
        'Name': dsAddress.data()['Name'],
        'AddressLineA': dsAddress.data()['AddressLineA'],
        'AddressLineB' : dsAddress.data()['AddressLineB'],
        'City' : dsAddress.data()['City'],
        'State' : dsAddress.data()['State'],
        'PinCode' : dsAddress.data()['PinCode'],
        'PhoneNumber' : dsAddress.data()['PhoneNumber'],
      };
    }
    else{
      DocumentSnapshot storeAddress =  await FirebaseFirestore.instance.collection('Admin').doc('Stores').get();
      opaddress = storeAddress.data()[HomePage.uProfile['PinCode']];
    }

    await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Cart').get().then((snapshot) =>
        snapshot.docs.forEach((doc) async {
          DocumentSnapshot UMeasurement = await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Measurement').doc(doc.data()['MeasurementTitle']).get();
          String orderid = new DateTime.now().millisecondsSinceEpoch.toString();
          Map<String,dynamic> orderData = new Map();
          orderData["UserPhone"] = await FirebaseAuth.instance.currentUser.phoneNumber;
          orderData["UserName"] = HomePage.uProfile['Name'];
          orderData["UserEmail"] = HomePage.uProfile['Email'];
          orderData["ProductID"] = doc.data()['ProductID'];
          orderData["Designs"] = doc.data()['Designs'];
          orderData["SubCategory"] = doc.data()['SubCategory'];
          orderData["PaymentMethod"] = groupValue;
          DateTime now = DateTime.now();
          String formattedDate = DateFormat('dd-MM-yyyy, HH:mm').format(now);
          orderData["Status"] = "Awaiting Confirmation";
          orderData["StatusUpdateTime"] = formattedDate;
          orderData["OrderDate"] = formattedDate;
          orderData["Measurement"] = {
            'Title' :UMeasurement.id,
            'Shoulder': UMeasurement.data()['Shoulder'],
            'Bust': UMeasurement.data()['Bust'],
            'Waist' : UMeasurement.data()['Waist'],
            'SleeveLength' : UMeasurement.data()['SleeveLength'],
            'TopLength' : UMeasurement.data()['TopLength'],
            'BottomLength' : UMeasurement.data()['BottomLength'],
            'Hip' : UMeasurement.data()['Hip'],
            'InseamLength' : UMeasurement.data()['InseamLength'],
            'MeasurementUnit': UMeasurement.data()['MeasurementUnit']
          };
          orderData["Delivery"] = widget.deliveryMethod;
          if(widget.deliveryMethod == 'Deliver'){
            DocumentSnapshot dsAddress =   await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Address').doc(widget.deliveryAddress).get();
            orderData["Address"] = opaddress;
          }
          await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Orders').doc(orderid).set(orderData);
          await FirebaseFirestore.instance.collection('Admin').doc("Orders").collection('New Orders').doc(orderid).set(orderData);
          await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Cart').doc(doc.id).delete();
        }));
    await pr.hide();
    Fluttertoast.showToast(
        msg: "Order Placed...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).secondaryHeaderColor,
        fontSize: 16.0
    );

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        OrderPlaced(mamount: finalAmount.toString(),dtype: widget.deliveryMethod,adress: opaddress,)), (Route<dynamic> route) => false);
  }
  valueChanged(e) {
    setState(() {
      switch (e) {
        case "COD":
          groupValue = e;
          break;
        case "Online":
          groupValue = e;
          break;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Placing Order...',
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
          'Payment',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: new ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15.w, 20.h, 15.w, 0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.only(left:30.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top:20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Amount : ',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            stotal,
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Charges : ',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            '₹ ' + dCharges.toString(),
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Total Amount : ',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            sfinal,
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(top:15.h,),
                      child: Text('Payment Method',style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.sp,fontWeight: FontWeight.w600,),softWrap: true),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                          value: "Online",
                          groupValue: groupValue,
                          onChanged: (e) => valueChanged(e),
                        ),
                        Text(
                          'Pay Online',
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp),
                        ),
                      ],
                    ),
                    if(widget.deliveryMethod == 'Pickup')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                          value: "COD",
                          groupValue: groupValue,
                          onChanged: (e) => valueChanged(e),
                        ),
                        Text(
                          'Cash On Delivery',
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp),

                        ),
                      ],
                    ),
                    SizedBox(height:20.h)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: new Container(
          height: 60.h,
          child: MaterialButton(
            onPressed: () {
              if(groupValue == 'Online'){
                var options = {
                  'key': 'rzp_test_z1fePMhhDMzL1y',
                  'amount': finalAmount * 100,
                  'name': 'Vandana Clothing',
                  'description': 'Payment for Placing Order',
                  'prefill': {'contact': FirebaseAuth.instance.currentUser.phoneNumber, 'email': HomePage.uProfile['Email']},
                  'external': {
                    'wallets': ['paytm']
                  }
                };
                try {
                  _razorpay.open(options);
                } catch (e) {
                  debugPrint(e);
                }
              }
              else{
                placeOrder(context);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Place Order",
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

