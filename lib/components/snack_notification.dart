import 'package:flutter/material.dart';

void showOrderPlacedNotification(BuildContext context) {
  const snackBar = SnackBar(
    content: Text('Your order has been placed!'),
    backgroundColor: Colors.green,
    duration: Duration(seconds: 1),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
