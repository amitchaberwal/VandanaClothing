import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
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

class CreateProduct extends StatefulWidget {
  @override
  _CreateProductState createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  ProgressDialog prcp;
  String groupValue = "Existing";
  String checkStatus = null;
  String headcat, subcat, proName, proDesc, proFab, proPrice, proDiscount, proStock, proFabId;
  File _imageFile, _imageFile1, _imageFile2, _imageFile3, _imageFile4 = null;
  final picker = ImagePicker();
  Color featureColor = Colors.grey;
  bool featured = false;
  Map<String,dynamic> CustomDesign = {"NeckDesign":null,"SleeveDesign":null,"PipingDesign":null,"PonchaDesign":null,"CollarDesign":null,"SleeveLength":null,"Lining":null};

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

    if (headcat == null || subcat == null || proName == null || proDesc == null || proFab == null || proPrice == null || proDiscount == null || proFabId == null) {
      Fluttertoast.showToast(
          msg: "Please fill all details..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0);
    } else {
      String allwords = proName.toLowerCase() + ' ' + proDesc.toLowerCase() + ' ' + proFab.toLowerCase() + ' ' + headcat.toLowerCase() + ' ' + subcat.toLowerCase();
      var searchArray = allwords.split(' ');
      await prcp.show();
      String im, im1, im2, im3, im4;
      DocumentReference mproduct = FirebaseFirestore.instance.collection('Products').doc();
      String pid = mproduct.id;
      DateTime now = DateTime.now();
      String mDate = DateFormat('dd-MM-yyyy').format(now);
      Map<String, dynamic> orderData = new Map();

      var SWords = searchArray.toSet().toList();

      Map<String, dynamic> stData = new Map();
      SWords.forEach((element) {
        stData[element] = true;
      });
      orderData['SearchTags'] = stData;

      orderData["ProductType"] = 'Dress';
      orderData["SubCategoryName"] = subcat;
      orderData["ProductName"] = proName;
      orderData["ProductDescription"] = proDesc;
      orderData["ProductFabric"] = proFab;
      orderData["FabricID"] = proFabId;
      orderData["ProductPrice"] = int.parse(proPrice);
      orderData["ProductDiscount"] = int.parse(proDiscount);
      orderData["PostDate"] = mDate;
      orderData["SearchKeywords"] = SWords;
      orderData["Featured"] = featured;

      String fileName = basename(_imageFile.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('Products/$pid/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      await taskSnapshot.ref.getDownloadURL().then((value) {
        im = value;
      });
      orderData["ProductImage"] = im;
      if (_imageFile1 != null) {
        String fileName = basename(_imageFile1.path);
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('Products/$pid/$fileName');
        UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile1);
        TaskSnapshot taskSnapshot = await uploadTask;
        await taskSnapshot.ref.getDownloadURL().then((value) => im1 = value);
      }
      if (_imageFile2 != null) {
        String fileName = basename(_imageFile2.path);
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('Products/$pid/$fileName');
        UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile2);
        TaskSnapshot taskSnapshot = await uploadTask;
        await taskSnapshot.ref.getDownloadURL().then((value) => im2 = value);
      }

      if (_imageFile3 != null) {
        String fileName = basename(_imageFile3.path);
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('Products/$pid/$fileName');
        UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile3);
        TaskSnapshot taskSnapshot = await uploadTask;
        await taskSnapshot.ref.getDownloadURL().then((value) => im3 = value);
      }

      if (_imageFile4 != null) {
        String fileName = basename(_imageFile4.path);
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('Products/$pid/$fileName');
        UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile4);
        TaskSnapshot taskSnapshot = await uploadTask;
        await taskSnapshot.ref.getDownloadURL().then((value) => im4 = value);
      }
      orderData["Images"] = {
        'ImageA': im1,
        'ImageB': im2,
        'ImageC': im3,
        'ImageD': im4,
      };
      orderData["Designs"] = CustomDesign;
      await mproduct.set(orderData);
      if (groupValue == 'New')
        await FirebaseFirestore.instance.collection('Fabric').doc(proFabId).set({
          'FabricStock': int.parse(proStock),
          'FabricImage': im,
          'Type': 'Dress',
          'PostDate': mDate,
          "Images": {
            'ImageA': im1,
            'ImageB': im2,
            'ImageC': im3,
            'ImageD': im4,
          }
        });
      Fluttertoast.showToast(
          msg: "Product Added Successfully...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0);
      await prcp.hide();
      Navigator.of(context).pop();
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
              Icons.star,
              color: featureColor,
              size: 35.r,
            ),
            onPressed: () {
              setState(() {
                featured = !featured;
                if(featured == true){
                  featureColor = Theme.of(context).accentColor;
                }
                else{
                  featureColor = Colors.grey;
                }
              });
            },
          )
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 170.w,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Categories')
                        .snapshots(),
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
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
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
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
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
              SizedBox(
                width: 180.w,
                child: new StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('SubCategories')
                        .where('CategoryName', isEqualTo: headcat)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.docs.isNotEmpty) {
                          return DropdownButtonFormField(
                            hint: Text(
                              'Choose SubCategory',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            style: TextStyle(color: Colors.white),
                            value: subcat,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                subcat = newValue;
                              });
                            },
                            items: snapshot.data.docs.map((document) {
                              return DropdownMenuItem(
                                child: new Text(
                                  document.id,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                ),
                                value: document.id,
                              );
                            }).toList(),
                          );
                        } else {
                          return Text(
                            'SubCategories not found...',
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
                              'Getting SubCategories...',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
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
            ],
          ),
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
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Center(
                child: Text(
              'Fabric ID',
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400),
            )),
          ),
          Row(
            children: [
              Flexible(
                  child: ListTile(
                      title: Text(
                        'Existing',
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                      leading: Radio(
                        value: "Existing",
                        groupValue: groupValue,
                        onChanged: (e) => valueChanged(e),
                      ))),
              Flexible(
                  child: ListTile(
                      title: Text(
                        'New',
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                      leading: Radio(
                        value: "New",
                        groupValue: groupValue,
                        onChanged: (e) => valueChanged(e),
                      ))),
            ],
          ),
          (groupValue == 'Existing')
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.w, 5.h, 30.w, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 280.w,
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
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                  hintText: "Fabric ID",
                                  fillColor: Theme.of(context).cardColor),
                              onChanged: (value) {
                                proFabId = value.toUpperCase();
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Theme.of(context).accentColor,
                              size: 35.r,
                            ),
                            onPressed: () async {
                              ProgressDialog ch = ProgressDialog(context,
                                  type: ProgressDialogType.Normal,
                                  isDismissible: true,
                                  showLogs: false);
                              ch.style(message: 'Checking..');
                              await ch.show();
                              DocumentSnapshot ds = await FirebaseFirestore
                                  .instance
                                  .collection('Fabric')
                                  .doc(proFabId)
                                  .get();
                              await ch.hide();
                              if (ds.exists) {

                                setState(() {
                                  checkStatus = 'Found';
                                });
                              } else {
                                setState(() {
                                  checkStatus = 'NotFound';
                                });
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    if (checkStatus == 'Found')
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Center(
                            child: Text(
                          'Fabric ID Exists...',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        )),
                      ),
                    if (checkStatus == 'NotFound')
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Center(
                            child: Text(
                          'Fabric ID Not Found...',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        )),
                      ),
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.w, 5.h, 30.w, 0),
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
                      padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 0),
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
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
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
                  ],
                ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 0),
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
                  hintText: "Product Name",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                proName = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 0),
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
                  hintText: "Product Description",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                proDesc = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 0),
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
            padding: EdgeInsets.only(top: 10.h),
            child: Row(
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
                        hintText: "Price",
                        fillColor: Theme.of(context).cardColor),
                    onChanged: (value) {
                      proPrice = value;
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
                      proDiscount = value;
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(100.w, 20.h, 100.w, 10),
            child: SizedBox(
              height: 60.h,
              child: FlatButton(
                onPressed: () async{
                  if(subcat != null){
                    Map<String,dynamic> CDesign = await showDialog(context: context, builder: (BuildContext context) {return customDesigns(subcatName: subcat,);
                        });
                      CustomDesign = CDesign;
                  }
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.design_services,
                        color: Theme.of(context).accentColor,
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text(
                        "Customize",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(100.w, 10.h, 100.w, 10),
            child: SizedBox(
              height: 60.h,
              child: FlatButton(
                onPressed: () {
                  uploadData(context);
                },
                child: Center(
                  child: Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  valueChanged(e) {
    setState(() {
      switch (e) {
        case "Existing":
          groupValue = e;
          break;
        case "New":
          groupValue = e;
          break;
      }
    });
  }
}
class customDesigns extends StatefulWidget {
  final String subcatName;

  const customDesigns({Key key, this.subcatName}) : super(key: key);
  @override
  _customDesignsState createState() => _customDesignsState();
}

class _customDesignsState extends State<customDesigns> {
  List NeckID=null,SleeveID=null,SleeveLengthID=null,PipingID=null,PonchaID=null,CollarID=null;
  Map<String,dynamic> sDesigns = {'NeckDesign':null,'SleeveDesign':null,'PipingDesign':null,'PonchaDesign':null,'SleeveLength':null,'CollarDesign':null,'Lining':null};
  bool liningEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
          height: 450.h,
          margin: EdgeInsets.only(top: 1),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.design_services,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Text(
                      "Customize",
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 15.w),
              child: FutureBuilder(
                  future: FirebaseFirestore.instance.collection('SubCategories').doc(widget.subcatName).get(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> mdata) {
                    if (mdata.hasData) {
                      return Column(
                        children: [
                          Container(
                            height: 365.h,
                            width: 250.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: SingleChildScrollView(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                direction: Axis.horizontal,
                                children: [
                                  if(mdata.data['Features']['NeckDesign'] == true)
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 150.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: InkWell(
                                              onTap: () async{
                                                var neckData = await showDialog(context: context,
                                                    builder: (BuildContext context) {
                                                      return ChooseDesign(designType: 'NeckDesign',);
                                                    });
                                                setState(() {
                                                  NeckID = neckData;
                                                });
                                                sDesigns['NeckDesign'] = NeckID[0];
                                              },
                                              child: NeckID != null
                                                  ? Column(
                                                    children: [
                                                      Padding(
                                                        padding:  EdgeInsets.only(top:5.h,bottom: 5.h),
                                                        child: Container(
                                                          height:120.h,
                                                          width:90.w,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                          imageUrl:NeckID[2],
                                                          fit: BoxFit.cover,
                                                          placeholder: (context, url) => Container(
                                                              height:120.h,
                                                              width:120.w,
                                                              child: CircularProgressIndicator()),
                                                ),
                                              ),
                                                        ),
                                                      ),
                                                      Text(
                                                          '₹ '+ NeckID[3].toString(),
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 14.sp,
                                                              fontWeight: FontWeight.w400)
                                                      )
                                                    ],
                                                  )
                                                  :
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.color_lens_rounded,
                                                    size: 40.r,
                                                    color: Theme.of(context).accentColor,
                                                  ),
                                                  Text(
                                                      'Choose\nNeck\nDesign',
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w300)
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(mdata.data['Features']['SleeveDesign'] == true)
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 150.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),

                                            child: InkWell(
                                              onTap: () async{
                                                var sleeveData = await showDialog(context: context,
                                                    builder: (BuildContext context) {
                                                      return ChooseDesign(designType: 'SleeveDesign',);
                                                    });
                                                setState(() {
                                                  SleeveID = sleeveData;
                                                });
                                                sDesigns['SleeveDesign'] = SleeveID[0];
                                              },
                                              child: SleeveID != null
                                                  ? Column(
                                                children: [
                                                  Padding(
                                                    padding:  EdgeInsets.only(top:5.h,bottom: 5.h),
                                                    child: Container(
                                                      height:120.h,
                                                      width:90.w,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: CachedNetworkImage(
                                                          imageUrl:SleeveID[2],
                                                          fit: BoxFit.cover,
                                                          placeholder: (context, url) => Container(
                                                              height:120.h,
                                                              width:120.w,
                                                              child: CircularProgressIndicator()),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      '₹ '+ SleeveID[3].toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w400)
                                                  )
                                                ],
                                              )
                                                  :
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.color_lens_rounded,
                                                    size: 40.r,
                                                    color: Theme.of(context).accentColor,
                                                  ),
                                                  Text(
                                                      'Choose\nSleeve\nDesign',
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w300)
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(mdata.data['Features']['PipingDesign'] == true)
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 150.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: InkWell(
                                              onTap: () async{
                                                var pipingData = await showDialog(context: context,
                                                    builder: (BuildContext context) {
                                                      return ChooseDesign(designType: 'PipingDesign',);
                                                    });
                                                setState(() {
                                                  PipingID = pipingData;
                                                });
                                                sDesigns['PipingDesign'] = PipingID[0];
                                              },
                                              child: PipingID != null
                                                  ? Column(
                                                children: [
                                                  Padding(
                                                    padding:  EdgeInsets.only(top:5.h,bottom: 5.h),
                                                    child: Container(
                                                      height:120.h,
                                                      width:90.w,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: CachedNetworkImage(
                                                          imageUrl:PipingID[2],
                                                          fit: BoxFit.cover,
                                                          placeholder: (context, url) => Container(
                                                              height:120.h,
                                                              width:120.w,
                                                              child: CircularProgressIndicator()),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      '₹ '+ PipingID[3].toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w400)
                                                  )
                                                ],
                                              )
                                                  :
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.color_lens_rounded,
                                                    size: 40.r,
                                                    color: Theme.of(context).accentColor,
                                                  ),
                                                  Text(
                                                      'Choose\nPiping\nDesign',
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w300)
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(mdata.data['Features']['PonchaDesign'] == true)
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 150.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: InkWell(
                                              onTap: () async{
                                                var ponchaData = await showDialog(context: context,
                                                    builder: (BuildContext context) {
                                                      return ChooseDesign(designType: 'PonchaDesign',);
                                                    });
                                                setState(() {
                                                  PonchaID = ponchaData;
                                                });
                                                sDesigns['PonchaDesign'] = PonchaID[0];
                                              },
                                              child: PonchaID != null
                                                  ? Column(
                                                children: [
                                                  Padding(
                                                    padding:  EdgeInsets.only(top:5.h,bottom: 5.h),
                                                    child: Container(
                                                      height:120.h,
                                                      width:90.w,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: CachedNetworkImage(
                                                          imageUrl:PonchaID[2],
                                                          fit: BoxFit.cover,
                                                          placeholder: (context, url) => Container(
                                                              height:120.h,
                                                              width:120.w,
                                                              child: CircularProgressIndicator()),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      '₹ '+ PonchaID[3].toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w400)
                                                  )
                                                ],
                                              )
                                                  :
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.color_lens_rounded,
                                                    size: 40.r,
                                                    color: Theme.of(context).accentColor,
                                                  ),
                                                  Text(
                                                      'Choose\nPoncha\nDesign',
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w300)
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(mdata.data['Features']['CollarDesign'] == true)
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 150.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: InkWell(
                                              onTap: () async{
                                                var collarData = await showDialog(context: context,
                                                    builder: (BuildContext context) {
                                                      return ChooseDesign(designType: 'CollarDesign',);
                                                    });
                                                setState(() {
                                                  CollarID = collarData;
                                                });
                                                sDesigns['CollarDesign'] = CollarID[0];
                                              },
                                              child: CollarID != null
                                                  ? Column(
                                                children: [
                                                  Padding(
                                                    padding:  EdgeInsets.only(top:5.h,bottom: 5.h),
                                                    child: Container(
                                                      height:120.h,
                                                      width:90.w,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: CachedNetworkImage(
                                                          imageUrl:CollarID[2],
                                                          fit: BoxFit.cover,
                                                          placeholder: (context, url) => Container(
                                                              height:120.h,
                                                              width:120.w,
                                                              child: CircularProgressIndicator()),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      '₹ '+ CollarID[3].toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w400)
                                                  )
                                                ],
                                              )
                                                  :
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.color_lens_rounded,
                                                    size: 40.r,
                                                    color: Theme.of(context).accentColor,
                                                  ),
                                                  Text(
                                                      'Choose\nCollar',
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w300)
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(mdata.data['Features']['SleeveLength'] == true)
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 150.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: InkWell(
                                              onTap: () async{
                                                var sleevelengthData = await showDialog(context: context,
                                                    builder: (BuildContext context) {
                                                      return ChooseDesign(designType: 'SleeveLength',);
                                                    });
                                                setState(() {
                                                  SleeveLengthID = sleevelengthData;
                                                });
                                                sDesigns['SleeveLength'] = SleeveLengthID[0];
                                              },
                                              child: SleeveLengthID != null
                                                  ? Column(
                                                mainAxisAlignment:MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      SleeveLengthID[0].toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w400)
                                                  )
                                                ],
                                              )
                                                  :
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.zoom_out_map_rounded,
                                                    size: 40.r,
                                                    color: Theme.of(context).accentColor,
                                                  ),
                                                  Text(
                                                      'Choose\nSleeve\nLength',
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w300)
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if(mdata.data['Lining'] != false)
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 150.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: InkWell(
                                              onTap: () async{
                                                setState(() {
                                                  liningEnabled = !liningEnabled;
                                                });

                                              },
                                              child: Stack(
                                                children:[
                                                  Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.line_weight,
                                                          size: 40.r,
                                                          color: Theme.of(context).accentColor,
                                                        ),
                                                        Text(
                                                            'Set\nLining',
                                                            style: TextStyle(
                                                                color: Theme.of(context).secondaryHeaderColor,
                                                                fontSize: 14.sp,
                                                                fontWeight: FontWeight.w300)
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  if (liningEnabled == true)
                                                    Container(
                                                      width: 100.w,
                                                      height: 150.h,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(15.0),
                                                          color: Theme.of(context).accentColor.withOpacity(0.7)),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            Icons.done,
                                                            color: Colors.black,
                                                            size: 40.r,
                                                          ),
                                                          Text(
                                                              '₹' + mdata.data['Lining'].toString(),
                                                              style: TextStyle(
                                                                  color: Theme.of(context).secondaryHeaderColor,
                                                                  fontSize: 16.sp,
                                                                  fontWeight: FontWeight.w900)
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FlatButton(
                                child: Text('Cancel',
                                    style: TextStyle(
                                        color: Theme.of(context).secondaryHeaderColor)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Theme.of(context).accentColor),
                                ),
                                onPressed: () {
                                  if(liningEnabled == true){
                                    sDesigns['Lining'] = mdata.data['Lining'];
                                  }
                                  Navigator.of(context).pop(sDesigns);
                                },)
                            ],
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),

          ])),
    );
  }
}


class ChooseDesign extends StatefulWidget {
  final String designType;

  const ChooseDesign({Key key, this.designType}) : super(key: key);
  @override
  _ChooseDesignState createState() => _ChooseDesignState();
}

class _ChooseDesignState extends State<ChooseDesign> {
  List<dynamic> selectedID = [null,null,null,null];
  List<bool> isSelected = [false, false, false,false,false];
  List<String> SLength = ['0','1/4','1/2','3/4','1'];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
          height: 600.h,
          margin: EdgeInsets.only(top: 1.h),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme
                .of(context)
                .primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Center(
                child: Text(
                  'Choose Design',
                  style: TextStyle(
                      color: Theme
                          .of(context)
                          .secondaryHeaderColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: 510.h,
              child: (widget.designType == 'SleeveLength')?
              Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Choose Length', style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:10.h),
                    child: SizedBox(
                      height: 55.h,
                      child: ToggleButtons(
                        children: <Widget>[
                          Text(
                            '0',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            '1/4',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            '1/2',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            '3/4',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            '1',
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
                            for (int indexBtn = 0;indexBtn < isSelected.length;indexBtn++) {
                              if (indexBtn == index) {
                                isSelected[indexBtn] = !isSelected[indexBtn];
                              } else {
                                isSelected[indexBtn] = false;
                              }
                              if(isSelected[indexBtn] == true){
                                selectedID[0] = SLength[index];
                              }
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),)
                  :SingleChildScrollView(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Designs').where('Type',isEqualTo: widget.designType).snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(snapshot.hasData){
                        return Wrap(
                          children: snapshot.data.docs.map((document) => Padding(
                            padding:  EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
                            child: new
                            Container(
                              width: 120.w,
                              height: 200.h,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap:(){
                                            setState(() {
                                              selectedID[0] = document.id;
                                              selectedID[1] = document['Name'];
                                              selectedID[2] = document['Image'];
                                              selectedID[3] = document['Price'];
                                            });
                                          },
                                          child: Stack(
                                              children:[
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(10.w, 10.h, 0, 0),
                                                  width:110.w,
                                                  height: 150.h,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(15.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl:document['Image'],
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) => Container(
                                                          height:120.h,
                                                          width:120.w,
                                                          child: CircularProgressIndicator()),
                                                    ),
                                                  ),
                                                ),
                                                if(selectedID[0] == document.id)
                                                  Padding(
                                                    padding: EdgeInsets.fromLTRB(10.w, 10.h, 0, 0),
                                                    child: Container(
                                                      width:100.w,
                                                      height: 140.h,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(15.0),
                                                          color: Theme.of(context).accentColor.withOpacity(0.7)
                                                      ),
                                                      child: Icon(Icons.done,color: Colors.black,size: 40.r,),
                                                    ),
                                                  )
                                              ]
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:  EdgeInsets.only(top: 5.h),
                                              child: Text(document['Name'],style: TextStyle(color: Theme.of(context).accentColor,fontSize: 14.sp,fontWeight: FontWeight.w800),),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.only(top:2.h),
                                              child: Text('₹' + document['Price'].toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 12.sp,fontWeight: FontWeight.w300),),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ]),
                            ),
                          )
                          ).toList(),
                        );
                      }
                      else{
                        return Container(height: 50.h,width: 50.w,);
                      }
                    }
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                FlatButton(
                  minWidth: 150.w,
                  child: Text('Cancel',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                    minWidth: 150.w,
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                    onPressed: () {if(selectedID[0] !=null){
                      Navigator.of(context).pop(selectedID);
                    }
                    else{
                      Navigator.of(context).pop();
                    }
                      }),
              ],
            ),
          ])),
    );
  }
}
