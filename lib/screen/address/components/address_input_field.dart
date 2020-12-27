
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddressInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            isDense: true,
            labelText: '郵便番号',
            hintText: '1234567',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly //数字のみ使用可
          ],
        ),
        RaisedButton(
          onPressed: () {
          },
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          disabledColor: Theme.of(context).primaryColor.withAlpha(100),
          child: Text('郵便番号で検索'),
        )
      ],
    );
  }
}
