import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CreateBanner extends StatefulWidget {
  @override
  _CreateBannerState createState() => _CreateBannerState();
}

class _CreateBannerState extends State<CreateBanner> {
  String bannerType = null;
  String offercat,minDate,maxDate,adTitle,adDesc,adlink;
  int minDiscount,maxDiscount,minPrice,maxPrice;
  List<bool> OfferType = [true, false];
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
    if(bannerType == null){
      Fluttertoast.showToast(
          msg: "Choose Banner Type..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0
      );
    }
    if(bannerType == 'Advertisement'){
      if(adTitle == null || adDesc == null){
        Fluttertoast.showToast(
            msg: "Required Fields are empty!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).secondaryHeaderColor,
            fontSize: 16.0
        );
      }
      else{
        DateTime now = DateTime.now();
        String mDate = DateFormat('dd-MM-yyyy').format(now);
        await pr.show();
        DocumentReference mBanners = FirebaseFirestore.instance.collection('Banners').doc();
        String bid = mBanners.id;
        String fileName = basename(_imageFile.path);
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('Banners/$bid/$fileName');
        UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        taskSnapshot.ref.getDownloadURL().then(
                (value) => mBanners.set({
              'BannerType': bannerType,
              'Title': adTitle,
              'Description': adDesc,
              'PostDate': mDate,
              'Image' : value,})

        );
        Fluttertoast.showToast(
            msg: "Banner Created Successfully...",
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
    if(bannerType == 'Link'){
      if(adlink == null){
        Fluttertoast.showToast(
            msg: "Required Fields are empty!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).secondaryHeaderColor,
            fontSize: 16.0
        );
      }
      else{
        DateTime now = DateTime.now();
        String mDate = DateFormat('dd-MM-yyyy').format(now);
        await pr.show();
        DocumentReference mBanners = FirebaseFirestore.instance.collection('Banners').doc();
        String bid = mBanners.id;
        String fileName = basename(_imageFile.path);
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('Banners/$bid/$fileName');
        UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        taskSnapshot.ref.getDownloadURL().then(
                (value) => mBanners.set({
              'BannerType': bannerType,
              'Link': adlink,
              'PostDate': mDate,
              'Image' : value,})
        );
        Fluttertoast.showToast(
            msg: "Banner Created Successfully...",
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
    if(bannerType == 'Offer'){
      if(offercat == null){
        Fluttertoast.showToast(
            msg: "Select Offer Category!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).secondaryHeaderColor,
            fontSize: 16.0
        );
      }
      else{
        bool allOK = false;
        DateTime now = DateTime.now();
        String mDate = DateFormat('dd-MM-yyyy').format(now);
        Map<String,dynamic> offerData = new Map();
        offerData['BannerType'] = bannerType;
        offerData['OfferCategory'] = offercat;
        offerData['PostDate'] = mDate;

        if(OfferType[0] == true){
          if(minDiscount == null || maxDiscount == null){
            Fluttertoast.showToast(
                msg: "Insert Required Values!!!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Theme.of(context).cardColor,
                textColor: Theme.of(context).secondaryHeaderColor,
                fontSize: 16.0
            );
          }
          else{
            offerData["Discount"] = true;
            offerData["Price"] = false;
            offerData["MinimumDiscount"] = minDiscount;
            offerData["MaximumDiscount"] = maxDiscount;
            allOK = true;
          }
        }
        if(OfferType[1] == true){
          if(minPrice == null || maxPrice == null){
            Fluttertoast.showToast(
                msg: "Insert Required Values!!!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Theme.of(context).cardColor,
                textColor: Theme.of(context).secondaryHeaderColor,
                fontSize: 16.0
            );
          }
          else{
            offerData["Discount"] = false;
            offerData["Price"] = true;
            offerData["MinimumPrice"] = minPrice;
            offerData["MaximumPrice"] = maxPrice;
            allOK = true;
          }
        }
        if(allOK == true){
          await pr.show();
          DocumentReference mBanners = FirebaseFirestore.instance.collection('Banners').doc();
          String bid = mBanners.id;
          String fileName = basename(_imageFile.path);
          Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('Banners/$bid/$fileName');
          UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
          TaskSnapshot taskSnapshot = await uploadTask;
          taskSnapshot.ref.getDownloadURL().then(
                  (value) {
                offerData['Image'] = value;
                mBanners.set(offerData);
              }
          );
          Fluttertoast.showToast(
              msg: "Banner Created Successfully...",
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
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Theme.of(context).secondaryHeaderColor, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),

      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
        height: 620.h,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListView(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Center(
              child: Text(
                'Create Banner',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
            child: DropdownButtonFormField(
              hint: Text(
                'Choose Category',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor),
              ),
              style: TextStyle(color: Colors.white),
              value: bannerType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
              ),
              onChanged: (newValue) {
                setState(() {
                  bannerType = newValue;
                });
              },
              items: [
                DropdownMenuItem(
                  value: "Advertisement",
                  child: Text(
                    "Advertisement",style: TextStyle(
                      color:
                      Theme.of(context).secondaryHeaderColor),
                  ),
                ),
                DropdownMenuItem(
                  value: "Offer",
                  child: Text(
                    "Offer",style: TextStyle(
                      color:
                      Theme.of(context).secondaryHeaderColor),
                  ),
                ),
                DropdownMenuItem(
                  value: "Link",
                  child: Text(
                    "Link",style: TextStyle(
                      color:
                      Theme.of(context).secondaryHeaderColor),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              Center(
                child: Container(
                  height: 160.h,
                  width: 300.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(30),
                  ),

                  margin: EdgeInsets.only(
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
          if(bannerType == 'Advertisement')
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(30.w, 20.h, 20.w, 0),
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
                      hintText: "Heading",
                      fillColor: Theme.of(context).cardColor),
                  onChanged: (value) {
                    adTitle = value;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.w, 20.h, 20.w, 5.h),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
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
                      hintText: "Description",
                      fillColor: Theme.of(context).cardColor),
                  onChanged: (value) {
                    adDesc = value;
                  },
                ),
              ),
            ],
          ),
          if(bannerType == 'Link')
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(30.w, 20.h, 20.w, 20.h),
                child: TextField(
                  keyboardType: TextInputType.name,
                  maxLines: 2,
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
                      hintText: "Link",
                      fillColor: Theme.of(context).cardColor),
                  onChanged: (value) {
                    adlink = value;
                  },
                ),
              ),
              SizedBox(height: 120.h,)
            ],
          ),
          if(bannerType == 'Offer')
          Column(
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('SubCategories').snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.docs.isNotEmpty) {
                          return DropdownButtonFormField(
                            hint: Text(
                              'Offer For',
                              style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor),
                            ),
                            style: TextStyle(color: Colors.white),
                            value: offercat,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                offercat = newValue;
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
                                    height:20.h,
                                    child: CircularProgressIndicator()),
                              ],
                            ));
                      }
                    }),
              ),
              Text(
                'Offer Type',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 55.h,
                child: ToggleButtons(
                  children: <Widget>[
                    Text(
                      'Discount',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      'Price',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                  fillColor: Theme.of(context).accentColor,
                  isSelected: OfferType,
                  borderColor: Theme.of(context).secondaryHeaderColor,
                  borderRadius: BorderRadius.circular(10),
                  onPressed: (int index) {
                    setState(() {
                      for (int indexBtn = 0;indexBtn < OfferType.length;indexBtn++) {
                        if (indexBtn == index) {
                          OfferType[indexBtn] = true;
                        } else {
                          OfferType[indexBtn] = false;
                        }
                      }
                    });
                  },
                ),
              ),
              if(OfferType[0] == true)
              Padding(
                padding:  EdgeInsets.only(top:10.h),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                            hintText: "Min Discount %",
                            fillColor: Theme.of(context).cardColor),
                        onChanged: (value) {
                          minDiscount = int.parse(value);
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
                            hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                            hintText: "Max Discount %",
                            fillColor: Theme.of(context).cardColor),
                        onChanged: (value) {
                          maxDiscount = int.parse(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if(OfferType[1] == true)
              Padding(
                padding:  EdgeInsets.only(top:10.h),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                            hintText: "Min Price ₹",
                            fillColor: Theme.of(context).cardColor),
                        onChanged: (value) {
                          minPrice = int.parse(value);
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
                            hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                            hintText: "Max Price ₹",
                            fillColor: Theme.of(context).cardColor),
                        onChanged: (value) {
                          maxPrice = int.parse(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 50.w,vertical: 10.h),
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