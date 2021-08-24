import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vc_admin/Pages/ManageDatabase/Catagories/CreateSubCategory.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageSubCatagory extends StatefulWidget {
  @override
  _ManageSubCatagoryState createState() => _ManageSubCatagoryState();
}

class _ManageSubCatagoryState extends State<ManageSubCatagory> {
  ProgressDialog pr;

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
            color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 19.sp,
            fontWeight: FontWeight.w600));
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Manage SubCategory',
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
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CreateSubCategory();
                  });
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
            child: SingleChildScrollView(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('SubCategories')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Wrap(
                        children: snapshot.data.docs
                            .map((document) => Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 10.h, 10.w, 10.h),
                                  child: new Container(
                                    width: 160.w,
                                    height: 280.h,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Stack(children: [
                                      Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10.w, 10.h, 0, 0),
                                            width: 150.w,
                                            height: 200.h,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              child: CachedNetworkImage(
                                                imageUrl: document['Image'],
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Container(
                                                        height: 120.h,
                                                        width: 120.w,
                                                        child:
                                                            CircularProgressIndicator()),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10.h),
                                                child: Text(
                                                  document.id,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 2.h),
                                                child: Text(
                                                  document['CategoryName'],
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .secondaryHeaderColor,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 2.h),
                                                child: Text(
                                                  '₹' +
                                                      document['StitchingPrice']
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .secondaryHeaderColor,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return EditSubcat(subCatName: document.id,);
                                                });
                                          },
                                          icon: CircleAvatar(
                                            radius: 12.r,
                                            backgroundColor:
                                                Theme.of(context).accentColor,
                                            child: Icon(
                                              Icons.edit_rounded,
                                              size: 15.r,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () async {
                                            await pr.show();
                                            await FirebaseStorage.instance.ref().child("SubCategories").child(document.id).listAll().then((value) =>
                                                value.items.forEach((element) async {
                                                  print(element);
                                                  element.delete();
                                                })
                                            );
                                            await FirebaseFirestore.instance.collection('SubCategories').doc(document.id).delete();
                                            await pr.hide();
                                          },
                                          icon: Icon(
                                            Icons.delete_outline_rounded,
                                            size: 25.r,
                                          ),
                                          color: Theme.of(context).accentColor,
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

class EditSubcat extends StatefulWidget {
  final String subCatName;

  const EditSubcat({Key key, this.subCatName}) : super(key: key);

  @override
  _EditSubcatState createState() => _EditSubcatState();
}

class _EditSubcatState extends State<EditSubcat> {
  ProgressDialog pr;
  String stPrice, lprice;

  List<bool> isSelected = [false, false, false,false,false,false];
  void getfeatures()async{
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('SubCategories').doc(widget.subCatName).get();
    isSelected[0] = ds.data()['Features']['NeckDesign'];
    isSelected[1] = ds.data()['Features']['SleeveDesign'];
    isSelected[2] = ds.data()['Features']['PonchaDesign'];
    isSelected[3] = ds.data()['Features']['PipingDesign'];
    isSelected[4] = ds.data()['Features']['CollarDesign'];
    isSelected[5] = ds.data()['Features']['SleeveLength'];
  }
  Future uploadData(BuildContext context) async {
    if (stPrice == null) {
      Fluttertoast.showToast(
          msg: "Please Set Price",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0);
    } else {
      await pr.show();
      Map<String, dynamic> sdata = new Map();
      sdata['StitchingPrice'] = int.parse(stPrice);
      if (lprice != null && lprice != "") {
        sdata['Lining'] = int.parse(lprice);
      }
      if (lprice == "") {
        sdata['Lining'] = false;
      }

      sdata["Features"] = {
        'NeckDesign': isSelected[0],
        'SleeveDesign': isSelected[1],
        'PonchaDesign': isSelected[2],
        'PipingDesign': isSelected[3],
        'CollarDesign': isSelected[4],
        'SleeveLength': isSelected[5],
      };

      await FirebaseFirestore.instance.collection('SubCategories').doc(widget.subCatName).update(sdata);
      Fluttertoast.showToast(
          msg: "Updated Successfully...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0);
      await pr.hide();
      Navigator.pop(context);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfeatures();
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Updating..',
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
        height: 400.h,
        margin: EdgeInsets.only(top: 1),
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
                'Edit Price',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          FutureBuilder(
              future: FirebaseFirestore.instance.collection('SubCategories').doc(widget.subCatName).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> mdata) {
                if (mdata.hasData) {
                 stPrice =  mdata.data['StitchingPrice'].toString();
                 if(mdata.data['Lining']!= false){
                   lprice = mdata.data['Lining'].toString();
                 }
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
                        child: TextFormField(
                          controller: TextEditingController(text: mdata.data['StitchingPrice'].toString()),
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
                              hintText: "Stitching Price",
                              fillColor: Theme.of(context).cardColor),
                          onChanged: (value) {
                            stPrice = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
                        child: TextFormField(
                         initialValue: lprice,
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
                              hintText: "Lining",
                              fillColor: Theme.of(context).cardColor),
                          onChanged: (value) {
                            lprice = value;
                          },
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(top:10.h),
                            child: Center(
                              child: Text(
                                'Features',
                                style: TextStyle(
                                    color: Theme.of(context).secondaryHeaderColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600),
                              ),
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
                                      'Neck',
                                      style: TextStyle(
                                          color: Theme.of(context).secondaryHeaderColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      'Sleeve',
                                      style: TextStyle(
                                          color: Theme.of(context).secondaryHeaderColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      'Poncha',
                                      style: TextStyle(
                                          color: Theme.of(context).secondaryHeaderColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      'Piping',
                                      style: TextStyle(
                                          color: Theme.of(context).secondaryHeaderColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      'Collar',
                                      style: TextStyle(
                                          color: Theme.of(context).secondaryHeaderColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      'Sleeve\nLength',
                                      style: TextStyle(
                                          color: Theme.of(context).secondaryHeaderColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                  fillColor: Theme.of(context).accentColor,
                                  isSelected: isSelected,
                                  borderColor: Theme.of(context).secondaryHeaderColor,
                                  borderRadius: BorderRadius.circular(10),
                                  onPressed: (int index) {
                                    setState(() {
                                      isSelected[index] = !isSelected[index];
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(50.w, 10.h, 50.w, 10.h),
                        child: SizedBox(
                          height: 60.h,
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
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ]));
  }
}
