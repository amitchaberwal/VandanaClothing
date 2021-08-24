import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vc_admin/Pages/ManageDatabase/Designs/Poncha/CreatePonchaDesign.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ManagePoncha extends StatefulWidget {
  @override
  _ManagePonchaState createState() => _ManagePonchaState();
}

class _ManagePonchaState extends State<ManagePoncha> {
  @override
  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Deleting...',
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

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Poncha Design',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        //toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.add_box_rounded,
              color: Theme.of(context).accentColor,
              size: 35.r,
            ),
            onPressed: (){
              showDialog(context: context,
                  builder: (BuildContext context){
                    return CreatePoncha();
                  }
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 710.h,
            child: SingleChildScrollView(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Designs').where('Type',isEqualTo: 'PonchaDesign').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(snapshot.hasData){
                      return Wrap(
                        children: snapshot.data.docs.map((document) => Padding(
                          padding:  EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
                          child: new
                          Container(
                            width: 160.w,
                            height: 270.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.fromLTRB(10.w, 10.h, 0, 0),
                                        width: 150.w,
                                        height: 200.h,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0),
                                          child: CachedNetworkImage(
                                            imageUrl:document['Image'],
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(
                                                height:120,
                                                width:120,
                                                child: CircularProgressIndicator()),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:  EdgeInsets.only(top: 10.h),
                                            child: Text(document['Name'],style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.sp,fontWeight: FontWeight.w600),),
                                          ),
                                          Padding(
                                            padding:  EdgeInsets.only(top:2.h),
                                            child: Text('₹' + document['Price'].toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 18.sp,fontWeight: FontWeight.w300),),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Align(
                                    alignment:Alignment.topRight,
                                    child: IconButton(
                                      onPressed:() async{
                                        await pr.show();
                                        await FirebaseStorage.instance.ref().child("Designs").child(document.id).listAll().then((value) => value.items.forEach((element) async {
                                          element.delete();
                                        }));
                                        await FirebaseFirestore.instance.collection('Designs').doc(document.id).delete();
                                        await pr.hide();
                                      },
                                      icon: Icon(Icons.delete_outline_rounded,size: 25.r,),
                                      color: Theme.of(context).accentColor,
                                    ),
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
        ],
      ),
    );
  }
}

