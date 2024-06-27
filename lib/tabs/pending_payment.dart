import 'package:billing_app/components/pending_card.dart';
import 'package:billing_app/state_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendingPayment extends StatefulWidget {
  const PendingPayment({super.key});

  @override
  State<PendingPayment> createState() => _PendingPaymentState();
}

class _PendingPaymentState extends State<PendingPayment> {
  List<dynamic> data = [];


  // @override
  // Widget build(BuildContext context) {
  //   final stateDataVar = Provider.of<StateData>(context);
  //   return Expanded(
  //     child: ListView.builder(
  //         itemBuilder: (context, position) {
  //           return PendingCard(
  //             item: stateDataVar.paymentsPending[position],
  //           );
  //         },
  //         itemCount: stateDataVar.paymentsPending.length,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var pendingList = Provider.of<StateData>(context,listen: true).paymentsPending;
    return ListView.builder(
          itemBuilder: (context, position) {
            return PendingCard(
              item: pendingList[position],
            );
          },
          itemCount: pendingList.length,
      );
  }
}