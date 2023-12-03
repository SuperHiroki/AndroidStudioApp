class Folder {
  final int id;
  final String name;
  final int? parentFolderId; // 親フォルダのID（ルートフォルダの場合はnull）
  int depth = 0; // フォルダの深さを表すプロパティ

  Folder({
    required this.id,
    required this.name,
    this.parentFolderId, // 親フォルダのIDをオプショナルで追加
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'parentFolderId': parentFolderId, // MapにparentFolderIdを含める
    };
  }

  // Mapからオブジェクトを生成するメソッド
  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'],
      name: map['name'],
      parentFolderId: map['parentFolderId'], // MapからparentFolderIdを読み込む
    );
  }
}
