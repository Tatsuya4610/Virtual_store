import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/common/splash_screen.dart';
import 'package:virtual_store_flutter/model/address.dart';
import 'package:virtual_store_flutter/model/admin_orders_manager.dart';
import 'package:virtual_store_flutter/model/admin_user_manager.dart';
import 'package:virtual_store_flutter/model/cart_manager.dart';
import 'package:virtual_store_flutter/model/home_manager.dart';
import 'package:virtual_store_flutter/model/orders_manager.dart';
import 'package:virtual_store_flutter/model/page_manager.dart';
import 'package:virtual_store_flutter/model/product_manager.dart';
import 'package:virtual_store_flutter/model/stores_manager.dart';
import 'package:virtual_store_flutter/model/user_manager.dart';
import 'package:virtual_store_flutter/screen/address/address_screen.dart';
import 'package:virtual_store_flutter/screen/admin_orders/admin_order_screen.dart';
import 'package:virtual_store_flutter/screen/base/base_screen.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/screen/cart/cart_screen.dart';
import 'package:virtual_store_flutter/screen/checkout/checkout_screen.dart';
import 'package:virtual_store_flutter/screen/confirmation/confirmation_screen.dart';
import 'package:virtual_store_flutter/screen/edit_product/edit_product_screen.dart';
import 'package:virtual_store_flutter/screen/home/home_screen.dart';
import 'package:virtual_store_flutter/screen/login/login_screen.dart';
import 'package:virtual_store_flutter/screen/product/product_screen.dart';
import 'package:virtual_store_flutter/screen/select_product/select_product_screen.dart';
import 'package:virtual_store_flutter/screen/signup/signup_screen.dart';
import 'package:virtual_store_flutter/service/postal.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => PageManager(),
                ),
                ChangeNotifierProvider(
                  create: (_) => UserManager(),
                  lazy: false, //遅延実行しない。立ち開けた時にすぐデーターを取得する。
                  //ない場合は実装していない限り呼ばれない。
                ),
                ChangeNotifierProvider(
                  create: (_) => ProductManager(),
                  lazy: false,
                ),
                ChangeNotifierProvider(
                  create: (_) => HomeManager(),
                  lazy: false,
                ),
                ChangeNotifierProvider(
                  create: (_) => Postal(),
                  lazy: false,
                ),
                ChangeNotifierProvider(
                  create: (_) => Address(),
                  lazy: false,
                ),
                ChangeNotifierProvider(
                  create: (_) => StoresManager(),
                ),
                ChangeNotifierProxyProvider<UserManager, CartManager>(
                  //ログインユーザーの切替りに対応。
                  create: (_) => CartManager(),
                  lazy: false,
                  update: (_, userManager, cartManager) =>
                      cartManager..updateUser(userManager),
                ),
                ChangeNotifierProxyProvider<UserManager, OrdersManager>(
                  create: (_) => OrdersManager(),
                  lazy: false,
                  update: (_, userManager, ordersManager) =>
                      ordersManager..updateUser(userManager.users),
                ),
                ChangeNotifierProxyProvider<UserManager, AdminUserManager>(
                  create: (_) => AdminUserManager(),
                  lazy: false,
                  update: (_, userManager, adminUserManager) =>
                      adminUserManager..updateUser(userManager),
                ),
                ChangeNotifierProxyProvider<UserManager, AdminOrderManager>(
                  create: (_) => AdminOrderManager(),
                  lazy: false,
                  update: (_, userManager, adminOrderManager) =>
                      adminOrderManager..updateAdmin(userManager.adminEnabled),
                ),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: ThemeData(
                    primarySwatch: Colors.teal,
                    scaffoldBackgroundColor: Colors.teal,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    appBarTheme: AppBarTheme(
                      elevation: 0,
                    )),
                home: BaseScreen(),
                routes: {
                  HomeScreen.id: (context) => HomeScreen(),
                  SignUPScreen.id: (context) => SignUPScreen(),
                  LoginScreen.id: (context) => LoginScreen(),
                  ProductScreen.id: (context) => ProductScreen(),
                  CartScreen.id: (context) => CartScreen(),
                  BaseScreen.id: (context) => BaseScreen(),
                  EditProductScreen.id: (context) => EditProductScreen(),
                  SelectProductScreen.id: (context) => SelectProductScreen(),
                  AddressScreen.id: (context) => AddressScreen(),
                  CheckoutScreen.id: (context) => CheckoutScreen(),
                  ConfirmationScreen.id: (context) => ConfirmationScreen(),
                  AdminOrdersScreen.id: (context) => AdminOrdersScreen(),
                },
              ),
            );
          } else { //Firebaseのinitializeが完了するまでの待機画面。
            return SplashScreen();
          }
        });
  }
}
