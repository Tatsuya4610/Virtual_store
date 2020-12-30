import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/helper/valid.dart';
import 'package:virtual_store_flutter/model/user.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/model/user_manager.dart';
import 'package:virtual_store_flutter/screen/base/base_screen.dart';

class SignUPScreen extends StatelessWidget {
  static const id = 'SignUPScreen';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User _user = User();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final bool loading = Provider.of<UserManager>(context).loading; //Consumerではないバージョン。LoginはConsumer使用。
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('新規登録'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              children: <Widget>[
                TextFormField(
                  enabled: !loading, //falseの場合入力不可。登録ボタンを押した後　firebase登録確認中は入力不可。
                  decoration: InputDecoration(hintText: '名前'),
                  onSaved: (name) => _user.subname = name,
                  validator: (name) {
                    if (name.isEmpty) {
                      return '入力してください';
                    } else if (name.trim().split('　').length <= 1) {
                      return 'フルネームを入力してください';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  enabled: !loading, //falseの場合入力不可。登録ボタンを押した後　firebase登録確認中は入力不可。
                  decoration: InputDecoration(hintText: '名前ふりがな'),
                  onSaved: (name) => _user.name = name,
                  validator: (name) {
                    if (name.isEmpty) {
                      return '入力してください';
                    } else if (name.trim().split('　').length <= 1) {
                      return 'フルネームを入力してください';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  enabled: !loading,
                  decoration: InputDecoration(hintText: 'メールアドレス'),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  onSaved: (email) => _user.email = email,
                  validator: (email) {
                    if (email.isEmpty) {
                      return '入力してください';
                    } else if (!emailValid(email)) {
                      return '正しいメールアドレスを入力して下さい';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  enabled: !loading,
                  decoration: InputDecoration(hintText: 'パスワード'),
                  obscureText: true,
                  onSaved: (pass) => _user.password = pass,
                  validator: (pass) {
                    if (pass.isEmpty) {
                      return '入力してください';
                    } else if (pass.length < 6) {
                      return '6文字以上入力してください';
                    } else
                      return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  enabled: !loading,
                  decoration: InputDecoration(hintText: '確認パスワード'),
                  obscureText: true,
                  onSaved: (pass) => _user.confirmPassword = pass,
                  validator: (pass) {
                    if (pass.isEmpty) {
                      return '入力してください';
                    } else if (pass.length < 6) {
                      return '6文字以上入力してください';
                    } else
                      return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    disabledColor: Theme.of(context)
                        .primaryColor
                        .withAlpha(100), //ボタン無効中の色。
                    textColor: Colors.white,
                    onPressed:loading ? null : () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save(); //validate問題なければ保存。
                        if (_user.password != _user.confirmPassword) {
                          //確認パスワードが違う確認し警告。
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              //エラーメッセージ画面。
                              backgroundColor: Colors.red,
                              content: Text('確認パスワードが同じでありません'),
                            ),
                          );
                          return;
                        }
                        context.read<UserManager>().singUp( //firebaseへサインアップ。
                              user: _user,
                              onFail: (error) { //日本変換されたエラー受け取り、SnackBar表示。
                                _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text(error),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                              onSuccess: () {
                                Navigator.of(context).pushNamed(BaseScreen.id);
                              },
                            );
                      }
                    },
                    child: loading ? CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation(Colors.white),
                    ) : Text(
                      'アカウントを作成する',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
