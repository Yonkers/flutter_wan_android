import 'package:flutter/material.dart';
import 'feed_list.dart';


class CollectType{
  String name;
  String api;
  String code;

  CollectType(this.name, this.code, this.api);

}

class CollectListPage extends StatefulWidget{

  final List<CollectType> collectTypes = [
   new CollectType('收藏文章',"post-collect" ,'http://www.wanandroid.com/lg/collect/list/0/json'),
   new CollectType('收藏网站', "website-collect", 'http://www.wanandroid.com/lg/collect/usertools/json')
  ];

  CollectListPage();

  @override
  State<StatefulWidget> createState() => new _CollectListState();

}

class _CollectListState extends State<CollectListPage>{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new DefaultTabController(
          length: widget.collectTypes.length,
          child: new Scaffold(
            appBar: new AppBar(
              leading: new IconButton(
                tooltip: 'back',
                icon: const Icon(Icons.arrow_back),
                onPressed: () { Navigator.of(this.context).pop(); },
              ),
              title: new Text('我的收藏'),
              bottom: new TabBar(
                isScrollable: true,
                  tabs: widget.collectTypes.map((CollectType t){
                return new Tab(text: t.name);
              }).toList()),
            ),
            body: new TabBarView(
              children: widget.collectTypes.map((CollectType t){
                return new FeedListPage(t.code == "website-collect" ? LIST_TYPE_WEBSITE : LIST_TYPE_FEEDS, apiUrl: t.api);
              }).toList(),
            ),
          )),
    );


  }

}