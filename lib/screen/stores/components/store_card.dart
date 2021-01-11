import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:virtual_store_flutter/common/costom_icon_button.dart';
import 'package:virtual_store_flutter/model/store.dart';

class StoreCard extends StatelessWidget {
  StoreCard(this.store);

  final Store store;
  @override
  Widget build(BuildContext context) {
    Color colorStatus(StoreStatus status) {
      switch (status) {
        case StoreStatus.closed:
          return Colors.red;
        case StoreStatus.open:
          return Colors.green;
        case StoreStatus.closing:
          return Colors.yellow;
        default:
          return Colors.green;
      }
    }

    Future openMap() async {
      //Dartパッケージ。map_launcher
      try {
        final availableMaps = await MapLauncher.installedMaps;
        showModalBottomSheet(
            context: context,
            builder: (_) {
              return SafeArea(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (final map in availableMaps)
                    ListTile(
                      onTap: () {
                        map.showMarker(
                          coords: Coords(store.lat, store.lon),
                          title: store.name,
                          description: store.address,
                        );
                        Navigator.of(context).pop();
                      },
                      title: Text(map.mapName),
                      leading: Image(
                        image: map.icon,
                        width: 30,
                        height: 30,
                      ),
                    )
                ],
              ));
            });
      } catch (e) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('ご利用できません'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Card(
      clipBehavior: Clip.antiAlias, //角丸く
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image.network(store.image),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  color: Colors.white,
                  child: Text(
                    store.statusText,
                    style: TextStyle(
                      color: colorStatus(store.status),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 180,
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        store.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(width: 5),
                      Row(
                        children: <Widget>[
                          Text(
                            store.address,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          CustomIconButton(
                            size: 18,
                            iconData: Icons.map,
                            color: Theme.of(context).primaryColor,
                            onTap: openMap,
                          ),
                        ],
                      ),
                      Text('TEL: ${store.phone.toString()}'),
                      Text(
                        store.openingText,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
