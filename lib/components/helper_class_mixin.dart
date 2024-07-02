import 'package:billing_app/state_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin HelperClass {
  void newFunc(){
    debugPrint("hello");
  }
  void showClearDialog(BuildContext context){
    showDialog(context: context, builder: (BuildContext ctx){
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
                context.read<StateData>().clearMenu();
                Navigator.of(context).pop();
              }, 
              child: const Text("Confirm")
            ),
          ],
          content: const Text('Do you want to clear the menu? You cannot undo this action!'),
        );
    });
  }
  void showExcelInline(BuildContext context) async {
    final datedData = context.read<StateData>().datedData;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        String? selected = datedData.keys.toList()[0];
        return AlertDialog(
          title: const Text("Convert data to Excel"),
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
                makeExcel(selected ?? "", datedData[selected]);
                Navigator.of(context).pop();
              }, 
              child: const Text("Confirm")
            ),
          ],
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return  Column( 
                mainAxisSize: MainAxisSize.min, 
                children: [
                  const Text("Select date from the drop-down and hit confirm to export!"),
                  DropdownButton<String>( 
                    value: selected, 
                    items: datedData.keys.toList().map((String item) { 
                      return DropdownMenuItem<String>( 
                        value: item, 
                        child: Text(item), 
                      ); 
                    }).toList(), 
                    onChanged: (String? newValue) { 
                      setState((){
                          selected = newValue ?? selected;
                      });
                    }, 
                  ),
                ]
              );
        
            }) 
        );
      }
    );
  } 
  void makeExcel(String date,dynamic data){
    debugPrint("$date : $data");
  }
}
 