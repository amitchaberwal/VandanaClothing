import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CreateCategory extends StatefulWidget {
  @override
  _CreateCategoryState createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  String catname;
  File _imageFile = null;
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
          msg: "Select Image First!!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0
      );
    }
    if(catname == null ){
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
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('Categories/$catname/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      taskSnapshot.ref.getDownloadURL().then(
              (value) => FirebaseFirestore.instance.collection('Categories').doc(catname).set({
            'Name': catname,
            'Image' : value,})

      );
      Fluttertoast.showToast(
          msg: "Category Created Successfully...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0
      );
      await pr.hide();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Uploading...',
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context) {

    return Container(
        height: 430.h,
        margin: EdgeInsets.only(top: 1.h),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListView(children: <Widget>[
          Padding(
            padding:  EdgeInsets.only(top: 10.h),
            child: Center(
              child: Text(
                'Create Category',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Center(
                child: Container(
                  height: 200.h,
                  width: 140.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(30),
                  ),

                  margin:  EdgeInsets.only(
                      left: 30.w, right: 30.w, top: 10.h),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: _imageFile != null
                        ? ClipRRect(
                      child: Image.file(_imageFile,fit: BoxFit.cover,),
                    )
                        : FlatButton(
                      child: Icon(
                        Icons.image_rounded,
                        size: 70.r,
                      ),
                      onPressed: pickImage,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
            child: TextField(
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
                    Icons.category_rounded,
                    color: Theme.of(context).accentColor,
                  ),
                  hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  hintText: "Category Name",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                catname = value;
              },
            ),
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(50.w, 10.h, 50.w, 10.h),
            child: SizedBox(
              height: 60.h,
              child: FlatButton(
                onPressed:(){
                  uploadData(context);
                },
                child: Center(
                  child: Text("Submit",style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                ),
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
          ),

        ]));
  }
}

