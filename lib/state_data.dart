import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateData extends ChangeNotifier{
  StateData(){
    initData();
  }
  
  late SharedPreferences prefs;
  List<dynamic> productList = [];
  late List<dynamic> paymentsPending;
  late List<dynamic> completedOrders;
  late String editDate;
  late int orderNo = 1;
  late Map<String,dynamic> datedData = {};

  void initData() async {
    prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    orderNo = prefs.getInt("orderNo") ?? 1;
    notifyListeners();
    debugPrint('or -- $orderNo');
    productList = await json.decode(prefs.getString("productList") ?? '[]');
    paymentsPending = await json.decode(prefs.getString("paymentsPending") ?? '[]');
    completedOrders = await json.decode(prefs.getString("completedOrders") ?? '[]');
    datedData = await json.decode(prefs.getString("datedData") ?? '{}');
    editDate = prefs.getString("lastEditDate") ?? "";
    if(datedData.containsKey(getNow())){
      orderNo = datedData[getNow()]!.length + paymentsPending.length + 1;
    }
    deleteOldData();
    notifyListeners();
  }
  String getNow(){
    var curr = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    String now = formatter.format(curr);
    return now;
  }

  void deleteOldData(){
      if(datedData.length <= 7) return;
      var curr = DateTime.now();
      var formatter = DateFormat('dd-MM-yyyy');
      String now = formatter.format(curr);
      int maxDiff = 0;
      String toRemove = "";
      int today = int.parse(now.substring(0,2)) + int.parse(now.substring(3,5))*30;
      int tmp;
      for(var key in datedData.keys){
        tmp = int.parse(key.substring(0,2)) + int.parse(key.substring(3,5))*30;
        if(today - tmp > maxDiff){
            maxDiff = today - tmp;
            toRemove = key;
        }
      }
      datedData.remove(toRemove);
  }

  void checkForOrders(){
    var date = getNow();
    if(datedData.containsKey(date) && orderNo <= datedData[date]!.length){
      orderNo = datedData[date]!.length  + paymentsPending.length + 1;
    }
  }

  void punchOrder(items){
    if(items.isEmpty){
      return;
    } 
    num amt=0;
    items.forEach((element) => amt+=(element["price"]*element["count"]));
    String tdata = DateFormat("hh:mm:ss a").format(DateTime.now());
    checkForOrders();
    paymentsPending.add({"orderNo" : orderNo,"order":items,"totalPrice":amt,"orderDate":getNow(),"orderTime" : tdata});
    prefs.setString("paymentsPending",json.encode(paymentsPending));
    debugPrint("${prefs.getString("paymentsPending")}");
    orderNo++;
    prefs.setInt("orderNo", orderNo);
    notifyListeners();
    // clearOrder();
  }

  void addMenuItem(name,price){
    Map<String,dynamic> tmp = {"name" : name , "price" : double.parse(price)};
    productList.add(tmp);
    prefs.setString("productList", json.encode(productList));
  } 

  void paid(item){
    paymentsPending.removeWhere( (el) => el["orderNo"] == item["orderNo"] );
    prefs.setString("paymentsPending", json.encode(paymentsPending));
    completedOrders.add(item);
    prefs.setString("completedOrders", json.encode(completedOrders));
    if(datedData.containsKey(item["orderDate"])){
      datedData[item["orderDate"]]?.add(item);
    } else{
      datedData[item["orderDate"]] = [item,];
    }
    prefs.setString("datedData",json.encode(datedData));
    
    notifyListeners();
  }
  void clearMenu(){
    productList = [];
    prefs.setString('productList', '[]');
    notifyListeners();
  }
  void removeItem(item){
    productList = productList.where((el) => el["name"].toLowerCase() != item.toLowerCase()).toList();
    prefs.setString("productList", json.encode(productList));
    notifyListeners();
  }
  void closeStore(){
    debugPrint("${datedData}");
    prefs.setString("paymentsPending",'[]');
    prefs.setString("completedOrders",'[]');
    prefs.setInt("orderNo",1);
    orderNo = 1;
    paymentsPending = [];
    completedOrders = [];
  }
}