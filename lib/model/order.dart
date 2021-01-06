import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_store_flutter/model/cart_manager.dart';
import 'package:virtual_store_flutter/model/cart_product.dart';

class Order {

  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.documentID;
    price = doc.data['price'] as num;
    userId = doc.data['user'] as String;
    date = doc.data['date'] as Timestamp;
    items = (doc.data['items'] as List<dynamic>).map((e) {
      return CartProduct.fromMap(e as Map<String,dynamic>);
    }).toList();

  }

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
  Timestamp date;
  
  String get formatId => '#${orderId.padLeft(4, '0')}'; //5桁で左側は0で埋める。







}
