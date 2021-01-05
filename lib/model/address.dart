

import 'package:flutter/foundation.dart';

class Address extends ChangeNotifier {
  Address({this.prefecture,this.city,this.town,this.town1,this.postal, this.latitude,this.longitude});
  String prefecture; //都道府県
  String city; //区
  String town; //町
  String town1;
  String postal; //郵便番号
  String _ollStreetAddress; //全ての住所情報。
  String _subStreetAddress;
  double longitude; //経度
  double latitude; //緯度

  set ollStreetAddress(String value) {
    _ollStreetAddress = value;
    notifyListeners();
  }

  set subStreetAddress(String value) {
    _subStreetAddress = value;
    notifyListeners();
  }

  String get ollStreetAddress => _ollStreetAddress;
  String get subStreetAddress => _subStreetAddress;





}
