import 'package:flutter/material.dart';
import 'package:virtual_store_flutter/model/page_manager.dart';
import 'package:virtual_store_flutter/model/user_manager.dart';
import 'package:virtual_store_flutter/screen/base/base_screen.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store_flutter/screen/login/login_screen.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => PageManager(),
          ),
          ChangeNotifierProvider(
            create: (_) => UserManager(),
          ),
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            elevation: 0,
          )),
      home: LoginScreen(),
    );
  }
}
