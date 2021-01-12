import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  CardTextField({
    this.title,
    this.bold,
    this.hintText,
    this.textInputType,
    this.inputFormatter,
    this.validator,
  });

  final String title;
  final bool bold;
  final String hintText;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatter;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(//各々のTextFieldのvalidatorでエラーを出すと
      //heightが高くなってしまう為、エラー表示を別で表示。今回はタイトル横。
        initialValue: '',//FormFieldを使う場合initialValue入れないと空の状態はnullでエラーになる。
        validator: validator,
        builder: (state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: Colors.white),
                  ),
                  SizedBox(width: 5),
                  if(state.hasError)
                    Text('入力に間違いがあります',style: TextStyle(color: Colors.red,fontSize: 9),),
                ],),
                TextFormField(
                  inputFormatters: inputFormatter,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color: Colors.white.withAlpha(100),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 2)),
                  keyboardType: textInputType,
                  onChanged: (text) { //個別にエラーを認識。ない場合、全ての入力を正しくする必要あり。
                    state.didChange(text);
                  },
                ),
              ],
            ),
          );
        });
  }
}
