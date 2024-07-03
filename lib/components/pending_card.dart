import 'package:billing_app/state_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class PendingCard extends StatelessWidget {
  const PendingCard({required this.item, super.key});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final items = item["order"];
    final orderNo = item["orderNo"];
    final amt = item["totalPrice"];

    return Card(
      color: Colors.black,
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          Text(
            "     $orderNo     ",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.white,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "ITEMS ${items.length}",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            height: 40,
            width: 1,
          ),
          Column(
            children: [
              Text(
                "  Amount: $amt  ",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(5),
                ),
                onPressed: () {
                  context.read<StateData>().paid(item);
                  // Show a SnackBar notification
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Your payment is done for order $orderNo.'),
                      duration: const Duration(seconds: 1), // Adjust the duration as needed
                    ),
                  );
                },
                child: const Text(
                  "Paid",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
