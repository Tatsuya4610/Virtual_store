import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:virtual_store_flutter/model/section_item.dart';

class Section extends ChangeNotifier {
  Section({this.name, this.type, this.items}) {
    items = items ?? [];
  }

  Section.formDocument(DocumentSnapshot document) {
    name = document.data['name'] as String;
    type = document.data['type'] as String;
    items = (document.data['items'] as List)
        .map((map) => SectionItem.formMap(map as Map<String, dynamic>))
        .toList();
  }

  String name;
  String type;
  List<SectionItem> items;
  String _error;
  String get error => _error;
  set error(String value) {
    _error = value;
    notifyListeners();
  }

  Section clone() {
    return Section(
      name: name,
      type: type,
      items: items.map((i) => i.clone()).toList(),
    );
  }

  void addItem(SectionItem sectionItem) {
    items.add(sectionItem);
    notifyListeners();
  }

  void removeItem(SectionItem sectionItem) {
    items.remove(sectionItem);
    notifyListeners();
  }

  bool valid() {
    if(name == null || name.isEmpty) {
      error = '入力してください';
    } else if (items.isEmpty) {
      error = '画像を入れてください';
    } else {
      error = null;
    }
    return error == null; //問題ない場合はtrueで返される。
  }

  // @override
  // String toString() {
  //   return 'section : $name, type : $type, items : $items';
  // }
}
