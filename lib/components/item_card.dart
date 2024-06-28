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
      margin: EdgeInsets.all(5),
      color : Colors.white,


            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(

                children: [

                  Text(
                    "     ${itemFromList["name"]}     ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => decreaseCount(itemFromList),
                    child: Icon(
                      Icons.remove_circle,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "     $itemCount     ",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => increaseCount(itemFromList),
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "${itemFromList["price"]}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,

                    ),
                  ),

                ],
              ),
            ),
          );
    }
}