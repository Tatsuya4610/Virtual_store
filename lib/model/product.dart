import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
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
  final FirebaseStorage storage = FirebaseStorage.instance;
  StorageReference get storageRef => storage.ref().child('products').child(id);
  //firebaseStorageにproductsのフォルダーを作成し、そこに商品Id別に保存。

  String id;
  String name;
  String description;
  List<String> images;
  List<dynamic> newImage;
  List<ItemSize> sizes;
  ItemSize _selectedSize;
  ItemSize get selectedSize => _selectedSize;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }



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
    loading = true;
    final Map<String, dynamic> data = { //Image以外のデーターの保存情報。
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

    //ここから下はImageの保存。
    final List<String> updateImages = [];

    for (final newImage in newImage) { //firebaseへ画像を保存。
      if (images.contains(newImage)) {
        //編集追加された新しいImageリストの中に元あったfirebaseから取得したImageが
        //あるかどうか確認。既存のImageはupdateImagesへ。
        updateImages.add(newImage as String);
      } else {
        //既存のImage以外の新しく追加されたImageはStorageへ保存。UuidでId付きFile。
        final StorageUploadTask task = storageRef.child(Uuid().v1()).putFile(newImage as File);
        final StorageTaskSnapshot snapshot = await task.onComplete; //アップロード(保存)待ち。
        final String url = await snapshot.ref.getDownloadURL() as String; //ダウンロードする為のURL
        updateImages.add(url); //新しく追加されたImageはStorageに保存後にダウンロードURLを取得し、そのURLを追加する。
      }
    }

    for(final image in images) { //削除されたImageのfirebase削除。
      if (!newImage.contains(image)) {
        try {
          //編集された新しいImageリストに含まれていない既存のImage。(削除されたImage)
          final ref = await storage.getReferenceFromUrl(
              image); //削除されたStorageに保存されているImageのURL情報を取得
          await ref.delete(); //削除。
        } catch (e) {
          //ただし、Storageに保存されていない直接firestore.documentに画像URLを保存した場合は
          //Storage削除に失敗する。
          // debugPrint('削除に失敗　$image}');
        }
      }
    }
    await firestore.document('products/$id').updateData({'images' : updateImages});
    //直接firestore.documentに画像URLを保存した場合、Storage削除に失敗するが、documentをupdateすれば
    //削除したImageはupdateImagesに追加されていない為、削除と同様。

    images = updateImages; //問題なくupdateされたらimagesと同じ。updateされたら再読み込み。
    loading = false;
  }



  // @override
  // String toString() {
  //   return 'Product{id: $id, name: $name, description: $description, images: $images, sizes: $sizes}, newImages: $newImage}';
  // }


}
