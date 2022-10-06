import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/product_in_cart.dart';
import '../model/orders.dart';
import '../model/product.dart';
import '../controller/auth_controller.dart';

class CartController extends GetxController {
  RxMap<String, ProduceInCart> cartProduct = <String, ProduceInCart>{}.obs;
  RxList<OrderProduct> orderItems = <OrderProduct>[].obs;
  RxDouble totalPrice = 0.0.obs;
  final AuthController authController = Get.find();

  void addProduct(String productId, double price, String title) {
    if (cartProduct.containsKey(productId)) {
      cartProduct.update(
        productId,
        (existingCartItem) => ProduceInCart(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity + 1,
            price: existingCartItem.price),
      );
    } else {
      cartProduct.putIfAbsent(
        productId,
        () => ProduceInCart(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price),
      );
    }

    Get.back();
    Get.snackbar(
      'Product Added',
      '',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
      colorText: Colors.black,
      backgroundColor: Colors.white70,
      mainButton: TextButton(
        onPressed: () {
          removeSingleItem(productId);
          Get.closeCurrentSnackbar();
        },
        child: const Text('UNDO'),
      ),
      messageText: Text(
        'you have added the $title to the cart',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  void decreaseItem(String productId) {
    if (cartProduct[productId]!.quantity >= 1) {
      cartProduct.update(productId, (existingCartItem) {
        return ProduceInCart(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity - 1,
            price: existingCartItem.price);
      });
    }
  }

  void increaseItem(String productId) {
    cartProduct.update(
      productId,
      (existingCartItem) => ProduceInCart(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price),
    );
  }

  void updateProduct(String id, Product newProduct) {
    if (cartProduct.containsKey(id)) {
      cartProduct.update(
        id,
        (existingCartItem) => ProduceInCart(
            id: existingCartItem.id,
            title: newProduct.title,
            quantity: existingCartItem.quantity,
            price: newProduct.price),
      );
    }
  }

  void removeProduct(String productId) {
    if (cartProduct.containsKey(productId)) cartProduct.remove(productId);
  }

  void removeSingleItem(String productId) {
    if (!cartProduct.containsKey(productId)) {
      return;
    }
    if (cartProduct[productId]!.quantity == 0) {
      cartProduct.remove(productId);
    } else {
      decreaseItem(productId);
    }

    update();
  }

  double totalAmount() {
    totalPrice.value = 0;
    cartProduct.forEach((key, cartItem) {
      totalPrice.value += cartItem.price * cartItem.quantity;
    });
    return totalPrice.value;
  }

  double productAmount(String productId) {
    double productAmount = 0.0;
    productAmount =
        cartProduct[productId]!.price * cartProduct[productId]!.quantity;
    return productAmount;
  }

  int productQuantity(String productId) {
    for (var value in cartProduct.values) {
      if (value.id == productId) return value.quantity;
    }
    return 0;
  }

  Future<void> addOrder() async {
    final url = Uri.parse(
        'https://shop-app-demo-213d6-default-rtdb.asia-southeast1.firebasedatabase.app/orders/${authController.userId}.json?auth=${authController.token}');
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': totalPrice.value.toStringAsFixed(2),
        'dateTime': timestamp.toIso8601String(),
        'products': cartProduct.values
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    orderItems.insert(
      0,
      OrderProduct(
        id: json.decode(response.body)['name'],
        amount: totalPrice.value,
        products: cartProduct.values.toList(),
        dateTime: timestamp,
      ),
    );
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shop-app-demo-213d6-default-rtdb.asia-southeast1.firebasedatabase.app/orders/${authController.userId}.json?auth=${authController.token}');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      final List<OrderProduct> loadedOrders = [];

      extractedData?.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderProduct(
              id: orderId,
              amount: double.parse(orderData['amount']),
              dateTime: DateTime.parse(orderData['dateTime']),
              products: ((orderData['products'] ?? []) as List<dynamic>)
                  .map((item) => ProduceInCart(
                        id: item['id'],
                        price: item['price'],
                        quantity: item['quantity'],
                        title: item['title'],
                      ))
                  .toList()),
        );
      });
      orderItems.value = loadedOrders.reversed.toList();
    } catch (error) {
      rethrow;
    }
  }

  void clear() {
    totalPrice.value = 0;
    cartProduct.clear();
  }
}
