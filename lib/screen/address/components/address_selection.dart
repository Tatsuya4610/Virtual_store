import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/address.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/service/postal.dart';

class AddressSelection extends StatelessWidget {
  AddressSelection(this.address);
  final Address address;

  @override
  Widget build(BuildContext context) {
    final town = '${address.prefecture}${address.city}${address.town}';
    final town1 = '${address.prefecture}${address.city}${address.town1}';
    final townSelect = context.watch<Postal>();
    return Column(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              TownSelect(town: town,townSelect: townSelect.townSelectValue,onSelect: (val) {
                townSelect.townSelect = val;
              },),
              TownSelect(town: town1,townSelect: townSelect.town1SelectValue,onSelect: (val) {
                townSelect.town1Select = val;
              },),
            ],
          ),
        )
      ],
    );
  }
}

class TownSelect extends StatelessWidget {
  TownSelect({this.town, this.townSelect,this.onSelect});
  final String town;
  final bool townSelect;
  final onSelect;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(town),
        Checkbox(
          value: townSelect,
          onChanged: onSelect,
        ),
      ],
    );
  }
}
