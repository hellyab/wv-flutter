import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:string_validator/string_validator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  bool loading = true;

  load() async {
    if (isURL(_controller.text)) {
      if (!(_controller.text.startsWith("http://") ||
          _controller.text.startsWith("https://"))) {
        _controller.text = 'https://${_controller.text}';
      }
      if (_controller.text != await _webviewController.currentUrl()) {
        _webviewController.loadUrl(_controller.text);
        setState(() {
          loading = true;
        });
      }
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter a valid URL.",
          ),
        ),
      );
    }
    print(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: SizedBox(
          width: width * 0.7,
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            controller: _controller,
            keyboardType: TextInputType.url,
            style: TextStyle(
              color: Colors.white54,
            ),
            onSubmitted: (value) {
              load();
            },
          ),
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => ButtonTheme(
              child: FlatButton(
                shape: CircleBorder(),
                child: Icon(
                  Icons.navigate_next,
                  color: Colors.white54,
                ),
                onPressed: () {
                  load();
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
              ),
              minWidth: width * 0.2,
              height: width * 0.2,
            ),
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            WebView(
              initialUrl: url,
              // 'https://anz1-usdc2.etadirect.com/ssmportal/mobility/',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController controller) {
                _webviewController = controller;
              },
              onPageFinished: (url) async {
                _controller.text = await _webviewController.currentUrl();
                setState(() {
                  loading = false;
                });
              },
              onWebResourceError: (error) {
                setState(() {
                  loading = false;
                });
              },
            ),
            Builder(
              builder: (context) => loading
                  ? SizedBox(height: 2.5, child: LinearProgressIndicator())
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
