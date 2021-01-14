import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:virtual_store_flutter/screen/checkout/components/card_text_field.dart';

class CardBack extends StatelessWidget {

  CardBack({this.cvvFocus});

  final FocusNode cvvFocus;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, //childをshape内に
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 15,
      child: Container(
        height: 200,
        color: Colors.teal[800],
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.black,
              height: 40,
              margin: EdgeInsets.symmetric(vertical: 16),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 70,
                  child: Container(
                    color: Colors.grey[500],
                    margin: EdgeInsets.only(left: 10),
                    padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                    alignment: Alignment.centerRight,
                    child: CardTextField(
                      bold: false,
                      textAlign: TextAlign.end,
                      textInputType: TextInputType.number,
                      focusNode: cvvFocus,
                      inputFormatter: [
                        CreditCardCvcInputFormatter()
                      ],
                      validator: (cvv) {
                        if(cvv.isEmpty || cvv.length < 3) {
                          return '正しく入力して下さい';
                        }
                        return null;
                      },
                      onSubmitted: null,
                    ),
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: Container(),

                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
