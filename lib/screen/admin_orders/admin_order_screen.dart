import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:virtual_store_flutter/common/costom_icon_button.dart';
import 'package:virtual_store_flutter/common/custom_drawer/custom_drawer.dart';
import 'package:virtual_store_flutter/common/empty_cart.dart';
import 'package:virtual_store_flutter/model/admin_orders_manager.dart';
import 'package:virtual_store_flutter/common/order/order_tile.dart';
import 'package:virtual_store_flutter/model/order.dart';

class AdminOrdersScreen extends StatelessWidget {
  static const id = 'AdminOrdersScreen';
  final PanelController panelController = PanelController(); //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('リクエストメニュー'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrderManager>(builder: (_, adminOrdersManager, __) {
        final filteredOrders = adminOrdersManager.filterOrders;
        return SlidingUpPanel(
          //Dartパッケージ。
          controller: panelController,
          body: Column(
            children: <Widget>[
              if (adminOrdersManager.userFilter != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 2),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${adminOrdersManager.userFilter.name}の注文',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CustomIconButton(
                        iconData: Icons.close,
                        color: Colors.white,
                        onTap: () {
                          adminOrdersManager
                              .setUserFilter(null); //userフィルタークリア。
                        },
                      )
                    ],
                  ),
                ),
              if (filteredOrders.isEmpty)
                Expanded(
                  child: EmptyCard(
                    title: '注文なし',
                    iconData: Icons.border_clear,
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (__, index) {
                      return OrderTile(
                        filteredOrders[index],
                        showControls: true,
                      );
                    },
                  ),
                ),
            ],
          ),
          minHeight: 40,
          maxHeight: 250,
          panel: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                onTap: () { //スクロールが閉じている、開いている状態時。
                  if (panelController.isPanelClosed) {
                    panelController.open();
                  } else {
                    panelController.close();
                  }
                },
                child: Container(
                  height: 40,
                  child: Text(
                    'フィルター',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: Status.values.map((e) {
                  return CheckboxListTile(title: Text(Order.getStatusText(e)),dense: true, value: true, onChanged: (value) {

                  });
                }).toList(),
              ))
            ],
          ),
        );
      }),
    );
  }
}
