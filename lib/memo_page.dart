//mamo_page.dart
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'photo_item.dart';
import 'dart:async';

class MemoPage extends StatefulWidget {
  final int? folderId;
  final int? memoId; // メモのID

  MemoPage({this.folderId, this.memoId});

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _textController = TextEditingController();
  Timer? _debounce;
  int? _memoId; // メモのIDを保持するための変数

  @override
  void initState() {
    super.initState();
    _memoId = widget.memoId;
    _titleController.addListener(_onTextChanged);
    _textController.addListener(_onTextChanged);
    if (_memoId != null) {
      _loadMemoData();
    }
  }

  void _loadMemoData() async {
    PhotoItem? memo = await DBHelper.getPhotoItemById(_memoId!);
    if (memo != null) {
      setState(() {
        _titleController.text = memo.name;
        _textController.text = memo.description;
      });
    }
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _saveMemo);
  }


  void _saveMemo() {
    String title = _titleController.text;
    String description = _textController.text;

    if (_memoId == null) {
      PhotoItem newItem = PhotoItem(
        id: DateTime.now().millisecondsSinceEpoch,
        name: title,
        description: description,
        imagePath: "default",
        folderId: widget.folderId ?? 0,
      );
      DBHelper.insertPhotoItem(newItem).then((int newId) {
        setState(() {
          _memoId = newId; // 新しいIDをwidget.memoIdにセット
        });
        print('New memo saved with id: $newId');
      });
    } else {
      PhotoItem updatedItem = PhotoItem(
        id: _memoId!,
        name: title,
        description: description,
        imagePath: "default",
        folderId: widget.folderId ?? 0,
      );
      DBHelper.updatePhotoItem(updatedItem);
      print('Memo updated: ${_memoId}');
    }
    print('MMMMMMMMMMM Memo saved: ${_titleController.text}');
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII');
        _saveMemo();
        Navigator.pop(context, true); // デバイスのバックボタンに true を渡す
        return false; // 既定の戻る動作をキャンセル
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              print('QQQQQQQQQQQQQQQQQQQQQQQQQQQQ');
              _saveMemo();
              Navigator.pop(context, true); // 戻るボタンに true を渡す
            },
          ),
          title: Text('メモ'),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(hintText: 'タイトル'),
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(hintText: 'メモを入力してください'),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    _titleController.removeListener(_saveMemo);
    _textController.removeListener(_saveMemo);
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

}
