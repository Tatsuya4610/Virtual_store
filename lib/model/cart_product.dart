import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_store_flutter/model/item_size.dart';
import 'package:virtual_store_flutter/model/product.dart';

class CartProduct {
  CartProduct.formProduct(this.product) {
    //元々ログインしていた、直接のカート追加分。
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  CartProduct.formDocument(DocumentSnapshot cartSnapDoc) {
    //ユーザー別のカートドキュメントをProductへ変換。//別のログインユーザー分
    productId = cartSnapDoc['productDocId']; //商品のドキュメントID。
    quantity = cartSnapDoc['quantity'];
    size = cartSnapDoc['size'];

    Firestore.instance
        .document('products/$productId')
        .get()
        .then((doc) => product = Product.fromDocument(doc)); //商品のドキュメント情報。
  }

  String productId;
  int quantity;
  String size;

  Product product;

  ItemSize get itemSize {
    //カートに入ったサイズ。
    if (product == null) {
      return null;
    }
    return product.findSize(size);
  }

  int get unitPrice {
    //選択されたサイズ別の金額。
    if (product == null) {
      return 0;
    } else {
      return itemSize?.price ??
          0; //↑findSizeでnullの場合はnullが返される。nullが返された時は保証で0。
    }
  }
}
