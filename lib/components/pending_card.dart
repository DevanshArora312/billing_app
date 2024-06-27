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
    debugPrint("$item");
    num amt=0;
    items.forEach((element) => amt+=(element["price"]*element["count"]));
    return Card(
            child: Row(
              children: [
                Text("$orderNo"),
                Expanded(
                  child: Column(children: [
                    Text("ITEMS ${items.length}")
                  ],),
                ),
                Column(
                  children: [
                    Text("Amount: $amt"),
                    ElevatedButton(onPressed: () => context.read<StateData>().paid(item), child: const Text("Paid"))
                  ],
                )
              ],
            ),
          );
  }
}