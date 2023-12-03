//db_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'photo_item.dart'; // PhotoItem クラスをインポート
import 'folder.dart'; // Folder クラスをインポート

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'photo_items.db'),
      onCreate: (db, version) {
        // Folderテーブルを追加
        db.execute(
          'CREATE TABLE folders(id INTEGER PRIMARY KEY, name TEXT, parentFolderId INTEGER)',
        );
        return db.execute(
          'CREATE TABLE photo_items(id INTEGER PRIMARY KEY, name TEXT, description TEXT, imagePath TEXT, folderId INTEGER)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertPhotoItem(PhotoItem item) async {
    final db = await DBHelper.database();
    await db.insert(
      'photo_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('FFFFFFFFFFFFFFFFFFFF Item added: ${item.toMap()}'); // ログ出力
  }

  // アイテムの取得
  static Future<List<PhotoItem>> getPhotoItems() async {
    final db = await DBHelper.database();
    final List<Map<String, dynamic>> items = await db.query('photo_items');
    return List.generate(items.length, (i) => PhotoItem.fromMap(items[i]));
  }

  // アイテムの更新
  static Future<void> updatePhotoItem(PhotoItem item) async {
    final db = await DBHelper.database();
    await db.update(
      'photo_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  // アイテムの削除
  static Future<void> deletePhotoItem(int id) async {
    final db = await DBHelper.database();
    await db.delete(
      'photo_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }



  // フォルダの取得
  static Future<List<Folder>> getFolders() async {
    final db = await DBHelper.database();
    final List<Map<String, dynamic>> foldersMap = await db.query('folders');
    return List.generate(foldersMap.length, (i) => Folder.fromMap(foldersMap[i]));
  }


  static Future<void> insertFolder(Folder folder) async {
    print('SSSSSSSSSS insertFolder');
    final db = await DBHelper.database();
    await db.insert(
      'folders',
      folder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
