import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/src/controller/auth_controller.dart';

import './src/view/screen/product_detail_screen.dart';
import './src/view/screen/product_overview_screen.dart';
import './src/view/screen/cart_screen.dart';
import './src/view/screen/order_screen.dart';
import './src/view/screen/user_product_screen.dart';
import './src/view/screen/edit_product_screen.dart';
import './src/view/screen/auth_screen.dart';
import './src/view/screen/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Lato',
        iconTheme: const IconThemeData(color: Colors.grey),
      ),
      home: Obx(
        () => authController.isAuth
            ? const ProductOverviewScreen()
            : FutureBuilder(
                future: authController.tryAutoLogin(),
                builder: (ctx, authResultSnapshot) =>
                    authResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? const SplashScreen()
                        : const AuthScreen()),
      ),
      routes: {
        ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
        CartScreen.routeName: (ctx) => const CartScreen(),
        OrderScreen.routeName: (ctx) => const OrderScreen(),
        UserProductScreen.routeName: (ctx) => const UserProductScreen(),
        EditProductScreen.routeName: (ctx) => const EditProductScreen(),
        ProductOverviewScreen.routeName: (ctx) => const ProductOverviewScreen(),
      },
    );
  }
}
