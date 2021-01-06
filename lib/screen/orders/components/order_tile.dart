import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/order.dart';
import 'package:virtual_store_flutter/screen/orders/components/order_product_tile.dart';

class OrderTile extends StatelessWidget {
  OrderTile(this.orders);

  final Order orders;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '注文番号 ${orders.formatId}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  '購入金額 ${orders.price.toString()}円',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                )
              ],
            ),
            Text(
              '配送中',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Theme.of(context).primaryColor,
                fontSize: 14,
              ),
            )
          ],
        ),
        children: <Widget>[
          Column(children: orders.items.map((e) {
            return OrderProductTile(e);
          }).toList(),)
        ],
      ),
    );
  }
}
