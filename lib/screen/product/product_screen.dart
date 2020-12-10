import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/model/product.dart';
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '¥1000円',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
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
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Wrap( //囲い
                    spacing: 5, //囲い間の幅(横)。
                    runSpacing: 5,//囲い間の幅(縦)。
                    children: product.sizes.map((sizesMap) {
                      return SizeWidget(size: sizesMap);
                    }).toList(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
