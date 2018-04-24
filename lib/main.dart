import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'feed_list.dart';
import 'type_list.dart';
import 'drawer.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'collect_list.dart';
import 'search_page.dart';
import 'presenter/feeds_presenter.dart';
import 'adapter/feed_item_adapter.dart';
import 'about_author.dart';

void main() => runApp(new MyApp());

Map<String, WidgetBuilder> buildRoutes() {
  return <String, WidgetBuilder>{
    '/login': (BuildContext context) => new LoginPage(),
    '/favorite/list': (BuildContext context) => new CollectListPage(),
    '/about/author': (BuildContext context) => new AboutAuthor(),
  };
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'WanAndroid',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: buildRoutes(),
      home: new MyHomePage(title: 'WanAndroid'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  int _currentIndex = 0;

  Map userInfo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkLogin();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("app state $state");
    if (state == AppLifecycleState.resumed) {
      checkLogin();
    }
  }

  Future checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loginCookie = prefs.getString("loginCookie");
    bool login = loginCookie != null && loginCookie.isNotEmpty;
    setState(() {
      if (login) {
        userInfo = json.decode(loginCookie);
      } else {
        userInfo = null;
      }
    });
  }

  Widget _buildStack() {
    final List<Widget> transitions = <Widget>[];
    transitions
        .add(new FeedListPage(new FeedsPresenter(), new FeedItemAdapter()));
    transitions.add(new SearchPage());
    transitions.add(new TypeListPage());
    return new IndexedStack(
      children: transitions,
      index: _currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: _buildStack(),
      drawer: new Drawer(child: new DrawerSetting(userInfo)),
      bottomNavigationBar: new BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              this._currentIndex = index;
            });
          },
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
                icon: new Icon(Icons.home), title: new Text("推荐")),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.search), title: new Text("搜索")),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.menu), title: new Text("知识体系")),
          ]),
    );
  }
}
