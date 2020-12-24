import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/home_manager.dart';
import 'package:virtual_store_flutter/model/section.dart';

class AddSectionWidget extends StatelessWidget {
  AddSectionWidget(this.homeManager);
  final HomeManager homeManager;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton(
            onPressed: () {
              homeManager.addSection(Section(type: 'List'));
            },
            textColor: Colors.white,
            child: Text('今日の商品を追加'),
          ),
        ),
        Expanded(
          child: FlatButton(
            onPressed: () {
              homeManager.addSection(Section(type: 'promotion'));
            },
            textColor: Colors.white,
            child: Text('プロモーションを追加'),
          ),
        ),
      ],
    );
  }
}
