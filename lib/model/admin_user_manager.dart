import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/user.dart';
import 'package:virtual_store_flutter/model/user_manager.dart';
// import 'package:faker/faker.dart';

class AdminUserManager extends ChangeNotifier {
  List<User> _users = [];

  final Firestore firestore = Firestore.instance;

  String _search = '';
  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  void updateUser(UserManager userManager) {
    if (userManager.adminEnabled) {
      _listenToUser();
    }
  }

  _listenToUser() {
    // final faker = Faker(); //Dartパッケージ。　偽データを生成。
    // for (int i = 0; i < 20; i++) {
    //   users.add(User(
    //     name: faker.person.name(),
    //     email: faker.internet.email(),
    //   ));
    // }

    firestore.collection('users').getDocuments().then((snapshot) { //userドキュメントをリスト化
      _users = snapshot.documents.map((doc) => User.formDocument(doc)).toList();
      _users.sort(
          //アルファベット順に表示。これをしないと
          // Dartパッケージのalphabet_list_scroll_view.dartでエラー発生。
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  List<String> get names => _users.map((e) => e.name).toList();
  List<User> get users => _users;

}
