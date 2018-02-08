import 'package:flutter/material.dart';
import 'text_link_span.dart';

class AboutAuthor extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle aboutTextStyle = themeData.textTheme.body2;
    final TextStyle linkStyle = themeData.textTheme.body2.copyWith(color: themeData.accentColor);


    return new Scaffold(
      appBar: new AppBar(
        title: new Text("关于我"),
      ),
      body: new Container(
        padding: const EdgeInsets.all(10.0),
        child: new Card(
          child: new Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Text("leeoLuo", textScaleFactor: 1.5, textAlign: TextAlign.center,),
                new RichText(
                  textAlign: TextAlign.center,
                    text: new TextSpan(children: <TextSpan>[
                  new TextSpan(style:aboutTextStyle, text: "\n\n小小的一枚Android开发\n\n"),
                  new TextSpan(style:aboutTextStyle, text: "Blog: "),
                  new LinkTextSpan(style: linkStyle, url: "http://www.leeo.xin")
                ]))
              ],
            ),
          ),
        ),
      ),
    );
  }

}