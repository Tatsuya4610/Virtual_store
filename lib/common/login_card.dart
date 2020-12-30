import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/screen/login/login_screen.dart';

class LoginCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.account_circle,
                color: Theme.of(context).primaryColor,
                size: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'アカウントへログイン',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              RaisedButton(
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed(LoginScreen.id);
                },
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text(
                    'ログイン'
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}