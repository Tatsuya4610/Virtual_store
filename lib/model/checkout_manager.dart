import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:virtual_store_flutter/model/cart_manager.dart';
import 'package:virtual_store_flutter/model/order.dart';
import 'package:virtual_store_flutter/model/product.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager _cartManager;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final Firestore firestore = Firestore.instance;

  void updateCart(CartManager cartManager) {
    //カート更新
    _cartManager = cartManager;
  }

  Future<void> checkout({Function onStockFail, Function onSuccess}) async { //カート注文、firebase更新保存。
    loading = true;
    try {
      await _decrementStock();
    } catch (e) {
      onStockFail(e);
      loading = false;
      return;
    }
    final orderId = await  _getOrderId();
    final order = Order.fromCartManager(_cartManager);
    order.orderId = orderId.toString();
    await order.save(); //firebase保存
    _cartManager.clear();
    onSuccess(); //成功した際に呼び出し。
    loading = false;
  }

  Future<int> _getOrderId() async {
    //注文カウント。番号。
    final ref = firestore.document('shopLocation/ordercount');
    try {
      final result = await firestore.runTransaction((tx) async {
        //カート内の取引。
        final doc = await tx.get(ref);
        final orderId = doc.data['current'] as int; //取引カウント取得。
        await tx.update(ref, {'current': orderId + 1}); //取引カウント更新。
        return {'orderId': orderId};
      });
      return result['orderId'] as int; //取引カウント返し。
    } catch (e) {
      return Future.error('注文に失敗。');
    }
  }

  Future<void> _decrementStock() async { //firebase カート購入　ストック更新減算

    return firestore.runTransaction((tx) async {
      final List<Product> productsToUpdate = []; //在庫あり、問題なく注文できるList
      final List<Product> productsWithoutStock = []; //在庫なしList。

      for (final cartProduct in _cartManager.items) {
        Product product;
        //個別にカート内のアイテムを照合しないとサイズは違うけど同じ商品だった場合、判別できない。
        if (productsToUpdate.any((pdc) => pdc.id == cartProduct.productId)) { //カート内のアイテムを商品ごとに照会
          product = productsToUpdate.firstWhere((pdc) => pdc.id == cartProduct.productId); //同上
        } else {
          final doc = await tx.get(
            //カート内の各アイテムをfirebaseのproductで受け取り。
            firestore.document('products/${cartProduct.productId}'),
          );
          product = Product.fromDocument(doc); //カート内を1年放置すると1年前の情報になる為、最新のproductを取得。
        }

        cartProduct.products = product; //productを渡して、UI更新しておく。在庫切れの際、Usersに知らせる為。

        final size = product.findSize(cartProduct.size);

        if (size.stock - cartProduct.quantity < 0) {
          //カートアイテムの数と実際の在庫数を照合。
          productsWithoutStock.add(product); //購入する前に在庫が無くなったアイテム。
        } else {
          //問題なくストックあるなら。
          size.stock -= cartProduct.quantity; //ストック数減算
          productsToUpdate.add(product);
        }
      }

      if (productsWithoutStock.isNotEmpty) {
        return Future.error('在庫切の商品あり');
      }
      for (final product in productsToUpdate) { //問題ない商品を更新。減算
        tx.update(firestore.document('products/${product.id}'), {
          'sizes': product.exportSizeList(),
        });
      }
    });
  }
}
