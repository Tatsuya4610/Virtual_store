import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:virtual_store_flutter/model/section_item.dart';

class Section extends ChangeNotifier {
  Section({this.id, this.name, this.type, this.items}) {
    items = items ?? [];
    originalItems = List.from(items); //クローン作成時に追加されたitems。編集されたitems
  }

  Section.formDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.data()['name'] as String;
    type = document.data()['type'] as String;
    items = (document.data()['items'] as List ?? [])
        .map((map) => SectionItem.formMap(map as Map<String, dynamic>))
        .toList();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  DocumentReference get firestoreRef => firestore.doc('home/$id');
  Reference get storageRef => storage.ref().child('home/$id');

  String id;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItems;

  String _error;
  String get error => _error;
  set error(String value) {
    _error = value;
    notifyListeners();
  }

  Section clone() {
    return Section(
      id: id,
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

  Future<void> save(int pos) async {
    // product.dartのsaveと内容は類似。
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'pos': pos, //pos順序番号登録。
    };

    if (id == null) {
      //新規登録編集の場合はidなし。
      final doc = await firestore.collection('home').add(data);
      id = doc.id;
    } else {
      //idがあれば、firebaseから受け取った既存の商品。
      await firestoreRef.update(data);
    }

    for (final item in items) {
      if (item.image is File) {
        //カメラやフォトギャラリーの画像はUuidでid作成しとりあえず保存。
        final UploadTask task =
            storageRef.child(Uuid().v1()).putFile(item.image as File);
        final String url =
            await (await task).ref.getDownloadURL(); //保存された画像のダウンロードurl
        item.image = url;
      }
      for (final original in originalItems) {
        if (!items.contains(original) &&
            (original.image as String).contains('firebase')) {
          //直接firebaseに登録した画像。
          //編集前の元のitemsと編集された新しいitemsを比較。削除された画像がある場合
          try {
            final ref = storage
                .ref(original.image as String); //削除された画像情報
            await ref.delete();
          } catch (e) {
            //ただし、Storageに保存されていない直接firestore.documentに画像URLを保存した場合は
            //Storage削除に失敗する。&&(original.image as String).contains('firebase')追加要。
            // debugPrint('削除に失敗　$image}');
          }
        }
      }

      final Map<String, dynamic> itemsData = {
        'items': items.map((e) => e.toMap()).toList(),
      };
      //直接firestore.documentに画像URLを保存した場合、Storage削除に失敗するが、documentをupdateすれば
      //削除したImageはupdateImagesに追加されていない為、削除と同様。
      try {
        await firestoreRef.update(itemsData);
      } catch (e) {}
    }
  }

  Future<void> delete() async {
    //section削除。
    await firestoreRef.delete(); //ドキュメントごと削除。
    for (final item in items) {
      //ドキュメントに残っていたstorage保存されている画像を削除。
      if ((item.image as String).contains('firebase')) { //直接firebaseに登録している画像
        try {
          final ref =  storage.ref(item.image as String);
          await ref.delete();
        } catch (e) {}
      }
    }
  }

  bool valid() {
    if (name == null || name.isEmpty) {
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
