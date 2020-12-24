import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/common/custom_drawer/custom_drawer.dart';
import 'package:virtual_store_flutter/model/home_manager.dart';
import 'package:virtual_store_flutter/model/user_manager.dart';
import 'package:virtual_store_flutter/screen/cart/cart_screen.dart';
import 'package:virtual_store_flutter/screen/home/components/add_section_widget.dart';
import 'package:virtual_store_flutter/screen/home/components/section_list.dart';
import 'package:virtual_store_flutter/screen/home/components/section_promotion.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: const [
                Color.fromRGBO(0, 221, 255, 100),
                Color.fromRGBO(208, 255, 0, 100),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
          ),
          CustomScrollView(
            //一画面で複数のスクロール要素を構築する。
            slivers: <Widget>[
              SliverAppBar(
                snap: true, //*1
                floating: true, //*1セット、下までスクロールしても少し上へスクロールするとAppBar表示。
                backgroundColor: Colors.transparent, //上記のStackグラデーションと同じ色。
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('Myショップ'),
                  centerTitle: true,
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.id);
                    },
                  ),
                  Consumer2<UserManager, HomeManager>(
                      builder: (_, userManager, homeManager, __) {
                    if (userManager.adminEnabled) {
                      //管理者かどうか。
                      if (homeManager.editing) {
                        //管理者で編集モードかどうか。
                        return PopupMenuButton(onSelected: (e) {
                          if (e == '保存する') {
                            homeManager.saveEditing();
                          } else {
                            homeManager.discardEditing();
                          }
                        }, itemBuilder: (_) {
                          return ['保存する', '編集破棄'].map((e) {
                            return PopupMenuItem(value: e, child: Text(e));
                          }).toList();
                        });
                      } else {
                        //編集モードで無ければ。
                        return IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: homeManager.enterEditing,
                        );
                      }
                    } else {
                      //管理者で無ければ非表示。
                      return Container();
                    }
                  })
                ],
              ),
              Consumer<HomeManager>(builder: (_, homeManager, __) {
                final List<Widget> children =
                    homeManager.sections.map<Widget>((section) {
                  switch (section.type) {
                    //(例)print(section){type: List, name: 今日の商品, items<List> : Map{image: url}} *firebaseのフィールド内
                    case 'List':
                      return SectionList(section);
                    case 'promotion':
                      return SectionPromotion(section);
                    default:
                      return Container();
                  }
                }).toList();

                if (homeManager.editing) //childrenのWidgetを追加。
                  children.add(AddSectionWidget(homeManager));

                return SliverList(
                  //各々のWidgetsごとにスクロール。
                  delegate: SliverChildListDelegate(children),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
