import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/common/custom_drawer/custom_drawer_header.dart';
import 'package:virtual_store_flutter/common/custom_drawer/drawer_tile.dart';
import 'package:virtual_store_flutter/model/user_manager.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 200, 230, 240),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            ),
          ),
          ListView(
            children: <Widget>[
              CustomDrawerHeader(),
              Divider(),
              DrawerTile(
                iconData: Icons.home,
                title: 'Home',
                page: 0,
              ),
              DrawerTile(
                iconData: Icons.list,
                title: '製品',
                page: 1,
              ),
              DrawerTile(
                iconData: Icons.playlist_add_check,
                title: 'リクエスト',
                page: 2,
              ),
              DrawerTile(
                iconData: Icons.location_on,
                title: '店舗',
                page: 3,
              ),
              Consumer<UserManager>(builder: (_,userManager,__) {
                if (userManager.adminEnabled) {
                  return Column(
                    children: <Widget>[
                      Divider(),
                      DrawerTile(iconData: Icons.settings, title: 'ユーザー', page: 4),
                      DrawerTile(iconData: Icons.settings, title: 'リクエスト', page: 5),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
            ],
          ),
        ],
      ),
    );
  }
}
