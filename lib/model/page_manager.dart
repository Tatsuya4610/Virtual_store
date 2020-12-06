import 'package:flutter/material.dart';

class PageManager extends ChangeNotifier {

  PageController _pageController;

  set pageControllers(PageController controller) { //pageController受け取り。
    _pageController = controller;
  }

  int _page = 0; //選択中のページ。

  int get page {
    return _page;
  }

  void setPage(int value) { //PageViewのchildren<Widgets>内のlengths番目へ移動。
    if (value == _page) return; //今いるページと同じページにいる場合はストップ。
    _page = value;
    _pageController.jumpToPage(value); //ページ移動。
  }

}