import 'package:billing_app/components/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:billing_app/state_data.dart';
import 'package:provider/provider.dart';

mixin EditUtility{
  void showEditDialog(BuildContext context,Map<String, dynamic> item){
    showDialog(context: context, builder: (BuildContext ctx){
      List<Map<String, dynamic>> items = [...item["order"]];
      num tempPrice= 0;
      var update = context.read<StateData>().updateOrder;
      var delete= context.read<StateData>().deleteOrder;
      final stateDataVar = Provider.of<StateData>(context);
      return AlertDialog(
        backgroundColor: Colors.white,
          title: Text("Edit Order for Order No. : ${item["orderNo"]}"),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: (){
                Navigator.of(context).pop();
              }, 
              child: const Text(
                  "Close",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: (){
                update(item,tempPrice,items);
                Navigator.of(context).pop();
                showSnackBar(context, "Updated Order!", backgroundColor: Colors.blue);
              }, 
              child: const Text(
                  "Confirm",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: (){
                delete(item);
                Navigator.of(context).pop();
                showSnackBar(context, "Order no. ${item["orderNo"]} Deleted!", backgroundColor: Colors.red);
              }, 
              child: const Text(
                  "Delete Order",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ),
          ],
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              void setItems(Map<String, dynamic> one) {
                setState(() {
                  bool itemExists = false;
                  for (var i in items) {
                    if (i["name"] == one["name"]) {
                      i["count"]++;
                      tempPrice += i["price"];
                      itemExists = true;
                      break;
                    }
                  }
                  if (!itemExists) {
                    items = [...items, one];
                    tempPrice += one["price"] * one["count"];
                  }
                });
              }
              void increaseCount(Map<String, dynamic> item) {
                setState(() {
                  for (var i in items) {
                    if (i['name'].toLowerCase() == item["name"].toLowerCase()) {
                      i["count"]++;
                      tempPrice += i['price'];
                      return;
                    }
                  }
                  items = [...items, {...item, "count": 1}];
                  tempPrice += item["price"];
                });
              }

              void decreaseCount(Map<String, dynamic> item) {
                setState(() {
                  for (var i in items) {
                    if (i['name'].toLowerCase() == item["name"].toLowerCase()) {
                      if (i["count"] > 0) {
                        i["count"]--;
                        tempPrice -= i['price'];
                      }
                      if (i["count"] == 0) items.removeWhere((el) => el['name'] == item["name"]);
                      break;
                    }
                  }
                });
              }
              late TextEditingController textEditingController;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          List<String> res = [];
                          for (var i in stateDataVar.productList){
                            res.add(i["name"]);
                          }
                          return res.where((String option) {
                            return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          textEditingController.text = "";
                          debugPrint('You just selected $selection');
                          for(var i in stateDataVar.productList){
                            if(selection == i["name"]){
                              setItems({...i,"count" : 1});
                            }
                          }
                        },
                        fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                          textEditingController = fieldTextEditingController;
                          return TextField(
                            controller: fieldTextEditingController,
                            focusNode: fieldFocusNode,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                                hintText: 'Search for a product',
                              icon: Icon(
                                Icons.search_sharp,
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                   
                    SizedBox(
                      height: 150,
                      width: 500,
                        child: ListView.builder(
                      itemBuilder: (context, position) {
                        return ItemCard(
                          itemFromList: items[position],
                          items: items,
                          decreaseCount: decreaseCount,
                          increaseCount: increaseCount,
                          );
                        },
                        itemCount: items.length,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10,10,10,0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(15),
                      child: SizedBox(
                        child: Text(
                            "Extra Order Value : $tempPrice",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ),
                    ),
                  ],
                ),
              );
            }
          )
        );
    });
  }
  
}


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
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      color : Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10,10,10,0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      "${itemFromList["name"]} ",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Text(
                    "${itemFromList["price"]}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
            
                    ),
                  ),
                  
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
            ],
          ),
        ),
      );
    }
}