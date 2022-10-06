import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/product_controller.dart';
import '../widget/user_product_item.dart';
import '../widget/app_drawer.dart';
import '../screen/edit_product_screen.dart';

final ProductController productController = Get.find();

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);
  static const routeName = '/user-product';
  Future<void> _refreshProduct() async {
    await productController.fetchDataAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your product'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProduct(),
        builder: (ctx, snapshot) => (snapshot.connectionState ==
                ConnectionState.waiting)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: _refreshProduct,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Obx(
                    () => ListView.builder(
                      itemCount: productController.allProducts.length,
                      itemBuilder: (_, i) => Column(
                        children: [
                          UserProductItem(
                            id: productController.allProducts[i].id,
                            title: productController.allProducts[i].title,
                            imageUrl: productController.allProducts[i].imageUrl,
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
