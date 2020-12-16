import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/common/custom_drawer/custom_drawer.dart';
import 'package:virtual_store_flutter/model/page_manager.dart';
import 'package:virtual_store_flutter/screen/home/home_screen.dart';
import 'package:virtual_store_flutter/screen/products/products_screen.dart';

class BaseScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    Provider.of<PageManager>(context).pageControllers = _pageController;
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(), //スライドでページ移動不可。
      children: <Widget>[
        HomeScreen(),
        Scaffold(
          drawer: CustomDrawer(),
          appBar: AppBar(
            title: Text('Home'),
          ),
        ),
        ProductsScreen(),
        Scaffold(
          drawer: CustomDrawer(),
          appBar: AppBar(
            title: Text('Home1'),
          ),
        ),
        Scaffold(
          drawer: CustomDrawer(),
          appBar: AppBar(
            title: Text('Home2'),
          ),
        ),
        Scaffold(
          drawer: CustomDrawer(),
          appBar: AppBar(
            title: Text('Home3'),
          ),
        ),
      ],
    );
  }
}
