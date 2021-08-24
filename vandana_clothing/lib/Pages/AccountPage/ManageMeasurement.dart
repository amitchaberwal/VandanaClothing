import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vandana_clothing/Pages/AccountPage/Utils/EditMeasurement.dart';
import 'package:vandana_clothing/Pages/AccountPage/Utils/NewMeasurement.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageMeasurement extends StatefulWidget {
  @override
  _ManageMeasurementState createState() => _ManageMeasurementState();
}

class _ManageMeasurementState extends State<ManageMeasurement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Body Measurements',
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
      body: ListView(
          children:[
            Padding(
              padding:  EdgeInsets.fromLTRB(50.w, 10.h, 50.w, 0),
              child: FlatButton(
                onPressed:(){
                  showDialog(context: context,
                      builder: (BuildContext context){
                        return NewMeasurement();
                      }
                  );
                },
                child: Center(
                  child: ListTile(
                    leading:Icon(Icons.add_rounded,color: Colors.black,),
                    title: Text("New Measurement",style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                  ),
                ),
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Measurement').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.hasData){
                    return Padding(
                      padding:  EdgeInsets.only(bottom: 20.h),
                      child: Column(
                        children: snapshot.data.docs.map((document) => Padding(
                          padding:  EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                          child: new
                          Container(
                            width: double.infinity,
                            height: 160.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment:Alignment.topRight,
                                  child: IconButton(
                                    onPressed:(){
                                      FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Measurement').doc(document.id).delete();
                                    },
                                    icon: Icon(Icons.delete_outline_rounded,size: 25.r,),
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                Align(
                                  alignment:Alignment.topLeft,
                                  child: IconButton(
                                    onPressed:(){
                                      showDialog(context: context,
                                          builder: (BuildContext context){
                                            return EditMeasurement(mtitleid: document.id,);
                                          }
                                      );
                                    },
                                    icon: CircleAvatar(
                                      radius: 12.r,
                                      backgroundColor: Theme.of(context).accentColor,
                                        child: Icon(Icons.edit_rounded,size: 15.r,color: Theme.of(context).primaryColor,),
                                      ),
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                Column(
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(top: 10.h),
                                    child: Text(document.id,style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.sp,fontWeight: FontWeight.w700),),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(top: 15.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Shoulder: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.fade,),
                                        Flexible(child: Text(document['Shoulder'] + " " + document['MeasurementUnit'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.fade,)),
                                        SizedBox(width: 30.w,),
                                        Text('Chest/Bust: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.fade,),
                                        Flexible(child: Text(document['Bust'] + " " + document['MeasurementUnit'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.fade,)),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Waist: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.fade,),
                                        Flexible(child: Text(document['Waist'] + " " + document['MeasurementUnit'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.fade,)),
                                        SizedBox(width: 30.w,),
                                        Text('Sleeve Length: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.fade,),
                                        Flexible(child: Text(document['SleeveLength'] + " " + document['MeasurementUnit'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.fade,)),
                                      ],
                                    ),
                                  ),


                                  Padding(
                                    padding:  EdgeInsets.only(top: 10.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Top Length: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.fade,),
                                        Flexible(child: Text(document['TopLength'] + " " + document['MeasurementUnit'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.fade,)),
                                        SizedBox(width: 30.w,),
                                        Text('Bottom Length: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.fade,),
                                        Flexible(child: Text(document['BottomLength'] + " " + document['MeasurementUnit'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.fade,)),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Hip Size: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.fade,),
                                        Flexible(child: Text(document['Hip'] + " " + document['MeasurementUnit'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.fade,)),
                                        SizedBox(width: 30.w,),
                                        Text('Inseam Length: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.fade,),
                                        Flexible(child: Text(document['InseamLength'] + " " + document['MeasurementUnit'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.fade,)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        )
                        ).toList(),
                      ),
                    );
                  }
                  else{
                    return Center(child: Image.asset("images/DualBall.gif",height: 80.h,));
                  }
                }
            ),
          ]

      ),

    );
  }
}

