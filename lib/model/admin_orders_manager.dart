import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/order.dart';
import 'package:virtual_store_flutter/model/user.dart';

class AdminOrderManager extends ChangeNotifier {
  final List<Order> _orders = [];
  User userFilter;
  List<Status> statusFilter = [];

  List<Order> get filterOrders { //ユーザーごとにフィルターされたOrder
    List<Order> output = _orders.reversed.toList();
    if (userFilter != null) {
      output = output.where((element) => element.userId == userFilter.id).toList();
    }

    output = output.where((element) => statusFilter.contains(element.status)).toList();//statusごとのフィルター。
    return output;
  }

  final Firestore firestore = Firestore.instance;
  StreamSubscription _subscription;

  void updateAdmin(bool adminEnabled) {
    _orders.clear(); //保証でここでもクリア。
    _subscription?.cancel(); //以前の_listenToOrders、snapshotを停止。
    if (adminEnabled) {
      _listenToOrders();
    }
  }

  void _listenToOrders() {
    //全ての注文を取得。
    _subscription = firestore.collection('orders').snapshots().listen((event) {
      for (final change in event.documentChanges) {
        //document(snapshots)で変更があった場合、なんでもかんでも受け取るのではなく、
        //documentの変更Type、内容別で分ける。
        switch (change.type) {
          case DocumentChangeType.added: //追加された場合
            _orders.add(Order.fromDocument(change.document));
            break;
          case DocumentChangeType.modified: //変更された場合。今回の場合status[index]変更時
            final changeOrder = _orders
                .firstWhere((ord) => ord.orderId == change.document.documentID);
            changeOrder.updateFromDocument(change.document); //変更があったorderを更新。
            break;
          case DocumentChangeType.removed: //消された場合。今回は消すことない為スルー。
            break;
        }
        // orders.clear(); //管理者になるたびにカートクリアし、際取得。
        // for (final doc in event.documents) {//変更Typeではなく変更時、全て受け取る場合。
        //   orders.add(Order.fromDocument(doc));
        // }
        // notifyListeners();
      }
      notifyListeners();
    });
  }

  void setUserFilter(User user) {
    userFilter = user;
    notifyListeners();
  }

  void setStatusFilter({Status status, bool enable}) {
    if (enable) { //ボタンが押されていたら、押されているstatusを追加。
      statusFilter.add(status);
    } else {
      statusFilter.remove(status);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel(); //?を付ける理由は初めて利用の場合、最初はnullの為。
    //_listenToOrders()はsnapshotsで常にデータリンクしている為、userが変更した場合、
    //以前行っていたデータリンクを即停止する必要がある。subscriptionで管理し、user変更時にクリアする。
  }
}
