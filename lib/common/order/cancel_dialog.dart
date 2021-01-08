import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/order.dart';

class CancelDialog extends StatelessWidget {
  CancelDialog(this.order);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${order.formatId}をキャンセルしますか？'),
      // content: Text('キャンセルします'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('戻る'),
          textColor: Theme.of(context).primaryColor,
        ),
        FlatButton(
          onPressed: () {
            order.cancel();
            Navigator.of(context).pop();
          },
          child: Text('キャンセルへ'),
          textColor: Colors.red,
        ),
      ],
    );
  }
}
