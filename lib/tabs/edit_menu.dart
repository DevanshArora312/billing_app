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
  final removItemController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> removeItem = GlobalKey<FormState>();
  @override
  void dispose() {
    productNameController.dispose();
    productPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox.fromSize(
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                      ),
                      onPressed: () => {
                        if(context.read<StateData>().paymentsPending.isEmpty){
                          context.read<StateData>().closeStore()
                        } else {
                          showDialog(context: context, builder: (BuildContext context){
                            return AlertDialog(
                              title: const Text("Caution!"),
                              titleTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),
                              actions: [
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Close")
                                ),
                              ],
                              content: const Text("There are still some orders remaining in payment's tab. Please mark them before closing for the day!"),
                            );
                          })
                        }
                      },
                      child: const Text(
                        "                   Close Store!                  ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
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
                        child: const Text(
                            'ADD TO MENU',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
          
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        Form(
            key: removeItem,
            child: Column(
              children: [
                SizedBox.fromSize(
                ),
                Container(
                  margin: const EdgeInsets.all(10),
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
                          controller: removItemController,
                          decoration: const InputDecoration(
                            hintText: 'Enter Product Name to Remove',
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          if (removeItem.currentState!.validate()) {
                            final dataClass = context.read<StateData>();
                            dataClass.removeItem(
                                removItemController.text,
                            );
          
                            removItemController.clear();
                          }
                        },
                        child: const Text(
                            'REMOVE FROM MENU',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
          
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
            ),
            child :ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () => context.read<StateData>().clearMenu() ,
                child: const Text("          Clear Menu          ",
                  style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),)
            ),
          ),
        ],
      ),
    );
  }
}
