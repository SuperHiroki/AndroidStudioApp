class Folder {
  final int id;
  final String name;
  final int? parentFolderId; // 親フォルダのID（ルートフォルダの場合はnull）
  int depth = 0;

  Folder({
    required this.id,
    required this.name,
    this.parentFolderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'parentFolderId': parentFolderId,
    };
  }

  // Mapからオブジェクトを生成するメソッド
  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'],
      name: map['name'],
      parentFolderId: map['parentFolderId'],
    );
  }
}
