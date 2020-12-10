import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/item_size.dart';

class Product extends ChangeNotifier {
  Product.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document['name'];
    description = document['description'];
    images = List<String>.from(document.data['images']);
    sizes = (document.data['sizes'] as List<dynamic> ?? []) //全ての商品にfirebase上にsizesが登録されていない場合、mapでnullが返される為、??[]でもしくは0と表現要。
        .map((sizeMap) => ItemSize.formMap(sizeMap as Map<String, dynamic>))
        .toList();
  }

  String id;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;

  ItemSize _selectedSize;
  ItemSize get selectedSize => _selectedSize;

  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }
}
