import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/order.dart';

class DoneDialog extends StatelessWidget {
  DoneDialog(this.order);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${order.formatId}を完了しますか？'),
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
            order.done();
            Navigator.of(context).pop();
          },
          child: Text('完了する'),
          textColor: Colors.blue,
        ),
      ],
    );
  }
}