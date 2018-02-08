import 'package:flutter/material.dart';
import 'package:flutter_wan_android/post_detail.dart';
import 'base_adapter.dart';
class FeedItemAdapter extends BaseAdapter{

  FeedItemAdapter();

  @override
  Widget getItemView(BuildContext context, Map<String, dynamic> item){
    return new ListTile(
      leading: new CircleAvatar(child: new Text(item['title'].toString().substring(0,1)),),
      title: new Text(item['title'], style: new TextStyle(fontSize: 16.0)),
      subtitle: new Text("${item['chapterName']}  ${item['author']}"),
      dense: true,
      isThreeLine: true,
      onTap: (){
        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
          return new PostDetailPage(item);
        }));
      },
    );
  }

}