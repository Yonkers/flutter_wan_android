import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'post_detail.dart';
import 'feed_list.dart';
import 'presenter/search_presenter.dart';
import 'adapter/feed_item_adapter.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SearchState();
}

class _SearchState extends State<SearchPage> {
  List hotWords;

  List colors = [
    Colors.blue,
    Colors.amber,
    Colors.green,
    Colors.pink,
    Colors.cyan
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> columns = <Widget>[
      new TextField(
        autofocus: false,
        maxLines: 1,
        decoration: new InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: '搜索关键词',
          hintStyle: const TextStyle(color: Colors.blueGrey),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(16.0),
          suffixIcon: new IconButton(
              icon: const Icon(Icons.arrow_right), onPressed: () {}),
        ),
      )
    ];
    if (null != hotWords && hotWords.length > 0) {
      columns.add(new Divider(
        height: 30.0,
        color: Colors.transparent,
      ));

      Random random = new Random(colors.length);

      Wrap hotLayout = new Wrap(
        spacing: 16.0,
        runSpacing: 16.0,
        alignment: WrapAlignment.center,
        children: hotWords.map((word) {
          return new InkWell(
            child: new Container(
              child: new Text(
                word['name'],
                style: new TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              color: colors[random.nextInt(colors.length)],
            ),
            onTap: () {
              Navigator.push(this.context,
                  new MaterialPageRoute(builder: (BuildContext context) {
                return new Scaffold(
                    appBar: new AppBar(
                      title: new Text("search:${word['name']}"),
                    ),
                    body: new FeedListPage(
                      new SearchPresenter(),
                      new FeedItemAdapter(),
                      postParam: {'k': word['name']},
                    ));
              }));
            },
          );
        }).toList(),
      );

      columns.add(hotLayout);
    }

    return new Container(
      padding: const EdgeInsets.all(5.0),
      child: new Column(children: columns),
    );
  }

  @override
  void initState() {
    super.initState();

    loadHotWords();
  }

  Future loadHotWords() async {
    var response = await http.get("http://www.wanandroid.com/hotkey/json");
    if (response.statusCode == HttpStatus.OK) {
      Map res = json.decode(response.body);
      List list = res['data'];
      if (list == null) list = [];
      setState(() {
        this.hotWords = list;
      });
    } else {}
  }
}
