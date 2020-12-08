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
  FirebaseUser _user;
  bool _loading = false;
  bool get loading => _loading;

  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      _user = result.user;

      onSuccess(); //成功した場合。
    } on PlatformException catch (error) {
      onFail(getErrorString(error.code)); //失敗した場合はgetErrorStringにerror.codeを渡して日本語変換し出力。
    }
    loading = false;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    final FirebaseUser currentUser = await _auth.currentUser(); //ログイン中のアカウント。
    if (currentUser != null) {
      _user = currentUser;
      print(_user.uid);
    }
    notifyListeners();
  }

}
