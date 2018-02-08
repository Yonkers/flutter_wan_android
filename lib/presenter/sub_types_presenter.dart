
import 'dart:async';

import 'base_presenter.dart';
import '../net/wan_android_api.dart';
import 'response_data.dart';

class TypeFeedsPresenter extends BasePresenter {

  @override
  Future<ResponseData> fetch({int page, dynamic query, Map<String, dynamic> body}) async {
    String url = fillUrl(TREE_FEEDS,params: [page, query]);
    Map<String, dynamic> header = await getHeader();
    var response = await httpClient.get(url, headers: header);
    return parseResponse(response);
  }

}