import 'package:billing_app/components/helper_class_mixin.dart';
import 'package:billing_app/state_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:billing_app/components/snack_bar_helper.dart'; // Import the snack bar helper file

class EditMenu extends StatefulWidget {
  const EditMenu({super.key});

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> with HelperClass {
  final productNameController = TextEditingController();
  final productPriceController = TextEditingController();
  final removeItemController = TextEditingController();
  final expenseController = TextEditingController();
  final endingCashController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _removeItemFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    productNameController.dispose();
    productPriceController.dispose();
    removeItemController.dispose();
    endingCashController.dispose();
    expenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCloseStoreButton(context),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
            ),

            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.black,
                    width: 30,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.all(5),
                    child: const Image(
                      image: AssetImage('images/excel.png'),
                    ),
                  ),
                  const SizedBox(width: 30,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[900],
                    ),
                    onPressed: () {
                      showExcelInline(context);
                    },
                    child: const Text(
                      "Export to Excel",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
          _buildAddItemForm(context),
          _buildRemoveItemForm(context),
          _buildClearMenuButton(context),
        ],
      ),
    );
  }

  Widget _buildCloseStoreButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[300],
        ),
        onPressed: () {
          var func =  context.read<StateData>().closeStore;
          if (context.read<StateData>().paymentsPending.isEmpty) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.black,
                  title: const Text(
                      "Close Store",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  titleTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                          "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        if( expenseController.text.isEmpty || endingCashController.text.isEmpty){
                           showSnackBar(context, "Enter the required fields!!");
                           return;
                        }
                        func(expense: expenseController.text,cash: endingCashController.text);
                        expenseController.clear();
                        endingCashController.clear();
                        Navigator.of(context).pop();
                        showSnackBar(context, "Store closed successfully!");
                      },
                      child: const Text(
                          "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Enter the below statistics to close the store successfully",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      _buildTextFormField(
                        controller: endingCashController,
                        hintText: 'Enter ending cash',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => value!.isEmpty ? 'Please enter some text' : null,
                      ),
                      _buildTextFormField(
                        controller: expenseController,
                        hintText: 'Enter total expense of the day',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => value!.isEmpty ? 'Please enter some text' : null,
                      ),
                    ],
                  )
                );
              },
            );
            
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.black,
                  title: const Text(
                      "Caution!",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  titleTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                          "Close",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  content: const Text(
                    "There are still some orders remaining in payment's tab. Please mark them before closing for the day!",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
            );
          }
        },
        child: const Center(
          child: Text(
            "Close Store!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddItemForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextFormField(
              controller: productNameController,
              hintText: 'Enter Product Name',
              validator: (value) => value!.isEmpty ? 'Please enter some text' : null,
            ),
            const SizedBox(height: 10),
            _buildTextFormField(
              controller: productPriceController,
              hintText: 'Enter Product Price',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) => value!.isEmpty ? 'Please enter some text' : null,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<StateData>().addMenuItem(
                    productNameController.text,
                    productPriceController.text,
                  );
                  productNameController.clear();
                  productPriceController.clear();
                  showSnackBar(context, "Item added to menu!", backgroundColor: Colors.green);
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
    );
  }

  Widget _buildRemoveItemForm(BuildContext context) {
    return Form(
      key: _removeItemFormKey,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextFormField(
              controller: removeItemController,
              hintText: 'Enter Product Name to Remove',
              validator: (value) => value!.isEmpty ? 'Please enter some text' : null,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                if (_removeItemFormKey.currentState!.validate()) {
                  if(context.read<StateData>().removeItem(removeItemController.text)){
                    showSnackBar(context, "Item removed from menu!", backgroundColor: Colors.red);
                  } else{
                    showSnackBar(context, "No such Item found! Please try again.", backgroundColor: Colors.red);
                  }
                  removeItemController.clear();
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
    );
  }

  Widget _buildClearMenuButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        onPressed: () {
          showClearDialog(context);
        },
        child: const Center(
          child: Text(
            "Clear Menu!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
        ),
        validator: validator,
        keyboardType: keyboardType,
      ),
    );
  }
}
