import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditAddress extends StatefulWidget {
  final String mAddressid;

  const EditAddress({Key key, this.mAddressid}) : super(key: key);

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  Map<String,dynamic> mdata = new Map();
  final databaseReference = FirebaseFirestore.instance;
  ProgressDialog pr;
  bool processed = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    DocumentSnapshot mydata =   await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Address').doc(widget.mAddressid).get();
    if(mydata.exists){
      mdata = mydata.data();
    }
    setState(() {
      processed = true;
    });
  }

  Future saveAddress(BuildContext context) async {
    if (mdata['Name'] == "" || mdata['AddressLineA'] == "" || mdata['AddressLineB'] == "" || mdata['City'] == "" || mdata['State'] == "" || mdata['PinCode'] == "" || mdata['PhoneNumber'] == "") {
      Fluttertoast.showToast(
          msg: "Please fill all details..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0);
    } else {
      await pr.show();
      String uphone = FirebaseAuth.instance.currentUser.phoneNumber;
        databaseReference.collection('Users').doc(uphone).collection('Address').doc(widget.mAddressid).update(mdata);
        Fluttertoast.showToast(
            msg: "Address Saved...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).secondaryHeaderColor,
            fontSize: 16.0);
        await pr.hide();
        Navigator.of(context).pop();

    }
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Saving Address...',
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
      height: 710.h,
      margin: EdgeInsets.only(top: 1.h),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Center(
              child: Text(
                'Edit Address',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
    (processed == true)?
          Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 10.h),
                        child: Text(
                          widget.mAddressid,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 5.h, 8.w, 0),
                        child: Column(
                          children: [
                            Text(
                              'Name',
                              style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextFormField(
                              controller: TextEditingController(text: mdata['Name']),
                              keyboardType: TextInputType.name,
                              style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
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

                                  fillColor: Theme.of(context).cardColor),
                              onChanged: (value) {
    mdata['Name'] = value;
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0),
                        child: Column(
                          children: [
                            Text(
                              'Address Line A',
                              style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextFormField(
                              controller: TextEditingController(text: mdata['AddressLineA']),
                              keyboardType: TextInputType.name,
                              style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
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
                                  fillColor: Theme.of(context).cardColor),
                              onChanged: (value) {
    mdata['AddressLineA'] = value;
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0),
                        child: Column(
                          children: [
                            Text(
                              'Address Line B',
                              style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextFormField(
                              controller: TextEditingController(text: mdata['AddressLineB']),
                              keyboardType: TextInputType.name,
                              style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
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
                                  fillColor: Theme.of(context).cardColor),
                              onChanged: (value) {
    mdata['AddressLineB'] = value;
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0),
                        child: Column(
                          children: [
                            Text(
                              'City',
                              style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextFormField(
                              controller: TextEditingController(text: mdata['City']),
                              keyboardType: TextInputType.name,
                              style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
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
                                  fillColor: Theme.of(context).cardColor),
                              onChanged: (value) {
    mdata['City'] = value;
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0),
                        child: Column(
                          children: [
                            Text(
                              'State',
                              style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextFormField(
                              controller: TextEditingController(text: mdata['State']),
                              keyboardType: TextInputType.name,
                              style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
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
                                  fillColor: Theme.of(context).cardColor),
                              onChanged: (value) {
    mdata['State'] = value;
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0),
                        child: Column(
                          children: [
                            Text(
                              'PinCode',
                              style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextFormField(
                              controller: TextEditingController(text: mdata['PinCode']),
                              keyboardType: TextInputType.number,
                              style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
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
                                  fillColor: Theme.of(context).cardColor),
                              onChanged: (value) {
    mdata['PinCode'] = value;
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0),
                        child: Column(
                          children: [
                            Text(
                              'Phone Number',
                              style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextFormField(
                              controller: TextEditingController(text: mdata['PhoneNumber']),
                              keyboardType: TextInputType.phone,
                              style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
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
                                  fillColor: Theme.of(context).cardColor),
                              onChanged: (value) {
    mdata['PhoneNumber'] = value;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
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
                            onPressed: () => saveAddress(context),
                          ),
                        ],
                      ),

                    ],
                  )
                : Center(
                      child: Image.asset(
                    "images/DualBall.gif",
                    height: 80.h,
                  ))
        ],
      ),
    );
  }
}
