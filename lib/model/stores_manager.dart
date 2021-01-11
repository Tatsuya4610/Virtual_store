import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:virtual_store_flutter/model/store.dart';

class StoresManager extends ChangeNotifier {
  StoresManager() {
    _loadStoresList();
    _startTimer();
  }

  List<Store> stores = [];
  Timer _timer;

  final Firestore firestore = Firestore.instance;

  Future<void> _loadStoresList() async {
    final snapshot = await firestore.collection('stores').getDocuments();
    stores = snapshot.documents.map((doc) => Store.formDocument(doc)).toList();
    notifyListeners();
  }

  void _startTimer() { //営業時間確認の更新
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {//1分ごとに
      _checkOpening();
    });
  }

  void _checkOpening(){
    for(final store in stores){
      store.updateStatus();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();//一度開くと永遠に更新し続ける為、ストアページを閉じたら停止。
    super.dispose();
  }

}
