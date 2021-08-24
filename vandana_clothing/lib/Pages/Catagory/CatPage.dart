import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vandana_clothing/Pages/Cart/CartPage.dart';
import 'package:vandana_clothing/Pages/Product/ProductList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AllCatagories extends StatefulWidget {
  @override
  _AllCatagoriesState createState() => _AllCatagoriesState();
}

class _AllCatagoriesState extends State<AllCatagories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Categories',
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

      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data.docs.map((document) => Padding(
                      padding:  EdgeInsets.fromLTRB(15.w,10.h,10.w,15.h),
                      child: CatCatagory(
                        doc_text: document['Name'],
                      ),
                    ),).toList()
                );
              } else {
                return Center(child: Image.asset("images/DualBall.gif",height: 100,));
              }
            }),

      ),
    );
  }
}

class CatCatagory extends StatelessWidget {
  final String doc_text;
  const CatCatagory({Key key, this.doc_text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          doc_text,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            //letterSpacing: 1.0
          ),
        ),

        StreamBuilder(
            stream: FirebaseFirestore.instance.collection('SubCategories').where("CategoryName",isEqualTo: doc_text).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Wrap(
                    children: snapshot.data.docs.map((document) => Padding(
                      padding: EdgeInsets.fromLTRB(0,10.h,10.w,10.h),
                      child: SCatCatagory(
                        doc_text: document['Name'],
                        doc_img: document['Image'],
                        st_price: document['StitchingPrice'],
                        doc_id: document.id,
                      ),
                    ),).toList()
                );
              } else {
                return Center(child: Image.asset("images/Spinner2.gif"));
              }
            }),
      ],
    );
  }
}

class SCatCatagory extends StatelessWidget {
  final String doc_img;
  final String doc_text;
  final String doc_id;
  final int st_price;

  const SCatCatagory({Key key, this.doc_img, this.doc_text, this.doc_id, this.st_price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.w,
      child: InkWell(
        onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new ProductList(SubCatName: doc_text,st_price: st_price,))),
        child: Center(
            child: Column(
                children: [
                  Container(
                    width: 110.w,
                    height: 160.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        imageUrl:doc_img,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: Image.asset("images/Ripple2.gif")),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w,5.h,5.w,5.h),
                    child: Center(
                        child: Text(doc_text,
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600))),
                  ),
                ])
        ),
      ),

    );
  }
}

