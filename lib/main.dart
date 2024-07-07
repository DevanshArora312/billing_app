import 'package:billing_app/state_data.dart';
import 'package:billing_app/tabs/completed_orders.dart';
import 'package:billing_app/tabs/create_order.dart';
import 'package:billing_app/tabs/edit_menu.dart';
import 'package:billing_app/tabs/login.dart';
import 'package:billing_app/tabs/pending_payment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(

      home: MultiProvider(


      providers: [
        ChangeNotifierProvider(
          create: (context) => StateData()
        )
      ],

      child:const Scaffold(
        body: Home()
      )
      )  
    )
  );
}

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4, 
        child: Scaffold(
          bottomNavigationBar: const Menu(),
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: const Text("Bill App",style: TextStyle(
              color: Colors.white
            ),),
          ),
          body: Column(
            children: [
              Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                context.watch<StateData>().isLogged ? const CreateOrder() : const Login(),
                const PendingPayment(),
                const CompletedOrders(),
                const EditMenu(),
              ] 
            ),
          ),
        ],)

        )
      );
  }
}

class Menu extends StatelessWidget {
  const Menu({super.key});
  @override
  Widget build(BuildContext context) {
    return  Container(
    color: Colors.black,
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