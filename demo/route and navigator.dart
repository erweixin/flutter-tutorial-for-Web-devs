import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import './second.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

void main() {
  runApp(new MyApp());
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'todo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: home(),
      // 路由命名
      routes: <String, WidgetBuilder>{
        '/router/second': (_) => second(),
        '/router/third': (_) => third(),
      },
    );
  }
}

// 第3页，navigator pop时传递“message from third pages”
// 接受参数message
class third extends StatelessWidget {
  third({
    Key key,
    this.message: '',
  });
  String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:  OutlineButton(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              child: Text('${message} third page 返回上层'),
              onPressed: () {
                Navigator.of(context).pop('message from third pages');
              },
            )
        ),
    );
  }
}
// 第2页，navigator pop时传递“message from third pages”
// 接受参数message
class second extends StatelessWidget {
  second({
    Key key,
    this.message: '',
  });
  String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: OutlineButton(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              child: Text('${message}second page 返回上层'),
              onPressed: () {
                Navigator.of(context).pop('message from second pages');
              },
            )
        )
    );
  }
}

// 主页
class home extends StatelessWidget {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
          child: OutlineButton(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
        child: Text(
          'open drawer',
          style: new TextStyle(color: Theme.of(context).primaryColor),
        ),
        onPressed: () {
          // 打开侧边栏
          _scaffoldKey.currentState.openDrawer();
        },
      )),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            Container(
              height: 30.0,
            ),
            IconButton(
              icon: Icon(Icons.verified_user),
              // iOS式动画至第2页
              onPressed: () {
                Navigator
                    .of(context, rootNavigator: true)
                    .push(CupertinoPageRoute<void>(
                      builder: (BuildContext context) => second(),
                    ));
              },
            ),
            Container(
              height: 10.0,
            ),
            OutlineButton(
              borderSide: BorderSide(color: Colors.black),
              child: Text('命名路由至第3页，andriod式动画',
                  style: new TextStyle(color: Colors.black)),
              // 采用命名路由至第3页。
              onPressed: () {
                Navigator.of(context).pushNamed('/router/third').then((value) {
                  print(value);
                });
              },
            ),
            Container(
              height: 30.0,
            ),
            OutlineButton(
              borderSide: BorderSide(color: Colors.black),
              child: Text('非命名路由至第2页，iOS式动画',
                  style: new TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute<void>(
                      builder: (BuildContext context) =>
                          second(message: 'title from drawer '),
                    ));
              },
            ),
            Container(
              height: 30.0,
            ),
            OutlineButton(
              borderSide: BorderSide(color: Colors.black),
              child: Text('非命名路由至第2页，自适应式动画',
                  style: new TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          second(message: 'title from drawer '),
                    ));
              },
            ),
            Container(
              height: 30.0,
            ),
            OutlineButton(
              borderSide: BorderSide(color: Colors.black),
              child: Text('弹出式路由 showDialog',
                  style: new TextStyle(color: Colors.black)),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Title'),
                      content: Text('Y'),
                      actions: <Widget>[
                        FlatButton(
                          child: const Text('DISAGREE'),
                          onPressed: () {
                            print('sss');
                          },
                        ),
                        FlatButton(
                          child: const Text('AGREE'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
