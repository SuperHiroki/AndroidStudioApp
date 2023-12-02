//main.dart
import 'package:flutter/material.dart';
import 'db_helper.dart'; // DBHelper クラスが定義されているファイルをインポート
import 'add_photo_item_form.dart'; // 新しいインポート
import 'new_page.dart'; // 新しいインポート

void main() {
  print("Hello world OOOOOOOOOOOO");
  runApp(MyApp());
  print("Hello world KKKKKKKK");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Photo Item App xxxxx')),
        body: AddPhotoItemForm(),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewPage()),
              );
            },
            child: Icon(Icons.navigation),
          ),
        ),
      ),
    );
  }
}