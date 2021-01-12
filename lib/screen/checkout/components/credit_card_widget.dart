import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/screen/checkout/components/card_back.dart';
import 'package:virtual_store_flutter/screen/checkout/components/card_front.dart';

class CreditCardWidget extends StatelessWidget {
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

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
              front: CardFront(),
              back: CardBack(),
            ),
            FlatButton(
              onPressed: () {
                _cardKey.currentState.toggleCard();//タッチではなくここで回転。
              },
              textColor: Colors.white,
              padding: EdgeInsets.zero,
              child: Text('裏面へ'),
            ),
          ],
        ));
  }
}