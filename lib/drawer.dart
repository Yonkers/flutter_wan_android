import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'collect_list.dart';
import 'text_link_span.dart';

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
    final ThemeData themeData = Theme.of(context);
    final TextStyle aboutTextStyle = themeData.textTheme.body2;
    final TextStyle linkStyle = themeData.textTheme.body2.copyWith(color: themeData.accentColor);

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
      new ListTile(leading: new Icon(Icons.person), title: new Text("About Author"), onTap: () {
        Navigator.of(context).pushNamed("/about/author");
      },),
      new Divider(),
      new AboutListTile(
        icon: new Icon(Icons.info),
        applicationVersion: '2018.02.07.alpha',
        applicationLegalese: 'author: leeoLuo',
        aboutBoxChildren: <Widget>[
          new Padding(
              padding: const EdgeInsets.all(16.0),
            child: new RichText(text: new TextSpan(children: <TextSpan>[
              new TextSpan(
                style: aboutTextStyle,
                  text: '使用Flutter编写，WanAndroid提供api.'
              ),
              new TextSpan(
                  style: aboutTextStyle,
                  text: '\n\n代码仓库'
              ),
              new LinkTextSpan(
                style: linkStyle,
                url: 'https://github.com/Yonkers/flutter_wan_android',
                text: 'flutter_wan_android'
              ),
              new TextSpan(
                  style: aboutTextStyle,
                  text: '\n\n更多Flutter资料参考'
              ),
              new LinkTextSpan(
                  style: linkStyle,
                  url: 'https://flutter.io',
              ),
              new TextSpan(
                  style: aboutTextStyle,
                  text: '.'
              ),
            ]
            )
            ),
          ),

        ],
      )
    ]);
    return listView;
  }


}