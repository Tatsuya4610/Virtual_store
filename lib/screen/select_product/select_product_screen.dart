import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/model/product_manager.dart';

class SelectProductScreen extends StatelessWidget {
  static const id = 'SelectProduct';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('製品をリンク'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          return ListView.builder(
            itemCount: productManager.allProducts.length,
            itemBuilder: (_, index) {
              final product = productManager.allProducts[index];
              return ListTile(
                leading: Image.network(product.images.first),
                title: Text(product.name),
                subtitle: Text('${product.basePrice.toString()}円'),
                onTap: () {
                  Navigator.of(context).pop(product); //閉じた時に該当のproductをitem_tileへ渡し。
                },
              );
            },
          );
        },
      ),
    );
  }
}
