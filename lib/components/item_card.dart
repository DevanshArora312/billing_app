import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({required this.itemFromList,required this.items,required this.decreaseCount,required this.increaseCount,super.key});
  
  final Map<String,dynamic> itemFromList;
  final List<Map<String,dynamic>> items;
  final void Function(Map<String,dynamic>) decreaseCount;
  final void Function(Map<String,dynamic>) increaseCount;
  @override
  Widget build(BuildContext context) {
    final itemCount = items.any((el) => el.containsValue(itemFromList["name"])) ? items.firstWhere((el) => el['name'] == itemFromList["name"])["count"] : 0 ;
    return Card(
            child: Row(
              children: [
                Text("${itemFromList["name"]}"),
                ElevatedButton(onPressed: () => decreaseCount(itemFromList), child: const Text("-")),
                Text("$itemCount"),
                ElevatedButton(onPressed: () => increaseCount(itemFromList), child: const Text("+")),
                Text("${itemFromList["price"]}"),
              ],
            ),
          );
    }
}