import 'package:billing_app/state_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditMenu extends StatefulWidget {
  const EditMenu({super.key});

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  final productNameController = TextEditingController();
  final productPriceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    productNameController.dispose();
    productPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(

        children: [
          SizedBox.fromSize(
          ),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
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
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: productPriceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      hintText: 'Enter Product Price',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text(
                      'ADD TO MENU',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final dataClass = context.read<StateData>();
                      dataClass.addMenuItem(
                          productNameController.text, productPriceController.text,
                      );

                      productNameController.clear();
                      productPriceController.clear();
                    }
                  },


                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
