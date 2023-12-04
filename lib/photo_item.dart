class PhotoItem {
  final int id;
  final String name;
  final String description;
  final String imagePath;
  final int? folderId; // このアイテムが属するフォルダのID
  final int? createdAt;
  final int? updatedAt;

  PhotoItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.folderId, // コンストラクタにfolderIdを追加
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'folderId': folderId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
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
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  PhotoItem copyWith({
    int? id,
    String? name,
    String? description,
    String? imagePath,
    int? folderId,
    int? createdAt,
    int? updatedAt,
  }) {
    return PhotoItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      folderId: folderId ?? this.folderId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
