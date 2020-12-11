import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/cart_product.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;
  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 80,
              width: 80,
              child: Image.network(
                cartProduct.product.images.first, //複数登録されている写真の1枚目を表示
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                children: <Widget>[
                  Text(
                    cartProduct.product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'サイズ　${cartProduct.size}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text('${cartProduct.unitPrice.toString()}円',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),)
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
