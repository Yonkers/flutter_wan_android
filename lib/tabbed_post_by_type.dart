import 'package:flutter/material.dart';
import 'feed_list.dart';

class TabbedPostListPage extends StatefulWidget{
  final Map<String,dynamic> typeItem;

  TabbedPostListPage(this.typeItem);

  @override
  State<StatefulWidget> createState() => new _TabbedPostListState();

}

class _TabbedPostListState extends State<TabbedPostListPage>{
  @override
  Widget build(BuildContext context) {
    List<Map<String,dynamic>> types = this.widget.typeItem['children'];

    return new MaterialApp(

      home: new DefaultTabController(
          length: types.length,
          child: new Scaffold(
            appBar: new AppBar(
              leading: new IconButton(
                tooltip: 'Previous choice',
                icon: const Icon(Icons.arrow_back),
                onPressed: () { Navigator.of(this.context).pop(); },
              ),
              title: new Text(this.widget.typeItem['name']),
              bottom: new TabBar(
                isScrollable: true,
                  tabs: types.map((Map<String,dynamic> t){
                return new Tab(text: t['name']);
              }).toList()),
            ),
            body: new TabBarView(
              children: types.map((Map<String,dynamic> t){
                return new FeedListPage(LIST_TYPE_FEEDS, apiUrl: "http://www.wanandroid.com/article/list/0/json?cid=${t['id']}");
              }).toList(),
            ),
          )),
    );


  }

}