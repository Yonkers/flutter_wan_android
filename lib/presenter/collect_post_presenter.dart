import 'dart:async';
import 'package:http/http.dart' as http;
import 'base_presenter.dart';
import '../net/wan_android_api.dart';
import 'response_data.dart';

class CollectPostPresenter extends BasePresenter {
  @override
  Future<ResponseData> fetch(
      {int page, dynamic query, Map<String, dynamic> body}) async {
    String url = fillUrl(FAVORITE_LIST, params: [page]);
    Map<String, String> header = await getHeader();
    var response = await http.get(url, headers: header);
    return parseResponse(response);
  }

  //添加收藏
  Future<ResponseData> addCollect(
      {dynamic query, Map<String, dynamic> body}) async {
    String url = fillUrl(ADD_FAVORITE, params: [query]);
    Map<String, String> header = await getHeader();
    var response = await http.post(url, headers: header);
    return parseResponse(response);
  }

  //删除收藏
  Future<ResponseData> removeCollect(
      {dynamic query, Map<String, dynamic> body}) async {
    String url = fillUrl(REMOVE_FAVORITE, params: [query]);
    Map<String, String> header = await getHeader();
    var response = await http.post(url, headers: header);
    return parseResponse(response);
  }
}
