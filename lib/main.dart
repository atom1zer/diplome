import 'package:auth_ui/api/invoice_in_list.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Screens/authentification_screen.dart';
import './Screens/welcome_screen.dart';
import './Screens/auth_200.dart';
import 'Screens/add_customers.dart';
import 'Screens/add_item.dart';
import 'Screens/catalog.dart';
import 'Screens/customer_checkouts.dart';
import 'Screens/customer_invoices.dart';
import 'Screens/customers_catalog.dart';
import 'Screens/info_about_invoice.dart';
import 'Screens/invoice_draft.dart';
import 'Screens/new_order.dart';
import 'Screens/plan_sub.dart';
import 'Screens/report.dart';
import 'Screens/update_pers_info.dart';

late bool CheckValue;

Future<bool> _loadPerson() async {
  final prefs = await SharedPreferences.getInstance();
  final EncryptedSharedPreferences encryptedSharedPreferences =
  EncryptedSharedPreferences(prefs: prefs);
  //encryptedSharedPreferences.prefs!.remove('bearer_t');
  CheckValue = encryptedSharedPreferences.prefs!.containsKey('bearer_t');
  print(CheckValue);

  return CheckValue;
}

/*Future<void> check_date_auth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
   // DateTime lastMessageTime = DateTime(prefs.getInt("lastMessageTime")!.toInt());
    print('Дата последней авторизации: ;${prefs.getString('date_auth').toString()}');
    if (now.difference( DateTime.fromMillisecondsSinceEpoch(int.parse(prefs.getString('date_auth').toString()))).inDays >= 1) {
      prefs.remove("email");
      prefs.remove("password");
      prefs.remove("bearer_t");
    }
}*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //await check_date_auth();
  await _loadPerson();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  get det_invoice => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.pinkAccent),
      home: CheckValue == true ? AfterAuthScreen(true) : WelcomeScreen(),
      routes: {
        WelcomeScreen.routeName: (context) => WelcomeScreen(),
        AuthentificationScreen.routeName: (context) => AuthentificationScreen(),
        AfterAuthScreen.routeName: (context) => AfterAuthScreen(false),
        CatalogScreen.routeName: (context) => CatalogScreen(0),
        AddItemScreen.routeName: (context) => AddItemScreen(true,'', '',[]),
        Customers_CatalogScreen.routeName: (context) => Customers_CatalogScreen(0),
        AddCustomersScreen.routeName: (context) => AddCustomersScreen(),
        Update_CustomerScreen.routeName: (context) => Update_CustomerScreen('', '', '', '', '', '', '','','',''),
        New_OrderScreen.routeName: (context) => New_OrderScreen('', '',''),
               Invoice_draft_Screen.routeName: (context) => Invoice_draft_Screen('','','', '', [], '', '', '', ''),
        Plan_SubScreen.routeName: (context) => Plan_SubScreen(),
               Customer_InvoicesScreen.routeName: (context) => Customer_InvoicesScreen(true,'',''),
        Info_About_InvoiceScreen.routeName: (context) => Info_About_InvoiceScreen(det_invoice, ''),
        Customer_checkouts_Screen.routeName: (context) => Customer_checkouts_Screen('',''),
        ReportScreen.routeName: (context) => ReportScreen(),
      },
    );
  }
}