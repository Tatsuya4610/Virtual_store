import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/common/custom_drawer/custom_drawer.dart';
import 'package:virtual_store_flutter/model/page_manager.dart';
import 'package:virtual_store_flutter/model/user_manager.dart';
import 'package:virtual_store_flutter/screen/admin_user/admin_user_screen.dart';
import 'package:virtual_store_flutter/screen/home/home_screen.dart';
import 'package:virtual_store_flutter/screen/products/products_screen.dart';

class BaseScreen extends StatelessWidget {
  static const id = 'BaseScreen';
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    Provider.of<PageManager>(context).pageControllers = _pageController;
    return Consumer<UserManager>(builder: (_,userManager,__) {
      return PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), //スライドでページ移動不可。
        children: <Widget>[
          HomeScreen(), //1
          ProductsScreen(), //2
          Scaffold( //3
            drawer: CustomDrawer(),
            appBar: AppBar(
              title: Text('リクエスト'),
            ),
          ),
          Scaffold( //3
            drawer: CustomDrawer(),
            appBar: AppBar(
              title: Text('店舗'),
            ),
          ),
          if (userManager.adminEnabled) ...[ //5,6番目と認識。
            AdminUserScreen(),
            Scaffold( //6
              drawer: CustomDrawer(),
              appBar: AppBar(
                title: Text('リクエスト'),
              ),
            ),
          ]
        ],
      );
    });
  }
}
