import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/common/costom_icon_button.dart';
import 'package:virtual_store_flutter/model/item_size.dart';

class EditItemSize extends StatelessWidget {
  EditItemSize({
    Key key,
    this.size,
    this.onRemove,
    this.onMoveUP,
    this.onMoveDown,
  }) : super(key: key); //Widget内で何が変更し動いたか認識する為、keyを渡す。Remove、UP、Downで必要。

  final ItemSize size;
  final VoidCallback onRemove; //VoidCallbackは引数あり関数を呼ぶ。
  final VoidCallback onMoveUP;
  final VoidCallback onMoveDown;

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
            validator: (name) {
              if (name.isEmpty) {
                return '入力なし';
              } else {
                return null;
              }
            },
            onChanged: (name) => size.name = name, //＊onSavedでもオッケー。FormFieldでonSaved。
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
            validator: (stock) {
              if (stock.isEmpty) {
                return '入力なし';
              } else if (int.tryParse(stock) == null) {
                return '数字を入力';
              } else {
                return null;
              }
            },
            onChanged: (stock) => size.stock = int.tryParse(stock),
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
              prefixText: '¥',
            ),
            validator: (price) {
              if (price.isEmpty) {
                return '入力なし';
              } else if (int.tryParse(price) == null) {
                return '数字を入力';
              } else {
                return null;
              }
            },
            onChanged: (price) => size.price = num.tryParse(price),
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
          onTap: onMoveUP,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
          onTap: onMoveDown,
        ),
      ],
    );
  }
}
