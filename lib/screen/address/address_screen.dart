import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/screen/address/components/address_card.dart';

class AddressScreen extends StatelessWidget {
  static const id = 'AddressScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('配達'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AddressCard(),
        ],
      ),
    );
  }
}
