import 'package:flutter/material.dart';
import 'package:flutter_web_view/flutter_web_view.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/services.dart';
import 'cache.dart';
import 'dart:convert';

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;

  PostDetailPage(this.post);

  @override
  State<StatefulWidget> createState() => new _PostDetailWebViewState();
}

class _PostDetailState extends State<PostDetailPage> {

  String _redirectedToUrl;
  FlutterWebView flutterWebView = new FlutterWebView();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Widget leading;
    if (_isLoading) {
      leading = new CupertinoActivityIndicator();
    }
    var columnItems = <Widget>[
      new MaterialButton(
          onPressed: launchWebViewExample, child: new Text("Launch"))
    ];
    if (_redirectedToUrl != null) {
      columnItems.add(new Text("Redirected to $_redirectedToUrl"));
    }
    return new Scaffold(
      appBar: new AppBar(
        leading: leading,
        title: new Text(widget.post['title']),
      ),
      body: new Column(
        children: columnItems,
      ),
    );
  }

  void launchWebViewExample() {
    if (flutterWebView.isLaunched) {
      return;
    }

    flutterWebView.launch(this.widget.post['link'],
        javaScriptEnabled: true,
        toolbarActions: [
          new ToolbarAction("Dismiss", 1),
          new ToolbarAction("Reload", 2)
        ],
        barColor: Colors.green,
        tintColor: Colors.white);
    flutterWebView.onToolbarAction.listen((identifier) {
      switch (identifier) {
        case 1:
          flutterWebView.dismiss();
          break;
        case 2:
          reload();
          break;
      }
    });
    flutterWebView.listenForRedirect("mobile://test.com", true);

    flutterWebView.onWebViewDidStartLoading.listen((url) {
      setState(() => _isLoading = true);
    });
    flutterWebView.onWebViewDidLoad.listen((url) {
      setState(() => _isLoading = false);
    });
    flutterWebView.onRedirect.listen((url) {
      flutterWebView.dismiss();
      setState(() => _redirectedToUrl = url);
    });
  }

  void reload() {
    flutterWebView.load(
      "https://google.com",
    );
  }
}

class _PostDetailWebViewState extends State<PostDetailPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

// Instance of WebView plugin
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  final _history = [];

  void showSnack(String msg) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(msg)));
  }

  bool collected = false;

  @override
  initState() {
    super.initState();
    if(null != this.widget.post['collect']){
      collected = this.widget.post['collect'];
    }

    flutterWebviewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Webview Destroyed")));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add("onUrlChanged: $url");
        });
      }
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          if (mounted) {
            setState(() {
              _history.add("onStateChanged: ${state.type} ${state.url}");
            });
          }
        });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();

    flutterWebviewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.post['title'] == null ? widget.post['name'] : widget.post['title'];
    return new WebviewScaffold(
      key: _scaffoldKey,
      url: widget.post['link'],
      withJavascript: true,
      appBar: new AppBar(
        title: new Text(title),
        actions: <Widget>[
          new FlatButton(onPressed: () {
            if(collected) removeFavorite(); else addToFavorite();
          }, child: new Icon(collected ? Icons.favorite : Icons.favorite_border,color: Colors.white,))
        ],
      ),
    );
  }

  Future addToFavorite() async {
    String url = "http://www.wanandroid.com/lg/collect/${this.widget.post['id']}/json";
    var httpClient = createHttpClient();
    String login_cookie = await getCookie();
    var header;
    if(null != login_cookie){
      header = {
        'Cookie':login_cookie,
      };
    }
    var response = await httpClient.post(url, headers: header);

    if (response.statusCode == 200) {
      var res = JSON.decode(response.body);
      print(res);
      if(res['errorCode'] == 0){
        print("收藏成功");
        setState((){collected = true;});
      }else{
        print("收藏失败");
      }
      //showSnack("收藏成功");
    } else {
      //showSnack("收藏失败 ErrorCode:${response.statusCode}");
      print(response.body);
    }
  }

  Future removeFavorite() async{
    String url = "http://www.wanandroid.com/lg/uncollect_originId/${this.widget.post['id']}/json";
    var httpClient = createHttpClient();
    String login_cookie = await getCookie();
    var header;
    if(null != login_cookie){
      header = {
        'Cookie':login_cookie,
      };
    }
    String originId = widget.post['origin'];
    if(originId == null || originId.isEmpty) originId = "-1";
    var response = await httpClient.post(url, headers: header, body: {'originId': originId});

    if (response.statusCode == 200) {
      var res = JSON.decode(response.body);
      print(res);
      if(res['errorCode'] == 0){
        print("取消收藏成功");
        setState((){collected = false;});
      }else{
        print("取消收藏失败");
      }
      //showSnack("收藏成功");
    } else {
      //showSnack("收藏失败 ErrorCode:${response.statusCode}");
      print(response.body);
    }
  }



}