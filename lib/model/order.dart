import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_store_flutter/model/cart_manager.dart';
import 'package:virtual_store_flutter/model/cart_product.dart';

class Order {
  Order();
  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.productsPrice;
    userId = cartManager.user.id;
  }

  final Firestore firestore = Firestore.instance;
  Future<void> save() async {
    firestore.collection('orders').document(orderId).setData({
      'items': items.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      // 'address' : address.toMap(),
    });
  }

  String orderId;
  List<CartProduct> items;
  num price;
  String userId;
  Timestamp date; //日付で並べることが出来る。

}
