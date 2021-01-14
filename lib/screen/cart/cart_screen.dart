import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/common/empty_cart.dart';
import 'package:virtual_store_flutter/common/login_card.dart';
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
          if (cartManager.users == null) {
            return LoginCard(); //ログインしていない場合は
          }
          if (cartManager.items.isEmpty) { //カートに何もない場合は空カート画面
            return EmptyCard(
              iconData: Icons.remove_shopping_cart,
              title: 'カートに商品が有りません',
            );
          }
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
