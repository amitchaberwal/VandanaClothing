import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vandana_clothing/Pages/Cart/CartPage.dart';
import 'package:vandana_clothing/Pages/Product/ProductList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubCatagory extends StatefulWidget {
  final String doc_id;
  final String doc_name;

  const SubCatagory({Key key, this.doc_id,this.doc_name,}) : super(key: key);
  @override
  _SubCatagoryState createState() => _SubCatagoryState();
}

class _SubCatagoryState extends State<SubCatagory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          widget.doc_name,
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
              icon: SvgPicture.asset(
                "images/icons/bag.svg",
                height: 20.r,
                color: Theme.of(context).accentColor, //20
              ),
              onPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.topToBottom, child: MyCart()))
          ),
        ],

      ),

      body: Container(
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('SubCategories').where("CategoryName",isEqualTo: widget.doc_name).snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Wrap(
                      children: snapshot.data.docs.map((document) => Padding(
                        padding:  EdgeInsets.fromLTRB(10.w,10.h,10.w,15.h),
                        child: SCatagory(
                          doc_text: document['Name'],
                          doc_img: document['Image'],
                          doc_id: document.id,
                          st_price: document['StitchingPrice'],
                        ),
                      ),).toList()
                  );
                } else {
                  return Center(child: Image.asset("images/DualBall.gif",height: 100,));
                }
              }),
        ),
      ),
    );
  }
}

class SCatagory extends StatelessWidget {
  final String doc_img;
  final String doc_text;
  final String doc_id;
  final int st_price;

  const SCatagory({Key key, this.doc_img, this.doc_text, this.doc_id, this.st_price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170.w,
      child: InkWell(
        onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new ProductList(SubCatName: doc_text,st_price: st_price,))),
        child: Center(
            child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top:10.h),
                    width: 150.w,
                    height: 240.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: CachedNetworkImage(
                        imageUrl:doc_img,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(width: 150.w,
                            height: 220.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Theme.of(context).cardColor
                            ),
                            child: Center(child: Image.asset("images/Ripple2.gif"))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w,5.h,5.w,5.h),
                    child: Container(
                      width: 180.w,
                      child: Center(
                          child: Text(doc_text,
                              style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600))),
                    ),
                  ),
                ])
        ),
      ),

    );
  }
}

