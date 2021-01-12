import 'package:flutter/material.dart';

class CardBack extends StatelessWidget {
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
                Expanded(child: Container(color: Colors.grey[500],height: 20,),flex: 70,),
                Expanded(child: Container(),flex: 30,),
              ],
            )
          ],
        ),
      ),
    );
  }
}
