import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/orders.dart';

class OrderItem extends StatefulWidget {
  final OrderProduct orderProduct;

  const OrderItem({Key? key, required this.orderProduct}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderProduct.amount.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm')
                  .format(widget.orderProduct.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              height: min(widget.orderProduct.products.length * 20.0 + 10, 100),
              child: ListView.builder(
                itemCount: widget.orderProduct.products.length,
                itemBuilder: (ctx, i) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.orderProduct.products[i].title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.orderProduct.products[i].quantity}x \$${widget.orderProduct.products[i].price}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
