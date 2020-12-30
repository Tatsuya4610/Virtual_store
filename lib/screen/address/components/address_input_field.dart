import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_store_flutter/common/costom_icon_button.dart';
import 'package:virtual_store_flutter/model/address.dart';
import 'package:virtual_store_flutter/service/postal.dart';
import 'package:provider/provider.dart';

class AddressInputField extends StatelessWidget {
  AddressInputField(this.address);
  final Address address;

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final postalData = context.watch<Postal>();
    if (address.postal == null)
      return Column(
        children: <Widget>[
          TextFormField(
            // controller: controller,
            onChanged: (text) => postalData.postAddress = text,
            decoration: InputDecoration(
              isDense: true,
              labelText: '郵便番号',
              hintText: '1234567',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly //数字のみ使用可
            ],
            validator: (text) {
              if (text.isEmpty) {
                return '入力して下さい';
              } else if (text.length > 7) {
                return '無効な郵便番号';
              } else if (text.length < 5) {
                return '無効な郵便番号';
              } else {
                return null;
              }
            },
          ),
          RaisedButton(
            onPressed: () async {
              if (Form.of(context).validate()) { //valid入力全て問題なし。
                try { //郵便番号情報受け取り失敗または入力ミスを通知。
                  await context.read<Postal>().getAddress(postalData.postsAddress);
                } catch (e) {
                  scaffold.showSnackBar(SnackBar(
                    content: Text('郵便番号を再入力して下さい'),
                    duration: Duration(seconds: 5),
                    action: SnackBarAction(
                      label: '閉じる',
                      onPressed: () {},
                    ),
                  ));
                }
              }
            },
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            disabledColor: Theme.of(context).primaryColor.withAlpha(100),
            child: Text('郵便番号で検索'),
          ),
        ],
      );
    else //情報取得できたら別テキスト。
      return Row(
        children: <Widget>[
          Expanded(
            child: Text(
              '〒 ${address.postal}',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
          ),
          CustomIconButton(
            iconData: Icons.edit,
            color: Theme.of(context).primaryColor,
            onTap: () {
              context.read<Postal>().postRemove(); //郵便番号の入力情報を削除。
              postalData.onSave = false;
            },
          )
        ],
      );
  }
}
