import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/screen/address/components/address_input_field.dart';

class AddressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 4),
        child: Column(
          children: <Widget>[
            Text(
              '配達先住所',
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            AddressInputField(),
          ],
        ),
      ),
    );
  }
}
