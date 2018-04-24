import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'presenter/collect_post_presenter.dart';
import 'presenter/response_data.dart';

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;

  PostDetailPage(this.post);

  @override
  State<StatefulWidget> createState() => new _PostDetailWebViewState();
}

class _PostDetailWebViewState extends State<PostDetailPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  CollectPostPresenter presenter = new CollectPostPresenter();

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
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(msg)));
  }

  bool collected = false;
  bool loading = false;

  @override
  initState() {
    super.initState();
    if (null != this.widget.post['collect']) {
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
    String title = widget.post['title'] == null
        ? widget.post['name']
        : widget.post['title'];
    var favIcon = loading
        ? new CupertinoActivityIndicator()
        : new Icon(
            collected ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
          );
    return new WebviewScaffold(
      key: _scaffoldKey,
      url: widget.post['link'],
      withJavascript: true,
      appBar: new AppBar(
        title: new Text(title),
        actions: <Widget>[
          new FlatButton(
              onPressed: () {
                if (loading) return;
                if (collected)
                  removeFavorite();
                else
                  addToFavorite();
              },
              child: favIcon)
        ],
      ),
    );
  }

  Future addToFavorite() async {
    setState(() {
      loading = true;
    });
    ResponseData data = await presenter.addCollect(
      query: this.widget.post['id'],
    );
    if (data.isSuccess()) {
      print("收藏成功");
      setState(() {
        collected = true;
        loading = false;
      });
    } else {
      print("收藏失败");
      setState(() {
        loading = false;
      });
    }
  }

  Future removeFavorite() async {
    setState(() {
      loading = true;
    });
    String originId = widget.post['origin'];
    if (originId == null || originId.isEmpty) originId = "-1";
    ResponseData data = await presenter.removeCollect(
        query: this.widget.post['id'], body: {'originId': originId});
    if (data.isSuccess()) {
      print("取消收藏成功");
      setState(() {
        collected = false;
        loading = false;
      });
    } else {
      print("取消收藏失败");
      setState(() {
        loading = false;
      });
    }
  }
}
