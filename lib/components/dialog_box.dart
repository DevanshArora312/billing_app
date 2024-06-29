import 'package:flutter/material.dart';


class DialogBox extends StatelessWidget {
  const DialogBox({required this.clear,super.key});
  final void Function() clear;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Clear Menu?"),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.of(context).pop();
            }, 
            child: const Text("Close")
          ),
          ElevatedButton(
            onPressed: (){
              clear();
              Navigator.of(context).pop();
            }, 
            child: const Text("Confirm")
          ),
        ],
        content: const Text('Do you want to clear the menu? You cannot undo this action!'),
      );
  }
}