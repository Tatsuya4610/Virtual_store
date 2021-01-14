import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/helper/firebase_errors.dart';
import 'package:virtual_store_flutter/model/user.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Users users;
  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get islLogin => users != null; //userの情報があるならログイン状態。

  Future<void> signIn({Users user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final result = await _auth.signInWithEmailAndPassword(
        // firebaseにサインイン
        email: user.email,
        password: user.password,
      );

      await _loadCurrentUser(firebaseUser: result.user);
      onSuccess(); //成功した場合。
    } on FirebaseAuthException catch (error) {
      onFail(getErrorString(error.code));
    }
    loading = false;
  }

  Future<void> singUp({Users user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        //firebaseに登録。
        email: user.email,
        password: user.password,
      );
      user.id = result.user.uid; //user.uid渡し。
      this.users = user; //受け取ったuserをuserへ上書き。
      await user.saveData(); //ユーザーのデーターをfirebaseに追加。
      user.saveToken();
      onSuccess();
    } on FirebaseAuthException catch (error) {
      onFail(
        getErrorString(error.code), //エラー日本語化
      );
    }
    loading = false;
  }

  void signOut() {
    _auth.signOut();
    users = null;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({User firebaseUser}) async {
    final User currentUser = _auth.currentUser ?? firebaseUser; //ログイン中のアカウント。この2つどちらか。
    if (currentUser != null) {
      final DocumentSnapshot docUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get(); //ログイン中のアカウントのデータを取得。
      users = Users.formDocument(docUser); //取得したデーターをformDocumentに登録。
      users.saveToken();

      final docAdmin = await FirebaseFirestore.instance
          .collection('admin')
          .doc(users.id)
          .get();
      if (docAdmin.exists) {
        //ログインしたuserがAdmin(管理者)として登録されていたら。
        users.admin = true;
      }
      notifyListeners();
    }
  }

  bool get adminEnabled => users != null && users.admin; //管理者が有効かどうか。

}
