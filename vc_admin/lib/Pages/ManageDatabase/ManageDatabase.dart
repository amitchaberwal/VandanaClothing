import 'package:flutter/material.dart';
import 'package:vc_admin/Pages/ManageDatabase/Banners/ManageBanners.dart';
import 'package:vc_admin/Pages/ManageDatabase/Catagories/ManageCatagory.dart';
import 'package:vc_admin/Pages/ManageDatabase/Catagories/ManageSubCatagory.dart';
import 'package:vc_admin/Pages/ManageDatabase/Designs/Collar/ManageCollar.dart';
import 'package:vc_admin/Pages/ManageDatabase/Designs/Neck/ManageNeck.dart';
import 'package:vc_admin/Pages/ManageDatabase/Designs/Piping/ManagePiping.dart';
import 'package:vc_admin/Pages/ManageDatabase/Designs/Poncha/ManagePoncha.dart';
import 'package:vc_admin/Pages/ManageDatabase/Designs/Sleeve/ManageSleeve.dart';
import 'package:vc_admin/Pages/ManageDatabase/Fabric/ManageFabric.dart';
import 'package:vc_admin/Pages/ManageDatabase/Products/CreateProduct.dart';
import 'package:vc_admin/Pages/ManageDatabase/Products/CreateUnstitched.dart';
import 'package:vc_admin/Pages/ManageDatabase/Products/ManageProducts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ManageDatabase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Manage Database',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                child: new
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h,),
                      Text(
                        'Catagories',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:10.h),
                        child: SizedBox(
                          height: 60.h,
                          width: 250.w,
                          child: FlatButton(
                            onPressed:(){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (BuildContext context) => ManageCatagory()));
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.category_rounded),
                                  SizedBox(width: 15.w,),
                                  Text("Manage Categories",style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.h, 0, 20.h),
                        child: SizedBox(
                          height:60.h,
                          width: 280.w,
                          child: FlatButton(
                            onPressed:(){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (BuildContext context) => ManageSubCatagory()));
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.category_rounded),
                                  SizedBox(width: 15.w,),
                                  Text("Manage SubCategories",style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  )),

            Padding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                child: new
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h,),
                      Text(
                        'Banners',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.h, 0, 20.h),
                        child: SizedBox(
                          height: 60.h,
                          width: 250.w,
                          child: FlatButton(
                            onPressed:(){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (BuildContext context) => ManageBanners()));
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.tv_rounded),
                                  SizedBox(width: 15.w,),
                                  Text("Manage Banners",style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),

                    ],
                  ),
                )),

            Padding(
                padding:EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                child: new
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h,),
                      Text(
                        'Products',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
                        child: SizedBox(
                          height: 60.h,
                          width: 250.w,
                          child: FlatButton(
                            onPressed:(){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (BuildContext context) => CreateProduct()));
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_box_rounded),
                                  SizedBox(width: 15.w,),
                                  Text("Add Dress",style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
                        child: SizedBox(
                          height: 60.h,
                          width: 250.w,
                          child: FlatButton(
                            onPressed:(){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (BuildContext context) => CreateUnstitched()));
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_box_rounded),
                                  SizedBox(width: 15.w,),
                                  Text("Add Fabric",style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10.h),
                        child: SizedBox(
                          height: 60.h,
                          width: 250.w,
                          child: FlatButton(
                            onPressed:(){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (BuildContext context) => ManageProducts()));
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.imagesearch_roller),
                                  SizedBox(width: 15.w,),
                                  Text("Manage Products",style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: SizedBox(
                          height: 60.h,
                          width: 250.w,
                          child: FlatButton(
                            onPressed:(){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (BuildContext context) => ManageFabric()));
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.design_services_rounded),
                                  SizedBox(width: 15.w,),
                                  Text("Manage Stock",style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),

                    ],
                  ),
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
                child: new
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h,),
                      Text(
                        'Designs',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:10.h),
                        child: SizedBox(
                          height: 60.h,
                          width: 250.w,
                          child: FlatButton(
                            onPressed:(){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (BuildContext context) => ManagePoncha()));
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.design_services_rounded),
                                  SizedBox(width: 15.w,),
                                  Text("Poncha Design",style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:10.h),
                        child: SizedBox(
                          height: 60.h,
                          width: 250.w,
                          child: FlatButton(
                            onPressed:(){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (BuildContext context) => ManageNeck()));
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.design_services_rounded),
                                  SizedBox(width: 15.w,),
                                  Text("Neck Design",style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:10.h),
                        child: SizedBox(
                          height: 60.h,
                          width: 250.w,
                          child: FlatButton(
                            onPressed:(){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (BuildContext context) => ManageSleeve()));
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.design_services_rounded),
                                  SizedBox(width: 15.w,),
                                  Text("Sleeve Design",style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:10.h),
                        child: SizedBox(
                          height: 60.h,
                          width: 250.w,
                          child: FlatButton(
                            onPressed:(){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (BuildContext context) => ManagePiping()));
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.design_services_rounded),
                                  SizedBox(width: 15.w,),
                                  Text("Piping Design",style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:10.h,bottom: 20.h),
                        child: SizedBox(
                          height: 60.h,
                          width: 250.w,
                          child: FlatButton(
                            onPressed:(){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (BuildContext context) => ManageCollar()));
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.design_services_rounded),
                                  SizedBox(width: 15.w,),
                                  Text("Collar Design",style: TextStyle(color: Colors.black,fontSize: 18.sp,fontWeight: FontWeight.w800 ),),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),

                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
