import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/helper/valid.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/model/user_manager.dart';
import 'package:virtual_store_flutter/model/user.dart';

class LoginScreen extends StatelessWidget {
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
                    TextFormField(
                      enabled: !userManager.loading, //falseの場合入力不可。ログインボタンを押した後　firebaseログイン確認中は入力不可。
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
                        if (pass.isEmpty || pass.length < 6) {
                          return '6文字以上入力してください';
                        }
                        return null;
                      },
                    ),
                    child,
                    SizedBox(
                      height: 44,
                      child: RaisedButton(
                        onPressed: userManager.loading ? null : () { //ログイン確認中は使用不可。
                          _formKey.currentState.validate(); //validateを確認。
                          userManager.signIn(
                                //firebaseにサインイン。
                                user: User(
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
                                  //ログイン成功した場合に返ってくる。
                                  print('成功');
                                },
                              );
                        },
                        child: userManager.loading ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),) : Text('ログイン'),
                        color: Theme.of(context).primaryColor,
                        disabledColor: Theme.of(context).primaryColor.withAlpha(100), //ボタン無効中の色。
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                );
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
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
