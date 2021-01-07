import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/cart_product.dart';
import 'package:virtual_store_flutter/screen/product/product_screen.dart';

class OrderProductTile extends StatelessWidget {
  OrderProductTile(this.cartProduct);

  final CartProduct cartProduct;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ProductScreen.id,arguments: cartProduct.product);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 60,
              width: 60,
              child: Image.network(cartProduct.product.images.first),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    cartProduct.product.name,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'サイズ：${cartProduct.size}',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    '¥${cartProduct.unitPrice.toString()}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Text('${cartProduct.quantity}',style: TextStyle(fontSize: 20),)
          ],
        ),
      ),
    );
  }
}
