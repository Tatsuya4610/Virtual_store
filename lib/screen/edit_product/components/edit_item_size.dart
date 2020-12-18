import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/common/costom_icon_button.dart';
import 'package:virtual_store_flutter/model/item_size.dart';

class EditItemSize extends StatelessWidget {

  EditItemSize({this.size,this.onRemove});
  final ItemSize size;
  final VoidCallback onRemove; //VoidCallbackは引数あり関数を呼ぶ。

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.name,
            decoration: InputDecoration(
              labelText: 'サイズ',
              isDense: true, //幅密集。
            ),
          ),
        ),
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.stock?.toString(),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'ストック数',
              isDense: true,
            ),
          ),
        ),
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: size.price?.toString(),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '価格',
              isDense: true,
              prefixText: '¥'
            ),
          ),
        ),
        CustomIconButton(
          iconData: Icons.remove,
          color: Colors.red,
          onTap: onRemove,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
        ),
      ],
    );
  }
}
