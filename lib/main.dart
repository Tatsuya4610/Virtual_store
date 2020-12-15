import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/cart_manager.dart';
import 'package:virtual_store_flutter/model/cart_product.dart';
import 'package:virtual_store_flutter/model/page_manager.dart';
import 'package:virtual_store_flutter/model/product_manager.dart';
import 'package:virtual_store_flutter/model/user_manager.dart';
import 'package:virtual_store_flutter/screen/base/base_screen.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/screen/cart/cart_screen.dart';
import 'package:virtual_store_flutter/screen/login/login_screen.dart';
import 'package:virtual_store_flutter/screen/product/product_screen.dart';
import 'package:virtual_store_flutter/screen/signup/signup_screen.dart';

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
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          //ログインユーザーの切替りに対応。
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) => cartManager..updateUser(userManager),
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
          SignUPScreen.id: (context) => SignUPScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          ProductScreen.id: (context) => ProductScreen(),
          CartScreen.id: (context) => CartScreen(),
        },
      ),
    );
  }
}
