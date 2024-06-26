import 'package:flutter/material.dart';

class PendingPayment extends StatefulWidget {
  const PendingPayment({super.key});

  @override
  State<PendingPayment> createState() => _PendingPaymentState();
}

class _PendingPaymentState extends State<PendingPayment> {
  List<dynamic> data = [];
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Pending Payment"));
  }
}