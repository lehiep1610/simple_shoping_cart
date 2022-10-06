import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/cart_controller.dart';
import '../../view/widget/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Obx(
                      () => Text(
                        '\$${cartController.totalAmount().toStringAsFixed(2)}',
                      ),
                    ),
                    backgroundColor: Theme.of(context).iconTheme.color,
                  ),
                  OrderButton(cartController: cartController)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: cartController.cartProduct.length,
                itemBuilder: (ctx, index) => CartItem(
                    id: cartController.cartProduct.values.toList()[index].id,
                    productId: cartController.cartProduct.keys.toList()[index],
                    price:
                        cartController.cartProduct.values.toList()[index].price,
                    quantity: cartController.cartProduct.values
                        .toList()[index]
                        .quantity,
                    title: cartController.cartProduct.values
                        .toList()[index]
                        .title),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartController,
  }) : super(key: key);

  final CartController cartController;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cartController.totalPrice <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await widget.cartController.addOrder().then((_) {});
              setState(() {
                _isLoading = false;
              });
              widget.cartController.clear();
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text('ORDER NOW'),
    );
  }
}
