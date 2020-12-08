import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({this.email, this.password, this.name, this.confirmPassword, this.id});

  User.formDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document.data['name'];
    email = document.data['email'];
  }

  String id;
  String name;
  String email;
  String password;
  String confirmPassword;

  Future<void> saveData() async { //ユーザーidごとにデーターを保存。
    try {
      await Firestore.instance.collection('users').document(id).setData({
        'name': name,
        'email': email,
      });
    } catch (error) {
      print(error);
    }
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'name': name,
  //     'email': email,
  //   };
  // }
}
