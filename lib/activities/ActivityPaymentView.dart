import 'package:almajlis/core/server/Server.dart';
import 'package:almajlis/utils/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ActivityPaymentView extends StatefulWidget {
  String _url;

  ActivityPaymentView(this._url);

  @override
  State<StatefulWidget> createState() {
    return _ActivityPaymentView();
  }
}

class _ActivityPaymentView extends State<ActivityPaymentView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print("change+++++++++++++++++++++++++++++++++++++++++++++");
      if (url == Server.BASE_URL + Constants.SUCCESS_URL) {
        Navigator.pop(context, true);
      } else if (url == Server.BASE_URL + Constants.FAILURE_URL) {
        Navigator.pop(context, false);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flutterWebviewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget._url,
      appBar: AppBar(
        title: Text("Complete Payment"),
      ),
    );
  }
}
