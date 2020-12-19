import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    _loadAllProduct();
  }

  List<Product> _allProducts = [];
  List<Product> get allProducts => _allProducts;
  String _search = '';
  String get search => _search;

  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Product> get filteredProducts { //searchでフィルターされたProducts
    List<Product> filteredProducts = [];
    if (_search.isEmpty) {
      //search入力なしの場合は全部表示。
      filteredProducts.addAll(_allProducts);
    } else {
      filteredProducts.addAll(
        _allProducts.where( //_allProductsの中から_searchのキーワードが入った物を選別。
          (pdc) => pdc.name.toLowerCase().contains(_search.toLowerCase()), //toLowerCaseは小文字でも認識。
        ),
      );
    }
    return filteredProducts;
  }

  Future<void> _loadAllProduct() async {
    final QuerySnapshot snapProducts =
        await Firestore.instance.collection('products').getDocuments();

    _allProducts = //productsのドキュメントの中にある情報(List)別をfromDocumentで個々に受け取り。
        snapProducts.documents.map((doc) => Product.fromDocument(doc)).toList();
    notifyListeners();

    // for(DocumentSnapshot doc in snapProducts.documents) { //productsのdocumentsの数、全ての情報を取得。
    //   print(doc.data);
    // }
  }
  
  Product findProductById(String id) { //渡されたIdがListのIdと同じか照合。
    try {
      return _allProducts.firstWhere((pct) => pct.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(Product cloneProduct) { //更新
    _allProducts.removeWhere((pdc) => pdc.id == cloneProduct.id);
    //修正され渡されたcloneProductは_allProducts本体を修正していない為、
    //修正したproductを削除し、新しく追加する。
    _allProducts.add(cloneProduct);
    notifyListeners();
  }

}
