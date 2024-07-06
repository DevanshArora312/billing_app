import 'dart:io'show Directory, File, Platform;
import 'package:billing_app/components/snack_bar_helper.dart';
import 'package:billing_app/state_data.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:path_provider/path_provider.dart';

mixin HelperClass {
  void newFunc(){
    debugPrint("hello");
  }
  void showClearDialog(BuildContext context){
    showDialog(context: context, builder: (BuildContext ctx){
      return AlertDialog(
        backgroundColor: Colors.black,
          title: const Text("Clear Menu?"),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: (){
                Navigator.of(context).pop();
              }, 
              child: const Text(
                  "Close",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: (){
                context.read<StateData>().clearMenu();
                Navigator.of(context).pop();
                showSnackBar(context, "Menu cleared!", backgroundColor: Colors.red);
              }, 
              child: const Text(
                  "Confirm",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ),
          ],
          content: const Text(
              'Do you want to clear the menu? You cannot undo this action!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
    });
  }
  void showExcelInline(BuildContext context) async {
    final datedData = context.read<StateData>().datedData;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        String? selected = datedData.keys.toList().isNotEmpty ? datedData.keys.toList()[0] : "";
        return AlertDialog(
          // backgroundColor: Colors.black,
          title: const Text("Convert data to Excel"),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: (){
                Navigator.of(context).pop();
              }, 
              child: const Text(
                  "Close",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              )
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () async {
                if(selected == "" || datedData.keys.toList().isEmpty){
                  Navigator.of(context).pop();
                  showSnackBar(context, "No data to export!");
                  return;
                }
                final excel = await makeExcel(selected ?? "", datedData[selected]);
                saveExcel(excel, selected ?? "");
                Navigator.of(context).pop();
                showSnackBar(context, 'Excel File saved in Download folder!',backgroundColor: Colors.green);
              }, 
              child: const Text(
                  "Save",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              )
            ),
          ],
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              debugPrint("$datedData");
              return  Column( 
                mainAxisSize: MainAxisSize.min, 
                children: [
                  const Text(
                      "Select date from the drop-down and hit Save to export!",
                    // style: TextStyle(
                    //   color: Colors.white,
                    // ),
                  ),
                  DropdownButton<String>( 
                    value: selected, 
                    items: datedData.keys.toList().map((String item) { 
                      return DropdownMenuItem<String>( 
                        value: item, 
                        child: Text(
                          item,
                          // style: const TextStyle(
                          //   color: Colors.white,
                          // ),
                        ),
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
  Future<Excel> makeExcel(String date,dynamic data) async {
    debugPrint("$date : $data");
    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet()!];
    sheet.setDefaultColumnWidth(20);
    sheet.setDefaultRowHeight(15);
    CellStyle cellStyle = CellStyle(bold: true, fontFamily :getFontFamily(FontFamily.Calibri));
    var headings = ["Order No.","Order","Total Price","Order Date","Order Time","startingCash","closingCash","expense"];
    var keys = ["orderNo","order","totalPrice","orderDate","orderTime"];
    for(var col = 0;col<headings.length;col++){
      var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
      cell.value = TextCellValue(headings[col]);
      cell.cellStyle = cellStyle;
      if(col > 4){
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 1))
        .value = TextCellValue(data.containsKey(headings[col]) ? data[headings[col]].toString()  : "");
      }
        
    } 
    for(var row = 0;row < data["orders"].length;row++){
      for(var col = 0;col<keys.length;col++){
        // debugPrint("row:$row and col:$col");
        if(keys[col] == "order"){
            String dataString = "";
            for(var indOrder in data["orders"][row]["order"]){
              dataString += "${indOrder["name"]}*${indOrder["count"]}, ";
            }
            sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row+1))
            .value = TextCellValue(dataString);
        } else{
            sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row+1))
            .value = TextCellValue(data["orders"][row][keys[col]].toString());
        }
      }
    }
    return excel;
  }

  void saveExcel(Excel excel, String date) async {
    
    if(kIsWeb){
      excel.save(fileName: 'Bill_Data_$date.xlsx');
    } else{
      
      var fileBytes = excel.save();
      final plugin = DeviceInfoPlugin();
      
      if(Platform.isAndroid){
        final android = await plugin.androidInfo;
        
        if(android.version.sdkInt < 33){
            var status = await Permission.storage.request();
            // debugPrint('here : $status');
            if (!status.isGranted) {
              await Permission.storage.request();
              if(status.isPermanentlyDenied) openAppSettings();
            }
        }
        // var manage = await Permission.manageExternalStorage.request();
        // debugPrint('here : $manage');
        // if(!manage.isGranted){
        //   await Permission.manageExternalStorage.request();
        //   if(manage.isPermanentlyDenied) openAppSettings();
        // }
        // Directory generalDownloadDir = Directory('/storage/emulated/0/Bill_App');
        
        Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
        // debugPrint("dire : ${generalDownloadDir.path}");
        File('${generalDownloadDir.path}/Bill_Data_$date.xlsx')
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!);
        debugPrint("saved");
      }
  
    }
  }
  // void shareExcel(Excel excel) async {

  // }
}
