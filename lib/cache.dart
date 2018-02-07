import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

Future getUserInfo() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String loginCookie = prefs.getString("loginCookie");
  if(null != loginCookie){
    return JSON.decode(loginCookie);
  }
  return null;
}

Future getCookie() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String loginCookie = prefs.getString("set-cookie");
  return loginCookie;
}