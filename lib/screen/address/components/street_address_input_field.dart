import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/address.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/service/postal.dart';

class StreetAddressInputField extends StatelessWidget {

  StreetAddressInputField(this.address);
  final Address address;

  @override
  Widget build(BuildContext context) {

    final selectTown = context.watch<Postal>();

    final cityTown = '${address.prefecture}${address.city}${address.town}';
    final cityTown1 = '${address.prefecture}${address.city}${address.town1}';

    return Column(
      children: <Widget>[
        TextFormField(
          initialValue: (selectTown.townSelectValue) ? cityTown : cityTown1, //選択された住所別に表示。
          decoration: InputDecoration(
            labelText: '都道府県市町村',
            hintText: '東京都千代田区'
          ),
          validator: (text) {
            if (text.isEmpty){
              return '入力してください';
            } else {
              return null;
            }
          },
          onSaved: (text) => address.ollStreetAddress = text,
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'アパート・マンション名など',
          ),
          validator: (text) {
            if (text.isEmpty){
              return '入力してください';
            } else {
              return null;
            }
          },
          onSaved: (text) => address.subStreetAddress = text,
        ),
      ],
    );
  }
}
