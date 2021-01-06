import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/common/price_card.dart';
import 'package:virtual_store_flutter/model/cart_manager.dart';
import 'package:virtual_store_flutter/model/checkout_manager.dart';
import 'package:virtual_store_flutter/model/page_manager.dart';
import 'package:virtual_store_flutter/screen/cart/cart_screen.dart';
import 'package:virtual_store_flutter/screen/confirmation/confirmation_screen.dart';

class CheckoutScreen extends StatelessWidget {
  static const id = 'CheckoutScreen';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager..updateCart(cartManager), //カートの更新。
      lazy: false, //情報の受け取りに遅れがある為、false。
      child: Scaffold(
          appBar: AppBar(
            title: Text('最終確認'),
          ),
          body: Consumer<CheckoutManager>(
            builder: (_, checkoutManager, __) {
              if (checkoutManager.loading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
                      SizedBox(height: 15),
                      Text(
                        '注文中',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }
              return ListView(
                children: <Widget>[
                  PriceCard(
                    buttonText: '注文を確定する',
                    onPressed: () {
                      checkoutManager.checkout(
                        onStockFail: (e) { //在庫切で注文に失敗した場合はUI更新済みのCartScreenへ
                          Navigator.popUntil(
                              context, ModalRoute.withName(CartScreen.id));
                        },
                        onSuccess: (order) { //注文完了した場合
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.of(context).pushNamed(ConfirmationScreen.id, arguments: order);
                        }
                      );
                    },
                  ),
                ],
              );
            },
          )),
    );
  }
}
