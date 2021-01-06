import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/address.dart';
import 'package:virtual_store_flutter/model/admin_orders_manager.dart';
import 'package:virtual_store_flutter/model/admin_user_manager.dart';
import 'package:virtual_store_flutter/model/cart_manager.dart';
import 'package:virtual_store_flutter/model/home_manager.dart';
import 'package:virtual_store_flutter/model/orders_manager.dart';
import 'package:virtual_store_flutter/model/page_manager.dart';
import 'package:virtual_store_flutter/model/product_manager.dart';
import 'package:virtual_store_flutter/model/user_manager.dart';
import 'package:virtual_store_flutter/screen/address/address_screen.dart';
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

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PageManager(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false, //遅延実行しない。
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
              ordersManager..updateUser(userManager.user),
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
        },
      ),
    );
  }
}
