import 'package:flutter/material.dart';
import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/common/custom_drawer/custom_drawer.dart';
import 'package:virtual_store_flutter/model/admin_user_manager.dart';

class AdminUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ユーザー'),
          centerTitle: true,
        ),
        drawer: CustomDrawer(),
        body: Consumer<AdminUserManager>(
          builder: (_, adminUserManager, __) {
            return AlphabetListScrollView( //Dartパッケージ。
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(
                    adminUserManager.users[index].name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    adminUserManager.users[index].email,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
              highlightTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              indexedHeight: (index) => 60, //SizedBox(height)のイメージ。リストの高さ。
              strList: adminUserManager.names, //名前のリスト。
              showPreview: true, //右の検索アルファベット使用時に画面に文字表示。
            );
          },
        ));
  }
}
