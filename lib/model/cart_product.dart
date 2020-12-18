import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:virtual_store_flutter/model/item_size.dart';
import 'package:virtual_store_flutter/model/product.dart';

class CartProduct with ChangeNotifier {
  CartProduct.formProduct(this.product) {
    //元々ログインしていた、直接のカート追加分。
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  CartProduct.formDocument(DocumentSnapshot cartSnapDoc) {
    //firebaseから受け取ったユーザー別のカートドキュメントをProductへ変換。//別のログインユーザー分
    cartId = cartSnapDoc.documentID;
    productId = cartSnapDoc['productDocId']; //商品のドキュメントID。
    quantity = cartSnapDoc['quantity'];
    size = cartSnapDoc['size'];

    Firestore.instance.document('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
      notifyListeners(); //firebaseから情報を受け取った際、UIも更新。
    }); //商品のドキュメント情報。
  }

  String cartId;
  String productId;
  int quantity;
  String size;

  Product product;

  ItemSize get itemSize {
    //カートに入ったサイズの情報。
    if (product == null) {
      return null;
    }
    return product.findSize(size);
  }

  num get unitPrice {
    //選択されたサイズ別の金額。
    if (product == null) {
      return 0;
    } else {
      return itemSize?.price ??
          0; //↑findSizeでnullの場合はnullが返される。nullが返された時は保証で0。
    }
  }

  num get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toCartItemMap() {
    //firebaseにカート内容を登録する際のマップ。
    return {
      'productDocId': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  bool stackable(Product product) {
    return product.id == productId &&
        product.selectedSize.name == size; //商品IDとサイズが同じか確認。
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  bool get hasStock {
    //リアルタイムストック数
    final size = itemSize;
    if (size == null) {
      return false;
    } else {
      return size.stock >= quantity;
    }
  }
}
