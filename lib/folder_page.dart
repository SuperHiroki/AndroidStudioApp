import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'folder.dart';
import 'photo_item.dart';
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
      if (result == true) {
        _listItems();  // リストを更新
      }
    } catch (e) {
      print('NNNNNNNNNNNNNNNNNN Error occurred: $e');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('フォルダで管理'),
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
        itemBuilder: (context, index) => buildFolderItem(items[index], 0),
      ),
    );
  }



  Widget buildFolderItem(dynamic item, int depth) {
    // アイテムの背景色を設定
    Color backgroundColor = item is Folder
        ? (item.id == currentFolderId ? Colors.blue[100]! : Colors.lightBlue[50]!)
        : Colors.grey[200]!;

    return Column(
      children: [
        GestureDetector(
          onLongPress: () => showActionMenu(item), // 長押しでアクションメニューを表示
          child: Padding(
            padding: EdgeInsets.only(left: depth * 20.0), // 階層に応じたパディング
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor, // 背景色
                border: Border.all(
                  color: Colors.grey, // 枠線の色
                  width: 1.0, // 枠線の太さ
                ),
                borderRadius: BorderRadius.circular(4.0), // 角の丸み
              ),
              child: ListTile(
                title: Text(item.name),
                onTap: () {
                  if (item is Folder) {
                    toggleFolder(item.id); // フォルダの展開/非展開を切り替え
                  } else {
                    _addNewPhotoItem(item.id, item.folderId); // メモページへの遷移
                  }
                },
              ),
            ),
          ),
        ),
        // サブアイテムの展開
        if (item is Folder && folderExpanded[item.id] == true)
          FutureBuilder<List<dynamic>>(
            future: _getFolderContents(item.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data!.map((subItem) =>
                      buildFolderItem(subItem, depth + 1)).toList(),
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










  void showActionMenu(dynamic item) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('削除'),
            onTap: () => _deleteItem(item),  // 削除処理を実行
          ),
          ListTile(
            leading: Icon(Icons.move_to_inbox),
            title: Text('移動'),
            onTap: () => _showMoveItemDialog(item),  // 移動処理を実行
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(dynamic item) async {
    Navigator.pop(context); // モーダルを閉じる
    if (item is Folder) {
      await _deleteFolderRecursive(item.id); // 再帰的にフォルダ削除
    } else if (item is PhotoItem) {
      await DBHelper.deletePhotoItem(item.id); // フォトアイテム削除
    }
    _listItems(); // リストを更新
  }

  Future<void> _deleteFolderRecursive(int folderId) async {
    // サブフォルダを取得して削除
    List<Folder> subFolders = await DBHelper.getFolders()
        .then((folders) => folders.where((f) => f.parentFolderId == folderId).toList());
    for (var folder in subFolders) {
      await _deleteFolderRecursive(folder.id); // 再帰的にサブフォルダを削除
    }

    // このフォルダ内のフォトアイテムを削除
    List<PhotoItem> photoItems = await DBHelper.getPhotoItems()
        .then((items) => items.where((item) => item.folderId == folderId).toList());
    for (var item in photoItems) {
      await DBHelper.deletePhotoItem(item.id); // フォトアイテムを削除
    }

    // フォルダ自体を削除
    await DBHelper.deleteFolder(folderId);
  }


  void _showMoveItemDialog(dynamic item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('移動先のフォルダを選択'),
          content: Text('ここに移動先のフォルダ選択UIを実装'),
          actions: <Widget>[
            TextButton(
              child: Text('キャンセル'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }





  Future<void> _moveItem(dynamic item, int newFolderId) async {
    Navigator.pop(context);  // ダイアログを閉じる
    if (item is Folder) {
      // フォルダ移動ロジックを実装
    } else if (item is PhotoItem) {
      var newItem = item.copyWith(folderId: newFolderId); // 新しいインスタンスを作成
      await DBHelper.updatePhotoItem(newItem);  // 更新
    }
    _listItems();
  }






}

