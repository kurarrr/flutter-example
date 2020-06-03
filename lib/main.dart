import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class ChatStream {

  final searchQueryController = StreamController<String>();
  Stream<String> get query => searchQueryController.stream;
  StreamSink<String> get changeQuery => searchQueryController.sink;

  final searchResultController = StreamController<String>();
  Stream<String> get result => searchResultController.stream;
  StreamSink<String> get changeResult => searchResultController.sink;

  ChatStream() {
    query.listen((v) async {
      // APIの場合は await 使う
      final String result = "hello " + v;
      changeResult.add(result);
    });
  }

  void dispose() {
    searchResultController.close();
    searchQueryController.close();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home:
      Scaffold(
        body: Center(
          child: Provider<ChatStream>(
            create: (_) => ChatStream(),
            dispose: (_, stream) => stream.dispose(),
            child: MyWidget(),
          )
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController queryInputController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final chatStream = Provider.of<ChatStream>(context);

    return Column(children: <Widget>[
      Form(
        key: _formKey,
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'write text',
                ),
                controller: queryInputController,
              ))),
          RaisedButton(
            child: const Text('入力'),
            onPressed: () =>
              chatStream.changeQuery.add(queryInputController.text)),
        ])),
      StreamBuilder(
        stream: chatStream.result,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // エラー処理 if needed
          }
          if (snapshot.data != null) {
            // snapshot.data を使ったWidgetを返す
            return Text(snapshot.data);
          } else {
            // null 処理
          }
        }
      )
    ]);
  }
}
