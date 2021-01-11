import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/model/product.dart';
import 'package:virtual_store_flutter/model/product_manager.dart';
import 'package:virtual_store_flutter/screen/edit_product/components/images_from.dart';
import 'package:virtual_store_flutter/screen/edit_product/components/sizes_form.dart';

class EditProductScreen extends StatelessWidget {
  static const id = 'EditProductScreen';

  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context).settings.arguments
        as Product; //渡しているのはProduct.clone()。
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: (product.name != null) ? Text('商品編集画面') : Text('新規作成画面'),
          centerTitle: true,
          actions: <Widget>[
            if(product.id != null) //渡されたproductにデーターがある場合。クローンデータ(新規登録)ではない場合。
              IconButton(icon: Icon(Icons.delete), onPressed: (){
                context.read<ProductManager>().delete(product);
                Navigator.of(context).popUntil((route) => route.isFirst);
              })
          ],
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: fromKey, //Fromで囲っている部分全て有効。
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
                      keyboardType: TextInputType.name,
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
                      onSaved: (name) => product.name = name, //＊保存
                    ),
                    if (product.hasStock)
                      Text(
                        '${product.basePrice}円',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    if (!product.hasStock)
                      Text(
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
                      keyboardType: TextInputType.name,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: '商品説明文',
                      ),
                      // maxLines: null, //キーボード改行ボタン。
                      validator: (desc) {
                        if (desc.isEmpty) {
                          return '入力してください';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (desc) => product.description = desc,
                    ),
                    SizesForm(product),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Consumer<Product>(builder: (_, product, __) {
                return SizedBox(
                  height: 50,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    disabledColor:
                        Theme.of(context).primaryColor.withAlpha(100), //null時
                    textColor: Colors.white,
                    onPressed: (!product.loading) //firebase保存中なら
                        ? () async {
                            if (fromKey.currentState.validate()) {
                              //validator条件一致か確認。
                              fromKey.currentState.save(); //＊保存。
                              await product.save(); //firebaseに保存。

                              context.read<ProductManager>().update(product);
                              //update,ここで渡しているproductはクローン
                              //保存が完了したらページをPOPする前に更新。
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            }
                          }
                        : null,
                    child: (product.loading)
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : Text(
                            '保存する',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
