//main.dart
import 'package:flutter/material.dart';
import 'db_helper.dart'; // DBHelper クラスが定義されているファイルをインポート
import 'add_photo_item_form.dart'; // 新しいインポート
import 'new_page.dart'; // 新しいインポート
import 'folder_page.dart'; // FolderPageをインポート

void main() {
  DBHelper.getFolders();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Photo Item App'),
          leading: Builder( // Builderを使用して適切なコンテキストを提供
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.folder),
                onPressed: () {
                  // FolderPageに移動
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FolderPage()),
                  );
                },
              );
            },
          ),
        ),
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
