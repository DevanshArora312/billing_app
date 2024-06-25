import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class SearchBox extends StatefulWidget {
  const SearchBox({required this.setItems,super.key});
  final void Function(Map<String,dynamic>) setItems;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  
  void setPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }
  @override
  void initState() {
    super.initState();
    setPrefs();
  }

  late SharedPreferences prefs;
  late TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    List<dynamic> options = [
      {"name" : "Burger" , "price": 120},
      {"name" : "Fries", "price": 40}
    ];

    return Expanded(
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            // return const Iterable<Map<String,dynamic>>.empty();
            return const Iterable<String>.empty();
          }
          List<String> res = [];
          // var options = json.decode(prefs.getString("productList") ?? '[]');
          for (var i in options){
            res.add(i["name"]);
          }
          return res.where((String option) {
            return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (String selection) {
          textEditingController.text = "";
          debugPrint('You just selected $selection');
          // var options = json.decode(prefs.getString("productList") ?? '[]');
          for(var i in options){
            if(selection == i["name"]){
              widget.setItems({...i,"count" : 1});
            }
          }
        },
        fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
          textEditingController = fieldTextEditingController;
          return TextField(
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            style: const TextStyle(fontWeight: FontWeight.bold),
            decoration: const InputDecoration(hintText: 'Search for a product'),
          );
        },
      ),
    );
  }
}
