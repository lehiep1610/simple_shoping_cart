import 'product_in_cart.dart';

class OrderProduct {
  final String id;
  final double amount;
  final List<ProduceInCart> products;
  final DateTime dateTime;

  OrderProduct({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}
