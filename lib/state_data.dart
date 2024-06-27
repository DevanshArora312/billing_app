import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateData extends ChangeNotifier{
  StateData(){
    initData();
  }
  late SharedPreferences prefs;
  List<dynamic> productList = [];
  late List<dynamic> paymentsPending;
  late List<dynamic> completedOrders;
  late dynamic editDate;
  late int orderNo = 1;
  
  void initData() async {
    prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    orderNo = prefs.getInt("orderNo") ?? 1;
    notifyListeners();
    debugPrint('or -- $orderNo');
    productList = await json.decode(prefs.getString("productList") ?? '[]');
    paymentsPending = await json.decode(prefs.getString("paymentsPending") ?? '[]');
    completedOrders = await json.decode(prefs.getString("completedOrders") ?? '[]');
    editDate = await json.decode(prefs.getString("lastEditDate")!);
    notifyListeners();
  }

  void punchOrder(items){
    if(items.isEmpty){
      return;
    } 
    // prefs.setString("paymentsPending",'[]');
    // paymentsPending = [];
    paymentsPending.add({"orderNo" : orderNo,"order":items});
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
    notifyListeners();
  }
}