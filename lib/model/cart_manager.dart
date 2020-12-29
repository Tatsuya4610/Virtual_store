import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/cart_product.dart';
import 'package:virtual_store_flutter/model/product.dart';
import 'package:virtual_store_flutter/model/user.dart';
import 'package:virtual_store_flutter/model/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  User user;

  num productsPrice = 0;

  void updateUser(UserManager userManager) {
    user = userManager.user; //ログイン中のユーザーを記録。ユーザーが変更するたびに受け取る。
    items.clear(); //ユーザーが変わった場合は元のカートリストをクリア。
    if (user != null) {
      //ログアウトの可能性もある為、ユーザーの切替りまたログインが確認できた場合。
      _loadCartItems();
    }
  }

  Future<void> _loadCartItems() async {
    //ユーザー別のカートを取得。
    final QuerySnapshot cartSnap =
    await user.cartReference.getDocuments(); //ユーザー別のカートのドキュメント情報。
    items = cartSnap.documents
        .map(
          (doc) =>
      CartProduct.formDocument(doc)
        ..addListener(
            _onItemUpdated), //CartProductのnotifyListeners(quantity+-)が呼び出されるたびに通知。＊
    )
        .toList();
  }

  void addToCart(Product product) {
    //CartScreenのリストは_loadCartItemsでfirebaseから受け取った物とaddToCartで追加された物、内部てきには2種類ある。＊
    //Productの全ての情報をformProductでCartProductリスト化。
    try {
      final item = items.firstWhere((pdc) =>
          pdc.stackable(
              product)); //渡されたproductがitemsの商品IDとサイズを統合し、同じだった場合はquantity++;
      item.increment();
    } catch (e) {
      final cartProduct = CartProduct.formProduct(product);
      cartProduct.addListener(
          _onItemUpdated); //cartProductのnotifyListeners(quantity+-)が呼び出されるたびに通知。＊
      items.add(cartProduct);
      user.cartReference.add(
        cartProduct.toCartItemMap(), //user別にカートをfirebaseに追加。
      ).then((doc) =>
      cartProduct.cartId =
          doc.documentID); //_loadCartItemsはドキュメントIDを取得出来るがaddToCartの場合は
      //まだ追加仕立てでdoc.documentIDを受け取らないとcartProduct.cartIdに追加されていない。
      _onItemUpdated(); //productsPriceがfirebaseから受け取ったデーターではない時も更新出来るように受け取り。
    }
    notifyListeners();
  }

  void _onItemUpdated() {//addListenerで更新された時に呼び出され、データ更新。
    productsPrice = 0;
    for (int i = 0; i < items.length; i ++) {
      final cartProduct = items[i];
      if (cartProduct.quantity == 0) {
        removeCart(cartProduct);
        i--; //
        continue;
      }
      productsPrice += cartProduct.totalPrice;//itemsが有り、removeでもなく追加更新された場合。
      //for (final cartProduct in items) {
      //       if (cartProduct.quantity == 0) {
      //         removeOfCart(cartProduct);
      //       } これだとエラーが出る。items.lengthも更新要。
      _updateCartProduct(cartProduct);
    }
    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {//firebaseデータ更新。
    if (cartProduct.cartId != null) {
        user.cartReference
          .document(cartProduct
          .cartId)
          .updateData(cartProduct.toCartItemMap(),
      );
    }

  }

  void removeCart(CartProduct cartProduct) {
    items.removeWhere((item) => item.cartId == cartProduct.cartId); //items内を削除。
    user.cartReference.document(cartProduct.cartId).delete(); //firebaseのカートを削除。
    cartProduct.removeListener(
        _onItemUpdated); //各アイテムには、数量の更新後にnotifyListenerを呼び出すリスナーがあり、アイテムを削除するときは、
    //そのアイテムのリスナーも削除して、アプリの処理に使用されないようにする必要有り。他のアイテムには引き続きリスナーが含まれる。
    notifyListeners();
  }

  bool get isCartValid { //カートが有効かどうか。
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false; //ストックがなければ
    }
    return true;
  }


}
