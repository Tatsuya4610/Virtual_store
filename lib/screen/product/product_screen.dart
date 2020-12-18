import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/model/cart_manager.dart';
import 'package:virtual_store_flutter/model/product.dart';
import 'package:virtual_store_flutter/model/user_manager.dart';
import 'package:virtual_store_flutter/screen/cart/cart_screen.dart';
import 'package:virtual_store_flutter/screen/edit_product/edit_product_screen.dart';
import 'package:virtual_store_flutter/screen/login/login_screen.dart';
import 'package:virtual_store_flutter/screen/product/components/size_widget.dart';

class ProductScreen extends StatelessWidget {
  static const id = 'ProductScreen';

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context).settings.arguments as Product;
    return ChangeNotifierProvider.value(
      value: product, //ここのWidgetのみ使用したい場合。すでにproduct渡しているから。
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.name),
          centerTitle: true,
          actions: <Widget>[
            Consumer<UserManager>(builder: (_, userManager, __) {
              if (userManager.adminEnabled) {
                return IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(EditProductScreen.id, arguments: product);
                    });
              } else {
                return Container();
              }
            })
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            AspectRatio(
              //Container()でfitよりもこっちの方がいいかも？
              aspectRatio: 1,
              child: Carousel(
                //登録されている画像数分だけスライドショー。
                images: product.images.map((url) {
                  return NetworkImage(url);
                }).toList(),
                dotSize: 5,
                dotSpacing: 20, //dotの間隔。
                dotBgColor: Colors.transparent, //dotの枠バーの色。なし。
                dotColor: Theme.of(context).primaryColor,
                autoplay: false, //自動スライド
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  if (product.hasStock) //ストックあるなら、ストック内の最低価格を表示。
                    Text(
                      '${product.basePrice}円',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  if (!product.hasStock) //ストックなし。
                    Text(
                      '売り切れ',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      '＜商品説明＞',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(product.description),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 8),
                    child: Text(
                      'サイズ別',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Wrap(
                    //囲い
                    spacing: 5, //囲い間の幅(横)。
                    runSpacing: 5, //囲い間の幅(縦)。
                    children: product.sizes.map((sizesMap) {
                      return SizeWidget(size: sizesMap);
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  if (product.hasStock) //全てストックがある場合のみ表示。
                    Consumer2<UserManager, Product>(
                        builder: (_, userManager, product, __) {
                      return SizedBox(
                        height: 44,
                        child: RaisedButton(
                          onPressed: product.selectedSize != null
                              ? () {
                                  if (userManager.islLogin) {
                                    //ログインしていたらそのままカートへ
                                    context
                                        .read<CartManager>()
                                        .addToCart(product);
                                    Navigator.of(context)
                                        .pushNamed(CartScreen.id);
                                  } else {
                                    //ログインしていなければ
                                    Navigator.of(context)
                                        .pushNamed(LoginScreen.id);
                                  }
                                }
                              : null,
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          child: Text(
                              userManager.islLogin ? 'カートへ追加' : 'ログインしてカートへ'),
                        ),
                      );
                    }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
