import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/order.dart';
import 'package:virtual_store_flutter/model/user.dart';

class OrdersManager extends ChangeNotifier {
  User user;

  List<Order> orders = [];

  final Firestore firestore = Firestore.instance;
  StreamSubscription _subscription;

  void updateUser(User user) {
    this.user = user;
    orders.clear(); //保証でここでもクリア。
    _subscription?.cancel(); //以前の_listenToOrders、snapshotを停止。
    if (user != null) {
      _listenToOrders();
    }
  }

  void _listenToOrders() { //userごとの注文を取得。
    _subscription = firestore
        .collection('orders')
        .where('user', isEqualTo: user.id)
        .snapshots()
        .listen((event) {
      orders.clear(); //userが変わるたびにカートクリアし、際取得。
      for (final doc in event.documents) {
        orders.add(Order.fromDocument(doc));
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel(); //?を付ける理由は初めて利用の場合、最初はnullの為。
    //_listenToOrders()はsnapshotsで常にデータリンクしている為、userが変更した場合、
    //以前行っていたデータリンクを即停止する必要がある。subscriptionで管理し、user変更時にクリアする。
  }
}
