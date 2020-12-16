import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/section.dart';

class SectionHeader extends StatelessWidget {
  final Section section;
  SectionHeader(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(section.name,style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),),
    );
  }
}
