import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/common/costom_icon_button.dart';
import 'package:virtual_store_flutter/model/item_size.dart';
import 'package:virtual_store_flutter/model/product.dart';
import 'package:virtual_store_flutter/screen/edit_product/components/edit_item_size.dart';

class SizesForm extends StatelessWidget {
  final Product product;

  SizesForm(this.product);
  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      //product.sizesはItemSize。
      initialValue: List.from(product.sizes),
      //元のproduct.sizesだけではなくAddするのもあるため、List。fromで囲む。
      builder: (state) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'サイズ別詳細',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  onTap: () {
                    state.value.add(ItemSize()); //*1
                    state.didChange(state.value); //*1セット。itemを増やしたらvalue数が変わる為。
                  },
                )
              ],
            ),
            Column(
              children: state.value.map( //FormFieldここから
                (size) {
                  return EditItemSize(
                    size: size,
                    onRemove: () {
                      state.value.remove(size);
                      //各々、mapで渡されたsizeを消去。size引数があるのでFunctionではなくVoidCallback。
                      state.didChange(state.value);//value変化するので。
                    },
                  );
                },
              ).toList(),
            ),
          ],
        );
      },
    );
  }
}
