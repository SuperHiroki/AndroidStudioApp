class PhotoItem {
  final int id;
  final String name;
  final String description;
  final String imagePath;
  final int? folderId; // このアイテムが属するフォルダのID

  PhotoItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.folderId, // コンストラクタにfolderIdを追加
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'folderId': folderId, // MapにfolderIdを含める
    };
  }

  // Mapからオブジェクトを生成するメソッド
  factory PhotoItem.fromMap(Map<String, dynamic> map) {
    return PhotoItem(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imagePath: map['imagePath'],
      folderId: map['folderId'], // MapからfolderIdを読み込む
    );
  }
}
