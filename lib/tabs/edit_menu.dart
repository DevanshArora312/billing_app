import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditMenu extends StatefulWidget {
  const EditMenu({super.key});
  
  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  final productNameController = TextEditingController() ;
  final productPriceController = TextEditingController() ;
  late SharedPreferences prefs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  void setPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }
  @override
  void initState() {
    super.initState();
    setPrefs();
  }
  @override
  void dispose(){
    productNameController.dispose();
    productPriceController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: productNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Product Name',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: productPriceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: 'Enter Price',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process data.
                      List<Map<String,dynamic>> empt = [];
                      Map<String,dynamic> tmp = {"name" : productNameController.text , "price" : double.parse(productPriceController.text)};
                      if(prefs.containsKey("productList")){
                        var products = json.decode(prefs.getString("productList")!);
                        products.add(tmp);
                        prefs.setString("productList", json.encode(products));
                      } else{
                        empt.add(tmp);
                        prefs.setString("productList", json.encode(empt));
                      }
                      debugPrint(prefs.getString("productList"));
                      productNameController.text = "";
                      productPriceController.text = "";
                    }
                  },
                  child: const Text('Submit'),
                ),
              )
            ],
          )
        )
      ],
    );
  }
}