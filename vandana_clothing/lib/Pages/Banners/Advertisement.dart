import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Advertisement extends StatefulWidget {
  final String adtitle,addesc,adimage;
  const Advertisement({Key key, this.adtitle, this.addesc, this.adimage}) : super(key: key);

  @override
  _AdvertisementState createState() => _AdvertisementState();
}

class _AdvertisementState extends State<Advertisement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                height: 300.h,
                width: double.infinity,
                child:CachedNetworkImage(
                  imageUrl: widget.adimage,
                  placeholder: (context, url) =>
                      Center(child: Image.asset("images/Spinner2.gif")),
                  fit: BoxFit.cover,
                  width: 120.w,
                  height: 120.h,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top:250.h),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(top:30.h),
                        child: Container(
                          width: 370.w,
                          child: Center(
                            child: Text(
                              widget.adtitle,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 30.sp),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.fromLTRB(10.w, 20.h, 10.w, 0),
                        child: Text(
                          widget.addesc,
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp),textAlign: TextAlign.center,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

    );
  }
}
