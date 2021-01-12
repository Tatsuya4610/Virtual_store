import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_store_flutter/screen/checkout/components/card_text_field.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class CardFront extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, //childをshape内に
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 15,
      child: Container(
        padding: EdgeInsets.all(24),
        height: 200,
        color: Colors.teal[800],
        child: Row(
          children: <Widget>[
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CardTextField(
                  title: 'ナンバー',
                  hintText: '0000 0000 0000 0000',
                  textInputType: TextInputType.number,
                  bold: true,
                  inputFormatter: [
                    CreditCardNumberInputFormatter(onCardSystemSelected: (CardSystemData cardSystemData){
                      print(cardSystemData.system);
                    }),//Dartパッケージ。クレジット。
                  ],
                  validator: (number) {
                    if(number.length != 19) return '正しく入力してください';
                    return null;
                  },
                ),
                CardTextField(
                  title: '有効期限',
                  hintText: '01/21',
                  textInputType: TextInputType.number,
                  bold: false,
                  inputFormatter: [
                    CreditCardExpirationDateFormatter()//Dartパッケージ。
                  ],
                  validator: (date) {
                    if(date.length != 5) return '正しく入力してください';
                    return null;
                  },
                ),
                CardTextField(
                  title: '名前',
                  hintText: 'TARO YAMADA',
                  textInputType: TextInputType.text,
                  bold: true,
                  validator: (name) {
                    if(name.isEmpty) return '名前を入力してください';
                    return null;
                  },
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}