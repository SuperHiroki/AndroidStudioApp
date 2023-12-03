import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'folder.dart';

class FolderPage extends StatefulWidget {
  @override
  _FolderPageState createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  List<dynamic> items = [];
  int? currentFolderId; // 現在選択されているフォルダのID

  @override
  void initState() {
    super.initState();
    _listItems();
  }

  Future<void> _listItems({int? parentId}) async {
    var fetchedFolders = await DBHelper.getFolders();
    var fetchedPhotoItems = await DBHelper.getPhotoItems();
    
    print('CCCCCCCCCCC' + parentId.toString());

    // 一時的にすべてのアイテムを保持するためのリストを作成
    List<dynamic> tempItems = [];

    // 特定のparentIdに基づいてフォルダとフォトアイテムをフィルタリング
    if (parentId == null) {
      tempItems.addAll(fetchedFolders.where((folder) => folder.parentFolderId == null));
      tempItems.addAll(fetchedPhotoItems.where((item) => item.folderId == null));
    } else {
      tempItems.addAll(fetchedFolders.where((folder) => folder.parentFolderId == parentId));
      tempItems.addAll(fetchedPhotoItems.where((item) => item.folderId == parentId));
    }

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
              print('YYYY キャンセル');
            },
          ),
          TextButton(
            child: Text('作成'),
            onPressed: () async {
              print('GGGGGGG currentFolderId ' + (currentFolderId?.toString() ?? 'null'));
              if (nameController.text.isNotEmpty) {
                print('GGGGGGG currentFolderId ' + (currentFolderId?.toString() ?? 'null'));
                Folder newFolder = Folder(
                  id: DateTime.now().millisecondsSinceEpoch, // 一意のIDを生成
                  name: nameController.text,
                  parentFolderId: currentFolderId, // ここではルートフォルダとして扱う
                );
                await DBHelper.insertFolder(newFolder);
                Navigator.of(ctx).pop();
                _listItems(); // フォルダリストを更新
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addNewPhotoItem() async {
    // 新規メモ追加のロジックをここに追加
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
              _addNewPhotoItem(); // ファイル追加機能を呼び出す
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item is Folder ? item.name : item.name),
            onTap: () {
              print('PPPPP ' + item.id.toString());
              currentFolderId = item.id;
              if (item is Folder) {
                _listItems(parentId: item.id); // 選択されたフォルダ内のアイテムを表示
                print('PPPPP ' + item.id.toString());
              }
              // フォトアイテムがタップされた場合の動作をここに追加
            },
          );
        },
      ),
    );
  }
}

