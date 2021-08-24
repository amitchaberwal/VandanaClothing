import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class NewAddress extends StatefulWidget {
  @override
  _NewAddressState createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  String addname,adduname,adda,addb,addcity,addstate,addpin,addphone;
  final databaseReference = FirebaseFirestore.instance;
  ProgressDialog pr;

  Future saveAddress(BuildContext context) async {

    if(adduname == null ||addname == null || adda == null || addb == null || addcity == null || addstate == null || addpin == null || addphone == null ){
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
      var checkName = await databaseReference.collection('Users').doc(uphone).collection('Address').doc(addname).get();
      if(checkName.exists){
        Fluttertoast.showToast(
            msg: "Address Name Exists...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).secondaryHeaderColor,
            fontSize: 16.0
        );
        await pr.hide();
      }
      else{
        databaseReference.collection('Users').doc(uphone).collection('Address').doc(addname).set({
          'Name': adduname,
          'AddressLineA': adda,
          'AddressLineB' : addb,
          'City' : addcity,
          'State' : addstate,
          'PinCode' : addpin,
          'PhoneNumber' : addphone,});

        Fluttertoast.showToast(
            msg: "Address Added...",
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
      height: 670.h,
      margin: EdgeInsets.only(top: 1.h),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),

      ),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top:10.h),
            child: Center(
              child: Text(
              'New Address',
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold),
            ),),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 10.h),
            child: TextField(
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
                  hintText: "Address Title",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                addname = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 5.h, 0, 0),
            child: Text(
              'Name & Address',
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 5.h, 8.w, 0),
            child: TextField(
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
                  hintText: "Name",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                adduname = value;
              },
            ),
          ),

          Padding(
            padding:  EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0),
            child: TextField(
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
                  hintText: "Address Line 1",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                adda = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0),
            child: TextField(
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
                  hintText: "Address Line 2",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                addb = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0),
            child: TextField(
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
                  hintText: "City",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                addcity = value;
              },
            ),
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0),
            child: TextField(
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
                  hintText: "State",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                addstate = value;
              },
            ),
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0),
            child: TextField(
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
                  hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  hintText: "Pin Code",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                addpin = value;
              },
            ),
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0),
            child: TextField(
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
                  hintStyle: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  hintText: "Phone Number",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                addphone = value;
              },
            ),
          ),
          SizedBox(height: 5.h,),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              FlatButton(
                minWidth: 150.w,
                child: Text('Cancel',style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                minWidth: 150.w,
                child: Text('Submit',style: TextStyle(color: Theme.of(context).accentColor),),
                onPressed: ()=> saveAddress(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
