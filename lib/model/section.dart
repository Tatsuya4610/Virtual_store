import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_store_flutter/model/section_item.dart';

class Section {
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

  Section clone() {
    return Section(
      name: name,
      type: type,
      items: items.map((i) => i.clone()).toList(),
    );
  }

  // @override
  // String toString() {
  //   return 'section : $name, type : $type, items : $items';
  // }
}
