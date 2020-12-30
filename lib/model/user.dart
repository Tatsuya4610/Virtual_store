import 'package:cloud_firestore/cloud_firestore.dart';

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

  DocumentReference get fireStoreRef => Firestore.instance.document('users/$id'); //user別のドキュメントを取得。

  CollectionReference get cartReference => fireStoreRef.collection('cart'); // ユーザー別のカート。

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
}
