// add_photo_item_form.dart
import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../photo_item.dart';

class AddPhotoItemForm extends StatefulWidget {
  @override
  _AddPhotoItemFormState createState() => _AddPhotoItemFormState();
}

class _AddPhotoItemFormState extends State<AddPhotoItemForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  String imagePath = '';
  int folderId = 1; // 仮のfolderIdの値

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newItem = PhotoItem(
        id: DateTime.now().millisecondsSinceEpoch, // 一意のIDを生成
        name: name,
        description: description,
        imagePath: imagePath,
        folderId: folderId, // folderIdを指定
      );
      DBHelper.insertPhotoItem(newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Name DDD'),
            onSaved: (value) {
              name = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Description DDD'),
            onSaved: (value) {
              description = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Image Path DDD'),
            onSaved: (value) {
              imagePath = value!;
            },
          ),
          ElevatedButton(
            onPressed: _submitData,
            child: Text('Add Item FFF'),
          ),
        ],
      ),
    );
  }
}

