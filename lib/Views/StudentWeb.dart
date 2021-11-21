import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';



class StudentWeb extends StatefulWidget {

  const StudentWeb({Key key}) : super(key: key);

  @override
  _StudentWebState createState() => _StudentWebState();
}

class _StudentWebState extends State<StudentWeb> {
  String username='';
  String password='';
  SharedPreferences sharedPreferences;
  String uri;
  var encoded ;
  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      username=  sharedPreferences.getString("username");
      password=  sharedPreferences.getString("lmsToken");

      print(username);
      setState(() {
        uri='https://www.edumused.com/lms-login?username=${Uri.encodeComponent(username)}&password=${Uri.encodeComponent(password)}';
        encoded=uri;
        print("--------------------------------------------------");
        print(encoded);
      });
    });
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          initialUrl: encoded,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
