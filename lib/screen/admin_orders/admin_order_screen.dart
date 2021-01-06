import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/common/custom_drawer/custom_drawer.dart';
import 'package:virtual_store_flutter/common/empty_cart.dart';
import 'package:virtual_store_flutter/model/admin_orders_manager.dart';
import 'package:virtual_store_flutter/common/order_tile.dart';

class AdminOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('リクエストメニュー'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrderManager>(
        builder: (_, adminOrdersManager, __) {
          if (adminOrdersManager.orders.isEmpty) {
            return EmptyCard(
              title: '注文修正',
              iconData: Icons.border_clear,
            );
          }
          return ListView.builder(
            itemCount: adminOrdersManager.orders.length,
            itemBuilder: (__, index) {
              return OrderTile(
                adminOrdersManager.orders.reversed.toList()[index],
              ); //reversed.toList()逆順番
            },
          );
        },
      ),
    );
  }
}
