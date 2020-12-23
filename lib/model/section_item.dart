class SectionItem {

  SectionItem({this.image,this.product});

  SectionItem.formMap(Map<String, dynamic> map) {
    image = map['image'] as String;
    product = map['product'] as String;
  }

  String image;
  String product;

  SectionItem clone() {
    return SectionItem(
      image: image,
      product: product,
    );
}

  // @override
  // String toString() {
  //   return 'image : $image';
  // }
}