import 'package:flutter/material.dart';
import 'package:vandana_clothing/Pages/HomePage/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUp extends StatefulWidget {
  final String mPhone;
  
  SignUp(this.mPhone);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String uname,uemail,upin,uage = null;
  File _imageFile = null;
  String groupValue = "Female";
  final databaseReference = Firestore.instance;
  final picker = ImagePicker();
  ProgressDialog pr;

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future uploadData(BuildContext context) async {
    if(_imageFile == null){
      Fluttertoast.showToast(
          msg: "Select a profile Image!!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0
      );
    }
    else{
      if(uname == null || uemail == null || upin == null || uage == null ){
        Fluttertoast.showToast(
            msg: "Please fill all details..",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).secondaryHeaderColor,
            fontSize: 16.0
        );
      }
      else{
    await pr.show();
    String fileName = basename(_imageFile.path);
    String uphone = widget.mPhone;
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('Users/$uphone/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
    (value) => databaseReference.collection('Users')
        .doc(uphone).collection('Account').doc('Profile').set({
    'Name': uname,
    'Email': uemail,
    'PinCode' : upin,
    'Age' : int.parse(uage),
    'Gender' : groupValue,
    'ProfileImage' : value,})

    );
    Fluttertoast.showToast(
    msg: "Registration Successfull...",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Theme.of(context).cardColor,
    textColor: Theme.of(context).secondaryHeaderColor,
    fontSize: 16.0
    );
    await pr.hide();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }

    }
  }
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Signing Up...',
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
          'Registration',
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
      body: Center(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
          child: ListView(
            children: [
              SizedBox(height: 10.h,),
              Center(child: Text(widget.mPhone,style: TextStyle(color: Theme.of(context).accentColor,fontSize: 25.sp,fontWeight: FontWeight.w900),)),
              SizedBox(height: 20.h,),

              Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 200.r,
                      width: 200.r,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(100.r),
                      ),

                      margin:  EdgeInsets.only(
                          left: 30.w, right: 30.w, top: 10.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: _imageFile != null
                            ? ClipOval(
                          child: Image.file(_imageFile,fit: BoxFit.cover,),
                        )
                            : FlatButton(
                          child: Icon(
                            Icons.person,
                            size: 100.r,
                          ),
                          onPressed: pickImage,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h,),

              TextField(
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
                onChanged: (value) {
                  uname = value;
                },
              ),
              SizedBox(height: 20.h,),
              TextField(
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
                onChanged: (value) {
                  uemail = value;
                },
              ),
              SizedBox(height: 20.h,),
              TextField(
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
                onChanged: (value) {
                  upin = value;
                },
              ),
              SizedBox(height: 20.h,),
              TextField(
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
                      Icons.calendar_today_rounded,
                      color: Theme.of(context).accentColor,
                    ),
                    hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                    hintText: "Age",
                    fillColor: Theme.of(context).cardColor),
                onChanged: (value) {
                  uage = value;
                },
              ),
              SizedBox(height: 20.h,),
              Row(
                children: [
                  Flexible(child: ListTile(title: Text('Female',style: TextStyle(color: Theme.of(context).secondaryHeaderColor),),leading: Radio(value: "Female", groupValue: groupValue, onChanged:(e)=> valueChanged(e),))),
                  Flexible(child: ListTile(title: Text('Male',style: TextStyle(color: Theme.of(context).secondaryHeaderColor),),leading: Radio(value: "Male", groupValue: groupValue, onChanged:(e)=> valueChanged(e),))),
                ],
              ),
              SizedBox(height: 20.h,),
              Center(child: Text('By registering you confirm that you agree with our \n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t all terms and conditions.',style: TextStyle(color: Theme.of(context).accentColor,fontSize: 12.sp,fontWeight: FontWeight.w400),)),
              SizedBox(height: 20.h,),
              SizedBox(
                width: 10.w,
                height: 50.h,
                child: FlatButton(
                  //onPressed: signIn,
                  onPressed:()=>uploadData(context),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
              SizedBox(height: 20.h,),

            ],
          ),
        ),
      ),
    );
  }
  valueChanged(e){
    setState(() {

      switch (e) {
        case "Female":
          groupValue = e;
      break;
      case "Male":
        groupValue = e;
      break;
      case "Other":
        groupValue = e;
      break;
      }
    });
  }
}
