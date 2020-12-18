import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/item_size.dart';

class Product extends ChangeNotifier {

  Product({this.id,this.name,this.description,this.images,this.sizes}) {
    images = images ?? []; //nullなら空。ProductsScreenから直接来た場合は何も情報なし。
    sizes = sizes ?? [];
  }

  Product.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document['name'];
    description = document['description'];
    images = List<String>.from(document.data['images']);
    sizes = (document.data['sizes'] as List<dynamic> ?? []) //全ての商品にfirebase上にsizesが登録されていない場合、mapでnullが返される為、??[]でもしくは0と表現要。
        .map((sizeMap) => ItemSize.formMap(sizeMap as Map<String, dynamic>))
        .toList();
  }

  final Firestore firestore = Firestore.instance;

  String id;
  String name;
  String description;
  List<String> images;
  List<dynamic> newImage;
  List<ItemSize> sizes;
  ItemSize _selectedSize;
  ItemSize get selectedSize => _selectedSize;



  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }

   num get basePrice { //価格。
    num lowest = double.infinity; //在庫がある中の最低価格。
    for (final size in sizes){
      if (size.price < lowest && size.hasStock) {
        lowest = size.price;
      }
    }
    return lowest;
  }



  int get totalStock { //ストック数。
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock { //ストックがあるかないか。
    return totalStock > 0;
  }

  ItemSize findSize(String name) { //選択したサイズの確認。
    try {
      return sizes.firstWhere((s) => s.name == name);
    } catch (e) {
      return null;
    }
  }

  Product clone() { //クローン。元のオブジェクトを編集しないようにする為。
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images), //新しいリストを生成。
      sizes: sizes.map((size) => size.clone()).toList(), //新しいリストを生成。
    );
  }

  List<Map<String, dynamic>> exportSizeList() { //firebaseに記録する為のMap。
    return sizes.map((size) => size.toMap()).toList();
  }

  Future<void> save() async { //firebaseに保存。
    final Map<String, dynamic> data = {
      'name' : name,
      'description' : description,
      'sizes' : exportSizeList(),
    };
    if (id == null) { //新規登録編集の場合はidなし。
      final doc = await firestore.collection('products').add(data);
      id = doc.documentID;
    } else {//idがあれば、firebaseから受け取った既存の商品。
      await firestore.document('products/$id').updateData(data);
    }
  }


  // @override
  // String toString() {
  //   return 'Product{id: $id, name: $name, description: $description, images: $images, sizes: $sizes}, newImages: $newImage}';
  // }


}
