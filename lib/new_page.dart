import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'photo_item.dart';

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Page'),
      ),
      body: FutureBuilder<List<PhotoItem>>(
        future: DBHelper.getPhotoItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            // エラーハンドリング
            return Center(child: Text('An error occurred!'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(snapshot.data![i].name),
                subtitle: Text(snapshot.data![i].description),
                // 他に必要な情報を表示する
              ),
            );
          }
        },
      ),
    );
  }
}

