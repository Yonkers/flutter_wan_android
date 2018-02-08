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

  FeedListPage(this.presenter, this.adapter, {Key key, this.query, this.postParam}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<FeedListPage> {

  var _curPage = 0;

  List<Map<String, dynamic>> pageData;
  String _errorMsg;

  Future loadFeeds() async{
    ResponseData responseData =  await widget.presenter.fetch(page: _curPage, query: widget.query, body: this.widget.postParam);
    if(responseData.isSuccess()){
      if((responseData.data is List)){ //兼容收藏列表，网站列表
        pageData = responseData.data;
      }else {
        pageData = responseData.data['datas'];
      }
      if(pageData.isEmpty)  _errorMsg = "暂无数据";
    }else{
      pageData = [];
      _errorMsg = responseData.errorMsg;
    }
    return pageData;
  }


  @override
  void initState() {
    super.initState();

    loadFeeds().then((dynamic data){
      setState((){
        //update ui
      });
    });
  }

  Widget getBodyView(){
    var body;
    if(pageData == null){
      body = new Container(child: new Center(child: new CupertinoActivityIndicator(),));
    }else if(_errorMsg != null){
      body = new Container(child: new Center(child: new Text(_errorMsg),));
    }else{
      List<ListTile> listTiles = pageData.map((Map<String, dynamic> item){
        return widget.adapter.getItemView(context, item);
      }).toList();
      body = new ListView(children: ListTile.divideTiles(context: this.context, tiles: listTiles).toList(),);
    }
    return body;
  }

  @override
  Widget build(BuildContext context) {
    return  getBodyView();
  }
}
