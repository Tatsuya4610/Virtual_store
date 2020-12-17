import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function onImageSelected;
  ImageSourceSheet({this.onImageSelected});

  final ImagePicker picker = ImagePicker();

  Future<void> editImage(String path, BuildContext context) async {
    final File cropperFile = await ImageCropper.cropImage(//画像の編集。Dartパッケージ＊ImageCropper
      sourcePath: path,
      aspectRatio: CropAspectRatio(
        //画像のアスペクト比。最初の編集画面を全体像ではなく1対1対比。
        ratioX: 1.0,
        ratioY: 1.0,
      ),
      androidUiSettings: AndroidUiSettings(
        //AndroidのUI
        toolbarTitle: '編集画像',
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white,
      ),
      iosUiSettings: IOSUiSettings(
        title: '編集画像',
        cancelButtonTitle: 'キャンセル',
        doneButtonTitle: '閉じる',
      )
    );
    if (cropperFile != null) { //編集キャンセルされずに完了されたら渡す。
      onImageSelected(cropperFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid)
      return BottomSheet(
        onClosing: () {},
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min, //必要最低限のサイズ。
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FlatButton(
              onPressed: () async {
                final PickedFile file =
                    await picker.getImage(source: ImageSource.camera);
                editImage(file.path, context); //撮影したが画像を渡す
              },
              child: Text('カメラ'),
            ),
            FlatButton(
              onPressed: () async {
                final PickedFile file =
                    await picker.getImage(source: ImageSource.gallery);
                editImage(file.path, context);
              },
              child: Text('フォトギャラリー'),
            ),
          ],
        ),
      );
    else
      return CupertinoActionSheet(
        title: Text('写真アイテムを選択'),
        message: Text('写真を選択してください'),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('キャンセル'),
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () async {
              final PickedFile file =
                  await picker.getImage(source: ImageSource.camera);
              editImage(file.path, context); //撮影したが画像を渡す
            },
            child: Text('カメラ'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              final PickedFile file =
                  await picker.getImage(source: ImageSource.camera);
              editImage(file.path, context); //撮影したが画像を渡す
            },
            child: Text('フォトギャラリー'),
          ),
        ],
      );
  }
}
