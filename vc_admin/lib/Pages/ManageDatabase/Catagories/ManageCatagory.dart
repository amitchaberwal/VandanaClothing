import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vc_admin/Pages/ManageDatabase/Catagories/CreateCategory.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ManageCatagory extends StatefulWidget {
  @override
  _ManageCatagoryState createState() => _ManageCatagoryState();
}

class _ManageCatagoryState extends State<ManageCatagory> {
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
          'Manage Category',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
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
                    return CreateCategory();
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
                  stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(snapshot.hasData){
                      return Wrap(
                        children: snapshot.data.docs.map((document) => Padding(
                          padding:  EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
                          child: new
                          Container(
                            width: 160.w,
                            height: 250.h,
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
                                                height:120.h,
                                                width:120.w,
                                                child: CircularProgressIndicator()),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:  EdgeInsets.only(top: 10.h),
                                        child: Text(document.id,style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.sp,fontWeight: FontWeight.w700),),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment:Alignment.topRight,
                                    child: IconButton(
                                      onPressed:() async{
                                        await pr.show();
                                        await FirebaseFirestore.instance.collection('Categories').doc(document.id).delete();
                                        await FirebaseStorage.instance.ref().child("Categories").child(document.id).listAll().then((value) =>
                                            value.items.forEach((element) async {
                                              print(element);
                                              element.delete();
                                            })
                                        );
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
