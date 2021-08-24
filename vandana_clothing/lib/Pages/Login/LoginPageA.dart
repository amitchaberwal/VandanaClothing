import 'package:flutter/material.dart';
import 'package:vandana_clothing/Pages/Login/LoginPageB.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String phoneNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Welcome',
          style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 35.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        //toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(30.w,10.h,30.w,70.h),
              child: Text(
                'Enter your Phone number to continue.OTP \n will be sent on this number for verification',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w300),
              ),
            ),


            (Theme.of(context).brightness == Brightness.light)?
            Image.asset('images/VC_bright.png',
              height: 200.h,)
                :
            Image.asset('images/VC_dark.png',
              height: 200.h,),
            SizedBox(
              height: 30.h,
            ),


            Padding(
              padding:  EdgeInsets.symmetric(vertical: 16.h,horizontal: 40.w),
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30),
                      ),
                    ),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.phone_android_rounded,
                      color: Theme.of(context).accentColor,
                    ),
                    hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                    hintText: "Enter Your Phone Number...",
                    fillColor: Theme.of(context).cardColor),
                onChanged: (value) {
                  phoneNumber = '+91' + value;
                },
              ),
            ),
            SizedBox(
              height:20.h,
            ),
            Container(
              height: 60.h,
              child: FlatButton(
                shape: CircleBorder(
                    ),
                onPressed: () =>
                phoneNumber == null ? null : Navigator.of(context).push(
                    new MaterialPageRoute(builder: (context) => new PhoneAuthVerify(phoneNumber))),
                child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,size: 30.r,),
                color: Theme.of(context).accentColor,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }
}
