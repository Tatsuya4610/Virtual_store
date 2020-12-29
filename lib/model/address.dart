

class Address {

  Address({this.prefecture,this.city,this.town,this.town1, this.latitude,this.longitude});
  String prefecture; //都道府県
  String city; //区
  String town; //町
  String town1;
  String ollStreetAddress; //全ての住所情報。
  String subStreetAddress;
  double longitude; //経度
  double latitude; //緯度

}
