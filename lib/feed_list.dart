import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'presenter/response_data.dart';
import 'adapter/base_adapter.dart';

class FeedListPage extends StatefulWidget {
  final dynamic presenter;
  final dynamic query;
  final Map<String, dynamic> postParam;
  final BaseAdapter adapter;

  FeedListPage(this.presenter, this.adapter,
      {Key key, this.query, this.postParam})
      : super(key: key);

  @override
  _FeedListState createState() => new _FeedListState();
}

class _FeedListState extends State<FeedListPage> {
  var _curPage = 0;

  Future<List> _dataFuture;

  Future<List> loadFeeds() async {
    ResponseData responseData = await widget.presenter.fetch(
        page: _curPage, query: widget.query, body: this.widget.postParam);
    if (responseData.isSuccess()) {
      if ((responseData.data is List)) {
        //兼容收藏列表，网站列表
        return responseData.data;
      } else {
        return responseData.data['datas'];
      }
    } else {
      throw new Exception(responseData.errorMsg);
    }
  }

  @override
  void initState() {
    super.initState();

    _dataFuture = loadFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: _dataFuture,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return new Text("active");
            case ConnectionState.none:
              return new Center(
                child: new Text("none"),
              );
            case ConnectionState.waiting:
              return new Center(
                child: new CupertinoActivityIndicator(),
              );
            default:
              if (snapshot.hasError) {
                debugPrint("${snapshot.error}");
                return new Center(
                  child: new Text('Error: ${snapshot.error}'),
                );
              } else {
                List data = snapshot.data;
                if (null == data || data.length == 0) {
                  return new Center(
                    child: new Text('No Data'),
                  );
                }
                List<Widget> listTiles = data.map((item) {
                  return widget.adapter.getItemView(context, item);
                }).toList();
                return new ListView(
                  children: ListTile
                      .divideTiles(context: this.context, tiles: listTiles)
                      .toList(),
                );
              }
          }
        });
  }
}
