import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/screen/checkout/components/card_back.dart';
import 'package:virtual_store_flutter/screen/checkout/components/card_front.dart';

class CreditCardWidget extends StatefulWidget {
  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

  final FocusNode numberFocus = FocusNode();

  final FocusNode dateFocus = FocusNode();

  final FocusNode nameFocus = FocusNode();

  final FocusNode cvvFocus = FocusNode();


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            FlipCard(
              //Dartパッケージ。flip_card
              key: _cardKey,
              direction: FlipDirection.HORIZONTAL, //水平の動き
              speed: 700,
              flipOnTouch: false, //タッチで回転させない。
              front: CardFront(
                numberFocus: numberFocus,
                dateFocus: dateFocus,
                nameFocus: nameFocus,
                finished: () {
                  //表面の入力完了キーボードEnter後、裏面フォーカス。
                  _cardKey.currentState.toggleCard();
                  cvvFocus.requestFocus();
                },
              ),
              back: CardBack(
                cvvFocus: cvvFocus,
              ),
            ),
            FlatButton(
              onPressed: () {
                _cardKey.currentState.toggleCard(); //タッチではなくここで回転。
              },
              textColor: Colors.white,
              padding: EdgeInsets.zero,
              child: Text('裏面へ'),
            ),
          ],
        ));
  }
}
