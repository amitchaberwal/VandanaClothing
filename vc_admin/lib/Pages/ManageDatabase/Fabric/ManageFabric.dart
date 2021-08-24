import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vc_admin/Pages/ManageDatabase/Catagories/CreateCategory.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageFabric extends StatefulWidget {
  @override
  _ManageFabricState createState() => _ManageFabricState();
}

class _ManageFabricState extends State<ManageFabric> {
  ProgressDialog pr;
  List<bool> OrderBy = [true, false];

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> getStream() {
      if(OrderBy[0] == true){
        return FirebaseFirestore.instance.collection('Fabric').orderBy('PostDate', descending: true).snapshots();
      }
      if(OrderBy[1] == true){
        return FirebaseFirestore.instance.collection('Fabric').orderBy('FabricStock', descending: false).snapshots();
      }
    }

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
          'Manage Stock',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          Padding(
            padding:  EdgeInsets.only(right: 5.w),
            child: SizedBox(
              height: 50.h,
              child: ToggleButtons(
                children: <Widget>[
                  Text(
                    'Date',
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300),
                  ),
                  Text(
                    'Stock',
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300),
                  ),
                ],
                fillColor: Theme.of(context).accentColor,
                isSelected: OrderBy,
                borderColor: Theme.of(context).secondaryHeaderColor,
                borderRadius: BorderRadius.circular(10),
                onPressed: (int index) {
                  setState(() {
                    for (int indexBtn = 0;indexBtn < OrderBy.length;indexBtn++) {
                      if (indexBtn == index) {
                        OrderBy[indexBtn] = true;
                      } else {
                        OrderBy[indexBtn] = false;
                      }
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 710.h,
            child: SingleChildScrollView(
              child: StreamBuilder(
                  stream: getStream(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Wrap(
                        children: snapshot.data.docs.map((document) => Padding(
                                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
                                  child: new Container(
                                    width: 160.w,
                                    height: 270.h,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(5.w, 10.h, 5.w, 0),
                                          width: 150.w,
                                          height: 200.h,
                                          child: InkWell(
                                            onTap: (){
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return EditStock(
                                                      fabID: document.id,
                                                      fabType: document['Type'],
                                                    );
                                                  });
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15.0),
                                              child: CachedNetworkImage(
                                                imageUrl: document['FabricImage'],
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
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Text(
                                            document.id,
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        (document['FabricStock'] <= 0)
                                            ? Padding(
                                                padding: EdgeInsets.only(top: 5.h),
                                                child: Text(
                                                  'Out Of Stock',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 15.sp,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.only(top: 5.h),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('Stock: ',
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w300),
                                                    ),
                                                    Text(
                                                      document['FabricStock'].toString(),
                                                      style: TextStyle(
                                                          color: Theme.of(context).secondaryHeaderColor,
                                                          fontSize: 16.sp,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
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

class EditStock extends StatefulWidget {
  final String fabID,fabType;

  const EditStock({Key key, this.fabID, this.fabType}) : super(key: key);

  @override
  _EditStockState createState() => _EditStockState();
}

class _EditStockState extends State<EditStock> {
  ProgressDialog pr;
  String mStock;
  Future uploadData(BuildContext context) async {
    if (mStock == null || mStock == "") {
      Fluttertoast.showToast(
          msg: "Please Set Stock",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).secondaryHeaderColor,
          fontSize: 16.0);
    } else {
      await pr.show();
      pr.update(message: 'updating...');
      await FirebaseFirestore.instance.collection('Fabric').doc(widget.fabID).update(
          {'FabricStock':int.parse(mStock)});
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
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
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
      child: Container(
          height: 250.h,
          margin: EdgeInsets.only(top: 1),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(children: <Widget>[
            ListView(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Center(
                  child: Text(
                    'Edit Stock',
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Center(
                  child: Text(
                    widget.fabID,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),


              FutureBuilder(
                  future: FirebaseFirestore.instance.collection('Fabric').doc(widget.fabID).get(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> mdata) {
                    if (mdata.hasData) {
                      mStock = mdata.data['FabricStock'].toString();
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Center(
                              child: Text('Stock',
                                style: TextStyle(
                                    color: Theme.of(context).secondaryHeaderColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Center(
                              child: SizedBox(
                                width: 120.w,
                                child: TextFormField(
                                  controller: TextEditingController(text: mdata.data['FabricStock'].toString()),
                                  keyboardType: TextInputType.number,
                                  decoration: new InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10),
                                        ),
                                      ),
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.local_convenience_store_rounded,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      hintStyle: new TextStyle(
                                          color: Theme.of(context).secondaryHeaderColor),
                                      hintText: "Stock",
                                      fillColor: Theme.of(context).cardColor),
                                  onChanged: (value) {
                                    mStock = value;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.fromLTRB(50.w, 20.h, 50.w, 10.h),
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
            ]),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () async {
                  pr.update(message: 'Deleting...');
                  await pr.show();
                  await FirebaseFirestore.instance.collection('Products').where('FabricID', isEqualTo: widget.fabID).get().then((value) => value.docs.forEach((mdoc) {
                    if(mdoc.exists){
                      if (mdoc.data()['ProductType'] == 'Dress'){
                        FirebaseStorage.instance.ref().child("Products").child(mdoc.id).listAll().then((value) => value.items.forEach((element) async {
                          await element.delete();
                        }));
                        FirebaseFirestore.instance.collection('Products').doc(mdoc.id).delete();
                      }
                      if (mdoc.data()['ProductType'] == 'Fabric') {
                        FirebaseFirestore.instance.collection('Products').doc(mdoc.id).delete();
                      }
                    }
                  }));
                  if (widget.fabType == 'Fabric') {
                    FirebaseStorage.instance.ref().child("Products").child(widget.fabID).listAll().then((value) => value.items.forEach((element) async {
                      element.delete();
                    }));
                  }
                  await FirebaseFirestore.instance.collection('Fabric').doc(widget.fabID).delete();
                  await pr.hide();
                },
                icon: Icon(
                  Icons.delete,
                  size: 35.r,
                ),
                color: Theme.of(context).accentColor,
              ),
            ),
          ])),
    );
  }
}
