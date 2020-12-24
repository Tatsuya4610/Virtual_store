import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:virtual_store_flutter/model/home_manager.dart';
import 'package:virtual_store_flutter/model/section.dart';
import 'package:virtual_store_flutter/screen/home/components/add_tile_widget.dart';
import 'package:virtual_store_flutter/screen/home/components/item_tile.dart';
import 'package:virtual_store_flutter/screen/home/components/section_header.dart';
import 'package:provider/provider.dart';

class SectionPromotion extends StatelessWidget {
  final Section section;
  SectionPromotion(this.section);
  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionHeader(),
            Consumer<Section>(builder: (_,section,__) { //画像と追加した際に通知を受け取り反映。
              return StaggeredGridView.countBuilder(
                //Dartパッケージ。
                padding: EdgeInsets.zero, //元々Padding付いてる
                shrinkWrap: true, //shrinkWrapをtrueにしないと無限の高さを取得してしまう。最小限に画面を占領する。
                crossAxisCount: 4, //一つの正方形に4つ
                physics: NeverScrollableScrollPhysics(), //個々のWidgetをスクロールしない。全体のスクロールがスムーズ
                itemCount: homeManager.editing
                    ? section.items.length + 1 //＊編集モードなら追加用に1枠。
                    : section.items.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index < section.items.length) {
                    return ItemTile(section.items[index]);
                  } else {
                    return AddTileWidget(); //＊編集モードで1枠追加され、indexが多くなった場合。
                  }
                },
                staggeredTileBuilder: (int index) =>
                    StaggeredTile.count(2, index.isEven ? 2 : 1),
                mainAxisSpacing: 4.0, //縦間隔
                crossAxisSpacing: 4.0, //横間隔
              );
            })
          ],
        ),
      ),
    );
  }
}
