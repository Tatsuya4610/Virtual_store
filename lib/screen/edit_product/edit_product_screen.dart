import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/product.dart';
import 'package:virtual_store_flutter/screen/edit_product/components/images_from.dart';

class EditProductScreen extends StatelessWidget {
  static const id = 'EditProductScreen';

  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context).settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text('商品編集画面'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: fromKey,
        child: ListView(
          children: <Widget>[
            ImagesFrom(product),
            RaisedButton(
              onPressed: () {
                if (fromKey.currentState.validate()) {
                  print('有効');
                } else {
                  print('だめ');
                }
              },
              child: Text('保存する'),
            ),
          ],
        ),
      ),
    );
  }
}
