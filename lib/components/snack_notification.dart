import 'package:flutter/material.dart';

void showOrderPlacedNotification(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text('Your order has been placed!'),
    backgroundColor: Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
