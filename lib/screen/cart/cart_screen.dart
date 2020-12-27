import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/common/price_card.dart';
import 'package:virtual_store_flutter/model/cart_manager.dart';
import 'package:virtual_store_flutter/screen/address/address_screen.dart';
import 'package:virtual_store_flutter/screen/cart/components/cart_tile.dart';

class CartScreen extends StatelessWidget {
  static const id = 'CartScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カート'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          return ListView(
            children: <Widget>[
              Column(
                children: cartManager.items
                    .map((cartItem) => CartTile(cartItem))
                    .toList(),
              ),
              PriceCard(
                buttonText: '配達注文画面へ',
                onPressed: cartManager.isCartValid ? (){
                  Navigator.of(context).pushNamed(AddressScreen.id);
                } : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
