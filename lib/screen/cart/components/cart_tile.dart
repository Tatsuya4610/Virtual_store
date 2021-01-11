import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/common/costom_icon_button.dart';
import 'package:virtual_store_flutter/model/cart_product.dart';
import 'package:virtual_store_flutter/screen/product/product_screen.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;
  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cartProduct,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(ProductScreen.id, arguments: cartProduct.product);
        },
        child: Card(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        Consumer<CartProduct>(builder: (_,cartProduct, __) {
                          if (cartProduct.hasStock) {
                            return  Text(
                              '${cartProduct.unitPrice.toString()}円',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            );
                          } else {
                            return Text('在庫切です',style: TextStyle(
                              fontSize: 16,color: Colors.red
                            ),);
                          }
                        })
                      ],
                    ),
                  ),
                ),
                Consumer<CartProduct>(builder: (_,cartProduct,__) {
                  return Column(
                    children: <Widget>[
                      CustomIconButton(
                        iconData: Icons.add,
                        color: Theme.of(context).primaryColor,
                        onTap: cartProduct.increment,
                      ),
                      Text(
                        '${cartProduct.quantity}',
                        style: TextStyle(fontSize: 20),
                      ),
                      CustomIconButton(
                        iconData: Icons.remove,
                        color: cartProduct.quantity > 1 ?
                        Theme.of(context).primaryColor : Colors.red,
                        onTap: cartProduct.decrement,
                      ),
                    ],
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
