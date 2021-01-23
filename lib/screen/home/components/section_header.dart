import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/common/costom_icon_button.dart';
import 'package:virtual_store_flutter/model/home_manager.dart';
import 'package:virtual_store_flutter/model/section.dart';
import 'package:provider/provider.dart';

class SectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    final section = context.watch<Section>();

    if (homeManager.editing) {
      return Column(
        children: <Widget>[
          Text('画像長押しでリンクまたは削除可能。',style: TextStyle(color: Colors.white),),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  initialValue: section.name,
                  decoration: InputDecoration(
                    hintText: '題名',
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  onChanged: (text) => section.name = text, //＊自動的に渡す。
                ),
              ),
              CustomIconButton(
                iconData: Icons.remove,
                color: Colors.white,
                onTap: () {
                  homeManager.removeSection(section);
                },
              )
            ],
          ),
          if (section.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(section.error,
                  style: TextStyle(color: Colors.red,fontWeight: FontWeight.w700)),
            ), //＊渡されたtextにerror該当する場合は
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          section.name ?? 'バナナ', //nullだったら空。
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      );
    }
  }
}
