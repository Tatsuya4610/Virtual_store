import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/common/custom_drawer/custom_drawer.dart';
import 'package:virtual_store_flutter/common/empty_cart.dart';
import 'package:virtual_store_flutter/common/login_card.dart';
import 'package:virtual_store_flutter/model/orders_manager.dart';
import 'package:virtual_store_flutter/common/order/order_tile.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('リクエストメニュー'),
        centerTitle: true,
      ),
      body: Consumer<OrdersManager>(
        builder: (_, ordersManager, __) {
          if (ordersManager.users == null) {
            return LoginCard();
          }
          if (ordersManager.orders.isEmpty) {
            return EmptyCard(
              title: '注文履歴がありません',
              iconData: Icons.border_clear,
            );
          }
          return ListView.builder(
            itemCount: ordersManager.orders.length,
            itemBuilder: (__, index) {
              return OrderTile(
                ordersManager.orders.reversed.toList()[index],
              ); //reversed.toList()逆順番
            },
          );
        },
      ),
    );
  }
}
