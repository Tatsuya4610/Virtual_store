import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:virtual_store_flutter/model/section.dart';
import 'package:virtual_store_flutter/screen/home/components/item_tile.dart';
import 'package:virtual_store_flutter/screen/home/components/section_header.dart';

class SectionPromotion extends StatelessWidget {
  final Section section;
  SectionPromotion(this.section);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionHeader(section),
          StaggeredGridView.countBuilder( //Dartパッケージ。
            padding: EdgeInsets.zero, //元々Padding付いてる
            shrinkWrap: true, //shrinkWrapをtrueにしないと無限の高さを取得してしまう。最小限に画面を占領する。
            crossAxisCount: 4,//一つの正方形に4つ
            itemCount: section.items.length,
            itemBuilder: (BuildContext context, int index) =>
            ItemTile(section.items[index]),
            staggeredTileBuilder: (int index) =>
                StaggeredTile.count(2, index.isEven ? 2 : 1),
            mainAxisSpacing: 4.0, //縦間隔
            crossAxisSpacing: 4.0, //横間隔
          )
        ],
      ),
    );
  }
}
