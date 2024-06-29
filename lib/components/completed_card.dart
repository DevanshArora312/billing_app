import 'package:flutter/material.dart';


class CompletedCard extends StatelessWidget {
  const CompletedCard({required this.item,super.key});

  final Map<String,dynamic> item;
  @override
  Widget build(BuildContext context) {
    final items = item["order"];
    final orderNo = item["orderNo"]; 
    final amt = item["totalPrice"];
    debugPrint("$item");
    return Card(

      color: Colors.green[800],
      margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                    "     $orderNo     ",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: 40,
                  width: 1,
                ),
                Expanded(
                  child: Column(children: [
                    Text("ITEMS ${items.length}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],),
                ),
                Container(
                  color: Colors.white,
                  height: 40,
                  width: 1,
                ),
                Text(
                  "  Amount: $amt  ",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
  }
}