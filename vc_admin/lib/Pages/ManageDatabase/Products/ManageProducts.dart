import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

class ManageProducts extends StatefulWidget {
  @override
  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  ProgressDialog pr;
  List proSelect = List();
  String subcat;
  String orderBy = 'PostDate';

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
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
            color: Colors.black, fontSize: 13..sp, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 19.sp,
            fontWeight: FontWeight.w600));

    Stream<QuerySnapshot> getStream() {
      return FirebaseFirestore.instance
          .collection('Products')
          .where('SubCategoryName', isEqualTo: subcat)
          .orderBy(orderBy, descending: true)
          .snapshots();
    }

    ;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Manage Products',
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
                Icons.developer_board,
                color: Theme.of(context).accentColor,
                size: 35.r,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ModifyBatch(
                        selectedProducts: proSelect,
                      );
                    });
              }),
        ],
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 180.w,
                child: new StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('SubCategories')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.docs.isNotEmpty) {
                          return DropdownButtonFormField(
                            hint: Text(
                              'Choose SubCategory',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            style: TextStyle(color: Colors.white),
                            value: subcat,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                subcat = newValue;
                              });
                            },
                            items: snapshot.data.docs.map((document) {
                              return DropdownMenuItem(
                                child: new Text(
                                  document.id,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                ),
                                value: document.id,
                              );
                            }).toList(),
                          );
                        } else {
                          return Text(
                            'No SubCategories',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor),
                          );
                        }
                      } else {
                        return Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Getting SubCategories',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator()),
                          ],
                        ));
                      }
                    }),
              ),
              SizedBox(
                width: 170.w,
                child: DropdownButtonFormField(
                  hint: Text(
                    'Order By',
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                  style: TextStyle(color: Colors.white),
                  value: orderBy,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      orderBy = newValue;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: "ProductDiscount",
                      child: Text(
                        "Discount",
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "ProductPrice",
                      child: Text(
                        "Price",
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "PostDate",
                      child: Text(
                        "Date",
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Container(
              width: double.infinity,
              height: 640.h,
              child: StreamBuilder(
                  stream: getStream(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: snapshot.data.docs
                            .map((document) => Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h),
                                  child: new Container(
                                    width: double.infinity,
                                    height: 200.h,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Stack(children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () async {
                                            await pr.show();
                                            if(document['ProductType'] == 'Dress'){
                                              await FirebaseFirestore.instance.collection('Products').doc(document.id).delete();
                                              await FirebaseStorage.instance.ref().child("Products").child(document.id).listAll().then((value) => value.items.forEach((element) async {
                                                print(element);
                                                element.delete();
                                              }));
                                            }
                                            if(document['ProductType'] == 'Fabric'){
                                              await FirebaseFirestore.instance.collection('Products').doc(document.id).delete();
                                            }
                                            await pr.hide();
                                          },
                                          icon: Icon(
                                            Icons.delete_outline_rounded,
                                            size: 25.r,
                                          ),
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                      if(document['ProductType']=='Dress')
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: IconButton(
                                          onPressed: () async{
                                            bool feat = !document['Featured'];
                                            await FirebaseFirestore.instance.collection('Products').doc(document.id).update(
                                              {
                                                'Featured':feat
                                              }
                                            );
                                          },
                                          icon: Icon(
                                            Icons.star,
                                            size: 25.r,
                                          ),
                                          color: (document['Featured'] == true)?
                                              Theme.of(context).accentColor:
                                              Colors.grey
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () => showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return EditProducts(
                                                    proId: document.id,
                                                  );
                                                }),
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10.w, 10.h, 0, 10.h),
                                              width: 110.w,
                                              height: 200.h,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                child: CachedNetworkImage(
                                                  imageUrl: document['ProductImage'],
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                          height: 120.h,
                                                          width: 120.w,
                                                          child: CircularProgressIndicator()),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10.w),
                                                child: Text(document['FabricID'],
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor,
                                                      fontSize: 18.sp,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 30.w),
                                                child: Row(
                                                  children: [
                                                    Text('Name: ',
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w300),
                                                    ),
                                                    Container(
                                                        width: 150.w,
                                                        child: Text(document['ProductName'],overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(color: Theme.of(context).secondaryHeaderColor,
                                                              fontSize: 18.sp,fontWeight: FontWeight.w300),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 30.w),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Type: ',
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Text(
                                                      document['ProductType'].toString(),
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 30.w),
                                                child: Row(
                                                  children: [
                                                    Text('Price: ',
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Text(
                                                      '₹' +
                                                          document[
                                                                  'ProductPrice']
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .secondaryHeaderColor,
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 30.w),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Discount: ',
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .secondaryHeaderColor,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Text(
                                                      document['ProductDiscount']
                                                              .toString() +
                                                          '%',
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .secondaryHeaderColor,
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 30.w),
                                                child: Row(
                                                  children: [
                                                    Text('Posted On: ', style: TextStyle(color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w300),
                                                    ),
                                                    Text(
                                                      document['PostDate'],
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .secondaryHeaderColor,
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              FutureBuilder(
                                                  future: FirebaseFirestore.instance.collection('Fabric').doc(document['FabricID']).get(),
                                                  builder: (context, AsyncSnapshot<DocumentSnapshot>mdata) {
                                                    if (mdata.hasData) {
                                                      if (mdata.data['FabricStock'] <= 0) {
                                                        return Text('Out of Stock',style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16.sp,
                                                            fontWeight: FontWeight.w600),);
                                                      } else {
                                                        return Padding(
                                                          padding:
                                                          EdgeInsets.only(left: 30.w),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                'Stock: ',
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                        context)
                                                                        .secondaryHeaderColor,
                                                                    fontSize: 15.sp,
                                                                    fontWeight:
                                                                    FontWeight.w300),
                                                              ),
                                                              Text(
                                                                mdata.data['FabricStock']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                        context)
                                                                        .secondaryHeaderColor,
                                                                    fontSize: 18.sp,
                                                                    fontWeight:
                                                                    FontWeight.w300),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    } else
                                                      return Text('Loading');
                                                  }),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Checkbox(
                                          visualDensity: VisualDensity.compact,
                                          value:
                                              proSelect.contains(document.id),
                                          onChanged: (newValue) {
                                            if (newValue == true) {
                                              setState(() {
                                                proSelect.add(document.id);
                                              });
                                            } else {
                                              setState(() {
                                                proSelect.remove(document.id);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ]),
                                  ),
                                ))
                            .toList(),
                      );
                    } else {
                      return Container(
                        height: 50.h,
                        width: 50.w,
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class ModifyBatch extends StatefulWidget {
  final List selectedProducts;

  const ModifyBatch({Key key, this.selectedProducts}) : super(key: key);

  @override
  _ModifyBatchState createState() => _ModifyBatchState();
}

class _ModifyBatchState extends State<ModifyBatch> {
  ProgressDialog pr;
  String mdiscount, mPrice;

  Future updateData(BuildContext context) async {
    await pr.show();
    Map<String, dynamic> orderData = new Map();
    if (mPrice != null) {
      orderData["ProductPrice"] = int.parse(mPrice);
    }
    if (mdiscount != null) {
      orderData["ProductDiscount"] = int.parse(mdiscount);
    }
    widget.selectedProducts.forEach((docID) async => await FirebaseFirestore.instance.collection('Products').doc(docID).update(orderData));
    Fluttertoast.showToast(
        msg: "Updated...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).secondaryHeaderColor,
        fontSize: 16.0);
    await pr.hide();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Uploading...',
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
        height: 380.h,
        margin: EdgeInsets.only(top: 1.h),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListView(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Center(
              child: Text(
                'Batch Operation',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(50.w, 10.h, 50.w, 10.h),
            child: SizedBox(
              height: 60.h,
              child: FlatButton(
                onPressed: () async {
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
                          color: Colors.black,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400),
                      messageTextStyle: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w600));
                  await pr.show();
                  widget.selectedProducts.forEach((docID) async {
                    await FirebaseFirestore.instance
                        .collection('Products')
                        .doc(docID)
                        .delete();
                    await FirebaseStorage.instance.ref().child("Products").child(docID).listAll().then((value) => value.items.forEach((element) async {
                              element.delete();
                            }));
                  });
                  await pr.hide();
                  Navigator.pop(context);
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline_rounded),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text(
                        "Delete",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                  filled: true,
                  prefixIcon: Icon(
                    Icons.monetization_on_rounded,
                    color: Theme.of(context).accentColor,
                  ),
                  hintStyle: new TextStyle(
                      color: Theme.of(context).secondaryHeaderColor),
                  hintText: "Price",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                mPrice = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                  filled: true,
                  prefixIcon: Icon(
                    Icons.local_offer_rounded,
                    color: Theme.of(context).accentColor,
                  ),
                  hintStyle: new TextStyle(
                      color: Theme.of(context).secondaryHeaderColor),
                  hintText: "Discount",
                  fillColor: Theme.of(context).cardColor),
              onChanged: (value) {
                mdiscount = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(50.w, 10.h, 50.w, 10.h),
            child: SizedBox(
              height: 60.h,
              child: FlatButton(
                onPressed: () {
                  updateData(context);
                },
                child: Center(
                  child: Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
          ),
        ]));
  }
}
class EditProducts extends StatefulWidget {
  final String proId;

  const EditProducts({Key key, this.proId}) : super(key: key);
  @override
  _EditProductsState createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  ProgressDialog prep,prdw;
  String headcat, subcat, proName, proDesc, proFab,proPrice, proDiscount, proLining;

  static var httpClient = new HttpClient();
  Future<File> DownloadFile(String imageUrl, String filename) async {
    await prep.show();
    prep.update(message: 'Downloading..');
    bool downloading=true;
    double download=0.0;
    File f;
    Dio dio=Dio();
    var dir=await getApplicationDocumentsDirectory();
    String mpath = '/storage/emulated/0/Download/';
    String fileName=filename;
    await dio.download(imageUrl, "$mpath/$fileName",onReceiveProgress: (rec,total){
      setState(() {
        download=(rec/total)*100;
      });
        if(download == 100){
          setState(() {
            downloading = false;
            prep.hide();
          });
        }
  });
    await prep.hide();

  }

  Future uploadData(BuildContext context) async {
    if (proName == "" || proDesc == "" || proFab == "" || proPrice == "" ||
        proDiscount == "") {
      Fluttertoast.showToast(
          msg: "Please fill all details..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme
              .of(context)
              .cardColor,
          textColor: Theme
              .of(context)
              .secondaryHeaderColor,
          fontSize: 16.0
      );
    }
    else{
      DocumentSnapshot dsproduct = await FirebaseFirestore.instance.collection('Products').doc(widget.proId).get();
      await prep.show();
      prep.update(message: 'Updating..');
      String im, im1, im2, im3, im4;
      DocumentReference mproduct =
      FirebaseFirestore.instance.collection('Products').doc(widget.proId);
      String pid = widget.proId;
      Map<String, dynamic> orderData = new Map();
      if (proName != null) {
        orderData["ProductName"] = proName;
      }
      if (proDesc != null) {
        orderData["ProductDescription"] = proDesc;
      }
      if (proFab != null) {
        orderData["ProductFabric"] = proFab;
      }
      if (proPrice != null) {
        orderData["ProductPrice"] = int.parse(proPrice);
      }
      if (proDiscount != null) {
        orderData["ProductDiscount"] = int.parse(proDiscount);
      }
      await mproduct.update(orderData);
      Fluttertoast.showToast(
          msg: "Product Updated Successfully...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme
              .of(context)
              .cardColor,
          textColor: Theme
              .of(context)
              .secondaryHeaderColor,
          fontSize: 16.0);
      await prep.hide();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => ManageProducts()));
    }
  }

  @override
  Widget build(BuildContext context) {
    prep = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    prep.style(
        message: 'Updating...',
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
      child: Container(
        height: 580.h,
        margin: EdgeInsets.only(top: 1),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding:  EdgeInsets.only(top:10.h),
                child: Text(
                  'Edit Product',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200.w,
                  child: Text(
                    widget.proId,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.copy,
                    color: Theme.of(context).accentColor,
                    size: 25.r,
                  ),
                  onPressed: () {
                    Clipboard.setData(new ClipboardData(text: widget.proId));
                    Fluttertoast.showToast(
                        msg: "Product ID Copied..",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Theme.of(context).cardColor,
                        textColor: Theme.of(context).secondaryHeaderColor,
                        fontSize: 16.0
                    );
                  },

                )
              ],
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance.collection('Products').doc(widget.proId).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> mdata) {
                if (mdata.hasData) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 5.w),
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    height: 80.h,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),

                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: ClipRRect(
                                        child: CachedNetworkImage(
                                          imageUrl:mdata.data['ProductImage'],
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                              height:120.h,
                                              width:120.w,
                                              child: CircularProgressIndicator()),
                                        ),
                                      )
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 80.h,
                                  width: 50.w,
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.download_rounded,
                                        color: Theme.of(context).accentColor,
                                        size: 35.r,
                                      ),
                                      onPressed: () {
                                        DownloadFile(mdata.data['ProductImage'], mdata.data['ProductName'] + '.jpg');
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if(mdata.data['Images']['ImageA'] != null)
                          Padding(
                            padding: EdgeInsets.only(right: 5.w),
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    height: 80.h,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: ClipRRect(
                                          child: CachedNetworkImage(
                                            imageUrl:mdata.data['Images']['ImageA'],
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(
                                                height:120.h,
                                                width:120.w,
                                                child: CircularProgressIndicator()),
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 80.h,
                                  width: 50.w,
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.download_rounded,
                                        color: Theme.of(context).accentColor,
                                        size: 35.r,
                                      ),
                                      onPressed: () {
                                        DownloadFile(mdata.data['Images']['ImageA'], mdata.data['ProductName'] + 'A' + '.jpg');
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if(mdata.data['Images']['ImageB'] != null)
                          Padding(
                            padding: EdgeInsets.only(right: 5.w),
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    height: 80.h,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),

                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: ClipRRect(
                                          child: CachedNetworkImage(
                                            imageUrl:mdata.data['Images']['ImageB'] ,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(
                                                height:120.h,
                                                width:120.w,
                                                child: CircularProgressIndicator()),
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 80.h,
                                  width: 50.w,
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.download_rounded,
                                        color: Theme.of(context).accentColor,
                                        size: 35.r,
                                      ),
                                      onPressed: () {
                                        DownloadFile(mdata.data['Images']['ImageB'], mdata.data['ProductName']+ 'B' + '.jpg');
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if(mdata.data['Images']['ImageC'] != null)
                          Padding(
                            padding: EdgeInsets.only(right: 5.w),
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    height: 80.h,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: ClipRRect(
                                          child: CachedNetworkImage(
                                            imageUrl:mdata.data['Images']['ImageC'] ,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(
                                                height:120.h,
                                                width:120.w,
                                                child: CircularProgressIndicator()),
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 80.h,
                                  width: 50.w,
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.download_rounded,
                                        color: Theme.of(context).accentColor,
                                        size: 35.r,
                                      ),
                                      onPressed: () {
                                        DownloadFile(mdata.data['Images']['ImageC'], mdata.data['ProductName'] + 'C' + '.jpg');
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if(mdata.data['Images']['ImageD'] != null)
                          Stack(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  height: 80.h,
                                  width: 50.w,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: ClipRRect(
                                        child: CachedNetworkImage(
                                          imageUrl:mdata.data['Images']['ImageD'] ,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                              height:120.h,
                                              width:120.w,
                                              child: CircularProgressIndicator()),
                                        ),
                                      )
                                  ),
                                ),
                              ),
                              Container(
                                height: 80.h,
                                width: 50.w,
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.download_rounded,
                                      color: Theme.of(context).accentColor,
                                      size: 35.r,
                                    ),
                                    onPressed: () {
                                      DownloadFile(mdata.data['Images']['ImageD'], mdata.data['ProductName']+ 'D' + '.jpg');
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top:20.h,left: 10.w,right: 10.w),
                        child: TextFormField(
                          initialValue: mdata.data['ProductName'],
                          keyboardType: TextInputType.name,
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
                              hintText: "Product Name",
                              fillColor: Theme.of(context).cardColor),
                          onChanged: (value) {
                            proName = value;
                          },
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top:10.h,left: 10.w,right: 10.w),
                        child: TextFormField(
                          initialValue: mdata.data['ProductDescription'],
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(15),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor),
                              hintText: "Product Description",
                              fillColor: Theme.of(context).cardColor),
                          onChanged: (value) {
                            proDesc = value;
                          },
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top:10.h,left: 10.w,right: 10.w),
                        child: TextFormField(
                          initialValue: mdata.data['ProductFabric'],
                          keyboardType: TextInputType.name,
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
                              hintText: "Fabric",
                              fillColor: Theme.of(context).cardColor),
                          onChanged: (value) {
                            proFab = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 140,
                              child: TextFormField(
                                initialValue: mdata.data['ProductPrice'].toString(),
                                keyboardType: TextInputType.number,
                                decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle: new TextStyle(
                                        color:
                                        Theme.of(context).secondaryHeaderColor),
                                    hintText: "Price",
                                    fillColor: Theme.of(context).cardColor),
                                onChanged: (value) {
                                  setState(() {
                                    proPrice = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 140.w,
                              child: TextFormField(
                                initialValue: mdata.data['ProductDiscount'].toString(),
                                keyboardType: TextInputType.number,
                                decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle: new TextStyle(
                                        color:
                                        Theme.of(context).secondaryHeaderColor),
                                    hintText: "Discount %",
                                    fillColor: Theme.of(context).cardColor),
                                onChanged: (value) {
                                  proDiscount = value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding:  EdgeInsets.only(top:10.h),
                          child: SizedBox(
                            height: 60.h,
                            width:150.w,
                            child: FlatButton(
                              onPressed: () {
                                uploadData(context);
                              },
                              child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

