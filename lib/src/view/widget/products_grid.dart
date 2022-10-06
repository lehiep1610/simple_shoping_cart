import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './product_item.dart';
import '../../controller/product_controller.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs, {Key? key}) : super(key: key);
  final ProductController productController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: showFavs
            ? productController.favoriteProduct.length
            : productController.allProducts.length,
        itemBuilder: (ctx, index) => ProductItem(
          product: showFavs
              ? productController.favoriteProduct[index]
              : productController.allProducts[index],
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
      );
    });
  }
}
