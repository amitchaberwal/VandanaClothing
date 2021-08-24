import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditMeasurement extends StatefulWidget {
  final String mtitleid;

  const EditMeasurement({Key key, this.mtitleid}) : super(key: key);
  @override
  _EditMeasurementState createState() => _EditMeasurementState();
}

class _EditMeasurementState extends State<EditMeasurement> {
  String mshoulder, mbust, mwaist, msleeve, mtop, mbottom, mhip, minseam;
  List<bool> isSelected = [false, false, false, false, false];
  String mValue = "Inches";
  final databaseReference = FirebaseFirestore.instance;
  ProgressDialog pr;
  Map<String,dynamic> mdata = new Map();
  bool processed = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    DocumentSnapshot mydata =   await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Measurement').doc(widget.mtitleid).get();
    if(mydata.exists){
      mdata = mydata.data();
    }
    setState(() {
      processed = true;
    });
  }

  Future saveMeasurement(BuildContext context) async {
    if (mdata['Shoulder'] == "" || mdata['Bust'] == "" || mdata['Waist'] == "" || mdata['SleeveLength'] == "" || mdata['TopLength'] == "" || mdata['BottomLength'] == "" || mdata['Hip'] == "" || mdata['InseamLength'] == "") {
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
        databaseReference.collection('Users').doc(uphone).collection('Measurement').doc(widget.mtitleid).update(mdata);
        Fluttertoast.showToast(
            msg: "Measurement Saved...",
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
        message: 'Saving...',
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
      height: 510.h,
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
                'Edit Measurement',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          (processed == true)
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 10.h),
                      child: Text(
                        widget.mtitleid,
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 5.h, 0.w, 10.h),
                      child: Text(
                        'All measurements are in Inches.',
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 0, 0, 0),
                      child: Text(
                        'Body Measurement',
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Shoulder',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 80.w,
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: mdata['Shoulder']),
                                  keyboardType: TextInputType.number,
                                  style: new TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
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
                                      fillColor: Theme.of(context).cardColor),
                                  onChanged: (value) {
                                    mdata['Shoulder'] = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Chest',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 80.w,
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: mdata['Bust']),
                                  keyboardType: TextInputType.number,
                                  style: new TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
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
                                      fillColor: Theme.of(context).cardColor),
                                  onChanged: (value) {
                                    mdata['Bust'] = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Waist',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 80.w,
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: mdata['Waist']),
                                  keyboardType: TextInputType.number,
                                  style: new TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
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
                                      fillColor: Theme.of(context).cardColor),
                                  onChanged: (value) {
                                    mdata['Waist'] = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Sleeve Length',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 80.w,
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: mdata['SleeveLength']),
                                  keyboardType: TextInputType.number,
                                  style: new TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
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
                                      fillColor: Theme.of(context).cardColor),
                                  onChanged: (value) {
                                    mdata['SleeveLength'] = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Top Length',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 80.w,
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: mdata['TopLength']),
                                  keyboardType: TextInputType.number,
                                  style: new TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
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
                                      fillColor: Theme.of(context).cardColor),
                                  onChanged: (value) {
                                    mdata['TopLength'] = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Bottom Length',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 80.w,
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: mdata['BottomLength']),
                                  keyboardType: TextInputType.number,
                                  style: new TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
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
                                      fillColor: Theme.of(context).cardColor),
                                  onChanged: (value) {
                                    mdata['BottomLength'] = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Hip Size',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 80.w,
                                child: TextFormField(
                                  controller:
                                      TextEditingController(text: mdata['Hip']),
                                  keyboardType: TextInputType.number,
                                  style: new TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
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
                                      fillColor: Theme.of(context).cardColor),
                                  onChanged: (value) {
                                    mdata['Hip'] = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Inseam',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 80.w,
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: mdata['InseamLength']),
                                  keyboardType: TextInputType.number,
                                  style: new TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
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
                                      fillColor: Theme.of(context).cardColor),
                                  onChanged: (value) {
                                    mdata['InseamLength'] = value;
                                  },
                                ),
                              ),
                            ],
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
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 16.sp)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          minWidth: 150.w,
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 16.sp),
                          ),
                          onPressed: () => saveMeasurement(context),
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
