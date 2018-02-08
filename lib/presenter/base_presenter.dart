import 'response_data.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_wan_android/cache.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';

abstract class BasePresenter {

  var httpClient = createHttpClient();

  //请求接口数据
  Future<ResponseData> fetch({int page, dynamic query, Map<String, dynamic> body});

  Future getHeader() async {
    String loginCookie = await getCookie();
    Map<String, dynamic> header;
    if (null != loginCookie) {
      header = {
        'Cookie': loginCookie,
      };
    }
    return header;
  }

  ResponseData parseResponse(Response response) {
    print(response.body);
    ResponseData responseData;
    if (response.statusCode == HttpStatus.OK) {
      Map<String, dynamic> res = JSON.decode(response.body);
      responseData = new ResponseData(errorCode: res['errorCode'], errorMsg: res['errorMsg'], data: res['data']);
    } else {
      responseData = new ResponseData(errorCode: -1, errorMsg: "Request Server Error! Code:${response.statusCode}");
    }
    return responseData;
  }

}