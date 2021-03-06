import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/common/order/cancel_dialog.dart';
import 'package:virtual_store_flutter/model/order.dart';
import 'package:virtual_store_flutter/common/order/order_product_tile.dart';

import 'done_dialog.dart';

class OrderTile extends StatelessWidget {
  OrderTile(this.orders, {this.showControls = false});

  final Order orders;
  final bool showControls;
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
              orders.statusText,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: (orders.status == Status.cancel)
                    ? Colors.red
                    : Theme.of(context).primaryColor,
                fontSize: 14,
              ),
            )
          ],
        ),
        children: <Widget>[
          Column(
            children: orders.items.map((e) {
              return OrderProductTile(e);
            }).toList(),
          ),
          if (showControls && orders.status != Status.cancel)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  FlatButton(
                    onPressed:  () {
                      showDialog(context: context,builder: (_) => CancelDialog(orders));
                    },
                    textColor: Colors.red,
                    child: Text('キャンセル'),
                  ),
                  FlatButton(
                    onPressed: (orders.status != Status.preparing) ? () {
                      orders.preparing();
                    } : null,
                    child:  Text('準備'),
                  ),
                  FlatButton(
                    onPressed: (orders.status != Status.transporting) ? () {
                      orders.transporting();
                    } : null,
                    child:  Text('配達中'),
                  ),
                  FlatButton(
                    onPressed: (orders.status != Status.delivered) ? () {
                      showDialog(context: context,builder: (_) => DoneDialog(orders));
                    } : null,
                    textColor: Theme.of(context).primaryColor,
                    child: Text('完了'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
