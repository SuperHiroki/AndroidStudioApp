import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'folder.dart';
import 'memo_page.dart';

class FolderPage extends StatefulWidget {
  @override
  _FolderPageState createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  List<dynamic> items = [];
  int? currentFolderId; // 現在選択されているフォルダのID
  Map<int, bool> folderExpanded = {}; // フォルダの展開状態を追跡するマップ

  @override
  void initState() {
    super.initState();
    _listItems();
  }

  void toggleFolder(int folderId) {
    currentFolderId = folderId;
    setState(() {
      folderExpanded[folderId] = !(folderExpanded[folderId] ?? false);
    });
  }

  Future<List<dynamic>> _getFolderContents(int? folderId) async {
    var fetchedFolders = await DBHelper.getFolders();
    var fetchedPhotoItems = await DBHelper.getPhotoItems();

    List<dynamic> folderContents = [];
    folderContents.addAll(fetchedFolders.where((folder) => folder.parentFolderId == folderId));
    folderContents.addAll(fetchedPhotoItems.where((item) => item.folderId == folderId));

    return folderContents;
  }

  Future<void> _listItems({int? parentId}) async {
    List<dynamic> tempItems = await _getFolderContents(parentId);
    setState(() {
      items = tempItems; // itemsリストを更新
    });
  }

  Future<void> _addNewFolder() async {
    TextEditingController nameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('新しいフォルダを作成'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'フォルダ名'),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('キャンセル'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('作成'),
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                Folder newFolder = Folder(
                  id: DateTime.now().millisecondsSinceEpoch, // 一意のIDを生成
                  name: nameController.text,
                  parentFolderId: currentFolderId,
                );
                await DBHelper.insertFolder(newFolder);
                Navigator.of(ctx).pop();
                if (currentFolderId != null) {
                  toggleFolder(currentFolderId!);
                }
                _listItems(); // フォルダリストを更新
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addNewPhotoItem(int? id, int? folderId) async {
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
        _listItems();  // リストを更新
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
        title: Text('Folders'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.create_new_folder), // フォルダ追加アイコン
            onPressed: () {
              _addNewFolder(); // フォルダ追加機能を呼び出す
            },
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate), // ファイル追加アイコン
            onPressed: () {
              _addNewPhotoItem(null, currentFolderId);  // ファイル追加機能を呼び出す
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => buildFolderItem(items[index],0),
      ),
    );
  }

  Widget buildFolderItem(dynamic item, int depth) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: depth * 20.0), // 階層に応じて左側のパディングを増加
          child: Container(
            decoration: BoxDecoration(
              color: item is Folder && item.id == currentFolderId ? Colors.blue[100] : null, // 背景色
              border: Border.all(
                color: Colors.grey, // 枠線の色
                width: 1.0, // 枠線の太さ
              ),
              borderRadius: BorderRadius.circular(4.0), // 枠線の角を丸くする
            ),
            child: ListTile(
              title: Text(item.name),
              onTap: () {
                if (item is Folder) {
                  toggleFolder(item.id); // フォルダの展開/非展開を切り替え
                } else {
                  _addNewPhotoItem(item.id, item.folderId);
                }
              },
            ),
          ),
        ),
        if (item is Folder && folderExpanded[item.id] == true)
          FutureBuilder<List<dynamic>>(
            future: _getFolderContents(item.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data!.map((subItem) => buildFolderItem(subItem, depth + 1)).toList(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
      ],
    );
  }
}

