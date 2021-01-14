import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Users {
  Users({this.email, this.password, this.name, this.confirmPassword, this.id});

  Users.formDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.data()['name'];
    email = document.data()['email'];
    subname = document.data()['subname'];
  }

  String id;
  String name;
  String email;
  String password;
  String confirmPassword;
  String subname;
  bool admin = false;

  DocumentReference get fireStoreRef =>
      FirebaseFirestore.instance.doc('users/$id'); //user別のドキュメントを取得。

  CollectionReference get cartReference =>
      fireStoreRef.collection('cart'); // ユーザー別のカート。
  CollectionReference get tokenReference =>
      fireStoreRef.collection('tokens'); // ユーザー別のtoken

  Future<void> saveData() async {
    //ユーザーidごとにデーターを保存。
    try {
      await FirebaseFirestore.instance.collection('users').doc(id).set({
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
      await tokenReference.doc(token).set({
        'token': token,
        'updatedAt': FieldValue.serverTimestamp(),
        'platform' : Platform.operatingSystem,
      });
    } catch (e, s) {
      print(s);
    }
  }
}
