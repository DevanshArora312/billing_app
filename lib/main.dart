import 'package:billing_app/tabs/completed_orders.dart';
import 'package:billing_app/tabs/create_order.dart';
import 'package:billing_app/tabs/edit_menu.dart';
import 'package:billing_app/tabs/pending_payment.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      home: DefaultTabController(
        length: 4, 
        child: Scaffold(
          bottomNavigationBar: const Menu(),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 35, 36, 41),
            centerTitle: true,
            title: const Text("Bill App",style: TextStyle(
              color: Colors.white
            ),),
          ),
          body: const Expanded(
            child: TabBarView(
              children: [
                CreateOrder(),
                PendingPayment(),
                CompletedOrders(),
                EditMenu(),
              ] 
            ),
          ),
        )
      )
  ));
}

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
    color:const Color.fromARGB(255, 35, 36, 41),
    child:const TabBar(
      labelColor: Color.fromARGB(255, 243, 128, 33),
      unselectedLabelColor: Colors.white70,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.fromLTRB(5,5,5,2),
      indicatorColor: Color.fromARGB(255, 243, 128, 33),
      tabs: [
        Tab(
          text: "Create",
          icon: Icon(Icons.assignment),
        ),
        Tab(
          text: "Payments",
          icon: Icon(Icons.currency_rupee),
        ),
        Tab(
          text: "Completed",
          icon: Icon(Icons.account_balance_wallet),
        ),
        Tab(
          text: "Edit Menu",
          icon: Icon(Icons.settings),
        ),
      ],
    ),
  );
  }
}