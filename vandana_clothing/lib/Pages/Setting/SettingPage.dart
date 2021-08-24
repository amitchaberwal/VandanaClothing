import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vandana_clothing/main.dart';

class MySetting extends StatefulWidget {
  @override
  _MySettingState createState() => _MySettingState();
}

class _MySettingState extends State<MySetting> {
  String UTheme = 'System';
  @override
  void initState() {
    super.initState();
    getUserTheme();
  }

  getUserTheme()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      UTheme = prefs.getString('UserTheme');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Setting',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
      ),

      body: new ListView(
        children: [
          Padding(
            padding:  EdgeInsets.only(top:20.h,left: 20.w),
            child: Text(
              'Choose Theme',
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
            child: DropdownButtonFormField(
              hint: Text(
                'Choose Theme',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor),
              ),
              style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
              value: UTheme,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
              ),
              dropdownColor: Theme.of(context).primaryColor,
              onChanged: (newValue) async{
                setState(() {
                  UTheme = newValue;
                });
                if (UTheme == 'System') {
                  VCClient.of(context).changeTheme(ThemeMode.system);
                }
                else if (UTheme == 'Light') {
                  VCClient.of(context).changeTheme(ThemeMode.light);
                }
                else if (UTheme == 'Dark') {
                  VCClient.of(context).changeTheme(ThemeMode.dark);
                }

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('UserTheme', UTheme);
              },
              items: [
                DropdownMenuItem(
                  value: "System",
                  child: Text(
                    "System",style: TextStyle(
                      color:
                      Theme.of(context).secondaryHeaderColor),
                  ),
                ),
                DropdownMenuItem(
                  value: "Light",
                  child: Text(
                    "Light",style: TextStyle(
                      color:
                      Theme.of(context).secondaryHeaderColor),
                  ),
                ),
                DropdownMenuItem(
                  value: "Dark",
                  child: Text(
                    "Dark",style: TextStyle(
                      color:
                      Theme.of(context).secondaryHeaderColor),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
