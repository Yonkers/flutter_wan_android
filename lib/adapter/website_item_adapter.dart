import 'package:flutter/material.dart';
import 'package:flutter_wan_android/post_detail.dart';
import 'base_adapter.dart';
class WebsiteItemAdapter extends BaseAdapter{

  WebsiteItemAdapter();

  @override
  Widget getItemView(BuildContext context, Map<String, dynamic> item){
    return new ListTile(
      leading: new CircleAvatar(child: new Text(item['name'].toString().substring(0,1)),),
      title: new Text(item['name'], style: new TextStyle(fontSize: 18.0)),
      dense: true,
      isThreeLine: false,
      onTap: (){
        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
          return new PostDetailPage(item);
        }));
      },
    );
  }

}