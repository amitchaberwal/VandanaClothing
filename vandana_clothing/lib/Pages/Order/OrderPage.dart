import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vandana_clothing/Pages/Cart/CartPage.dart';
import 'package:vandana_clothing/Pages/Order/OrderView.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    double mHeight(double inputHeight) {
      double screenHeight = MediaQuery.of(context).size.height;
      return (inputHeight / 834.90) * screenHeight;
    }
    double mWidth(double inputWidth) {
      double screenWidth = MediaQuery.of(context).size.width;
      return (inputWidth / 392.72) * screenWidth;
    }
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Orders',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          new IconButton(
              icon: SvgPicture.asset(
                "images/icons/bag.svg",
                height: mHeight(20),
                color: Theme.of(context).accentColor, //20
              ),
              onPressed: () => Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => new MyCart())
              )),
        ],
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.phoneNumber).collection('Orders').snapshots(),
            builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasData){
                if(snapshot.data.docs.isNotEmpty){
                  return ListView(
                    children: snapshot.data.docs.map((document) =>
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                  new MaterialPageRoute(builder: (context) => new OrderView(orderID: document.id,status: document['Status'],)));
                            },
                            child: new
                            Container(
                              width: double.infinity,
                              height: mHeight(160),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top:10),
                                child: Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          width: mWidth(120),
                                          height: mHeight(140),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15.0),
                                            child: CachedNetworkImage(
                                              imageUrl:document['ProductImage'],
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Container(
                                                  height:mHeight(120),
                                                  width:mWidth(120),
                                                  child: CircularProgressIndicator()),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 0, 30, 0),
                                              child: Text(document.id,style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18,fontWeight: FontWeight.w700,),softWrap: true),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 0, 30, 0),
                                              child: Text(document['ProductName'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w300,),softWrap: true),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top:5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('Price : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w300,),softWrap: true),
                                                  Text('₹ ' + document['ProductPrice'].toString(),style: TextStyle(color: Theme.of(context).accentColor,fontSize: 16,fontWeight: FontWeight.w600,),softWrap: true),
                                                ],
                                              ),
                                            ),
                                            (document['Status'] == 'Canceled')?
                                            Padding(
                                              padding: const EdgeInsets.only(top:5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(document['Status'],style: TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.w600,),softWrap: true),
                                                ],
                                              ),
                                            )
                                              :
                                            Padding(
                                              padding: const EdgeInsets.only(top:5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('Status : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w300,),softWrap: true),
                                                  Text(document['Status'],style: TextStyle(color: Theme.of(context).accentColor,fontSize: 16,fontWeight: FontWeight.w600,),softWrap: true),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top:5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('Last Updated : ',style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w300,),softWrap: true),
                                                  Text(document['StatusUpdateTime'],style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontSize: 15,fontWeight: FontWeight.w300,),softWrap: true),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          ),
                        )
                    ).toList(),
                  );
                }
                else{
                  return Center(child: Text('Orders not Found',style: TextStyle(color:Theme.of(context).secondaryHeaderColor,fontSize: 20,fontWeight: FontWeight.w300 ),));
                }
              }
              else{
                return Center(child: CircularProgressIndicator());
              }
            }
        ),
      ),
    );
  }
}
