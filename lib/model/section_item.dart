class SectionItem {

  SectionItem.formMap(Map<String, dynamic> map) {
    image = map['image'] as String;
    product = map['product'] as String;
  }

  String image;
  String product;

  // @override
  // String toString() {
  //   return 'image : $image';
  // }
}