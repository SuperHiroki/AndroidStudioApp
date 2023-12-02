//photo_item.dart
class PhotoItem {
  final int id;
  final String name;
  final String description;
  final String imagePath;

  PhotoItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
    };
  }

  // Mapからオブジェクトを生成するメソッド
  factory PhotoItem.fromMap(Map<String, dynamic> map) {
    return PhotoItem(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imagePath: map['imagePath'],
    );
  }
}
