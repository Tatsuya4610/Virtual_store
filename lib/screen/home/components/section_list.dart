import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/home_manager.dart';
import 'package:virtual_store_flutter/model/section.dart';
import 'package:virtual_store_flutter/screen/home/components/add_tile_widget.dart';
import 'package:virtual_store_flutter/screen/home/components/item_tile.dart';
import 'package:virtual_store_flutter/screen/home/components/section_header.dart';
import 'package:provider/provider.dart';

class SectionList extends StatelessWidget {
  final Section section;
  SectionList(this.section);
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
            SizedBox(
              height: 150,
              child: Consumer<Section>( //画像と追加した際に通知を受け取り反映。
                builder: (_,section,__){
                  return ListView.separated(
                    scrollDirection: Axis.horizontal, //水平方向に
                    itemBuilder: (_, index) { //*編集モードで1つ枠を追加される。
                      if (index < section.items.length) {
                        return ItemTile(section.items[index]);
                      } else {
                        return AddTileWidget(); //編集モードで1枠追加され、indexが多い場合。
                      }

                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 4), //画像との間隔。
                    itemCount: homeManager.editing
                        ? section.items.length + 1 //*編集モードの場合は編集追加用に1枠作成する。
                        : section.items.length,
                  );
                },
              )
            )
          ],
        ),
      ),
    );
  }
}
