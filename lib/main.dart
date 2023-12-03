// main.dart
import 'package:flutter/material.dart';
import 'recent_memos_page.dart'; // 新しいインポート
import 'folder_page.dart'; // FolderPage クラスをインポート

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(), // 新しいホームページを設定
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メモ帳アプリ'),
        centerTitle: true, // タイトルを中央に配置
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0), // ボタンの周りにパディングを追加
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecentMemosPage()),
                  );
                },
                child: Text(
                  '最近使ったメモ',
                  style: TextStyle(
                    fontSize: 25, // テキストサイズを20に設定
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(350, 90), // ボタンのサイズを設定
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FolderPage()),
                  );
                },
                child: Text(
                  'フォルダで管理',
                  style: TextStyle(
                    fontSize: 25, // テキストサイズを20に設定
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(350, 90), // ボタンのサイズを設定
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
