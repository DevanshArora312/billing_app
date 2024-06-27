import 'package:flutter/material.dart';


class CompletedCard extends StatelessWidget {
  const CompletedCard({required this.item,super.key});

  final Map<String,dynamic> item;
  @override
  Widget build(BuildContext context) {
    final items = item["order"];
    final orderNo = item["orderNo"]; 
    debugPrint("$item");
    num amt=0;
    items.forEach((element) => amt+=(element["price"]*element['count']));
    return Card(
            child: Row(
              children: [
                Text("$orderNo"),
                Expanded(
                  child: Column(children: [
                    Text("ITEMS ${items.length}")
                  ],),
                ),
                Text("Amount: $amt"),
              ],
            ),
          );
  }
}