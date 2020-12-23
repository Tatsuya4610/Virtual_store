import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/section.dart';
import 'package:virtual_store_flutter/screen/home/components/item_tile.dart';
import 'package:virtual_store_flutter/screen/home/components/section_header.dart';


class SectionList extends StatelessWidget {
  final Section section;
  SectionList(this.section);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionHeader(section),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal, //水平方向に
              itemBuilder: (_, index) {
                return ItemTile(section.items[index]);
              },
              separatorBuilder: (_, __) => const SizedBox(width: 4), //画像との間隔。
              itemCount: section.items.length,
            ),
          )
        ],
      ),
    );
  }
}
