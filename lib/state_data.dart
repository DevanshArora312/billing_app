import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateData extends ChangeNotifier{
  StateData(){
    initData();
  }
  late SharedPreferences prefs;
  late List<dynamic> productList;
  late List<dynamic> paymentsPending;
  late List<dynamic> completedOrders;
  late dynamic editDate;
  late int orderNo = 1;
  
  void initData() async {
    prefs = await SharedPreferences.getInstance();
    orderNo = prefs.getInt("orderNo") ?? 1;
    debugPrint('or -- $orderNo');
    productList = json.decode(prefs.getString("productList") ?? '[]');
    paymentsPending = json.decode(prefs.getString("paymentsPending") ?? '[]');
    completedOrders = json.decode(prefs.getString("completedOrders") ?? '[]');
    editDate = json.decode(prefs.getString("lastEditDate")!);
    notifyListeners();
  }

  void punchOrder(items){
    if(items.isEmpty){
      return;
    } 
    paymentsPending.add({"id" : orderNo,"order":items});
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
}