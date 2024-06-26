import 'package:billing_app/components/item_card.dart';
import 'package:billing_app/components/search_box.dart';
import 'package:billing_app/state_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({super.key});

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}


class _CreateOrderState extends State<CreateOrder> {
  
    List<Map<String,dynamic>> items = [];
    double totalOrderValue = 0;
  
    void setItems(Map<String,dynamic> item){
        debugPrint('$items');
        setState(() {
          for(var i in items){
            if( i["name"] == item["name"]){
              i["count"]++;
              return;
            }
          }
          items = [...items,item];
          
          totalOrderValue += item["price"]*item["count"];
        });
        
        debugPrint("$items");
    }
    void increaseCount(String item){
      setState(() {
        for( var i in items){
          if(i['name'].toLowerCase() == item.toLowerCase() ){
            i["count"]++;
            totalOrderValue += i['price'];
            break;
          }
        }
      });
    }
    void decreaseCount(String item){
      setState(() {
        for( var i in items){
          if(i['name'].toLowerCase() == item.toLowerCase() ){
            i["count"]--;
            totalOrderValue -= i['price'];
            break;
          }
        }
      });
    }
    void deleteItem(String item){
      setState(() {
        for( var i in items){
          if(i['name'].toLowerCase() == item.toLowerCase() ){
            totalOrderValue -= i['price']*i['count'];
          }
        }
        items.removeWhere((el) => el['name'] == item);

      });
    }
    void clearOrder(){
      setState(() {
        items = [];
        totalOrderValue = 0;
      });
    }
    
  @override
  Widget build(BuildContext context) {
    
    return Consumer<StateData>(builder: (context,value,child) => 
        Padding(
          padding: const EdgeInsets.all(10),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Order No. : ${value.orderNo}"),
              Row( 
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SearchBox(setItems: setItems,),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    itemBuilder: (context, position) {
                      return ItemCard(
                        item: items[position],
                        decreaseCount: decreaseCount,
                        increaseCount: increaseCount,
                        deleteItem: deleteItem,
                      );
                    },
                    itemCount: items.length,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Total Order Value : $totalOrderValue")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: clearOrder, child: const Text("Clear Order")),
                  ElevatedButton(onPressed: (){
                    final dataClass = context.read<StateData>();
                    dataClass.punchOrder(items);
                    clearOrder();
                  }, child: const Text("Punch Order"))
                ],
              )
            ],
          ),
      )
    );
  }
}