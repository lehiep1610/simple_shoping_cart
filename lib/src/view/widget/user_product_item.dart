import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/product_controller.dart';
import '../../controller/cart_controller.dart';
import '../screen/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem(
      {Key? key, required this.id, required this.title, required this.imageUrl})
      : super(key: key);

  final String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find();
    final CartController cartController = Get.find();
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context)
                .pushNamed(EditProductScreen.routeName, arguments: id),
            icon: const Icon(Icons.edit),
            color: Colors.grey,
          ),
          IconButton(
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Are you sure?'),
                  content: Text('Do you want to remove $title from the list?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          await productController.deleteProduct(id);
                          Get.snackbar(
                            'Deleting successful',
                            'An item has been remove!',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2),
                            colorText: Colors.black,
                            backgroundColor: Colors.white70,
                          );
                        } catch (error) {
                          Get.snackbar(
                            'An error occurred',
                            Exception().toString(),
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2),
                            colorText: Colors.black,
                            backgroundColor: Colors.white70,
                          );
                        }
                        cartController.removeProduct(id);
                        Navigator.pop(context);
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete),
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
