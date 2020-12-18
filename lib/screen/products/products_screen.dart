import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/common/custom_drawer/custom_drawer.dart';
import 'package:virtual_store_flutter/model/product.dart';
import 'package:virtual_store_flutter/model/product_manager.dart';
import 'package:virtual_store_flutter/model/user_manager.dart';
import 'package:virtual_store_flutter/screen/cart/cart_screen.dart';
import 'package:virtual_store_flutter/screen/edit_product/edit_product_screen.dart';
import 'package:virtual_store_flutter/screen/products/components/product_list_tile.dart';
import 'package:virtual_store_flutter/screen/products/components/search_dialog.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Product product = Product(); //
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<ProductManager>(builder: (_, productManager, __) {
          if (productManager.search.isEmpty) {
            return Text('製品一覧');
          } else {
            return LayoutBuilder(
              builder: (_, constraints) {
                return GestureDetector(
                  onTap: () async {
                    final search = await showDialog<String>(
                        //textがpopされた時に渡される。
                        context: context,
                        builder: (_) => SearchDialog(
                              initialText: productManager.search,
                            ));
                    if (search != null) {
                      context.read<ProductManager>().search =
                          search; //showDialog<String>にしないとsearchはdynamic
                    }
                  },
                  child: Container(
                    width: constraints.biggest.width, //横幅の余力を最大
                    child: Text(
                      '${productManager.search}で検索',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            );
          }
        }),
        centerTitle: true,
        actions: <Widget>[
          Consumer<ProductManager>(
            builder: (_, productManager, __) {
              if (productManager.search.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                      //textがpopされた時に渡される。
                      context: context,
                      builder: (_) =>
                          SearchDialog(initialText: productManager.search),
                    );
                    if (search != null) {
                      context.read<ProductManager>().search =
                          search; //showDialog<String>にしないとsearchはdynamic
                    }
                  },
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'リセット',
                      style: TextStyle(fontSize: 10),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        productManager.search = '';
                      },
                    ),
                  ],
                );
              }
            },
          ),
          Consumer<UserManager>(
            builder: (_, userManager, __) {
              if (userManager.adminEnabled) {
                return IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      EditProductScreen.id,
                      arguments: product.clone(), //新規作成なので空のProductを渡す。
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          return ListView.builder(
            padding: EdgeInsets.all(4),
            itemCount: productManager.filteredProducts.length,
            itemBuilder: (ctx, index) {
              return ProductListTile(
                product: productManager.filteredProducts[index],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.shopping_cart,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(CartScreen.id);
        },
      ),
    );
  }
}
