import 'package:billing_app/state_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditMenu extends StatefulWidget {
  const EditMenu({super.key});
  
  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  final productNameController = TextEditingController() ;
  final productPriceController = TextEditingController() ;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
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
                      final dataClass = context.read<StateData>();
                      dataClass.addMenuItem(productNameController.text,productPriceController.text);

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