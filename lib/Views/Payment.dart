import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hemchaya_education/Views/Component/appBar.dart';
import 'package:webview_flutter/webview_flutter.dart';



class Payment extends StatefulWidget {
  final url;
  const Payment({Key key, this.url}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  void initState() {
    print("===============");
    print(widget.url);
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Payment"),
      body: WebView(
        initialUrl: Uri.decodeFull(widget.url),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
