import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'photo_item.dart';
import 'folder_page.dart';
import 'memo_page.dart';

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

  Future<void> _showPhotoItem(int? id, int? folderId) async {
    try {
      print('OOOOOOOOOOOOOOOOOOO Before Navigator.push');
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) {
              // 条件に基づいて適切な画面を返す
              if (id != null) {
                return MemoPage(memoId: id, folderId: folderId);
              } else {
                return MemoPage(folderId: folderId);
              }
            }
        ),
      );
      print('SSSSS   Result: $result');
      if (result == true) {
        print('RRRRRRRRRRRRRRR  Updating list');
        _loadPhotoItems();  // リストを更新
      } else {
        print('BBBBBBBBBBBBB  No update needed');
      }
    } catch (e) {
      print('NNNNNNNNNNNNNNNNNN Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('最近使ったメモ'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: photoItems.length,
        itemBuilder: (context, index) {
          PhotoItem item = photoItems[index];
          return Container(
            margin: EdgeInsets.all(8.0), // コンテナの外側の余白
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey), // 枠線の色と太さ
              borderRadius: BorderRadius.circular(5.0), // 角の丸み
            ),
            child: ListTile(
              title: Text(item.name),
              subtitle: Text(item.description),
              trailing: Text(
                '最終更新日: ${DateTime.fromMillisecondsSinceEpoch(item.updatedAt ?? item.createdAt ?? 0).toLocal()}',
              ),
              onTap: () {
                _showPhotoItem(item.id, item.folderId);
              },
            ),
          );
        },
      ),
    );
  }

}
