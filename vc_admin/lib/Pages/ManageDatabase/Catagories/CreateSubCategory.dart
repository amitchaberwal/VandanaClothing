import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateSubCategory extends StatefulWidget {
  @override
  _CreateSubCategoryState createState() => _CreateSubCategoryState();
}

class _CreateSubCategoryState extends State<CreateSubCategory> {
  bool mlining = false;

  List<bool> isSelected = [false, false, false,false,false,false];

  String mproLining = null;

  String headcat = null;
  String subcatname,stitchingPrice;
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
    if(headcat == null || subcatname == null ){
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
      Map<String, dynamic> orderData = new Map();
      orderData["Name"] = subcatname;
      orderData["CategoryName"] = headcat;
      orderData["StitchingPrice"] = int.parse(stitchingPrice);
      if(mproLining != null){
        orderData["Lining"] = int.parse(mproLining);
      }
      else{
        orderData["Lining"] = false;
      }
      orderData["Features"] = {
        'NeckDesign': isSelected[0],
        'SleeveDesign': isSelected[1],
        'PonchaDesign': isSelected[2],
        'PipingDesign': isSelected[3],
        'CollarDesign': isSelected[4],
        'SleeveLength': isSelected[5],
      };
      String im;
      String fileName = basename(_imageFile.path);
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('SubCategories/$subcatname/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      await taskSnapshot.ref.getDownloadURL().then(
              (value) => im = value
      );
      orderData["Image"] = im;
      FirebaseFirestore.instance.collection('SubCategories').doc(subcatname).set(orderData);
      Fluttertoast.showToast(
          msg: "SubCategory Created Successfully...",
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
        height: 650.h,
        margin: EdgeInsets.only(top: 1),
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
                'Create SubCategory',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Categories').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.isNotEmpty) {
                      return DropdownButtonFormField(
                        hint: Text(
                          'Choose Category',
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                        style: TextStyle(color: Colors.white),
                        value: headcat,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            headcat = newValue;
                          });
                        },
                        items: snapshot.data.docs.map((document) {
                          return DropdownMenuItem(
                            child: new Text(
                              document.id,
                              style: TextStyle(
                                  color:
                                  Theme.of(context).secondaryHeaderColor),
                            ),
                            value: document.id,
                          );
                        }).toList(),
                      );
                    } else {
                      return Text(
                        'Categories not found...',
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                      );
                    }
                  } else {
                    return Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Getting Categories...',
                              style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator()),
                          ],
                        ));
                  }
                }),
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
                    borderRadius: BorderRadius.circular(30.r),
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
                  hintText: "SubCategory Name",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                subcatname = value;
              },
            ),
          ),

          Padding(
            padding:  EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
            child: TextField(
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
                    Icons.monetization_on_rounded,
                    color: Theme.of(context).accentColor,
                  ),
                  hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  hintText: "Stitching Price",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                stitchingPrice = value;
              },
            ),
          ),


          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 140.w,
                  child: Column(
                    children: [
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text('Lining'),
                        value: mlining,
                        onChanged: (newValue) {
                          setState(() {
                            mlining = newValue;
                          });
                        },
                      ),
                      if(mlining == true)
                        Padding(
                          padding: EdgeInsets.only(left: 30.w),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(15),
                                  ),
                                ),
                                filled: true,
                                hintStyle: new TextStyle(
                                    color: Theme.of(context).secondaryHeaderColor),
                                hintText: "Lining Price",
                                fillColor: Theme.of(context).cardColor),
                            onChanged: (value) {
                              mproLining = value;
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:  EdgeInsets.only(top:10.h,bottom: 10.h),
                  child: Center(
                    child: Text(
                      'Enable Designs',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(bottom: 10.h),
                  child: Center(
                    child: SizedBox(
                      height: 55.h,
                      child: ToggleButtons(
                        children: <Widget>[
                          Text(
                            'Neck',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            'Sleeve',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            'Poncha',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            'Piping',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            'Collar',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            'Sleeve\nLength',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                        fillColor: Theme.of(context).accentColor,
                        isSelected: isSelected,
                        borderColor: Theme.of(context).secondaryHeaderColor,
                        borderRadius: BorderRadius.circular(10),
                        onPressed: (int index) {
                          setState(() {
                            isSelected[index] = !isSelected[index];
                          });
                        },
                      ),
                    ),
                  ),
                ),

              ],
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
