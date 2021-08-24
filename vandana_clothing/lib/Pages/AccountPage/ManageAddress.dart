import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vandana_clothing/Pages/AccountPage/Utils/EditAddress.dart';
import 'package:vandana_clothing/Pages/AccountPage/Utils/NewAddress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageAddress extends StatefulWidget {
  @override
  _ManageAddressState createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Manage Addresses',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize:25.sp,
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
            padding:  EdgeInsets.fromLTRB(70.w, 10.h, 70.w, 0),
            child: SizedBox(
              width:100.w,
              child: FlatButton(
                onPressed:(){
                  showDialog(context: context,
                      builder: (BuildContext context){
                        return NewAddress();
                      }
                  );
                },
                child: Center(
                  child: ListTile(
                    leading:Icon(Icons.add_rounded,color: Colors.black,),
                    title: Text("Add Address",style: TextStyle(color: Colors.black,fontSize: 20.sp,fontWeight: FontWeight.w800 ),),
                  ),
                ),
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Address').snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasData){
                 return Column(
                  children: snapshot.data.docs.map((document) => Padding(
                    padding:  EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                    child: new
                    Container(
                      width: double.infinity,
                      height: 150.h,
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
                                FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Address').doc(document.id).delete();
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
                                      return EditAddress(mAddressid: document.id,);
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
                              padding: EdgeInsets.only(top: 5.h),
                              child: Text(document.id,style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.sp,fontWeight: FontWeight.w700),),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top: 10.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Name: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),),
                                  Flexible(child: Text(document['Name'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500),)),
                                ],
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top: 10.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Address: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.fade,),
                                    Flexible(flex:3,child: Text(document['AddressLineA'] + ',' + document['AddressLineB'] ,style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500))),
                                ],
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top: 10.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('City: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.fade,),
                                  Flexible(child: Text(document['City'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.fade,)),
                                  SizedBox(width: 30.w,),
                                  Text('State: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.fade,),
                                  Flexible(child: Text(document['State'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.fade,)),
                                ],
                              ),
                            ),

                            Padding(
                              padding:  EdgeInsets.only(top: 10.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('PinCode: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.fade,),
                                  Flexible(child: Text(document['PinCode'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.fade,)),
                                  SizedBox(width: 30.w,),
                                  Text('Phone No.: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.fade,),
                                  Flexible(child: Text(document['PhoneNumber'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 14.sp,fontWeight: FontWeight.w500),overflow: TextOverflow.fade,)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  )
                  ).toList(),
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
