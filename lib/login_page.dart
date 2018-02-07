import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new LoginState();

}

class LoginState extends State<LoginPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("登陆"),
      ),
      body: getLoginForm(),
    );
  }

  void showSnack(String msg) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(msg)));
  }

  String userNameValidator(String username) {
    if (username
        .trim()
        .length == 0) return "请输入用户名";
    return null;
  }

  String passwordValidator(String pass) {
    if (pass
        .trim()
        .length == 0) return "请输入密码";
    return null;
  }

  Future login() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      print('login form error');
    } else {
      form.save();
      print("username $username , password: $password");
      var httpClient = createHttpClient();
      var response = await httpClient.post("http://www.wanandroid.com/user/login",
        body: {
          'username': this.username,
          'password': this.password
        },
        encoding: Encoding.getByName("utf-8")
      );
      print(response.body);
      print(response.headers);
      if (response.statusCode == HttpStatus.OK) {
        Map data = JSON.decode(response.body);
        if (data['errorCode'] != 0) {
          String msg = data['errorMsg'];
          String errMsg = msg == null || msg.trim().isEmpty ? "登陆失败" : msg;
          showSnack(errMsg);
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("loginCookie", JSON.encode(data['data']));
          String set_cookie = response.headers['set-cookie'];
          prefs.setString("set-cookie", set_cookie);
          Navigator.of(this.context).pop("login");
        }
      } else {
        showSnack("登陆失败 ErrorCode: ${response.statusCode}");
      }
    }
  }

  void register() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      print('register form error');
    } else {
      form.save();
      Navigator.of(this.context).pop("register");
    }
  }

  Widget getLoginForm() {
    var formItems = <Widget>[
      new TextFormField(
        decoration: const InputDecoration(
            labelText: '用户名',
            labelStyle: const TextStyle(fontSize: 16.0),
            hintText: '请输入用户名',
            hintStyle: const TextStyle(fontSize: 14.0)
        ),
        validator: passwordValidator,
        initialValue: 'leeoLuo',
        maxLines: 1,
        onSaved: (String value) {
          username = value;
        },
      ),
      new TextFormField(
        decoration: const InputDecoration(
            labelText: '密码',
            labelStyle: const TextStyle(fontSize: 16.0),
            hintText: '由数字 - _ 组成的密码',
            hintStyle: const TextStyle(fontSize: 14.0)
        ),
        obscureText: true,
        validator: userNameValidator,
        initialValue: '552355-wan-lee',
        maxLines: 1,
        onSaved: (String value) {
          password = value;
        },
      ),
      new ButtonTheme.bar(
        child: new ButtonBar(
          alignment: MainAxisAlignment.end,
          children: <Widget>[
            new FlatButton(
                child: const Text('注 册', textScaleFactor: 1.3),
                textColor: Colors.red.shade300,
                onPressed: register
            ),
            new FlatButton(
                child: const Text('登 陆', textScaleFactor: 1.3,),
                textColor: Colors.blue.shade600,
                onPressed: login
            ),
          ],
        ),
      ),
    ];
    return new Container(
      padding: new EdgeInsets.all(5.0),
      child: new Card(
        child: new Form(
          key: _formKey,
          autovalidate: true,
          child: new Padding(
            padding: new EdgeInsets.all(10.0),
            child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: formItems
            ),
          ),
        ),
      ),
    );
  }

}