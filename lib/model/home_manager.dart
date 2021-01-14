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

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _loadSections() async {//posの番号順に取得。
    firestore.collection('home').orderBy('pos').snapshots().listen(
      (snapshot) {
        //getDocumentではsnapshotはfirebase上で更新があれば通知。
        _sections.clear(); //更新時に一度クリアのち取得。
        for (DocumentSnapshot document in snapshot.docs) {
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

      int pos = 0;

      for(final section in _editingSections) { //posを渡し、順番有りで保存。
        await section.save(pos); //firebaseに保存。
        pos++;
      }

      for(final section in List.from(_sections)) { //セクション全体を削除。_loadSections時、clear後に新しくsectionsを受け取り変化するため。
        if(!_editingSections.any((element) => element.id == section.id)) { //sectionごと削除の場合は既存idなし。
          //新しく編集されたsectionが既存のsectionだった場合,写真やタイトルのみの編集だとidは残っている。
          await section.delete();
        }
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
