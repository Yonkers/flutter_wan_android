import 'package:flutter/material.dart';
import 'feed_list.dart';
import 'presenter/sub_types_presenter.dart';
import 'adapter/feed_item_adapter.dart';

class TabbedPostListPage extends StatefulWidget {
  final Map typeItem;

  TabbedPostListPage(this.typeItem);

  @override
  State<StatefulWidget> createState() => new _TabbedPostListState();
}

class _TabbedPostListState extends State<TabbedPostListPage> {
  @override
  Widget build(BuildContext context) {
    List types = this.widget.typeItem['children'];

    return new MaterialApp(
      home: new DefaultTabController(
          length: types.length,
          child: new Scaffold(
            appBar: new AppBar(
              leading: new IconButton(
                tooltip: 'Previous choice',
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(this.context).pop();
                },
              ),
              title: new Text(this.widget.typeItem['name']),
              bottom: new TabBar(
                  isScrollable: true,
                  tabs: types.map((t) {
                    return new Tab(text: t['name']);
                  }).toList()),
            ),
            body: new TabBarView(
              children: types.map((t) {
                return new FeedListPage(
                  new TypeFeedsPresenter(),
                  new FeedItemAdapter(),
                  query: t['id'],
                );
              }).toList(),
            ),
          )),
    );
  }
}
