import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/section.dart';

class HomeManager extends ChangeNotifier {
  HomeManager() {
    _loadSections();
  }

  List<Section> sections = [];

  bool editing = false;

  final Firestore firestore = Firestore.instance;

  Future<void> _loadSections() async {
    firestore.collection('home').snapshots().listen(
      (snapshot) {
        //getDocumentではsnapshotはfirebase上で更新があれば通知。
        sections.clear(); //更新時に一度クリアのち取得。
        for (DocumentSnapshot document in snapshot.documents) {
          //ホームに入ったドキュメントを全て取得。
          sections.add(Section.formDocument(
              document)); //documentをformDocumentに渡し、firebaseからデーター抽出。リストへ
        }
        notifyListeners();
        // print(sections);*内容確認。＊toString
      },
    );
  }

  void enterEditing() { //編集モード
    editing = true;
    notifyListeners();
  }

  void saveEditing() {
    editing = false;
    notifyListeners();
  }

  void discardEditing() {
    editing = false;
    notifyListeners();
  }

}
