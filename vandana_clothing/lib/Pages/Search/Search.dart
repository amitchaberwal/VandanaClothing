import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vandana_clothing/Pages/Product/ProductView.dart';
import 'package:vandana_clothing/Pages/Search/SearchedProducts.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchQ;
  Stream<QuerySnapshot> getList = new Stream.empty();
  //List<String> sWords = new List();
  var sWords = [];
  @override
  Widget build(BuildContext context) {
    sWords.add('');
    //getList = FirebaseFirestore.instance.collection('Products').where("SearchKeywords", arrayContainsAny: sWords).snapshots();
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: new AppBar(
          title: SizedBox(
            width: 280.w,
            height: 50.h,
            child: TextField(
              autofocus: true,
              keyboardType: TextInputType.name,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                  filled: true,
                  suffixIcon: InkWell(
                    onTap: () =>Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => SearchedProducts(sword: sWords))),
                    child: Icon(
                      Icons.search,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  hintStyle: new TextStyle(
                      color: Theme.of(context).secondaryHeaderColor),
                  fillColor: Theme.of(context).cardColor),
              style: new TextStyle(color: Theme.of(context).secondaryHeaderColor),
              onChanged: (value) {
                searchQ = value.toLowerCase();
                sWords = searchQ.split(' ');
                setState((){
                  Query quary = FirebaseFirestore.instance.collection('Products');
                  sWords.forEach((element) {
                    quary = quary.where('SearchTags.$element', isEqualTo: true);
                  });
                  quary = quary.limit(10);
                  getList = quary.snapshots();
                  //getList = FirebaseFirestore.instance.collection('Products').where("SearchKeywords", arrayContains: sWords).limit(10).snapshots();
                });
              },
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(top: 20.h),
            child: StreamBuilder(
                stream: getList,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      shrinkWrap: true,
                        children: snapshot.data.docs
                            .map(
                              (document) => Padding(
                                padding:
                                     EdgeInsets.fromLTRB(40.w, 0, 10.w, 15.h),
                                child: InkWell(
                                  onTap:() =>Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (context) => ProductView(pro_id: document.id,pro_name: document['ProductName'],pro_img: document['ProductImage'],))),
                                  child: Container(
                                      height:35.h,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(document.data()['ProductName'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15.sp,fontWeight: FontWeight.w600),),
                                          Row(
                                            children: [
                                              Text('In ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 12.sp,fontWeight: FontWeight.w300),),
                                              Text(document.data()['SubCategoryName'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 13.sp,fontWeight: FontWeight.w400),),
                                            ],
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            )
                            .toList());
                  } else {
                    return Container(height: 10.h,);
                  }
                }),
          ),
        ));
  }
}
