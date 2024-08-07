import 'package:billing_app/components/item_card.dart';
import 'package:billing_app/components/search_box.dart';
import 'package:billing_app/state_data.dart';
import 'package:billing_app/components/snack_notification.dart'; // Import the notification file
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({super.key});

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  List<Map<String, dynamic>> items = [];
  double totalOrderValue = 0;

  void setItems(Map<String, dynamic> item) {
    setState(() {
      bool itemExists = false;
      for (var i in items) {
        if (i["name"] == item["name"]) {
          i["count"]++;
          totalOrderValue += i["price"];
          itemExists = true;
          break;
        }
      }
      if (!itemExists) {
        items = [...items, item];
        totalOrderValue += item["price"] * item["count"];
      }
    });
  }

  void increaseCount(Map<String, dynamic> item) {
    setState(() {
      for (var i in items) {
        if (i['name'].toLowerCase() == item["name"].toLowerCase()) {
          i["count"]++;
          totalOrderValue += i['price'];
          return;
        }
      }
      items = [...items, {...item, "count": 1}];
      totalOrderValue += item["price"];
    });
  }

  void decreaseCount(Map<String, dynamic> item) {
    setState(() {
      for (var i in items) {
        if (i['name'].toLowerCase() == item["name"].toLowerCase()) {
          if (i["count"] > 0) {
            i["count"]--;
            totalOrderValue -= i['price'];
          }
          if (i["count"] == 0) items.removeWhere((el) => el['name'] == item["name"]);
          break;
        }
      }
    });
  }

  void clearOrder() {
    setState(() {
      items = [];
      totalOrderValue = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<StateData>().checkForOrders();

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
            ),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(15),
            child: Text(
              "Order No. : ${Provider.of<StateData>(context).orderNo}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SearchBox(setItems: setItems),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, position) {
                return ItemCard(
                  itemFromList: context.watch<StateData>().productList[position],
                  items: items,
                  decreaseCount: decreaseCount,
                  increaseCount: increaseCount,
                );
              },
              itemCount: context.watch<StateData>().productList.length,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total Order Value : $totalOrderValue",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(10),
                ),
                onPressed: clearOrder,
                child: const Text(
                  "Clear Order",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(10),
                ),
                onPressed: () {
                  final dataClass = context.read<StateData>();
                  if(items.isNotEmpty){
                    dataClass.punchOrder(items);
                    clearOrder();
                    showOrderPlacedNotification(context);
                  }
                },
                child: const Text(
                  "Punch Order",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
