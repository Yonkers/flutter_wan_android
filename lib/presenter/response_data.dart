//服务器返回的数据
class ResponseData {
  dynamic data;
  int errorCode = -1;
  String errorMsg = "";

  bool isSuccess() => errorCode == 0 && (errorMsg == null || errorMsg.length == 0);

  ResponseData({this.errorCode, this.errorMsg, this.data});
}