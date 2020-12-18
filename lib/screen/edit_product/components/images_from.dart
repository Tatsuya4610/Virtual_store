import 'dart:io';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/product.dart';
import 'package:virtual_store_flutter/screen/edit_product/components/image_source_sheet.dart';

class ImagesFrom extends StatelessWidget {
  final Product product;
  ImagesFrom(this.product);
  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(product.images), //編集前の最初のimageを取得。 //クローン
      //元のproduct.imageを変更するため、List.fromで囲む必要あり。
      validator: (image) {
        //画像があるかどうか(全て削除して画像がない場合)。EditProductScreenのFromKeyで確認。
        //state.hasError、エラーテキスト。
        if (image.isEmpty) {
          return '画像を追加してください';
        } else {
          return null;
        }
      },
      onSaved: (images) => product.newImage = images, //ここでのimageはdynamicの為、product.image(String)は不可
      builder: (state) {
        void onImageSelected(File file) {
          //写真かフォトギャラリーから受け取った画像fileをstateに追加。
          state.value.add(file); //*1
          state.didChange(state.value); //*1セット。valueも変更要
          Navigator.of(context).pop();
        }

        return Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                //登録されている画像数分だけスライドショー。
                images: state.value.map<Widget>((image) {
                  //map<Widget>にする理由は..add(Containerも追加する為。
                  return Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      if (image
                          is String) //受け取ったimageがString(URL)ならImageNetWork
                        Image.network(
                          image,
                          fit: BoxFit.cover,
                        )
                      else
                        Image.file(
                          image as File,
                          fit: BoxFit.cover,
                        ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            state.value.remove(image); //*
                            //*1セット。imageを削除した際にstate.value.mapで構築している為、valueも減らさないといけない。
                            state.didChange(state.value);
                          },
                        ),
                      )
                    ],
                  );
                }).toList()
                  ..add(Material(
                    //Materialにしないとcolorが表示されない。タッチ効果が無効。
                    color: Colors.grey[100],
                    child: IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(Icons.add_a_photo),
                      iconSize: 40,
                      onPressed: () {
                        if (Platform.isAndroid)
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => ImageSourceSheet(
                              onImageSelected: onImageSelected,
                            ),
                          );
                        else
                          showCupertinoModalPopup(
                            context: context,
                            builder: (_) => ImageSourceSheet(
                              onImageSelected: onImageSelected,
                            ),
                          );
                      },
                    ),
                  )),
                dotSize: 5,
                dotSpacing: 20, //dotの間隔。
                dotBgColor: Colors.transparent, //dotの枠バーの色。なし。
                dotColor: Theme.of(context).primaryColor,
                autoplay: false, //自動スライド
              ),
            ),
            if (state.hasError) //validatorのif文でエラーがあるなら表示。
              Container(
                margin: EdgeInsets.only(top: 16, left: 16),
                child: Text(
                  state.errorText,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
