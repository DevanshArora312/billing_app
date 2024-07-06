import 'package:billing_app/components/snack_bar_helper.dart';
import 'package:billing_app/state_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> _startingCashFormKey = GlobalKey<FormState>();
  final startingCashController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildRemoveItemForm(context),
            ],
          )
        ),
      ],
    );
  }
  Widget _buildRemoveItemForm(BuildContext context) {
    // final login = Provider.of<StateData>(context).completedOrders;
    return Form(
      key: _startingCashFormKey,
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
              controller: startingCashController,
              hintText: 'Enter cash in drawer',
              validator: (value) => value!.isEmpty ? 'Please enter some text' : null,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                if (_startingCashFormKey.currentState!.validate()) {
                  context.read<StateData>().login(
                    cash:startingCashController.text,
                  );
                  startingCashController.clear();
                } else{
                  showSnackBar(context, "Enter valid value!", backgroundColor: Colors.red);
                }
              },
              child: const Text(
                'LOGIN FOR THE DAY',
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

