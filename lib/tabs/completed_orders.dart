import 'package:billing_app/components/completed_card.dart';
import 'package:billing_app/state_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CompletedOrders extends StatelessWidget {
  const CompletedOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final stateDataVar = Provider.of<StateData>(context);
    final date = DateFormat("dd, MMM, yyyy").format(DateTime.now());
    num totalOrderValue = 0;
    stateDataVar.completedOrders.forEach((el) => totalOrderValue+= el["totalPrice"]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Date: ${date.substring(0,7)}"),
            Text("Total Orders: ${stateDataVar.completedOrders.length}")
          ],
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
          child : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Total Order Value : $totalOrderValue",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: (){},
          child: const Text("Export to Excel")
        )
      ],
    );
  }
}