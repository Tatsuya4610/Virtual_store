import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/order.dart';
import 'package:virtual_store_flutter/common/order/order_product_tile.dart';

class ConfirmationScreen extends StatelessWidget {
  static const id = 'ConfirmationScreen';

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context).settings.arguments as Order;
    return Scaffold(
      appBar: AppBar(
        title: Text('確認画面'),
        centerTitle: true,
      ),
      body: Card(
        margin: EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '注文番号 ${order.formatId}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    '注文合計 ${order.price.toString()}円',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
            Column(children: order.items.map((e) {
              return OrderProductTile(e);
            }).toList(),)
          ],
        ),
      ),
    );
  }
}
