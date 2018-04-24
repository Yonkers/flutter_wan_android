import 'dart:async';

import 'base_presenter.dart';
import '../net/wan_android_api.dart';
import 'response_data.dart';
import 'package:http/http.dart' as http;

class SearchPresenter extends BasePresenter {
  @override
  Future<ResponseData> fetch(
      {int page, dynamic query, Map<String, dynamic> body}) async {
    String url = fillUrl(SEARCH, params: [page]);
    Map<String, String> header = await getHeader();
    var response = await http.post(url, headers: header, body: body);
    return parseResponse(response);
  }
}
