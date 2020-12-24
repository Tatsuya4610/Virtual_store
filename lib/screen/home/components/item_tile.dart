import 'dart:io';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:virtual_store_flutter/model/home_manager.dart';
import 'package:virtual_store_flutter/model/product_manager.dart';
import 'package:virtual_store_flutter/model/section.dart';
import 'package:virtual_store_flutter/model/section_item.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/screen/product/product_screen.dart';
import 'package:virtual_store_flutter/screen/select_product/select_product_screen.dart';
import 'package:virtual_store_flutter/model/product.dart';

class ItemTile extends StatelessWidget {
  final SectionItem item;
  ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return GestureDetector(
      onTap: () {
        if (item.product != null) {
          final product =
              context.read<ProductManager>().findProductById(item.product);
          if (product != null) {
            //渡したIDがリストにある場合は
            Navigator.of(context)
                .pushNamed(ProductScreen.id, arguments: product);
          }
        }
      },
      onLongPress: (homeManager.editing)
          ? () {
              //長押しした場合。
              showDialog(
                context: context,
                builder: (_) {
                  final product = context
                      .read<ProductManager>()
                      .findProductById(item.product);
                  return AlertDialog(
                    title: Text('編集画像'),
                    content: (product != null) //productの情報がある場合は
                        ? ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Image.network(product.images.first),
                            title: Text(product.name),
                            subtitle: Text(
                              '${product.basePrice.toString()}円',
                            ),
                          )
                        : null,
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          context.read<Section>().removeItem(item); //画像削除
                          Navigator.of(context).pop();
                        },
                        textColor: Colors.red,
                        child: Text('削除'),
                      ),
                      FlatButton(
                        onPressed: () async {
                          if (product != null) {
                            //product情報がある場合はnullにしてリンクさせない。
                            item.product = null;
                          } else {
                            //リンクさせる場合。
                            final Product product = await Navigator.of(context)
                                .pushNamed(SelectProductScreen.id) as Product;
                            //画像を開くのを待ってから閉じる必要がある。エラーは起きずにページ移動できない。
                            //as Productにする。popで返されるデータがproductの為。'Route<dynamic>' is not type 'Route<Product>'
                            item.product = product?.id; //item.productがnullの場合は選択popで渡されたproductをリンク。
                            //戻るボタンで選択せずに戻って来た場合はnullが返される為、product?が必要。
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(product != null ? 'リンク解除' : 'リンクさせる'),
                      ),
                    ],
                  );
                },
              );
            }
          : null,
      child: AspectRatio(
        aspectRatio: 1,
        child: (item.image is String) //渡されるimageはdynamicで2種類ある為。
            ? FadeInImage.memoryNetwork(
                //Dartパッケージ。フワッと表示される。
                placeholder: kTransparentImage, //デフォルト。
                image: item.image as String,
                fit: BoxFit.cover,
              )
            : Image.file(
                item.image as File,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
