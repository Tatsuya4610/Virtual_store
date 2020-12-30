import 'package:flutter/cupertino.dart';
import 'package:virtual_store_flutter/model/cart_manager.dart';

class CheckoutManager extends ChangeNotifier {


  CartManager _cartManager;

  void updateCart(CartManager cartManager) { //ユーザーが変更した際に
    _cartManager = cartManager;
    print(_cartManager.productsPrice);
  }
}