import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/common/price_card.dart';
import 'package:virtual_store_flutter/screen/address/components/address_card.dart';
import 'package:virtual_store_flutter/screen/checkout/checkout_screen.dart';
import 'package:virtual_store_flutter/service/postal.dart';

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
          Consumer<Postal>(builder: (_,postal, __) {
            return PriceCard(
              buttonText: '支払いへ進む',
              onPressed: postal.onSaved ? () {
                Navigator.of(context).pushNamed(CheckoutScreen.id);
              } : null,
            );
          })
        ],
      ),
    );
  }
}
