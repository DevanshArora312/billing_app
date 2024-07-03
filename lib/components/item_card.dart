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
      margin: const EdgeInsets.all(5),
      color : Colors.white,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 70,
                    child: Text(
                      "${itemFromList["name"]} ",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => decreaseCount(itemFromList),
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "   $itemCount   ",
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () => increaseCount(itemFromList),
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.black,
                        ),
                      ),
                    ],),
                  SizedBox(
                    width: 70,
                    child: Text(
                      "${itemFromList["price"]}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,

                      ),
                    ),
                  )

                ],
              ),
            ),
          );
    }
}