import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wan_android/net/wan_android_api.dart';

void main(){
  test("url pattern", (){
    String url = fillUrl(TREE_FEEDS, params: [1, 12]);
    print(url);
  });
}