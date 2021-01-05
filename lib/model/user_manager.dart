import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_store_flutter/helper/firebase_errors.dart';
import 'package:virtual_store_flutter/model/user.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool _loading = false;
  bool get loading => _loading;
  bool get islLogin => user != null; //userの情報があるならログイン状態。

  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final result = await _auth.signInWithEmailAndPassword(
        //firebaseにサインイン
        email: user.email,
        password: user.password,
      );

      await _loadCurrentUser(firebaseUser: result.user);

      onSuccess(); //成功した場合。
    } on PlatformException catch (error) {
      onFail(
        //失敗した場合はgetErrorStringにerror.codeを渡して日本語変換し出力。
        getErrorString(error.code),
      );
    }
    loading = false;
  }

  Future<void> singUp({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        //firebaseに登録。
        email: user.email,
        password: user.password,
      );
      user.id = result.user.uid; //user.uid渡し。
      this.user = user; //受け取ったuserをuserへ上書き。
      await user.saveData(); //ユーザーのデーターをfirebaseに追加。
      onSuccess();
    } on PlatformException catch (error) {
      onFail(
        getErrorString(error.code), //エラー日本語化
      );
    }
    loading = false;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void signOut() {
    _auth.signOut();
    user = null;
    notifyListeners();
  }


  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    final FirebaseUser currentUser =
        await _auth.currentUser() ?? firebaseUser; //ログイン中のアカウント。この2つどちらか。
    if (currentUser != null) {
      final DocumentSnapshot docUser = await Firestore.instance
          .collection('users')
          .document(currentUser.uid)
          .get();//ログイン中のアカウントのデータを取得。
      user = User.formDocument(docUser);//取得したデーターをformDocumentに登録。

      final docAdmin = await Firestore.instance.collection('admin').document(user.id).get();
      if (docAdmin.exists) { //ログインしたuserがAdmin(管理者)として登録されていたら。
        user.admin = true;
      }
      notifyListeners();
    }
  }

  bool get adminEnabled => user != null && user.admin; //管理者が有効かどうか。

}
