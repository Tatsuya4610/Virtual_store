import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/common/costom_icon_button.dart';
import 'package:virtual_store_flutter/model/home_manager.dart';
import 'package:virtual_store_flutter/model/section.dart';
import 'package:provider/provider.dart';

class SectionHeader extends StatelessWidget {
  final Section section;
  SectionHeader(this.section);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    if (homeManager.editing) {
      return Row(
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
              onChanged: (text) => section.name,
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
