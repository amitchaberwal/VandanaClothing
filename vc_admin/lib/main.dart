import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:vc_admin/Pages/Login/Splash.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent
  ));
  await Firebase.initializeApp();
  runApp(vcAdmin());
}
class vcAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(392, 835),
      allowFontScaling: false,
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.grey[50],
          accentColor: Colors.yellow[800],
          secondaryHeaderColor: Colors.grey[900],
          cardColor: Colors.grey[200],
          textTheme:TextTheme(
            bodyText1: TextStyle(color: Colors.grey[900],fontSize: 20,letterSpacing: 1.0),
          ),
        ),
        darkTheme: ThemeData(
          primaryColor: Colors.grey[900],
          accentColor: Colors.yellow[800],
          secondaryHeaderColor: Colors.white,
          cardColor: Colors.black54,
          textTheme:TextTheme(
            bodyText1: TextStyle(color: Colors.white,fontSize: 20,letterSpacing: 1.0),
          ),
        ),
        home: Splash(),
      )
    );
  }
}


