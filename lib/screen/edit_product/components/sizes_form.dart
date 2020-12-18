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
      initialValue: product.sizes,
      //元のproduct.sizesを変更するため、List.fromで囲む必要あり。
      // 今回はProduct.clone()で新しいリストを渡している為不要。List.fromをこちらでも付けると、
      //数値の変更は問題ないが、削除と移動が反映されない。
      validator: (size) {
        if (size.isEmpty) {
          return 'サイズ別詳細を入力してください';
        } else {
          return null;
        }
      },
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
              children: state.value.map(
                //FormFieldここから
                (size) {
                  return EditItemSize(
                    key: ObjectKey(size), //keyをリンクさせる。
                    size: size,
                    onRemove: () {
                      state.value.remove(size);
                      //各々、mapで渡されたsizeを消去。size引数があるのでFunctionではなくVoidCallback。
                      state.didChange(state.value); //value変化するので。
                    },
                    onMoveUP: (size != state.value.first)//一番上のリストの場合は上ボタン不可。
                        ? () {
                            final index =
                                state.value.indexOf(size); //挿入されている順番号。
                            state.value.remove(size); //削除。
                            state.value
                                .insert(index - 1, size); //削除したところ(順番号)に挿入。
                            state.didChange(state.value);
                          }
                        : null,
                    onMoveDown: (size != state.value.last) //一番下のリストなら下ボタン不可。
                        ? () {
                            final index = state.value.indexOf(size);
                            state.value.remove(size);
                            state.value.insert(index + 1, size);
                            state.didChange(state.value);
                          }
                        : null,
                  );
                },
              ).toList(),
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
