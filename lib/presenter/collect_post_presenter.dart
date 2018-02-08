
import 'dart:async';

import 'base_presenter.dart';
import '../net/wan_android_api.dart';
import 'response_data.dart';


class CollectPostPresenter extends BasePresenter {

  @override
  Future<ResponseData> fetch({int page, dynamic query, Map<String, dynamic> body}) async {
    String url = fillUrl(FAVORITE_LIST, params: [page]);
    Map<String, dynamic> header = await getHeader();
    var response = await httpClient.get(url, headers: header);
    return parseResponse(response);
  }

  //添加收藏
  Future<ResponseData> addCollect({dynamic query, Map<String, dynamic> body}) async {
    String url = fillUrl(ADD_FAVORITE, params: [query]);
    Map<String, dynamic> header = await getHeader();
    var response = await httpClient.post(url, headers: header);
    return parseResponse(response);
  }

  //删除收藏
  Future<ResponseData> removeCollect({dynamic query, Map<String, dynamic> body}) async {
    String url = fillUrl(REMOVE_FAVORITE, params: [query]);
    Map<String, dynamic> header = await getHeader();
    var response = await httpClient.post(url, headers: header);
    return parseResponse(response);
  }

}