import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'post_detail.dart';
import 'feed_list.dart';
import 'tabbed_post_by_type.dart';
//知识体系列表
class TypeListPage extends StatefulWidget {
  TypeListPage({Key key}) : super(key: key);

  @override
  _TypeListPageState createState() => new _TypeListPageState();
}

class _TypeListPageState extends State<TypeListPage> {

  var httpClient = createHttpClient();
  var _curPage = 0;

  List<Map<String, dynamic>> typeList;
  String _errorMsg;

  Future loadFeeds() async{
    var response = await httpClient.get("http://www.wanandroid.com/tree/json");
    if(response.statusCode == 200){
      typeList = JSON.decode(response.body)['data'];
    }else{
      typeList = [];
      _errorMsg = "Data error ${response.statusCode}";
    }
    return typeList;
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
    if(typeList == null){
      body = new Container(child: new Center(child: new CupertinoActivityIndicator(),));
    }else if(_errorMsg != null){
      body = new Container(child: new Center(child: new Text(_errorMsg),));
    }else{
      List<ListTile> listTiles = typeList.map((Map<String, dynamic> item){
        List<Map<String, dynamic>> children = item['children'] as List;
        StringBuffer sb = new StringBuffer();
        children.forEach((Map<String, dynamic> child){
          sb.write(child['name']);
          sb.write("   ");
        });
        return new ListTile(
          leading: new CircleAvatar(child: new Text(item['name'].toString().substring(0,1)),),
          title: new Text(item['name'], style: new TextStyle(fontSize: 18.0)),
          isThreeLine: true,
          dense: true,
          subtitle: new Text("$sb", maxLines: 2,),
          onTap: (){
            Navigator.push(this.context, new MaterialPageRoute(builder: (BuildContext context){
              return new TabbedPostListPage(item);
            }));
          },
        );
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
