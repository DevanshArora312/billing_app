import 'package:flutter/material.dart';


class CompletedCard extends StatelessWidget {
  const CompletedCard({required this.item,super.key});

  final Map<String,dynamic> item;
  @override
  Widget build(BuildContext context) {
    final items = item["order"];
    final orderNo = item["orderNo"]; 
    final amt = item["totalPrice"];
    // debugPrint("$item");
    return Card(
      color: Colors.green,
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          Text(
            "  $orderNo  ",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 60,
            width: 1,
            color: Colors.white,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:8,horizontal: 0),
              child: Column(
                children: [
                  for(var one in items)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text("${one['name'].length > 12 ? one['name'].substring(0,12)+"..." : one['name']}*${one['count']}",style: const TextStyle(color:Colors.white),),
                          Text("(${one['price']*one['count']})",style: const TextStyle(color:Colors.white),)
                        ]
                      ),
                    )
                  
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            height: 60,
            width: 1,
          ),
          Column(
            children: [
              Text(
                " Amt: $amt ",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}