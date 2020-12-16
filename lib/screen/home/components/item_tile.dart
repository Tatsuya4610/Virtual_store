import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:virtual_store_flutter/model/product_manager.dart';
import 'package:virtual_store_flutter/model/section_item.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/screen/product/product_screen.dart';

class ItemTile extends StatelessWidget {
  final SectionItem item;
  ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.product != null) {
          final product = context.read<ProductManager>().findProductById(item.product);
          if (product != null) { //渡したIDがリストにある場合は
            Navigator.of(context).pushNamed(ProductScreen.id,arguments: product);
          }
        }
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: FadeInImage.memoryNetwork( //Dartパッケージ。フワッと表示される。
          placeholder: kTransparentImage, //デフォルト。
          image: item.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

