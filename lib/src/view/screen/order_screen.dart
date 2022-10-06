import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/badge.dart';
import '../widget/order_item.dart';
import '../../view/widget/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  static const routeName = '/order';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future: cartController.fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error == null) {
                return Obx(
                  () => ListView.builder(
                    itemBuilder: (ctx, i) => OrderItem(
                      orderProduct: cartController.orderItems[i],
                    ),
                    itemCount: cartController.orderItems.length,
                  ),
                );
              } else {
                return const Center(
                  child: Text('An error occurred!'),
                );
              }
            }
          }),
    );
  }
}
