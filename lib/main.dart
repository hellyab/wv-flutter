import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'Flutter Demo Webview'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = "https://google.com";
  final _controller = TextEditingController();
  WebViewController _webviewController;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        height: height,
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: width * 0.7,
                  height: height * 0.1,
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    controller: _controller,
                  ),
                ),
                FlatButton(
                  shape: CircleBorder(),
                  child: Icon(Icons.navigate_next),
                  onPressed: () {
                    print(_controller.text);
                    setState(() {});
                    _webviewController.loadUrl(_controller.text);
                  },
                )
              ],
            ),
            SizedBox(
              height: height * 0.9,
              child: WebView(
                initialUrl: url,
                // 'https://anz1-usdc2.etadirect.com/ssmportal/mobility/',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController controller) {
                  _webviewController = controller;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
