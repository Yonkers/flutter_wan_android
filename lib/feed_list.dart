import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'post_detail.dart';
import 'cache.dart';

const String LIST_TYPE_FEEDS = "FEEDS";
const String LIST_TYPE_WEBSITE = "COLLECTS";

class FeedListPage extends StatefulWidget {
  final apiUrl;
  final listType;

  FeedListPage(this.listType, {Key key, this.apiUrl}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<FeedListPage> {

  var httpClient = createHttpClient();
  var _curPage = 0;

  List<Map<String, dynamic>> pageData;
  String _errorMsg;

  Future loadFeeds() async{
    String url = "http://www.wanandroid.com/article/list/$_curPage/json";
    if(this.widget.apiUrl != null){
      url = this.widget.apiUrl;
    }
    print("url: $url");

    String login_cookie = await getCookie();
    var header;
    if(null != login_cookie){
      header = {
        'Cookie':login_cookie,
      };
    }

    var response = await httpClient.get(url, headers: header);
    print(response.body);
    if(response.statusCode == 200){
      Map result = JSON.decode(response.body);
      if(result['errorCode'] == 0) {
        if((result['data'] is List)){ //兼容收藏列表，网站列表
          pageData = result['data'];
        }else {
          pageData = result['data']['datas'];
        }
        if(pageData.isEmpty)  _errorMsg = "暂无收藏";
      }else{
        pageData = [];
        _errorMsg = result['errorMsg'];
      }
    }else{
      pageData = [];
      _errorMsg = "Data error ${response.statusCode}";
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
        return getItemView(item);
      }).toList();
      body = new ListView(children: ListTile.divideTiles(context: this.context, tiles: listTiles).toList(),);
    }
    return body;
  }

  Widget getItemView(Map<String, dynamic> item){
    if(widget.listType == LIST_TYPE_WEBSITE){
      return new ListTile(
        leading: new CircleAvatar(child: new Text(item['name'].toString().substring(0,1)),),
        title: new Text(item['name'], style: new TextStyle(fontSize: 18.0)),
        dense: true,
        isThreeLine: false,
        onTap: (){
          Navigator.push(this.context, new MaterialPageRoute(builder: (BuildContext context){
            return new PostDetailPage(item);
          }));
        },
      );
    }
    return new ListTile(
      leading: new CircleAvatar(child: new Text(item['title'].toString().substring(0,1)),),
      title: new Text(item['title'], style: new TextStyle(fontSize: 16.0)),
      subtitle: new Text("${item['chapterName']}  ${item['author']}"),
      dense: true,
      isThreeLine: true,
      onTap: (){
        Navigator.push(this.context, new MaterialPageRoute(builder: (BuildContext context){
          return new PostDetailPage(item);
        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  getBodyView();
  }
}
