import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/order.dart';

class AdminOrderManager extends ChangeNotifier {


  List<Order> orders = [];

  final Firestore firestore = Firestore.instance;
  StreamSubscription _subscription;

  void updateAdmin(bool adminEnabled) {
    orders.clear(); //保証でここでもクリア。
    _subscription?.cancel(); //以前の_listenToOrders、snapshotを停止。
    if (adminEnabled) {
      _listenToOrders();
    }
  }

  void _listenToOrders() { //全ての注文を取得。
    _subscription = firestore
        .collection('orders')
        .snapshots()
        .listen((event) {
      orders.clear(); //管理者になるたびにカートクリアし、際取得。
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
