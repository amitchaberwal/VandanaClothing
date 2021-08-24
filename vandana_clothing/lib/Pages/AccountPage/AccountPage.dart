import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vandana_clothing/Pages/AccountPage/EditProfile.dart';
import 'package:vandana_clothing/Pages/AccountPage/ManageAddress.dart';
import 'package:vandana_clothing/Pages/AccountPage/ManageMeasurement.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAccount extends StatefulWidget {
  final String Pimg,Pname;

  const MyAccount({Key key, this.Pimg, this.Pname}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  void initState() {
    super.initState();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Account',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        //toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          SizedBox(height: 30.h,),
          Column(
            children: [
              Column(
                      children: [
                        Hero(
                          tag:'pimg',
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl:widget.Pimg,
                              placeholder: (context, url) => Center(child: Image.asset("images/Spinner2.gif")),
                              fit: BoxFit.cover,
                              width: 150.w,
                              height: 150.h,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Text(widget.Pname,
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp),
                        )
                      ],
                    ),
              Padding(
                padding:  EdgeInsets.only(top:4.h),
                child: Text(
                  FirebaseAuth.instance.currentUser.phoneNumber,
                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 15.h),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.w,10.h,10.w,0),
                    child: SizedBox(
                      height:80.h,
                      width: double.infinity,
                      child: FlatButton(
                        onPressed: ()=> Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => new EditProfile())),
                          child:ListTile(
                            leading:Icon(Icons.person,color: Theme.of(context).accentColor),
                            title: Text("Edit Profile",style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 18.sp,fontWeight: FontWeight.w400 ),),
                          )
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1.h,
                    color: Theme.of(context).secondaryHeaderColor,
                    indent: 15.w,
                    endIndent: 15.w,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.w,5.h,10.w,0.h),
                    child: SizedBox(
                      height:80.h,
                      width: double.infinity,
                      child: FlatButton(
                        onPressed: ()=> Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => new ManageAddress())),
                          child:ListTile(
                            leading:Icon(Icons.home_rounded,color: Theme.of(context).accentColor),
                            title: Text("Manage Addresses",style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 18.sp,fontWeight: FontWeight.w400),),
                          )
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1.h,
                    color: Theme.of(context).secondaryHeaderColor,
                    indent: 15.w,
                    endIndent: 15.w,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.w,5.h,10.w,10.h),
                    child: SizedBox(
                      height:80.h,
                      width: double.infinity,
                      child: FlatButton(
                        onPressed: ()=> Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => new ManageMeasurement())),
                        child:ListTile(
                          leading:Icon(Icons.pregnant_woman_rounded,color: Theme.of(context).accentColor),
                          title: Text("Body Measurements",style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 18.sp,fontWeight: FontWeight.w400 ),),
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
