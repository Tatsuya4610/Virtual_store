import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/user.dart';
import 'package:virtual_store_flutter/model/user_manager.dart';

class AdminUserManager extends ChangeNotifier {
  List<User> users = []; //偽ユーザーリスト。

  void updateUser(UserManager userManager) {
    if (userManager.adminEnabled) {
      _listenToUser();
    }
  }

  _listenToUser() {
    //
    final faker = Faker(); //Dartパッケージ。　偽データを生成。
    for (int i = 0; i < 50; i++) {
      users.add(User(
        name: faker.person.name(),
        email: faker.internet.email(),
      ));
    }
    users.sort( //アルファベット順に表示。これをしないと
      // Dartパッケージのalphabet_list_scroll_view.dartでエラー発生。
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    notifyListeners();
  }

  List<String> get names => users.map((e) => e.name).toList();
}
