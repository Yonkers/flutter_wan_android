import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'collect_list.dart';

class DrawerSetting extends StatelessWidget {
  final Map userInfo;

  DrawerSetting(this.userInfo);

  @override
  Widget build(BuildContext context) {
    var header;
    if (userInfo != null) {
      header = new DrawerHeader(
        child: new Container(
          padding: const EdgeInsets.all(0.0),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new CircleAvatar(
                child: new Icon(Icons.person, color: Colors.white, size: 40.0,),
                backgroundColor: Colors.blue,
                radius: 40.0,
              ),
              new Divider(height: 20.0, color: Colors.transparent,),
              new Text(userInfo['username'], style: new TextStyle(fontSize: 18.0),)
            ],
          ),
          //color: Colors.blue,
        ),
      );
    } else {
      header = new DrawerHeader(
        child: new Container(
          child: new RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/login");
              },
              child: new Text("登 陆")),
          //color: Colors.blue,
        ),
      );
    }

    ListView listView = new ListView(children: <Widget>[
      header,
      new ListTile(leading: new Icon(Icons.favorite), title: new Text("我的收藏"),
        onTap: () {
          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
            return new CollectListPage();
          }));
        },),
      new Divider(),
      new ListTile(leading: new Icon(Icons.favorite), title: new Text("常用网站"),
        onTap: () {

        },),
      new Divider(),
      new ListTile(leading: new Icon(Icons.info), title: new Text("About This App"), onTap: () {

      },),
      new Divider(),
      new ListTile(leading: new Icon(Icons.person), title: new Text("About Author"), onTap: () {

      },)
    ]);
    return listView;
  }


}