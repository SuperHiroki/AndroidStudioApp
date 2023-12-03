import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'photo_item.dart';
import 'folder_page.dart';

class RecentMemosPage extends StatefulWidget {
  @override
  _RecentMemosPageState createState() => _RecentMemosPageState();
}

class _RecentMemosPageState extends State<RecentMemosPage> {
  List<PhotoItem> photoItems = [];

  @override
  void initState() {
    super.initState();
    _loadPhotoItems();
  }

  Future<void> _loadPhotoItems() async {
    List<PhotoItem> items = await DBHelper.getPhotoItems();
    items.sort((a, b) {
      int aTimestamp = a.updatedAt ?? a.createdAt ?? 0;
      int bTimestamp = b.updatedAt ?? b.createdAt ?? 0;
      return bTimestamp.compareTo(aTimestamp);
    });
    setState(() {
      photoItems = items.take(30).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('最近使ったメモ'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // アイコンを戻る矢印に変更
          onPressed: () {
            Navigator.of(context).pop(); // 前のページに戻る
          },
        ),
      ),
      body: ListView.builder(
        itemCount: photoItems.length,
        itemBuilder: (context, index) {
          PhotoItem item = photoItems[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.description),
            trailing: Text(
              '最終更新日: ${DateTime.fromMillisecondsSinceEpoch(item.updatedAt ?? item.createdAt ?? 0).toLocal()}',
            ),
            onTap: () {
              // メモを開く処理を追加
            },
          );
        },
      ),
    );
  }
}
