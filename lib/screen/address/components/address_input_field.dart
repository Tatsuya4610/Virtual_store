
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_store_flutter/model/address.dart';
import 'package:virtual_store_flutter/model/cart_manager.dart';
import 'package:virtual_store_flutter/service/postal.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

class AddressInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postalData = context.watch<Postal>();
    String postalCode;
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
          validator: (text) {
            if (text.isEmpty) {
              return '入力して下さい';
            } else if (text.length > 7 ) {
               return '無効な郵便番号';
            } else if (text.length < 5) {
              return '無効な郵便番号';
            } else{
              return null;
            }
          },
          onChanged: (text) => postalCode = text,
        ),
        if (!postalData.townSelectValue || !postalData.town1SelectValue)
            RaisedButton(
              onPressed: () {
                if (Form.of(context).validate()) { //もし入力問題ないなら
                  context.read<Postal>().getAddress(postalCode);
                }

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
