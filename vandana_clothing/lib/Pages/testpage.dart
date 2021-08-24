import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  final Uri muri;
  final String suri;
  const TestPage({Key key, this.muri, this.suri}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: Text(
          'Test',
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body:Column(
        children: [
          Text(muri.queryParameters['id']),
          Text(suri),
        ],
      ),
    );
  }
}
