import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String uname,uemail,upin = null;
  File _imageFile = null;
  final databaseReference = FirebaseFirestore.instance;
  final picker = ImagePicker();
  ProgressDialog pr;
  Map<String,dynamic> mdata = new Map();
  bool processed = false;

  @override
  void initState() {
    super.initState();
    getData();
  }
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future uploadData(BuildContext context) async {
    await pr.show();
    if(_imageFile != null){
      String fileName = basename(_imageFile.path);
      String uphone = FirebaseAuth.instance.currentUser.phoneNumber;
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('Users/$uphone/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      DocumentSnapshot udoc = await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Account').doc('Profile').get();
      Reference imgRef = await FirebaseStorage.instance.refFromURL(udoc.data()['ProfileImage']);
      await imgRef.delete();
      taskSnapshot.ref.getDownloadURL().then(
              (value) => mdata['ProfileImage'] = value
      );
    }
      String uphone = FirebaseAuth.instance.currentUser.phoneNumber;
      await databaseReference.collection('Users').doc(uphone).collection('Account').doc('Profile').update({
        'Name': mdata['Name'],
        'Email': mdata['Email'],
        'PinCode' : mdata['PinCode'],
        'ProfileImage' : mdata['ProfileImage']
      });
      Fluttertoast.showToast(
          msg: "Updated Successfully...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0
      );
      await pr.hide();
  }

   getData() async {
    DocumentSnapshot mydata =   await FirebaseFirestore.instance.collection('Users').doc(await FirebaseAuth.instance.currentUser.phoneNumber).collection('Account').doc('Profile').get();
    if(mydata.exists){
      mdata = mydata.data();
    }
    setState(() {
      processed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Updating...',
        borderRadius: 10.0,
        backgroundColor: Theme.of(context).primaryColor,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Theme.of(context).secondaryHeaderColor, fontSize: 19.sp, fontWeight: FontWeight.w600)
    );
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        //toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
      ),

      body: new ListView(
        children: [
          Center(
            child: Padding(
              padding:  EdgeInsets.only(top:10.h),
              child: Text(
                FirebaseAuth.instance.currentUser.phoneNumber,
                style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 25.sp,fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(height: 30.h,),
          Column(
            children: [
              (processed == true)?
              Column(
                      children: [
                        Stack(
                          children: <Widget>[
                            Center(
                              child: _imageFile != null
                                  ? ClipOval(
                                child: Image.file(_imageFile,fit: BoxFit.cover,height: 150.r,width: 150.r,),
                              )
                                  : FlatButton(
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl:mdata['ProfileImage'],
                                    fit: BoxFit.cover,
                                    width: 150.r,
                                    height: 150.r,
                                  ),
                                ),
                                onPressed: pickImage,
                              ),
                            ),

                          ],
                        ),

                        SizedBox(
                          height: 30.h,
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: TextFormField(
                            controller: TextEditingController(text: mdata['Name'],),
                            keyboardType: TextInputType.name,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(30),
                                  ),
                                ),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Theme.of(context).accentColor,
                                ),
                                hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                                hintText: "Name",
                                fillColor: Theme.of(context).cardColor),
                            style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                            onChanged: (value) {
                              mdata['Name'] = value;
                            },
                          ),
                        ),
                        SizedBox(height: 20.h,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: TextFormField(
                            controller: TextEditingController(text: mdata['Email'],),
                            keyboardType: TextInputType.emailAddress,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(30),
                                  ),
                                ),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Theme.of(context).accentColor,
                                ),
                                hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                                hintText: "Email",
                                fillColor: Theme.of(context).cardColor),
                            style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                            onChanged: (value) {
                              mdata['Email'] = value;
                            },
                          ),
                        ),
                        SizedBox(height: 20.h,),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 15.w),
                          child: TextField(
                            controller: TextEditingController(text: mdata['PinCode'],),
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(30),
                                  ),
                                ),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.home,
                                  color: Theme.of(context).accentColor,
                                ),
                                hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                                hintText: "Area Pin Code",
                                fillColor: Theme.of(context).cardColor),
                            style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                            onChanged: (value) {
                              mdata['PinCode'] = value;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: SizedBox(
                            width: 170.w,
                            height: 60.h,
                            child: FlatButton(
                              onPressed:()=>uploadData(context),
                              child: Text(
                                'Save',
                                style: TextStyle(fontSize: 20.sp),
                              ),
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                            ),
                          ),
                        ),
                      ],
                    ):
                    Center(child: Image.asset("images/DualBall.gif",height: 80.h,)),
            ],
          ),
        ],
      ),
    );
  }
}
