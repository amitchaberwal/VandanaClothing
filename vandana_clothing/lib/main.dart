import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:vandana_clothing/Pages/HomePage/HomePage.dart';
import 'package:vandana_clothing/Pages/Login/Splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent
  ));
  await Firebase.initializeApp();
  runApp(VCClient());
}

class VCClient extends StatefulWidget {
  static ThemeMode globalTheme;
  const VCClient({Key key}) : super(key: key);

  static _VCClientState of(BuildContext context) => context.findAncestorStateOfType<_VCClientState>();

  @override
  _VCClientState createState() => _VCClientState();
}

class _VCClientState extends State<VCClient> {
  ThemeMode utheme;

  @override
  void initState() {
    super.initState();
    getTheme();
  }
  getTheme()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mth = prefs.getString('UserTheme');
    if(mth == 'System'){
      setState(() {
        utheme = ThemeMode.system;
        VCClient.globalTheme = utheme;
      });
    }
    else if(mth == 'Light'){
      setState(() {
        utheme = ThemeMode.light;
        VCClient.globalTheme = utheme;
      });
    }
    else if(mth == 'Dark'){
      setState(() {
        utheme = ThemeMode.dark;
        VCClient.globalTheme = utheme;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(392, 835),
        allowFontScaling: false,
        builder: () => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.grey[50],
            accentColor: Colors.yellow[800],
            secondaryHeaderColor: Colors.grey[900],
            cardColor: Colors.grey[200],
            textTheme:TextTheme(
              bodyText1: TextStyle(color: Colors.grey[900],fontSize: 20,letterSpacing: 1.0),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.grey[900],
            accentColor: Colors.yellow[800],
            secondaryHeaderColor: Colors.white,
            cardColor: Colors.black54,
            textTheme:TextTheme(
              bodyText1: TextStyle(color: Colors.white,fontSize: 20,letterSpacing: 1.0),
            ),
          ),
          themeMode: utheme,
          home: Splash(),
        )
    );

  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      utheme = themeMode;
    });
  }

}


