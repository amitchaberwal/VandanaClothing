import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyNotifications extends StatefulWidget {
  @override
  _MyNotificationsState createState() => _MyNotificationsState();
}

class _MyNotificationsState extends State<MyNotifications> {
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
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.clear_all_rounded,
                color: Theme.of(context).accentColor, //20
              ),
              onPressed: (){}),
        ],
      ),

      body: new ListView(
        children: [

        ],
      ),
    );
  }
}
