import 'package:billing_app/components/completed_card.dart';
import 'package:billing_app/state_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CompletedOrders extends StatelessWidget {
  const CompletedOrders({super.key});

  final icon = '₹';
  @override
  Widget build(BuildContext context) {
    final stateDataVar = Provider.of<StateData>(context);
    final date = DateFormat("dd, MMM, yyyy").format(DateTime.now());
    num totalOrderValue = 0;

    // Ensure totalPrice is not null
    stateDataVar.completedOrders.forEach((el) {
      totalOrderValue += el["totalPrice"] ?? 0;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Container(

              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color :Colors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                ],
                
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(
                      Icons.wallet,
                    color: Colors.white,
                  ),
                  Text(
                      "Total Orders: ${stateDataVar.completedOrders.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, position) {
              return CompletedCard(
                item: stateDataVar.completedOrders[position],
              );
            },
            itemCount: stateDataVar.completedOrders.length,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total Order Value: $icon${totalOrderValue.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
