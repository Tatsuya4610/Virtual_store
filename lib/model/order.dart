import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_store_flutter/model/cart_manager.dart';
import 'package:virtual_store_flutter/model/cart_product.dart';

enum Status {
  cancel,
  preparing,
  transporting,
  delivered,
}

class Order {
  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.id;
    price = doc.data()['price'] as num;
    userId = doc.data()['user'] as String;
    date = doc.data()['date'] as Timestamp;
    items = (doc.data()['items'] as List<dynamic>).map((e) {
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();
    status = Status.values[doc.data()['status'] as int];
  }

  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.productsPrice;
    userId = cartManager.users.id;
    status = Status.preparing;
  }

  void updateFromDocument(DocumentSnapshot doc) {
    status = Status.values[doc.data()['status'] as int];
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set({
      'items': items.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      'status': status.index,
      'date': Timestamp.now(),
      // 'address' : address.toMap(),
    });
  }

  // Function get back { //
  //   return (status.index >= Status.transporting.index) ? () {
  //     status = Status.values[status.index - 1];
  //     firestore.collection('orders').document(orderId).updateData({
  //       'status' : status.index
  //     });
  //   } : null;
  // }
  // Function get advance {
  //   return (status.index <= Status.transporting.index) ? () {
  //     status = Status.values[status.index + 1];
  //     firestore.collection('orders').document(orderId).updateData({
  //       'status' : status.index
  //     });
  //   } : null;
  // }

  void cancel() { //キャンセル
    status = Status.cancel;
    firestore.collection('orders').doc(orderId).update({
      'status' : status.index
    });
  }
  void done() { //完了
    status = Status.delivered;
    firestore.collection('orders').doc(orderId).update({
      'status' : status.index
    });
  }

  void preparing() { //準備
    status = Status.preparing;
    firestore.collection('orders').doc(orderId).update({
      'status' : status.index
    });
  }
  void transporting() { //配達
    status = Status.transporting;
    firestore.collection('orders').doc(orderId).update({
      'status' : status.index
    });
  }


  String orderId;
  List<CartProduct> items;
  num price;
  String userId;
  Timestamp date;
  Status status;

  String get formatId => '#${orderId.padLeft(4, '0')}'; //5桁で左側は0で埋める。
  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch (status) {
      case Status.cancel:
        return 'キャンセル';
      case Status.preparing:
        return '準備';
      case Status.transporting:
        return '配達';
      case Status.delivered:
        return '完了';
      default:
        return '';
    }
  }
}
