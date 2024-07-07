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
  late bool isLogged = false;

  void initData() async {
    prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    orderNo = prefs.getInt("orderNo") ?? 1;
    notifyListeners();
    // debugPrint('or -- $orderNo');
    productList = await json.decode(prefs.getString("productList") ?? '[]');
    paymentsPending = await json.decode(prefs.getString("paymentsPending") ?? '[]');
    completedOrders = await json.decode(prefs.getString("completedOrders") ?? '[]');
    datedData = await json.decode(prefs.getString("datedData") ?? '{}');
    editDate = prefs.getString("lastEditDate") ?? "";
    isLogged = prefs.getBool("isLogged") ?? false;
    if(datedData.containsKey(getNow())){
      orderNo = datedData[getNow()]["orders"]!.length + paymentsPending.length + 1;
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
    if(datedData.containsKey(date) && orderNo <= datedData[date]["orders"]!.length){
      orderNo = datedData[date]["orders"]!.length  + paymentsPending.length + 1;
    }
    // notifyListeners();
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
    // debugPrint("${prefs.getString("paymentsPending")}");
    orderNo++;
    prefs.setInt("orderNo", orderNo);
    notifyListeners();
    // clearOrder();
  }

  void addMenuItem(name,price){
    Map<String,dynamic> tmp = {"name" : name.trim() , "price" : double.parse(price)};
    productList.add(tmp);
    prefs.setString("productList", json.encode(productList));
  } 

  void paid(item){
    paymentsPending.removeWhere( (el) => el["orderNo"] == item["orderNo"] );
    prefs.setString("paymentsPending", json.encode(paymentsPending));
    completedOrders.add(item);
    prefs.setString("completedOrders", json.encode(completedOrders));
    if(datedData.containsKey(item["orderDate"])){
      datedData[item["orderDate"]]["orders"]?.add(item);
    } else{
      datedData[item["orderDate"]]["orders"] = [item,];
    }
    prefs.setString("datedData",json.encode(datedData));
    
    notifyListeners();
  }
  void clearMenu(){
    productList = [];
    prefs.setString('productList', '[]');
    notifyListeners();
  }
  bool removeItem(item){
    if(productList.indexOf((el) => el["name"].toLowerCase() == item.trim().toLowerCase()) < 0 ) return false;
    productList = productList.where((el) => el["name"].toLowerCase() != item.trim().toLowerCase()).toList();
    prefs.setString("productList", json.encode(productList));
    notifyListeners();
    return true;
  }

  void updateOrder(item,tempPrice,items){
    var newList = [];
    // var doneList = [];
    for (var one in paymentsPending){
      if(one["orderNo"] == item["orderNo"]){
        one["order"] = items;
        one["totalPrice"] += tempPrice;
        
      }
      newList.add(one);
    }
    paymentsPending = newList;
    prefs.setString("paymentsPending", json.encode(paymentsPending));
    notifyListeners();
  }

  void login({cash=0}) {
    isLogged = true;
    prefs.setBool("isLogged", true);
    final now = getNow();
    if(!datedData.containsKey(now)){
        datedData[now] = {"startingCash" : cash,"orders":[]};
    }
    prefs.setString("datedData",json.encode(datedData));
    notifyListeners();
  }

  void closeStore({cash=0,expense=0}){
    isLogged = false;
    prefs.setString("paymentsPending",'[]');
    prefs.setString("completedOrders",'[]');
    prefs.setInt("orderNo",1);
    orderNo = 1;
    var now = getNow();
    if(completedOrders.isNotEmpty){
      datedData[completedOrders[0]["orderDate"]]["closingCash"] = cash;
      datedData[completedOrders[0]["orderDate"]]["expense"] = expense;
    } else {
      datedData[now]["closingCash"] = cash;
      datedData[now]["expense"] = expense;
    }
    prefs.setString("datedData",json.encode(datedData)); 
    paymentsPending = [];
    completedOrders = [];
    prefs.setBool("isLogged", false);
    notifyListeners();
  }
}