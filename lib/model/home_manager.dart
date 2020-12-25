import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/section.dart';

class HomeManager extends ChangeNotifier {
  HomeManager() {
    _loadSections();
  }

  List<Section> _sections = [];
  List<Section> _editingSections = [];

  bool editing = false;
  bool loading = false;

  final Firestore firestore = Firestore.instance;

  Future<void> _loadSections() async {
    firestore.collection('home').snapshots().listen(
      (snapshot) {
        //getDocumentではsnapshotはfirebase上で更新があれば通知。
        _sections.clear(); //更新時に一度クリアのち取得。
        for (DocumentSnapshot document in snapshot.documents) {
          //ホームに入ったドキュメントを全て取得。
          _sections.add(Section.formDocument(
              document)); //documentをformDocumentに渡し、firebaseからデーター抽出。リストへ
        }
        notifyListeners();
        // print(sections);*内容確認。＊toString
      },
    );
  }

  void removeSection(Section section) {
    _editingSections.remove(section);
    notifyListeners();
  }

  void addSection(Section section) {
    _editingSections.add(section);
    notifyListeners();
  }

  List<Section> get sections {
    if (editing) { //編集モード中の場合。
      return _editingSections;
    } else {
      return _sections;
    }
  }

  void enterEditing() { //編集モード
    editing = true;
    //_editingSections = _sectionsは意味なし。
    _editingSections = _sections.map((s) => s.clone()).toList();
    notifyListeners();
  }


  Future<void> saveEditing() async   { //保存ボタン時
    bool valid = true;
    for (final section in _editingSections) {
      if (!section.valid()) {//入力されたtextやimageの検証。
         valid = false; //検証結果、falseで返された場合は。
      }
      if (!valid) return;
      loading = true;
      notifyListeners();

      for(final section in _editingSections) {
        await section.save(); //firebaseに保存。
      }
    }
    loading = false;
    editing = false;
    notifyListeners();
  }

  void discardEditing() {
    editing = false;
    notifyListeners();
  }

}
