import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({required this.item,required this.decreaseCount,required this.increaseCount,required this.deleteItem,super.key});
  
  final Map<String,dynamic> item;
  final void Function(String) decreaseCount;
  final void Function(String) increaseCount;
  final void Function(String) deleteItem;

  @override
  Widget build(BuildContext context) {
    return Card(
            child: Row(
              children: [
                Text("${item["name"]}"),
                ElevatedButton(onPressed: () => decreaseCount(item["name"]), child: const Text("-")),
                Text("${item["count"]}"),
                ElevatedButton(onPressed: () => increaseCount(item["name"]), child: const Text("+")),
                ElevatedButton(onPressed: () => deleteItem(item["name"]), child: const Text("Delete")),
                Text("${item["price"]}"),
              ],
            ),
          );
    }
}