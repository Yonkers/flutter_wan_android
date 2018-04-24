import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'tabbed_post_by_type.dart';

//知识体系列表
class TypeListPage extends StatefulWidget {
  TypeListPage({Key key}) : super(key: key);

  @override
  _TypeListPageState createState() => new _TypeListPageState();
}

class _TypeListPageState extends State<TypeListPage>
    with AutomaticKeepAliveClientMixin {
  List typeList;
  String _errorMsg;

  Future loadFeeds() async {
    var response = await http.get("http://www.wanandroid.com/tree/json");
    if (response.statusCode == 200) {
      typeList = json.decode(response.body)['data'];
    } else {
      typeList = [];
      _errorMsg = "Data error ${response.statusCode}";
    }
    return typeList;
  }

  @override
  void initState() {
    super.initState();

    loadFeeds().then((dynamic data) {
      setState(() {
        //update ui
      });
    });
  }

  Widget getBodyView() {
    var body;
    if (typeList == null) {
      body = new Container(
          child: new Center(
        child: new CupertinoActivityIndicator(),
      ));
    } else if (_errorMsg != null) {
      body = new Container(
          child: new Center(
        child: new Text(_errorMsg),
      ));
    } else {
      List<ListTile> listTiles = typeList.map((item) {
        List children = item['children'] as List;
        StringBuffer sb = new StringBuffer();
        children.forEach((child) {
          sb.write(child['name']);
          sb.write("   ");
        });
        return new ListTile(
          leading: new CircleAvatar(
            child: new Text(item['name'].toString().substring(0, 1)),
          ),
          title: new Text(item['name'], style: new TextStyle(fontSize: 18.0)),
          isThreeLine: true,
          dense: true,
          subtitle: new Text(
            "$sb",
            maxLines: 2,
          ),
          onTap: () {
            Navigator.push(this.context,
                new MaterialPageRoute(builder: (BuildContext context) {
              return new TabbedPostListPage(item);
            }));
          },
        );
      }).toList();
      body = new ListView(
        children: ListTile
            .divideTiles(context: this.context, tiles: listTiles)
            .toList(),
      );
    }
    return body;
  }

  @override
  Widget build(BuildContext context) {
    return getBodyView();
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
