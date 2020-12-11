import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/cart_product.dart';
import 'package:virtual_store_flutter/model/product.dart';
import 'package:virtual_store_flutter/model/user.dart';
import 'package:virtual_store_flutter/model/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  User user;

  void addToCart(Product product) { //Productの全ての情報をformProductでCartProductリスト化。
    items.add(CartProduct.formProduct(product));
  }

  void updateUser(UserManager userManager) {
    user = userManager.user; //ログイン中のユーザーを記録。ユーザーが変更するたびに受け取る。
    items.clear(); //ユーザーが変わった場合は元のカートリストをクリア。
    if (user != null) { //ログアウトの可能性もある為、ユーザーの切替りまたログインが確認できた場合。
      _loadCartItems();
    }
  }

  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await user.cartReference.getDocuments(); //ユーザー別のカートのドキュメント情報。
    items = cartSnap.documents.map((doc) => CartProduct.formDocument(doc)).toList();
    
  }

}