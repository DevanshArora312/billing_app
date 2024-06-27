import 'package:billing_app/components/completed_card.dart';
import 'package:billing_app/state_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompletedOrders extends StatelessWidget {
  const CompletedOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final stateDataVar = Provider.of<StateData>(context);
    return ListView.builder(
          itemBuilder: (context, position) {
            return CompletedCard(
              item: stateDataVar.completedOrders[position],
            );
          },
          itemCount: stateDataVar.completedOrders.length,
      );
  }
}