import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewMeasurement extends StatefulWidget {
  @override
  _NewMeasurementState createState() => _NewMeasurementState();
}

class _NewMeasurementState extends State<NewMeasurement> {
  String mtitle,mshoulder,mbust,mwaist,msleeve,mtop,mbottom,mhip,minseam;
  List<bool> isSelected = [false, false, false,false,false];
  String mValue = "Inches";
  final databaseReference = FirebaseFirestore.instance;
  ProgressDialog pr;
  void templateData(int template){
    switch(template){
      case 0:
        setState(() {
          mshoulder='13';
          mbust='36';
          mwaist='28';
          msleeve='14';
          mtop='40';
          mbottom='38';
          mhip='30';
          minseam='27';
        });

      break;
      case 1:
        setState(() {
          mshoulder='14';
          mbust='38';
          mwaist='30';
          msleeve='16';
          mtop='40';
          mbottom='38';
          mhip='30';
          minseam='27';
        });


      break;
      case 2:
        setState(() {
          mshoulder='15';
          mbust='40';
          mwaist='32';
          msleeve='16';
          mtop='40';
          mbottom='38';
          mhip='32';
          minseam='29';
        });

      break;
      case 3:
        setState(() {
          mshoulder='16';
          mbust='42';
          mwaist='34';
          msleeve='16';
          mtop='40';
          mbottom='38';
          mhip='34';
          minseam='29';
        });
      break;
      case 4:
        setState(() {
          mshoulder='17';
          mbust='44';
          mwaist='36';
          msleeve='16';
          mtop='40';
          mbottom='38';
          mhip='36';
          minseam='31';
        });

      break;
    }
  }

  Future saveMeasurement(BuildContext context) async {

    if(mshoulder == null ||mbust == null || mwaist == null || msleeve == null || mtop == null || mbottom == null || mhip == null || minseam == null || mtitle == null ){
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
      String uphone = FirebaseAuth.instance.currentUser.phoneNumber;
      var checkName = await databaseReference.collection('Users').doc(uphone).collection('Measurement').doc(mtitle).get();
      if(checkName.exists){
        Fluttertoast.showToast(
            msg: "Title Exists Already...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).secondaryHeaderColor,
            fontSize: 16.0
        );
        await pr.hide();
      }
      else{
        databaseReference.collection('Users').doc(uphone).collection('Measurement').doc(mtitle).set({
          'Shoulder': mshoulder,
          'Bust': mbust,
          'Waist' : mwaist,
          'SleeveLength' : msleeve,
          'TopLength' : mtop,
          'BottomLength' : mbottom,
          'Hip' : mhip,
          'InseamLength' : minseam,
        'MeasurementUnit': mValue});

        Fluttertoast.showToast(
            msg: "Measurement Saved...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).secondaryHeaderColor,
            fontSize: 16.0
        );
        await pr.hide();
        Navigator.of(context).pop();
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
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
  contentBox(context){
    return Container(
      height: 640.h,
      margin: EdgeInsets.only(top: 1.h),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),

      ),
      child: ListView(
        children: <Widget>[
          Padding(
            padding:  EdgeInsets.only(top:10.h),
            child: Center(
              child: Text(
                'Insert Measurement',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),),
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 10.h),
            child: TextFormField(
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
                  hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  hintText: "Title",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                mtitle = value;
              },
            ),
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(20.w, 5.h, 0.w, 10.h),
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
              'Size Templates',
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 10.h),
            child: Center(
              child: SizedBox(
                height: 55.h,
                child: ToggleButtons(
                  children: <Widget>[
                    Text(
                      'S',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'M',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'L',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'XL',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'XXL',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                  fillColor: Theme.of(context).accentColor,
                  isSelected: isSelected,
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
                          templateData(index);
                        }
                      }
                    });
                  },
                ),
              ),
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
            padding:  EdgeInsets.only(top:10.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Shoulder',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 80.w,
                      child: TextFormField(
                        controller: TextEditingController(text: mshoulder),
                        keyboardType: TextInputType.number,
                        style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(15),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                            fillColor: Theme.of(context).cardColor),
                        onChanged: (value) {
                          mshoulder = value;
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
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 80.w,
                      child: TextFormField(
                        controller: TextEditingController(text: mbust),
                        keyboardType: TextInputType.number,
                        style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(15),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                            fillColor: Theme.of(context).cardColor),
                        onChanged: (value) {
                          mbust = value;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding:  EdgeInsets.only(top:10.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Waist',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 80.w,
                      child: TextFormField(
                        controller: TextEditingController(text: mwaist),
                        keyboardType: TextInputType.number,
                        style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(15),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                            fillColor: Theme.of(context).cardColor),
                        onChanged: (value) {
                          mwaist = value;
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
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 80.w,
                      child: TextFormField(
                        controller: TextEditingController(text: msleeve),
                        keyboardType: TextInputType.number,
                        style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(15),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                            fillColor: Theme.of(context).cardColor),
                        onChanged: (value) {
                          msleeve = value;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding:  EdgeInsets.only(top:10.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Top Length',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 80.w,
                      child: TextFormField(
                        controller: TextEditingController(text: mtop),
                        keyboardType: TextInputType.number,
                        style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(15),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                            fillColor: Theme.of(context).cardColor),
                        onChanged: (value) {
                          mtop = value;
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
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 80.w,
                      child: TextFormField(
                        controller: TextEditingController(text: mbottom),
                        keyboardType: TextInputType.number,
                        style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(15),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                            fillColor: Theme.of(context).cardColor),
                        onChanged: (value) {
                          mbottom = value;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding:  EdgeInsets.only(top:10.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Hip Size',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 80.w,
                      child: TextFormField(
                        controller: TextEditingController(text: mhip),
                        keyboardType: TextInputType.number,
                        style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(15),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                            fillColor: Theme.of(context).cardColor),
                        onChanged: (value) {
                          mhip = value;
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
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 80.w,
                      child: TextFormField(
                        controller: TextEditingController(text: minseam),
                        keyboardType: TextInputType.number,
                        style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(15),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                            fillColor: Theme.of(context).cardColor),
                        onChanged: (value) {
                          minseam = value;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),



          SizedBox(height: 5.h,),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              FlatButton(
                minWidth: 150.w,
                child: Text('Cancel',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 16.sp)),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                minWidth: 150.w,
                child: Text('Submit',style: TextStyle(color: Theme.of(context).accentColor,fontSize: 16.sp),),
                onPressed: ()=> saveMeasurement(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



