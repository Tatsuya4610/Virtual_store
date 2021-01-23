import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_store_flutter/helper/valid.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/model/user_manager.dart';
import 'package:virtual_store_flutter/model/user.dart';
import 'package:virtual_store_flutter/screen/signup/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  static const id = 'LoginScreen';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('ログイン画面'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed(SignUPScreen.id);
            },
            child: Text('アカウント作成',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, child) {
                return ListView(
                  shrinkWrap: true, //最小限に画面を占領する。
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    Text('管理者メールアドレス、test@test.com パスワード 1234567。管理者のみ編集機能やユーザー管理機能有り。お試し下さい。'),
                    SizedBox(height: 4,),
                    TextFormField(
                      enabled: !userManager
                          .loading, //falseの場合入力不可。ログインボタンを押した後　firebaseログイン確認中は入力不可。
                      controller: _emailController,
                      decoration: InputDecoration(hintText: 'メールアドレス'),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false, //キーボード上に予測変換を出さない。
                      validator: (email) {
                        if (!emailValid(email)) {
                          return '正しいメールアドレスを入力してください';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      enabled: !userManager.loading, //falseの場合入力不可。
                      controller: _passwordController,
                      decoration: InputDecoration(hintText: 'パスワード'),
                      autocorrect: false, //キーボード上に予測変換を出さない。
                      obscureText: true, //セキュリティー、非表示。
                      validator: (pass) {
                        if (pass.isEmpty) {
                          return '入力してください';
                        } else if (pass.length < 6) {
                          return '6文字以上入力してください';
                        }
                        return null;
                      },
                    ),
                    child,
                    RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,//マージンなし。
                      onPressed: userManager.loading
                          ? null
                          : () {
                              //ログイン確認中は使用不可。
                              _formKey.currentState.validate(); //validateを確認。
                              if (_passwordController.text.isEmpty) { //これがないとなぜかパスワードが間違えてますとSnackBarが出る。
                                return;
                              }
                              userManager.signIn(
                                //firebaseにサインイン。
                                user: Users(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                ),
                                onFail: (error) {
                                  //日本語変換したエラーを受け取り。
                                  _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      //エラーメッセージ画面。
                                      backgroundColor: Colors.red,
                                      content: Text(error),
                                    ),
                                  );
                                },
                                onSuccess: () {
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                      child: userManager.loading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.white),
                            )
                          : Text('ログイン'),
                      color: Theme.of(context).primaryColor,
                      disabledColor: Theme.of(context)
                          .primaryColor
                          .withAlpha(100), //ボタン無効中の色。
                      textColor: Colors.white,
                    ),
                  ],
                );
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    print(_emailController.text);
                  },
                  child: Text('パスワードを忘れた'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
