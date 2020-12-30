
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/screen/address/components/address_input_field.dart';
import 'package:virtual_store_flutter/screen/address/components/street_address_input_field.dart';
import 'package:virtual_store_flutter/service/postal.dart';
import 'package:virtual_store_flutter/model/address.dart';

import 'address_selection.dart';

class AddressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 4),
        child :  Consumer<Postal>(builder: (_,postal,__) {
          final address = postal.address ?? Address(); //nullだったら空情報。
          return Form(
            child: Column(
              children: <Widget>[
                Text(
                  '配達先住所',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                AddressInputField(address),
                if (address.postal != null && !postal.townSelectValue && !postal.town1SelectValue)
                  //addressの情報がない場合は非表示。townSelectValue押されたら非表示。
                  AddressSelection(address),
                if (postal.townSelectValue || postal.town1SelectValue)
                  if (address.postal != null)
                    StreetAddressInputField(address),
              ],
            ),
          );
        },)
      ),
    );
  }
}
