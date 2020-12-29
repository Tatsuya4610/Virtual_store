import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/address.dart';
import 'package:virtual_store_flutter/model/postal_address.dart';


class Postal extends ChangeNotifier {

  Address address;

  bool _townSelectValue = false;
  bool _town1SelectValue = false;
  bool get townSelectValue => _townSelectValue;
  bool get town1SelectValue => _town1SelectValue;



  Future<void> getAddress(String postalCode) async {
    //郵便番号情報取得API元　http://geoapi.heartrails.com/

    final url = 'http://geoapi.heartrails.com/api/json?method=searchByPostal&postal=1130031';

    final Dio dio = Dio(); //Httpパッケージの上位ver

    try {
      Response response = await dio.get(url);
      final data = response.data;
      print(data);
      final addressData = PostalAddress.fromMap(data); //jsonデーターを渡し、データを個別に抽出。
      address = Address( //Addressにデーターを移行。
        prefecture: addressData.prefecture,
        city: addressData.city,
        town: addressData.town,
        town1: addressData.town1,
        latitude: double.parse(addressData.latitude),
        longitude: double.parse(addressData.longitude),
      );
      notifyListeners();
    }  catch (e) {
      Future.error('無効です');
    }
  }

  set townSelect(bool select) {
    _townSelectValue = select;
    _town1SelectValue = false;
    notifyListeners();
  }
  set town1Select(bool select) {
    _town1SelectValue = select;
    _townSelectValue = false;
    notifyListeners();
  }

}