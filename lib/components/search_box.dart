import 'package:billing_app/state_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({required this.setItems,super.key});
  final void Function(Map<String,dynamic>) setItems;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  
  late SharedPreferences prefs;
  late TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    final stateDataVar = Provider.of<StateData>(context);
    return 
        Expanded(
        child: Autocomplete<String>(
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
