import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/item_size.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/model/product.dart';

class SizeWidget extends StatelessWidget {
  final ItemSize size;
  SizeWidget({this.size});

  @override
  Widget build(BuildContext context) {
    final product = context.watch<Product>();
    final selected = size == product.selectedSize;
    Color color;
    if (!size.hasStock) {
      //在庫なし。
      color = Colors.red.withAlpha(50);
    } else if (selected) {
      //選択中。
      color = Theme.of(context).primaryColor;
    } else {
      //その他。
      color = Colors.grey;
    }

    return GestureDetector(
      onTap: () {
        if (size.hasStock) {
          product.selectedSize = size;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, //幅を出来る限り狭く。
          children: <Widget>[
            Container(
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                size.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Text(
                '¥${size.price}',
                style: TextStyle(
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
