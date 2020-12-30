import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/common/price_card.dart';
import 'package:virtual_store_flutter/model/cart_manager.dart';
import 'package:virtual_store_flutter/model/checkout_manager.dart';

class CheckoutScreen extends StatelessWidget {
  static const id = 'CheckoutScreen';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_,cartManager,checkoutManager) =>
        checkoutManager..updateCart(cartManager), //カート変更があった際に通知。
      lazy: false, //情報の受け取りに遅れがある為、false。
      child: Scaffold(
        appBar: AppBar(
          title: Text('最終確認'),
        ),
        body: ListView(
          children: <Widget>[
            PriceCard(
              buttonText: '注文を確定する',
              onPressed: () {

              },
            )
          ],
        ),
      ),
    );
  }
}
