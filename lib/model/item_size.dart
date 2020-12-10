class ItemSize {
  ItemSize.formMap(Map<String, dynamic> map) {
    name = map['name'] as String;
    price = map['price'] as int;
    stock = map['stock'] as int;
  }

  String name;
  int price;
  int stock;

  bool get hasStock => stock > 0; //ストックがあるかどうか。

  // @override
  // String toString() {
  //   return 'ItemSize{name: $name, price: $price, stock :$stock';
  // }
}
