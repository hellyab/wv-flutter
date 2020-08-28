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
  DateTime currentBackPressTime;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool hasNext = false;
  bool hasPrevious = false;

  load() async {
    if (isURL(_controller.text)) {
      if (!(_controller.text.startsWith("http://") ||
          _controller.text.startsWith("https://"))) {
        _controller.text = 'https://${_controller.text}';
      }
      _webviewController.loadUrl(_controller.text);
      setState(() {
        loading = true;
      });
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

    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime) > Duration(seconds: 2)) {
          if (!await _webviewController.canGoBack()) {
            currentBackPressTime = now;
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Press back again to exit.'),
              duration: Duration(milliseconds: 750),
            ));
          }
          _webviewController.goBack();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            backgroundColor: Colors.black87,
            title: SizedBox(
              height: 45,
              child: TextField(
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(width: 0)),
                  filled: true,
                  hintText: "Enter URL here",
                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  fillColor: Colors.grey[800],
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    borderSide: BorderSide(width: 0),
                  ),
                ),
                controller: _controller,
                keyboardType: TextInputType.url,
                style: TextStyle(
                  color: Colors.white70,
                ),
                onSubmitted: (value) {
                  load();
                },
              ),
            ),
            actions: <Widget>[
              PopupMenuButton(
                offset: Offset(20, 58.0),
                padding: EdgeInsets.all(10),
                color: Colors.grey[900],
                onSelected: (value) {
                  if (value == "r") {
                    setState(() {
                      loading = true;
                    });
                    _webviewController.reload();
                  }
                  if (value == "f") {
                    _webviewController.goForward();
                  }
                  if (value == "b") {
                    _webviewController.goBack();
                  }
                },
                itemBuilder: (context) {
                  return <PopupMenuEntry>[
                    PopupMenuItem(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.refresh),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Reload",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      value: "r",
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.arrow_forward),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Forward",
                            style: TextStyle(
                              color: hasNext ? Colors.white : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      enabled: hasNext,
                      value: "f",
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.arrow_back),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Back",
                            style: TextStyle(
                              color: hasPrevious ? Colors.white : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      value: "b",
                      enabled: hasPrevious,
                    )
                  ];
                },
              ),
            ]),
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
                  var hp = await _webviewController.canGoBack();
                  var hn = await _webviewController.canGoForward();
                  setState(() {
                    hasNext = hn;
                    hasPrevious = hp;
                    loading = false;
                  });
                },
                onWebResourceError: (error) {
                  setState(() {
                    loading = false;
                  });
                },
                onPageStarted: (url) async {
                  setState(() {
                    loading = true;
                  });
                },
                gestureNavigationEnabled: true,
              ),
              Builder(
                builder: (context) => loading
                    ? SizedBox(height: 2.5, child: LinearProgressIndicator())
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
