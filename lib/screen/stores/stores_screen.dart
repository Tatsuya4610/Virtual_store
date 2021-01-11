import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/common/custom_drawer/custom_drawer.dart';
import 'package:virtual_store_flutter/model/stores_manager.dart';
import 'package:virtual_store_flutter/screen/stores/components/store_card.dart';

class StoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('お店一覧'),
        centerTitle: true,
      ),
      body: Consumer<StoresManager>(
        builder: (_,storesManager,__) {
          if (storesManager.stores.isEmpty) { //lazy: false,にしていない為、ページを開いた時にデーターを
            //取得し表示する為、ページ移行直後は待機表示にする。
            return LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
              backgroundColor: Colors.transparent,
            );
          }
          return ListView.builder(itemCount: storesManager.stores.length, itemBuilder: (_,index) {
            return StoreCard(storesManager.stores[index]);
          });
        },
      ),
    );
  }
}
