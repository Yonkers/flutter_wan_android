import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:math';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SearchState();

}

class _SearchState extends State<SearchPage> {

  List<Map<String, dynamic>> hotWords;

  List colors = [
    Colors.blue, Colors.amber,
    Colors.green, Colors.pink,
    Colors.cyan
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> columns = <Widget>[
      new TextField(
        autofocus: false,
        decoration: new InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: '搜索关键词',
            hintStyle: const TextStyle(color: Colors.blueGrey),
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(16.0),
          suffixIcon: new IconButton(icon: const Icon(Icons.close), onPressed: (){})
        ),
      )
    ];
    if (null != hotWords && hotWords.length > 0) {
      columns.add(new Divider(height: 30.0, color: Colors.transparent,));

      Random random = new Random(colors.length);

      Wrap hotLayout = new Wrap(
        spacing: 16.0,
        runSpacing: 16.0,
        alignment: WrapAlignment.center,
        children: hotWords.map((Map<String, dynamic> word) {
          return new Container(
            child: new Text(word['name'], style: new TextStyle(color: Colors.white, fontSize: 18.0),),
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            color: colors[random.nextInt(colors.length)],
          );
        }).toList(),
      );

      columns.add(hotLayout);
    }


    return new Container(
      padding: const EdgeInsets.all(5.0),
      child: new Column(
          children: columns
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    loadHotWords();
  }

  Future loadHotWords() async {
    var httpClient = createHttpClient();
    var response = await httpClient.get("http://www.wanandroid.com/hotkey/json");
    if (response.statusCode == HttpStatus.OK) {
      Map res = JSON.decode(response.body);
      List<Map<String, dynamic>> list = res['data'];
      if (list == null) list = [];
      setState(() {
        this.hotWords = list;
      });
    } else {

    }
  }

}