import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/product.dart';
import 'package:virtual_store_flutter/screen/edit_product/components/images_from.dart';
import 'package:virtual_store_flutter/screen/edit_product/components/sizes_form.dart';

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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    initialValue: product.name,
                    decoration: InputDecoration(
                      hintText: '題名',
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    validator: (name) {
                      if (name.isEmpty) {
                        return '商品名を入れてください';
                      } else {
                        return null;
                      }
                    },
                  ),
                  if (product.hasStock) Text(
                    '${product.basePrice}円',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  if (!product.hasStock)Text(
                    '売り切れ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 7),
                    child: Text(
                      '商品説明',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextFormField(
                    initialValue: product.description,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                        hintText: '商品説明文', ),
                    maxLines: null, //キーボード改行ボタン。
                    validator: (desc) {
                      if (desc.isEmpty) {
                        return '入力してください';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizesForm(product),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                if (fromKey.currentState.validate()) {
                  //validator条件一致か確認。
                } else {}
              },
              child: Text('保存する'),
            ),
          ],
        ),
      ),
    );
  }
}
