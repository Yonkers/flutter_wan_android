import 'package:flutter/material.dart';
import 'feed_list.dart';
import 'presenter/collect_post_presenter.dart';
import 'presenter/collect_website_presenter.dart';
import 'adapter/website_item_adapter.dart';
import 'adapter/feed_item_adapter.dart';

class CollectType{
  String name;
  String code;

  CollectType(this.name, this.code);

}

class CollectListPage extends StatefulWidget{

  final List<CollectType> collectTypes = [
   new CollectType('收藏文章',"post-collect" ),
   new CollectType('收藏网站', "website-collect")
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
                if(t.code == "website-collect"){
                  return new FeedListPage(new CollectWebsitePresenter(), new WebsiteItemAdapter());
                }
                return new FeedListPage(new CollectPostPresenter(), new FeedItemAdapter());
              }).toList(),
            ),
          )),
    );


  }

}