import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view/screen/product_detail_screen.dart';
import '../../model/product.dart';
import '../../controller/product_controller.dart';
import '../../controller/cart_controller.dart';

final ProductController productController = Get.put(ProductController());
final CartController cartController = Get.put(CartController());

class ProductItem extends StatelessWidget {
  final Product? product;

  const ProductItem({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product!.id,
          );
        },
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: GetBuilder(
              builder: (ProductController productController) {
                return IconButton(
                    onPressed: () =>
                        productController.changeFavoriteStatus(product!),
                    icon: Icon(product!.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    color: Theme.of(context).iconTheme.color);
              },
            ),
            title: Text(
              product!.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              onPressed: () {
                cartController.addProduct(
                    product!.id, product!.price, product!.title);
              },
              icon: const Icon(Icons.shopping_cart),
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          child: Image.network(
            product!.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
