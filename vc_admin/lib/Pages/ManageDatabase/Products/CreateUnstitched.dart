import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:vc_admin/Pages/ManageDatabase/ManageDatabase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateUnstitched extends StatefulWidget {
  @override
  _CreateUnstitchedState createState() => _CreateUnstitchedState();
}

class _CreateUnstitchedState extends State<CreateUnstitched> {
  ProgressDialog prcp;
  List selectedSubCat = new List();
  String proFab, proStock, proFabId,proPrice,proName,proDiscount,proDesc;
  Map<String, dynamic> mproPrice = new Map();
  Map<String, dynamic> mproDiscount = new Map();
  File _imageFile, _imageFile1, _imageFile2, _imageFile3, _imageFile4 = null;
  final picker = ImagePicker();
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future pickImage1() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile1 = File(pickedFile.path);
    });
  }

  Future pickImage2() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile2 = File(pickedFile.path);
    });
  }

  Future pickImage3() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile3 = File(pickedFile.path);
    });
  }

  Future pickImage4() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile4 = File(pickedFile.path);
    });
  }

  Future uploadData(BuildContext context) async {
    if (_imageFile == null) {
      Fluttertoast.showToast(
          msg: "Select Featured Image!!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0);
    }
    bool allOK = false;
    for(String catname in  selectedSubCat){
      if (mproPrice[catname] == null || mproDiscount[catname] == null || proName == null || proDesc == null || proFab == null || proStock == null) {
        allOK = false;
      }
      else {
        allOK = true;
      }
    }
    if(allOK == false){
      Fluttertoast.showToast(
          msg: "Please fill all details..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0);
    }
    if(allOK == true) {
      DocumentSnapshot fid = await FirebaseFirestore.instance.collection('Fabric').doc(proFabId).get();
      if(fid.exists){
        Fluttertoast.showToast(
            msg: "Fabric Id already exists",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).secondaryHeaderColor,
            fontSize: 16.0);
      }
      else{
        await prcp.show();
        String im, im1, im2, im3, im4;
        String fileName = basename(_imageFile.path);
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('Products/$proFabId/$fileName');
        UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        await taskSnapshot.ref.getDownloadURL().then((value) {
          im = value;
        });
        if (_imageFile1 != null) {
          String fileName = basename(_imageFile1.path);
          Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('Products/$proFabId/$fileName');
          UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile1);
          TaskSnapshot taskSnapshot = await uploadTask;
          await taskSnapshot.ref.getDownloadURL().then((value) => im1 = value);
        }
        if (_imageFile2 != null) {
          String fileName = basename(_imageFile2.path);
          Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('Products/$proFabId/$fileName');
          UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile2);
          TaskSnapshot taskSnapshot = await uploadTask;
          await taskSnapshot.ref.getDownloadURL().then((value) => im2 = value);
        }
        if (_imageFile3 != null) {
          String fileName = basename(_imageFile3.path);
          Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('Products/$proFabId/$fileName');
          UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile3);
          TaskSnapshot taskSnapshot = await uploadTask;
          await taskSnapshot.ref.getDownloadURL().then((value) => im3 = value);
        }
        if (_imageFile4 != null) {
          String fileName = basename(_imageFile4.path);
          Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('Products/$proFabId/$fileName');
          UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile4);
          TaskSnapshot taskSnapshot = await uploadTask;
          await taskSnapshot.ref.getDownloadURL().then((value) => im4 = value);
        }
        DateTime now = DateTime.now();
        String mDate = DateFormat('dd-MM-yyyy').format(now);

        for(String catname in  selectedSubCat){
          Map<String, dynamic> orderData = new Map();
          String allwords = proName.toLowerCase() + ' ' + proDesc.toLowerCase() + ' ' + proFab.toLowerCase() + ' ' + catname.toLowerCase();
          var searchArray = allwords.split(' ');
          var SWords = searchArray.toSet().toList();

          Map<String, dynamic> stData = new Map();
          SWords.forEach((element) {
            stData[element] = true;
          });
          orderData['SearchTags'] = stData;

          await prcp.show();
          DocumentReference mproduct = FirebaseFirestore.instance.collection('Products').doc();

          orderData["ProductType"] = 'Fabric';
          orderData["FabricID"] = proFabId;
          orderData["SubCategoryName"] = catname;
          orderData["ProductName"] = proName;
          orderData["ProductDescription"] = proDesc;
          orderData["ProductFabric"] = proFab;
          orderData["ProductPrice"] = mproPrice[catname];
          orderData["ProductDiscount"] = int.parse(mproDiscount[catname]);
          orderData["PostDate"] = mDate;
          orderData["SearchKeywords"] = SWords;
          orderData["ProductImage"] = im;
          orderData["Images"] = {
            'ImageA': im1,
            'ImageB': im2,
            'ImageC': im3,
            'ImageD': im4,
          };
          await mproduct.set(orderData);
        }
        await FirebaseFirestore.instance.collection('Fabric').doc(proFabId).set({
          'FabricStock':int.parse(proStock),
          'FabricImage': im,
          'Type': 'Fabric',
          'PostDate': mDate,
          "Images" : {
            'ImageA': im1,
            'ImageB': im2,
            'ImageC': im3,
            'ImageD': im4,
          }
        });
        await prcp.hide();
        Fluttertoast.showToast(
            msg: "Fabric Uploaded",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).secondaryHeaderColor,
            fontSize: 16.0);
        Navigator.of(context).pop();
      }

    }


  }

  @override
  Widget build(BuildContext context) {
    prcp = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    prcp.style(
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
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 19.sp,
            fontWeight: FontWeight.w600));

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Create Product',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.cloud_upload_rounded,
              color: Theme.of(context).accentColor,
              size: 35.r,
            ),
            onPressed: () {
              uploadData(context);
            },
          )
        ],
        //toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    height: 300.h,
                    width: 200.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 10.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: _imageFile != null
                          ? ClipRRect(
                              child: Image.file(
                                _imageFile,
                                fit: BoxFit.cover,
                              ),
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 110.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: EdgeInsets.only(left: 10.w, top: 10.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: _imageFile1 != null
                            ? ClipRRect(
                                child: Image.file(
                                  _imageFile1,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : FlatButton(
                                child: Icon(
                                  Icons.add,
                                  size: 40.r,
                                ),
                                onPressed: pickImage1,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 110.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin:
                          EdgeInsets.only(left: 10.w, right: 0.0, top: 10.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: _imageFile2 != null
                            ? ClipRRect(
                                child: Image.file(
                                  _imageFile2,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : FlatButton(
                                child: Icon(
                                  Icons.add,
                                  size: 40.r,
                                ),
                                onPressed: pickImage2,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 110.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin:
                          EdgeInsets.only(left: 10.w, right: 0.0, top: 10.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: _imageFile3 != null
                            ? ClipRRect(
                                child: Image.file(
                                  _imageFile3,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : FlatButton(
                                child: Icon(
                                  Icons.add,
                                  size: 40.r,
                                ),
                                onPressed: pickImage3,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 110.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin:
                          EdgeInsets.only(left: 10.w, right: 0.0, top: 10.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: _imageFile4 != null
                            ? ClipRRect(
                                child: Image.file(
                                  _imageFile4,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : FlatButton(
                                child: Icon(
                                  Icons.add,
                                  size: 40.r,
                                ),
                                onPressed: pickImage4,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          StreamBuilder(
              stream: FirebaseFirestore.instance.collection('SubCategories').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 0),
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
                              hintStyle: new TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor),
                              hintText: "Fabric ID",
                              fillColor: Theme.of(context).cardColor),
                          onChanged: (value) {
                            proFabId = value.toUpperCase();
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 0),
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
                              hintStyle: new TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor),
                              hintText: "Fabric",
                              fillColor: Theme.of(context).cardColor),
                          onChanged: (value) {
                            proFab = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 0),
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
                              hintStyle: new TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor),
                              hintText: "Name",
                              fillColor: Theme.of(context).cardColor),
                          onChanged: (value) {
                            proName = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 0),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 2,
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
                              hintText: "Fabric Description",
                              fillColor: Theme.of(context).cardColor),
                          onChanged: (value) {
                            proDesc = value;
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100.w,
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
                                    hintText: "Stock",
                                    fillColor: Theme.of(context).cardColor),
                                onChanged: (value) {
                                  proStock = value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: snapshot.data.docs.map((document) {
                        return Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Column(
                            children: [
                              CheckboxListTile(
                                value: selectedSubCat.contains(document.id),
                                subtitle: Text(document.id),
                                onChanged: (newValue) {
                                  if(newValue == true){
                                    setState(() {
                                      selectedSubCat.add(document.id);
                                    });
                                  }
                                  else{
                                    setState(() {
                                      selectedSubCat.remove(document.id);
                                    });
                                  }
                                },
                              ),
                              if(selectedSubCat.contains(document.id))
                                Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 140.w,
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
                                                hintText: "Fabric Price",
                                                fillColor: Theme.of(context).cardColor),
                                            onChanged: (value) {
                                              setState(() {
                                                mproPrice[document.id] = int.parse(value) + document['StitchingPrice'];
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 140.w,
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
                                                hintText: "Discount %",
                                                fillColor: Theme.of(context).cardColor),
                                            onChanged: (value) {
                                              mproDiscount[document.id]  = value;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(top:5.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Total Price: ',
                                            style: TextStyle(
                                                color: Theme.of(context).secondaryHeaderColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Text('₹' +
                                            mproPrice[document.id].toString(),
                                            style: TextStyle(
                                                color: Theme.of(context).secondaryHeaderColor,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );}).toList()
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),


        ],
      ),
    );
  }
}
