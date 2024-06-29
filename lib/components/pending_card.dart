import 'package:billing_app/state_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendingCard extends StatelessWidget {
  const PendingCard({required this.item,super.key});

  final Map<String,dynamic> item;
  @override
  Widget build(BuildContext context) {
    final items = item["order"];
    final orderNo = item["orderNo"];
    final amt = item["totalPrice"]; 
    debugPrint("$item");
    return Card(
      color: Colors.black,

            margin: EdgeInsets.all(5),


            child: Row(
              children: [
                Text(
                    "     $orderNo     ",
                  style: TextStyle(
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
                      style: TextStyle(
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
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    ElevatedButton(
                      child: const Text(
                        "Paid",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.all(5),
                        ),
                        onPressed: () => context.read<StateData>().paid(item),

                    )
                  ],
                )
              ],

            ),
          );
  }
}