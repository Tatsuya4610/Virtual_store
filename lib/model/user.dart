import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class User {
  User({this.email, this.password, this.name, this.confirmPassword, this.id});

  User.formDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document.data['name'];
    email = document.data['email'];
    subname = document.data['subname'];
  }

  String id;
  String name;
  String email;
  String password;
  String confirmPassword;
  String subname;
  bool admin = false;

  DocumentReference get fireStoreRef =>
      Firestore.instance.document('users/$id'); //user別のドキュメントを取得。

  CollectionReference get cartReference =>
      fireStoreRef.collection('cart'); // ユーザー別のカート。
  CollectionReference get tokenReference =>
      fireStoreRef.collection('tokens'); // ユーザー別のtoken

  Future<void> saveData() async {
    //ユーザーidごとにデーターを保存。
    try {
      await Firestore.instance.collection('users').document(id).setData({
        'name': name,
        'subname': subname,
        'email': email,
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> saveToken() async {
    //Dartパッケージ。firebase_messaging
    final token = await FirebaseMessaging().getToken();
    try {
      //FieldValue.serverTimestamp(),時間軸を全てサーバーに預けてモバイルの個体差によるずれを解消する
      await tokenReference.document(token).setData({
        'token': token,
        'updatedAt': FieldValue.serverTimestamp(),
        'platform' : Platform.operatingSystem,
      });
    } catch (e, s) {
      print(s);
    }
  }
}
