import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchDialog extends StatelessWidget {
  final String initialText;
  SearchDialog({this.initialText});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 2,
          left: 2,
          right: 2,
          child: Card(
            child: TextFormField(
              initialValue: initialText, //前回の検索テキストを残す。
              textInputAction: TextInputAction.search, //キーボードの完了ボタンをsearch。
              autofocus: true, //自動でキーボード表示。
              decoration: InputDecoration(
                border: InputBorder.none, //テキスト入力下にボーダーを入れるかどうか。
                contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                prefixIcon: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              onFieldSubmitted: (text) { //onPressedで渡すより効率的。
                Navigator.of(context).pop(text); //popした際に入力されたtextを渡す。
              },
            ),
          ),
        ),
      ],
    );
  }
}
