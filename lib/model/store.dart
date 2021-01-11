import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/helper/extensions.dart';

enum StoreStatus { closed, open, closing }

class Store {
  Store.formDocument(DocumentSnapshot doc) {
    name = doc.data['name'] as String;
    image = doc.data['image'] as String;
    phone = doc.data['phone'] as int;
    address = doc.data['address'] as String;
    lat = doc.data['lat'] as double;
    lon = doc.data['lon'] as double;
    opening = (doc.data['opening'] as Map<String, dynamic>).map((key, value) {
      final timesString = value as String;
      if (timesString != null && timesString.isNotEmpty) {
        final splitted = timesString
            .split(RegExp(r"[:-]")); //"8:00-12:00" ⇨　["8","00","12" , "00]
        return MapEntry(key, {
          "from": TimeOfDay(
            //8:00
            hour: int.parse(splitted[0]), //8
            minute: int.parse(splitted[1]), //00
          ),
          "to": TimeOfDay(
            //12:00
            hour: int.parse(splitted[2]), //12
            minute: int.parse(splitted[3]), //00
          )
        });
      } else {
        return MapEntry(key, null);
      }
    });
    updateStatus(); //情報取得した際の店の営業状態を取得。
  }

  String name;
  String image;
  int phone;
  String address;
  Map<String, Map<String, TimeOfDay>> opening;
  StoreStatus status;
  double lat;
  double lon;

  String get openingText {
    return '月曜日〜金曜 : ${formattedPeriod(opening['monfri'])}\n'
        '土曜日 : ${formattedPeriod(opening['saturday'])}\n'
        '日曜、祝日 : お休み';
  }

  String formattedPeriod(Map<String, TimeOfDay> period) {
    if (period == null) return 'お休み';
    return '${period['from'].formatted()} - ${period['to'].formatted()}';
    //formattedを作成しないと、TimeOfDayがそのまま反映される。
  }


  void updateStatus() { //店舗営業状況。
    final weekDay = DateTime.now().weekday; //今日の曜日
    Map<String, TimeOfDay> period;
    if (weekDay >= 1 && weekDay <= 5) {
      //月曜日から金曜日だった場合
      period = opening['monfri'];
    } else if (weekDay == 6) {
      period = opening['saturday'];
    } else {
      period = null;
    }

    final now = TimeOfDay.now();

    if (period == null) {
      status = StoreStatus.closed;
    } else if (period['from'].toMinutes() < now.toMinutes() &&
        period['to'].toMinutes() - 15 > now.toMinutes()) { //開店時間と閉店時間を現在時間と比較
      status = StoreStatus.open;
    } else if (period['from'].toMinutes() < now.toMinutes() &&
        period['to'].toMinutes()  > now.toMinutes()) {
      status = StoreStatus.closing;
    } else {
      status = StoreStatus.closed;
    }
  }

  String get statusText {
    switch(status){
      case StoreStatus.closed:
        return '営業時間外';
      case StoreStatus.closing:
        return 'もうすぐ閉店します';
      case StoreStatus.open:
        return '営業中';
      default:
        return '';
    }
  }

}
