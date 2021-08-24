import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vc_admin/Pages/ManageDatabase/Banners/CreateBanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ManageBanners extends StatefulWidget {
  @override
  _ManageBannersState createState() => _ManageBannersState();
}

class _ManageBannersState extends State<ManageBanners> {
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
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Theme.of(context).secondaryHeaderColor, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Manage Banners',
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
                    return CreateBanner();
                  }
              );
            },
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.infinity,
            height: 710.h,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Banners').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.hasData){
                    return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: snapshot.data.docs.map((document) => Padding(
                        padding:  EdgeInsets.symmetric(horizontal:15.w,vertical: 10.h),
                        child: new
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 10.h),
                                      width: 340.w,
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
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:  EdgeInsets.only(left: 10.w),
                                          child: Text(document['BannerType'],style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18.sp,fontWeight: FontWeight.w700),),
                                        ),
                                        if(document['BannerType'] == 'Advertisement')
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('Title: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                Container(width: 250.w,child: Text(document['Title'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 18.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,)),
                                              ],
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.symmetric(vertical: 5.h),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('Description: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                  Container(width: 250.w,height:50.h,child: Text(document['Description'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.only(bottom: 10.h),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('Posted On: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                  Text(document['PostDate'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        if(document['BannerType'] == 'Link')
                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 5.h),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('Link: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                  Container(width: 300.w,child: Text(document['Link'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 18.sp,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.only(bottom: 10.h),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('Posted On: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                  Text(document['PostDate'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        if(document['BannerType'] == 'Offer')
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('Offer On: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                Text(document['OfferCategory'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w400),),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('Offer For: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                Text(document['OfferFor'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 18.sp,fontWeight: FontWeight.w300),),
                                              ],
                                            ),
                                            if(document['Discount'] == true)
                                            Padding(
                                              padding:  EdgeInsets.symmetric(vertical: 5.h),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('Discount: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                  Text(document['MinimumDiscount'].toString() + '% - ' + document['MaximumDiscount'].toString() + '%',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                ],
                                              ),
                                            ),
                                            if(document['Price'] == true)
                                            Padding(
                                              padding:  EdgeInsets.symmetric(vertical: 10.h),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('Price Range: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                  Text('₹' + document['MinimumPrice'].toString() + ' - ₹' + document['MaximumPrice'].toString(),style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                ],
                                              ),
                                            ),
                                            if(document['Date'] == true)
                                            Padding(
                                              padding:  EdgeInsets.symmetric(vertical: 10.h),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('Between Date: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                  Text(document['MinimumDate'] + ' - ' + document['MaximumDate'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                ],
                                              ),
                                            ),

                                            Padding(
                                              padding:  EdgeInsets.only(bottom: 10.h),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('Posted On: ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                  Text(document['PostDate'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w300),),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment:Alignment.topRight,
                                  child: IconButton(
                                    onPressed:() async {
                                      await pr.show();
                                      await FirebaseStorage.instance.ref().child("Banners").child(document.id).listAll().then((value) => value.items.forEach((element) async {
                                        element.delete();
                                      }));
                                      await FirebaseFirestore.instance.collection('Banners').doc(document.id).delete();
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
                    return Container(height: 50,width: 50,);
                  }
                }
            ),
          ),
        ],
      ),
    );
  }
}
