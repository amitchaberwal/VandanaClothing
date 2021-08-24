import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vandana_clothing/Pages/Login/LoginPageA.dart';
import 'package:vandana_clothing/Pages/HomePage/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vandana_clothing/Pages/Login/SignUpA.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Splash extends StatelessWidget {
  Future getPage(BuildContext context) async{
    User user = await FirebaseAuth.instance.currentUser;
    if(user != null){
      String mphone = await FirebaseAuth.instance.currentUser.phoneNumber;
      var muser = await FirebaseFirestore.instance.collection('Users').doc(mphone).collection('Account').doc('Profile').get();
      if(muser.exists){
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomePage()));
      }
      else{
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignUp(mphone)));
      }
    }
    else{
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    getPage(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        centerTitle: true,
        elevation: 0,
        //toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          SizedBox(height: 150.h,),
          SizedBox(
            child:(Theme.of(context).brightness == Brightness.light)?
            Image.asset('images/VC_bright.png',
              height: 300.h,)
                :
            Image.asset('images/VC_dark.png',
              height: 300.h,)
          ),
        ],
      ),

    );
  }
}

