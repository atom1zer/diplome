import 'dart:convert';
import 'package:auth_ui/api/add_sub.dart';
import 'package:auth_ui/api/add_sub_plan.dart';
import 'package:auth_ui/api/api_catalog.dart';
import 'package:auth_ui/api/catalog_cc.dart';
import 'package:auth_ui/api/catalog_plans.dart';
import 'package:auth_ui/api/customers_cc.dart';
import 'package:auth_ui/api/location.dart';
import 'package:auth_ui/api/locations_catalog.dart';
import 'package:auth_ui/api/recurring_price_money.dart';
import 'package:auth_ui/api/sub_plan.dart';
import 'package:auth_ui/api/variations.dart';
import 'package:auth_ui/class/frecuency.dart';
import 'package:auth_ui/others/change_options.dart';
import 'package:connectivity/connectivity.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:auth_ui/others/on_session.dart' as globals;


class Plan_SubScreen extends StatefulWidget {

  static const routeName = '/plan_sub';

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title: Text( '', style: TextStyle(color: Colors.white70)),
      ),
      //title: 'Shared preferences demo',
    );
  }

  @override
  State<Plan_SubScreen> createState() => _Plan_SubState();

}


class _Plan_SubState extends State<Plan_SubScreen> {

  final name_plan_Controller = TextEditingController();
  final search_plan_Controller = TextEditingController();
  final price_plan_Controller = TextEditingController();
  final frecuency_plan_Controller = TextEditingController();
  final datepicker_plan_ends_Controller= TextEditingController();
  final notes_Controller = TextEditingController();
  final quantity_Controller = TextEditingController();
  final datepicker_sub_start_Controller = TextEditingController();
  final location_Controller = TextEditingController();
  final location_search_Controller = TextEditingController();
  late List<Frecuency> frecuency_list;
  late Object this_frecuency;
  late Catalog_cc catalog_cc;
  late Catalog_plan plans;
  late final snack_bar_nul;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> scaffoldKey_2 = new GlobalKey<ScaffoldState>();
  late Future future_customers;
  late bool isInternetOn;
  late Catalog catalog;
  late Variations? selectedRadioTile;
  late int quantity;
  late String value;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  late Object this_location;
  late Object this_plan;
  late Object this_customer;
  late List<Location>? locations_list;
  late Customers_cc customers_cc;
  late bool get_customers_ready;
  late Add_sub_plan new_plan;
  late Subscription_plan subscription_plan;
  late Recurring_price_money recurring_price_money;
  late Add_sub new_sub;
  List<Customers_cc> items = [];
  TextEditingController controller = TextEditingController();
  late String? selectedRadioTile_plan;
  late List<Subscription_plan> search_plans = [];
  List<Location>? locations_list_search;
  late String? selectedRadioTile_location;
  late final snack_bar;
  late final snack_bar_plan;
  late Locations_catalog locations_catalog;

  get item_variation_data => null;

  Future<String> _selectDate_sub_start(BuildContext context) async {
    final DateTime? d = await showDatePicker( //we wait for the dialog to return
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(2023),
    );
    if (d != null) //if the user has selected a date
      setState(() {
        datepicker_sub_start_Controller.text = new DateFormat("y-M-d").format(d);
        print(datepicker_sub_start_Controller.text);

      });

    return  datepicker_sub_start_Controller.text;
  }

  @override
  void initState() {
    super.initState();
    frecuency_list = [];
    frecuency_list.add(Frecuency(name: 'Еженедельно', value: 'WEEKLY'));
    frecuency_list.add(Frecuency(name: 'Ежемесячно', value: 'MONTHLY'));
    this_frecuency = '';
    future_customers = get_customers();
    isInternetOn = true;
    selectedRadioTile = Variations(id: '', type: '', item_variation_data: item_variation_data, updated_at: '', created_at: '', version: '', is_deleted: false, present_at_all_locations: false);
    GetConnect();
    quantity = 1;
    quantity_Controller.text = quantity.toString();
    value = '';
    this_location = Object();
    this_customer = Object();
    this_plan = Object();
    locations_list = [];
    //get_customers();
    get_customers_ready = true;
    selectedRadioTile_plan = '';
    locations_list_search = [];
    locations_list_search!.addAll(locations_list!);
    selectedRadioTile_location = '';
    snack_bar =
        SnackBar(
          backgroundColor: Colors.green.shade600,
          content: const Text('Подписка успешно создана!', style: TextStyle(fontSize: 20, color: Colors.white70), textAlign: TextAlign.center,),
          duration: const Duration(milliseconds: 5000),
          //width: 280.0, // Width of the SnackBar.
          /*padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, // Inner padding for SnackBar content.
                                  ),*/
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
    snack_bar_plan =
        SnackBar(
          backgroundColor: Colors.green.shade600,
          content: const Text('План успешно создан!', style: TextStyle(fontSize: 20, color: Colors.white70), textAlign: TextAlign.center,),
          duration: const Duration(milliseconds: 5000),
          //width: 280.0, // Width of the SnackBar.
          /*padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, // Inner padding for SnackBar content.
                                  ),*/
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
  }

  Future<void> add_new_plan() async {
    final employeeId = Guid.newGuid;
    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();

    // await new_order_post();
    //create_invoice = Create_invoice(order_id: 'order_id', delivery_method: selected_communication.toString(), payment_method: selected_payment_option.toString(), due_date: datepicker_invoice_Controller.text, message: message_invoice_Controller.text);
    recurring_price_money = Recurring_price_money(amount: int.parse(price_plan_Controller.text)*100, currency: 'RUB');
    subscription_plan = Subscription_plan(name: name_plan_Controller.text, cadence: this_frecuency.toString(), recurring_price_money: recurring_price_money, id: '');
    new_plan = Add_sub_plan(idempotency_key: employeeId.toString(),subscription_plan: subscription_plan);

    final jsonToString = jsonEncode(new_plan);
    print('jsonToString  $jsonToString');


      var response = await http.post(
          '${Change_options.url_api_server}/subscription-plans',
          headers: {
            'Authorization': 'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t')?
            globals.before_restart_token :  token}',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }, body: jsonToString);
      print(response);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    Map<String, dynamic> response_dec = jsonDecode(
        response.body);

      if (response.statusCode >= 200 && response.statusCode <= 300) {

        print("Plan успешно добавлен: ${response.body}");
        hideKeyboard();
        name_plan_Controller.clear();
        price_plan_Controller.clear();
        frecuency_plan_Controller.clear();
        scaffoldKey_2.currentState!.showSnackBar(snack_bar_plan);
      }else {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) =>
                AlertDialog(
                  title: Text("Ошибка!"),
                  content: Text("${response_dec['message']}"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                  elevation: 24.0,
                  backgroundColor: Colors.white,
                )
        );
      }
  }

  Future<void> add_new_sub(Customers_cc object) async {
    final employeeId = Guid.newGuid;

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    new_sub = Add_sub(idempotency_key: employeeId.toString(),location_id: selectedRadioTile_location.toString(), plan_id: selectedRadioTile_plan.toString(), customer_id: object.id,
        start_date: datepicker_sub_start_Controller.text);

    final jsonToString = jsonEncode(new_sub);
    print('jsonToString  $jsonToString');

    var response = await http.post('${Change_options.url_api_server}/subscriptions',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t') ?
        globals.before_restart_token :  token}','Content-Type':'application/json', 'Accept':'application/json'} , body: jsonToString);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    Map<String, dynamic> response_dec = jsonDecode(
        response.body);

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      //email_name = emailController.text;
      // получить общие настройки

      print("Sub успешно добавлен: ${response.body}");
      hideKeyboard();
      datepicker_sub_start_Controller.clear();
      notes_Controller.clear();

      this_location = '';
      location_Controller.clear();
      name_plan_Controller.clear();

      scaffoldKey.currentState!.showSnackBar(snack_bar);
      /*Navigator.push(context, MaterialPageRoute(
          builder: (context) => CatalogScreen(check)));*/
      //Navigator.of(context).pop(true);
    }else {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) =>
              AlertDialog(
                title: Text("Ошибка!"),
                content: Text("${response_dec['message']}"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
                elevation: 24.0,
                backgroundColor: Colors.white,
              )
      );
    }
  }

  Future<Catalog_plan> get_plans() async {

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    var response = await http.get('${Change_options.url_api_server}/subscription-plans',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t') ?
        globals.before_restart_token :  token}','Content-Type':'application/json'} /*, body: jsonToString*/);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print("ЭТО response.body.length  ${response.body.length}");
    final jsonToString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
    print('jsonToString:   ${jsonToString}');

    plans = Catalog_plan.fromJson(jsonToString);
    print(plans);
    search_plans.clear();
    search_plans.addAll(plans.catalog_plan);


    return plans;
  }


  Future<Locations_catalog> get_locations() async {


    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    var response = await http.get('${Change_options.url_api_server}/locations',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t') ?
        globals.before_restart_token :  token}','Content-Type':'application/json'} /*, body: jsonToString*/);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print("ЭТО response.body.length  ${response.body.length}");
    final jsonToString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
    print('jsonToString:   ${jsonToString}');

    locations_catalog = Locations_catalog.fromJson(jsonToString);
    print(locations_catalog);
    locations_list_search!.clear();
    locations_list_search!.addAll(locations_catalog.locations_catalog);
    /*search_plans.clear();
    search_plans.addAll(plans.catalog_plan);*/


    return locations_catalog;
  }


  /*void Value(){
    value = '${this_plan. } ₽';}*///ДОДЕЛАТЬ ПОСЛЕ РЕАЛИЗАЦИИ ПЛАНОВ


  void filterSearchPlans(String query) {
    List<Subscription_plan> dummySearchList = <Subscription_plan>[];
    dummySearchList.addAll(plans.catalog_plan);
    if(query.isNotEmpty) {
      List<Subscription_plan> dummyListData = <Subscription_plan>[];
      dummySearchList.forEach((item) {
        if(item.name.contains(query)) {
          print('СОДЕРЖИТ!!!');
          dummyListData.add(item);
        }
      });
      setState(() {
        search_plans.clear();
        search_plans.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        search_plans.clear();
        search_plans.addAll(plans.catalog_plan);
      });
    }

  }

  void filterSearchLocation(String query) {
    List<Location> dummySearchList = <Location>[];
    dummySearchList.addAll(locations_list_search!);
    if(query.isNotEmpty) {
      List<Location> dummyListData = <Location>[];
      dummySearchList.forEach((item) {
        if(item.name.contains(query)) {
          print('СОДЕРЖИТ!!!');
          dummyListData.add(item);
        }
      });
      setState(() {
        locations_list_search!.clear();
        locations_list_search!.addAll(dummyListData);
      });
    } else {
      setState(() {
        locations_list_search!.clear();
        locations_list_search!.addAll(locations_catalog.locations_catalog);
      });
    }

  }

  _showChooseLocation(context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    selectedRadioTile_location = null;
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // should dialog be dismissed when tapped outside
      barrierLabel: "Modal", // label for barrier
      transitionDuration: Duration(milliseconds: 100), // how long it takes to popup dialog after button click
      pageBuilder: (_,__, ___) {
        return StatefulBuilder(
            builder: (context, StateSetter setState)
            { // your widget implementation
              return Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.white,
                    centerTitle: true,
                    leading: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          //selectedRadioTile_location = '';
                          Navigator.pop(context);
                        }
                    ),
                    actions: <Widget>[
                      Container(
                        child: IconButton(
                          onPressed: () {
                            location_Controller.text = this_location.toString();
                            hideKeyboard();
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                    title: Text(
                      'Торговые точки',
                      style: TextStyle(color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Overpass',
                          fontSize: 24),
                    ),
                    elevation: 0.0
                ),
                backgroundColor: Colors.white.withOpacity(0.95),
                body: Container(
                  height: screenHeight,
                  width: screenWidth,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              leading: Icon(Icons.search, color: Color.fromRGBO(124, 58, 237, 0.8)),
                              title: TextField(
                                controller: location_search_Controller,
                                decoration: InputDecoration(
                                    hintText: 'Поиск торговой точки', border: InputBorder.none),
                                onChanged: (value) {
                                  setState((){
                                    filterSearchLocation(value);
                                  });
                                },
                              ),
                              trailing: IconButton(icon: Icon(Icons.cancel,),
                                onPressed: () {
                                  location_search_Controller.clear();
                                  setState(() {
                                    locations_list_search!.clear();
                                    locations_list_search!.addAll(locations_catalog.locations_catalog);
                                  });
                                  //onSearchTextChanged('');
                                },),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(height: 10.0,),
                      // Divider(color: Colors.black, thickness: 3,),

                      Expanded(
                        child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            itemCount: locations_list_search!.length,
                            separatorBuilder: (BuildContext context, int index) =>
                                Divider(color: Colors.black, thickness: 1,),
                            itemBuilder: (BuildContext context, int ind) {
                              return RadioListTile<String>(
                                // controlAffinity: ListTileControlAffinity.leading,
                                title: Text('${locations_list_search![ind].name}',
                                    style: TextStyle(color: Colors.black87,
                                        fontFamily: 'Overpass', fontSize: 16)),
                                groupValue: selectedRadioTile_location,
                                onChanged: (val) async{
                                  setState(()  {
                                    print("Radio Tile pressed $val");
                                    selectedRadioTile_location = val;
                                    this_location = locations_list_search![ind].name.toString();
                                  });

                                },
                                selected: true,
                                value: locations_list_search![ind].id,
                              );
                            }),
                        // flex:5,
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }


  _showChoosePlan(context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    selectedRadioTile_plan = null;
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // should dialog be dismissed when tapped outside
      barrierLabel: "Modal", // label for barrier
      transitionDuration: Duration(milliseconds: 100), // how long it takes to popup dialog after button click
      pageBuilder: (_,__, ___) {
        return StatefulBuilder(
            builder: (context, StateSetter setState)
            { // your widget implementation
              return Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.white,
                    centerTitle: true,
                    leading: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          selectedRadioTile_plan = '';
                          Navigator.pop(context);
                        }
                    ),
                    actions: <Widget>[
                      Container(
                        child: IconButton(
                          onPressed: () {
                            name_plan_Controller.text = this_plan.toString();
                            hideKeyboard();
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                    title: Text(
                      'Планы',
                      style: TextStyle(color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Overpass',
                          fontSize: 24),
                    ),
                    elevation: 0.0
                ),
                backgroundColor: Colors.white.withOpacity(0.95),
                body: Container(
                  height: screenHeight,
                  width: screenWidth,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              leading: Icon(Icons.search, color: Color.fromRGBO(124, 58, 237, 0.8)),
                              title: TextField(
                                controller: search_plan_Controller,
                                decoration: InputDecoration(
                                    hintText: 'Поиск плана', border: InputBorder.none),
                                onChanged: (value) {
                                  setState((){
                                    filterSearchPlans(value);
                                  });
                                },
                              ),
                              trailing: IconButton(icon: Icon(Icons.cancel,),
                                onPressed: () {
                                  search_plan_Controller.clear();
                                  setState(() {
                                    search_plans.clear();
                                    search_plans.addAll(plans.catalog_plan);
                                  });
                                  //onSearchTextChanged('');
                                },),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(height: 10.0,),
                      // Divider(color: Colors.black, thickness: 3,),

                      Expanded(
                        child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            itemCount: search_plans.length,
                            separatorBuilder: (BuildContext context, int index) =>
                                Divider(color: Colors.black, thickness: 1,),
                            itemBuilder: (BuildContext context, int ind) {
                              return RadioListTile<String>(
                                // controlAffinity: ListTileControlAffinity.leading,
                                title: Text('${search_plans[ind].name}',
                                    style: TextStyle(color: Colors.black87,
                                        fontFamily: 'Overpass', fontSize: 16)),
                                groupValue: selectedRadioTile_plan,
                                onChanged: (val) async{
                                  setState(()  {
                                    print("Radio Tile pressed $val");
                                    selectedRadioTile_plan = val;
                                    this_plan = search_plans[ind].name.toString();
                                  });

                                },
                                selected: true,
                                value: search_plans[ind].id,
                              );
                            }),
                        // flex:5,
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }


  Widget userInput(TextEditingController userInput, String label,
      TextInputType keyboardType, readOnly) {
    return Container(
      // margin: EdgeInsets.only(top: 10),

      child:  TextField(

        controller: userInput,
        readOnly: readOnly,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38),
            ),

            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(124, 58, 237, 0.8)),
            ),
            labelText: (label),
            labelStyle: TextStyle(
                color: Color.fromRGBO(124, 58, 237, 0.8)
            )
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  Future<Catalog> get() async {

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    var response = await http.get('${Change_options.url_api_server}/catalog/list',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t')  ?
        globals.before_restart_token :  token}','Content-Type':'application/json'} /*, body: jsonToString*/);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print("ЭТО response.body.length  ${response.body.length}");
    final jsonToString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
    print('jsonToString:   ${jsonToString}');

    if(response.body.length < 3){
        snack_bar_nul =
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: const Text('Каталог клиентов пуст!', style: TextStyle(fontSize: 20, color: Colors.white70), textAlign: TextAlign.center, ),
              duration: const Duration(milliseconds: 5000),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            );
        scaffoldKey.currentState!
            .showSnackBar(snack_bar_nul);

    };

    catalog = Catalog.fromJson(jsonToString);
    print(catalog);

    return catalog;
  }

  Future<Catalog_cc> get_customers() async {
    setState(() {
      get_customers_ready = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    var response = await http.get('${Change_options.url_api_server}/customers',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t') ?
        globals.before_restart_token :  token}','Content-Type':'application/json'} /*, body: jsonToString*/);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print("ЭТО response.body.length  ${response.body.length}");
    final jsonToString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
    print('jsonToString:   ${jsonToString}');

    catalog_cc = Catalog_cc.fromJson(jsonToString);
    print(catalog_cc);
    items.clear();
    items.addAll(catalog_cc.customers_cc);

    setState(() {
      get_customers_ready = false;
    });

    return catalog_cc;
  }

  void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  Future _refreshData() async {
    _refreshIndicatorKey.currentState!.show();
    return get_customers().then((_user) {
      setState(() => catalog_cc = _user);
    });

  }

  void filterSearchResults(String query) {
    List<Customers_cc> dummySearchList = <Customers_cc>[];
    dummySearchList.addAll(catalog_cc.customers_cc);
    if(query.isNotEmpty) {
      List<Customers_cc> dummyListData = <Customers_cc>[];
      dummySearchList.forEach((item) {
        if(item.email_address.contains(query)) {
          print('СОДЕРЖИТ!!!');
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(catalog_cc.customers_cc);
      });
    }

  }


  void GetConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
      });
    }else{
      setState(() {
        isInternetOn = true;
      });
    }
  }

  setSelectedRadioTile(Variations val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  _showFullModal(context, Customers_cc object) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    selectedRadioTile = null;
    value = '';
    quantity_Controller.text = '1';
    quantity = 1;
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // should dialog be dismissed when tapped outside
      barrierLabel: "Modal", // label for barrier
      transitionDuration: Duration(milliseconds: 500), // how long it takes to popup dialog after button click
      pageBuilder: (_,__, ___) {
        return StatefulBuilder(
            builder: (context, StateSetter setState)
            { // your widget implementation
              return Scaffold(
                key: scaffoldKey,
                appBar: AppBar(
                    backgroundColor: Colors.white,
                    centerTitle: true,
                    leading: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          selectedRadioTile_location = '';
                          location_Controller.clear();
                          selectedRadioTile_plan = '';
                          name_plan_Controller.clear();
                          datepicker_sub_start_Controller.clear();
                          Navigator.pop(context);
                        }
                    ),
                    actions: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(124, 58, 237, 0.8),
                        ),
                        child: TextButton(
                          onPressed: () {
                            add_new_sub(object);
                          },
                          child: Text('Добавить', style: TextStyle(color: Colors.black87,
                            fontFamily: 'Overpass',
                            fontSize: 14,)),
                        ),
                      ),

                    ],
                    title: Text(
                      '${object.email_address}  $value',
                      style: TextStyle(color: Colors.black87,
                          fontFamily: 'Overpass',
                          fontSize: 16),
                    ),
                    elevation: 0.0
                ),
                backgroundColor: Colors.white.withOpacity(0.95),
                body: Container(
                  height: screenHeight,
                  width: screenWidth,
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(

                        child: Column(
                          children: [
                            TextField(
                              readOnly: true,
                              controller: name_plan_Controller,
                              style: TextStyle(color: Colors.black87,
                                fontFamily: 'Overpass', fontSize: 16,),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color:  Colors.black, width: 1),
                                ),

                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(124, 58, 237, 0.8)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Выберите план',),
                              onTap: () async {
                                await get_plans();
                                setState((){
                                  _showChoosePlan(context);
                                });
                              },
                            ),

                            SizedBox(height: 20.0,),

                            TextField(
                              readOnly: true,
                              controller: location_Controller,
                              style: TextStyle(color: Colors.black87,
                                fontFamily: 'Overpass', fontSize: 16,),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color:  Colors.black, width: 1),
                                ),

                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(124, 58, 237, 0.8)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Выберите торговую точку',),
                              onTap: ()async {
                                await get_locations();
                                setState((){
                                  _showChooseLocation(context);
                                });
                              },
                            ),
                            SizedBox(height: 20.0,),

                            TextFormField(
                              readOnly: true,
                              controller: datepicker_sub_start_Controller,
                              decoration:  InputDecoration(
                                  prefixIcon:
                                  IconButton(
                                    icon: const Icon(Icons.today),
                                    iconSize: 20.0,
                                    splashColor: Color.fromRGBO(124, 58, 237, 0.8),
                                    splashRadius: 10,
                                    color: Color.fromRGBO(124, 58, 237, 0.8),
                                    onPressed: () {
                                      _selectDate_sub_start(context);
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black38),
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromRGBO(124, 58, 237, 0.8)),
                                  ),
                                  labelText: 'Дата начала действия подписки',
                                  labelStyle: TextStyle(
                                      color: Color.fromRGBO(124, 58, 237, 0.8)
                                  )
                              ),
                            ),
                            SizedBox(height: 20.0,),

                           // userInput(notes_Controller, 'Заметки', TextInputType.text, false),
                          ],
                        ),
                       // flex: 2,
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  Widget list_customers_Widjet() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: future_customers,
                builder: (BuildContext context, snapshot){
                  print("snapshot.data: ${snapshot.data.toString()}");
                  if(snapshot.connectionState == ConnectionState.waiting &&
                      snapshot.data == null){
                    return Container(
                        height: screenHeight,
                        color: Colors.white,
                        child: SafeArea(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              //shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (BuildContext ctx, index) {
                                return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                    child: Shimmer.fromColors(
                                      highlightColor: Colors.deepPurpleAccent,
                                      baseColor: Color.fromRGBO(124, 58, 237, 0.8)/*Colors.grey[500]*/,
                                      child: Container(
                                        margin: EdgeInsets.only(right : 0),
                                        height: 80,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      period: Duration(milliseconds: 805),
                                    )
                                );
                              }),
                        )
                    );
                  }else if(isInternetOn == false){
                    return Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Подключение к интернету отсутствует', style: TextStyle(fontSize: 24, color: Color.fromRGBO(124, 58, 237, 0.8)), textAlign: TextAlign.center,),
                        )
                    );
                  }
                  else if(snapshot.connectionState == ConnectionState.done && snapshot.data.toString().length == 30 && isInternetOn == true){
                    return Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Каталог клиентов пуст', style: TextStyle(fontSize: 24, color: Color.fromRGBO(124, 58, 237, 0.8)), textAlign: TextAlign.center,),
                        )
                    );
                  }
                  else{
                    print('В ОСНОВНУЮ ЧАСТЬ');
                    return
                      Column(
                          children: <Widget>[
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: ListTile(
                                    leading: Icon(Icons.search, color: Color.fromRGBO(124, 58, 237, 0.8)),
                                    title: TextField(
                                      controller: controller,
                                      decoration: InputDecoration(
                                          hintText: 'Поиск', border: InputBorder.none),
                                      onChanged: (value) {
                                        filterSearchResults(value);
                                      },
                                    ),
                                    trailing: IconButton(icon: Icon(Icons.cancel,), onPressed: () {
                                      controller.clear();
                                      setState(() {
                                        items.clear();
                                        items.addAll(catalog_cc.customers_cc);
                                      });
                                      //onSearchTextChanged('');
                                    },),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child:  RefreshIndicator(
                                  displacement: 30,
                                  strokeWidth: 4.0,
                                  color: Color.fromRGBO(124, 58, 237, 0.8),
                                  child: ListView.separated(
                                    //scrollDirection: Axis.vertical,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      itemCount: items.length,
                                      separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black, thickness: 1,),
                                      itemBuilder: (BuildContext context, int index){
                                        print('CATALOG ${items.length}');
                                        return ListTile(

                                          title: Text('${items[index].email_address}', style: TextStyle(color: Colors.black),),

                                          onTap: () async {
                                            print('НАЖАЛ $index');
                                            _showFullModal(context, items[index]);
                                            //get_plans();
                                            //update_customer(catalog_cc.customers_cc[ind].id);
                                            // update_item(catalog.objects[index].id);
                                          },
                                        );
                                      }
                                  ),
                                  key: _refreshIndicatorKey,
                                  onRefresh: _refreshData,)
                            ),
                          ]);
                  }
                }
            ),
          )
        ],
      ),
    );
  }

  Widget sub_Widjet() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight,
      width: screenWidth,
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        children: [
          Text('Создание подписки', style: TextStyle(color: Colors.black87,
              fontFamily: 'Overpass', fontSize: 20, fontWeight: FontWeight.bold )),
          SizedBox(height: 20.0,),
        ],
      ),
    );
  }

  Widget planWidjet() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight,
      width: screenWidth,
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Создание плана', style: TextStyle(color: Colors.black87,
                fontFamily: 'Overpass', fontSize: 20, fontWeight: FontWeight.bold )),
            SizedBox(height: 20.0,),

            userInput(name_plan_Controller, 'Название плана',
                TextInputType.text, false),
            SizedBox(height: 20.0,),
            userInput(price_plan_Controller, 'Стоимость плана',
                TextInputType.text, false),
            SizedBox(height: 20.0,),
            DropdownButtonFormField(
              hint: Text('Периодичность оплаты', style: TextStyle(color: Color.fromRGBO(124, 58, 237, 0.8)),),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:  Color.fromRGBO(124, 58, 237, 0.8), width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              items: frecuency_list.map((Frecuency frecuency_list) => DropdownMenuItem(
                child: Text(frecuency_list.name),
                value: frecuency_list.value,
              ),
              ).toList(),
              onChanged: (newValue) {
                setState(() {
                  this_frecuency = newValue!;
                  print(this_frecuency);
                });
              },
            ),
            SizedBox(height: 20.0,),
            RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              color: Color.fromRGBO(124, 58, 237, 0.8),
              onPressed: () {

                add_new_plan();
                hideKeyboard();

              },
              child: Text('Создать план', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white,),),
            ),
          ]
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey_2,
          appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
                  //title: Text( 'План & подписка', style: TextStyle(color: Colors.white70)),

                  flexibleSpace: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TabBar(
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(20), // Creates border
                            color: Colors.white24),
                        isScrollable: true,
                        tabs: [
                          Tab(child: Text('План', style: TextStyle(fontSize: 20.0),)),
                          Tab(child: Text('Подписки', style: TextStyle(fontSize: 20.0),)),
                        ],
                      ),
                    ],
                  ),
                ),
            body: TabBarView(
              children: <Widget>[
                //Icon(Icons.flight, size: 350),
                Column(children: [
                  Expanded(
                      child: Padding(padding: EdgeInsets.all(10.0),
                          child: Container(
                            width: screenWidth,
                            child: planWidjet(),
                          )
                      )
                  ),
                ],),
                Tab(
                  child:
                Column(children: [
                  Expanded(
                      child: Padding(padding: EdgeInsets.all(10.0),
                          child: list_customers_Widjet(),
                      )
                  ),
                ],),),
              ],
            ),
          ),
    );
  }
}