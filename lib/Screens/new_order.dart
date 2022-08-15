import 'dart:async';
import 'dart:convert';
import 'package:auth_ui/Screens/auth_200.dart';
import 'package:auth_ui/Screens/welcome_screen.dart';
import 'package:auth_ui/Widjets/drawer.dart';
import 'package:auth_ui/api/add_item_var.dart';
import 'package:auth_ui/api/add_order.dart';
import 'package:auth_ui/api/api_catalog.dart';
import 'package:auth_ui/api/base_price_money.dart';
import 'package:auth_ui/api/catalog_cc.dart';
import 'package:auth_ui/api/create_invoice.dart';
import 'package:auth_ui/api/create_invoice_message_null.dart';
import 'package:auth_ui/api/customers_cc.dart';
import 'package:auth_ui/api/line_include.dart';
import 'package:auth_ui/api/line_item_include_2.dart';
import 'package:auth_ui/api/location.dart';
import 'package:auth_ui/api/locations_catalog.dart';
import 'package:auth_ui/api/objects.dart';
import 'package:auth_ui/api/parse_order.dart';
import 'package:auth_ui/api/take_invoice_status.dart';
import 'package:auth_ui/api/variation_retrive_id.dart';
import 'package:auth_ui/api/variations.dart';
import 'package:auth_ui/class/model_order.dart';
import 'package:auth_ui/others/change_options.dart';
import 'package:connectivity/connectivity.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'invoice_draft.dart';
import 'package:auth_ui/others/on_session.dart' as globals;

class New_OrderScreen extends StatefulWidget {

  static const routeName = '/new_orders';
  late String customer_email_address;
  late String customer_reference_id;
  late String id;

  New_OrderScreen(String EMAIL, String REF_ID, String ID){

    customer_email_address = EMAIL;
    customer_reference_id = REF_ID;
    id = ID;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title: Text( 'Заказы', style: TextStyle(color: Colors.white70)),
      ),
    );
  }

  @override
  State<New_OrderScreen> createState() => _New_OrderScreenState();

}


class _New_OrderScreenState extends State<New_OrderScreen> {

  late Map<String, dynamic> formData;
  late List<String> cities;
  late List<String> countries;
  late Catalog catalog;
  late Future catalog_future;
  late Model_order item_sale;
  late List<Model_order> all_items_sale;
  late List<Model_order> table_items;

  late List<String> name_catalog_items;
  late bool flag;
  final name_custom_Controller = TextEditingController();
  final quantity_custom_Controller = TextEditingController();
  final price_custom_Controller = TextEditingController();
  final customer_invoice_Controller = TextEditingController();
  final message_invoice_Controller = TextEditingController();
  final datepicker_invoice_Controller = TextEditingController();
  final email_invoice_Controller = TextEditingController();
  final quantity_Controller = TextEditingController();
  final location_Controller = TextEditingController();
  final location_search_Controller = TextEditingController();
  final customer_search_Controller = TextEditingController();
  late Variation_retrive_id catalog_retrive;

  late bool isInternetOn;
  late String? selectedRadioTile;
  late String? selectedRadioTile_location;
  late String? selectedRadioTile_customer;
  late String? selected_payment_option;
  late String? selected_communication;
  late bool _loading;
  late bool get_customers_ready;
  bool readonly_check = false;
  late String this_location;
  late String this_customer;
  late Catalog_cc catalog_cc;
  late List<Customers_cc> all_customers;
  late Add_order add_order;
  late Line_include line_include;
  late List<Object> list_line_include;
  late List<String> list_catalog_id;
  late Line_item_include_2 line_include_2;
  late bool _get_loading;
  late String status;
  late String app_bar_title;
  int sum = 0;
  late int count;
  late String _selectedDate;
  late List<String> payment_options;
  late List<String> communications;
  late Parse_order order;
  late Create_invoice create_invoice;
  late Create_invoice_mess_null create_invoice_mess;
  late String cust_id;
  late String ref_id;
  late Take_invoice_status take_invoice;
  late Future future_items;
  late String value;
  late String ref_id_from_select;
  late int quantity;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  List<Objects> items = [];
  List<Customers_cc> search_customer = [];
  TextEditingController controller = TextEditingController();
  late List<Location>? locations_list_search;
  late List<Location>? locations_list;
  late Locations_catalog locations_catalog;

  get total => null;

  get message_null => null;
  //late Change_options url_api_server;

  Future<Catalog> get() async {

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    var response = await http.get('${Change_options.url_api_server}/catalog/list',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t') ?
        globals.before_restart_token :  token}','Content-Type':'application/json'} /*, body: jsonToString*/);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print("ЭТО response.body.length  ${response.body.length}");
    final jsonToString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
    print('jsonToString:   ${jsonToString}');
    catalog = Catalog.fromJson(jsonToString);
    print("ЭТО catalog  $catalog");
    items.clear();
    items.addAll(catalog.objects);
    return catalog;
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

  void filterSearchResults(String query) {
    List<Objects> dummySearchList = <Objects>[];
    /* for(int i = 0; i<catalog.objects.length; i++){
      dummySearchList.add(catalog.objects[i].item_data.name);
    }*/
    dummySearchList.addAll(catalog.objects);
    if(query.isNotEmpty) {
      List<Objects> dummyListData = <Objects>[];
      dummySearchList.forEach((item) {
        if(item.item_data.name.contains(query)) {
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
        items.addAll(catalog.objects);
      });
    }

  }


  void filterSearchCustomer(String query) {
    List<Customers_cc> dummySearchList = <Customers_cc>[];
    /* for(int i = 0; i<catalog.objects.length; i++){
      dummySearchList.add(catalog.objects[i].item_data.name);
    }*/
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
        search_customer.clear();
        search_customer.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        search_customer.clear();
        search_customer.addAll(catalog_cc.customers_cc);
      });
    }

  }

  void filterSearchLocation(String query) {
    List<Location> dummySearchList = <Location>[];
    /* for(int i = 0; i<catalog.objects.length; i++){
      dummySearchList.add(catalog.objects[i].item_data.name);
    }*/
    dummySearchList.addAll(locations_list!);
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
      return;
    } else {
      setState(() {
        locations_list_search!.clear();
        locations_list_search!.addAll(locations_list!);
      });
    }

  }

  String final_value(){
  if(all_items_sale.length > 0){
  sum = 0;
    for(int z = 0; z<all_items_sale.length; z++){
    sum = sum + all_items_sale[z].value;
    }
    setState(() {
      sum;
    });

  }
  return sum.toString();
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

  Future<void> new_order_post() async {

    final employeeId = Guid.newGuid;
    list_line_include.clear();

    for(int i = 0; i<all_items_sale.length; i++){

      if(all_items_sale[i].is_customize == true){

        Bace_price_money bace_price_money = Bace_price_money(amount: int.parse(all_items_sale[i].price.toString()), currency: 'RUB');
        line_include = Line_include(quantity:  all_items_sale[i].quantity.toString(),
            name:  all_items_sale[i].name.toString(), bace_price_money: bace_price_money);
        list_line_include.add(line_include);

      } else if(all_items_sale[i].is_customize == false){

        line_include_2 = Line_item_include_2(quantity:  all_items_sale[i].quantity.toString(), catalog_object_id: all_items_sale[i].id_from_catalog_item);
        list_line_include.add(line_include_2);

      }
    }
   /* if(get_customers_ready == false){
      for(int i = 0; i<catalog_cc.customers_cc.length; i++){
        if(catalog_cc.customers_cc[i].email_address == widget.customer_email_address){
          cust_id = catalog_cc.customers_cc[i].id;
          ref_id = catalog_cc.customers_cc[i].reference_id;
          print('АЙДИ КАСТОМЕРА $cust_id');
        }
      }
    }*/


    add_order = Add_order(idempotency_key: employeeId.toString(),location_id: selectedRadioTile_location.toString(),
        customer_id: widget.customer_email_address != '' ? widget.id : selectedRadioTile_customer.toString(),
        line_items: list_line_include, id: '', order_state: '', total_amount: total);

    print('widget.customer_reference_id.toString() тут  ${widget.customer_reference_id}');
    print('ref_id_from_select тут  ${ref_id_from_select.toString()}');

    final jsonToString = jsonEncode(add_order);
    print('jsonToString  $jsonToString');


    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    var response = await http.post('${Change_options.url_api_server}/orders',
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

      print("Order успешно добавлен: ${response.body}");
      hideKeyboard();
      final jsonString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
      print('jsonString:   $jsonString');
      order = Parse_order.fromJson(jsonString);
      print('ORDER $order');

     /* setState(() {
        done = true;
      });*/

      //new_invoice();
      /*Navigator.push(context, MaterialPageRoute(
          builder: (context) => CatalogScreen(check)));*/
      //Navigator.of(context).pop(true);

    }else {
      /* Map<String, dynamic> mess = jsonDecode(
                                                      response.body);*/

      // print("Requare: ${mess['message']}");
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

  List<Model_order> take_list_sale(){
    setState(() {
      all_items_sale;
    });
    return all_items_sale;
  }

  Future<void> new_invoice() async {

    final jsonToString;
    if(message_invoice_Controller.text.length !=0){
      create_invoice = Create_invoice(order_id: order.order.id, delivery_method: selected_communication.toString(), payment_method: selected_payment_option.toString(), due_date: datepicker_invoice_Controller.text,
          message:  message_invoice_Controller.text);
       jsonToString = jsonEncode(create_invoice);
      print('СТРУКТУРА INVOICE  $jsonToString');
    }else {
      create_invoice_mess = Create_invoice_mess_null(order_id: order.order.id, delivery_method: selected_communication.toString(), payment_method: selected_payment_option.toString(), due_date: datepicker_invoice_Controller.text);
       jsonToString = jsonEncode(create_invoice_mess);
      print('СТРУКТУРА INVOICE без сообщения  $jsonToString');
    }

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    var response = await http.post('${Change_options.url_api_server}/invoices',
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

      print("Invoices успешно добавлен: ${response.body}");
      hideKeyboard();
      final jsonString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
      print('jsonString:  $jsonString');
      take_invoice = Take_invoice_status.fromJson(jsonString);
      print('STATUS ${take_invoice.invoice.status}');

      if(take_invoice.invoice.status == 'DRAFT'){
       /* for(int m = 0; m<catalog_cc.customers_cc.length; m++){
          if(catalog_cc.customers_cc[m].id == this_customer.toString())
            email_invoice_Controller.text = catalog_cc.customers_cc[m].email_address.toString();
        }*/
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Invoice_draft_Screen( widget.id.length == 0 ? selectedRadioTile_customer : widget.id, take_invoice.invoice.id ,widget.customer_email_address.toString() == '' ? customer_invoice_Controller.text : widget.customer_email_address.toString(),
                location_Controller.text, all_items_sale, selected_payment_option!, selected_communication!, datepicker_invoice_Controller.text, message_invoice_Controller.text)));
      }
    }else {
      /* Map<String, dynamic> mess = jsonDecode(
                                                      response.body);*/

      // print("Requare: ${mess['message']}");
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

  Future<String> _selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker( //we wait for the dialog to return
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(2023),
    );
    if (d != null) //if the user has selected a date
      setState(() {
         datepicker_invoice_Controller.text = new DateFormat("y-M-d").format(d);
         print(_selectedDate);

      });

    return  datepicker_invoice_Controller.text;
  }


  Future<Variation_retrive_id> retrive_item(id) async {

    setState(() {
      _loading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    var response = await http.get('${Change_options.url_api_server}/catalog/object/$id',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t') ?
        globals.before_restart_token :  token}','Content-Type':'application/json'} /*, body: jsonToString*/);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print("ЭТО response.body.length  ${response.body.length}");
    final jsonToString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
    print('jsonToString:   $jsonToString');
    catalog_retrive = Variation_retrive_id.fromJson(jsonToString);
    print(catalog_retrive);

    setState(() {
      _loading = false;

    });

    return catalog_retrive;
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
    search_customer.clear();
    search_customer.addAll(catalog_cc.customers_cc);

    setState(() {
      get_customers_ready = false;
    });

    return catalog_cc;
  }

  void add_item(obj){
    all_items_sale.add(obj);
  }
  void delet_item(obj){
    all_items_sale.removeWhere((Model_order all_items_sale) => all_items_sale.id == obj);
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

  @override
  void initState() {
    super.initState();
    //widget.customer_email_address == '' ? [] : get_customers();
    get_customers_ready = true;
    locations_list = [];
    all_customers = [];
    //locations_2 = Locations(public_id: '1', name: 'Москва');
    this_location = '';
    this_customer = '';
    //locations_list!.add(locations_2);
    list_line_include = [];
    list_catalog_id = [];
    _get_loading = true;
    _loading = true;
    status = 'Выберите продукт';
    app_bar_title = 'Покупка';
    print(locations_list);
    flag = false;
    name_catalog_items = [];
    selectedRadioTile = '';
    selectedRadioTile_location = '';
    selected_payment_option = '';
    selected_communication = '';
    item_sale = Model_order(id: '',id_from_catalog_item: '',name: '',descriptions: '' ,quantity: 0, price: 0, value: 0, is_customize: false);
    all_items_sale = <Model_order>[];
    table_items = <Model_order>[];
    count = 0;
    _selectedDate = '';
    payment_options = <String>['CARD'];
    communications = <String>['EMAIL'];
    email_invoice_Controller.text = widget.customer_email_address;
    future_items = get();
    value = '0';
    quantity = 1;
    GetConnect();
    locations_list_search = [];
    locations_list_search!.addAll(locations_list!);
    ref_id_from_select = '';
  }

  void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void Value(){
  value = '${catalog_retrive.object.item_data.price_money.amount*
  int.parse(quantity_Controller.text)}';
}


  _showChooseCustomer(context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    selectedRadioTile_customer = null;
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // should dialog be dismissed when tapped outside
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
                          ref_id_from_select = '';
                          selectedRadioTile_customer = '';
                          customer_search_Controller.clear();
                          Navigator.pop(context);
                        }
                    ),
                    actions: <Widget>[
                      Container(
                        child: IconButton(
                          onPressed: () {
                            customer_invoice_Controller.text = this_customer.toString();
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
                      'Покупатели',
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
                                controller: customer_search_Controller,
                                decoration: InputDecoration(
                                    hintText: 'Поиск покупателя', border: InputBorder.none),
                                onChanged: (value) {
                                  setState((){
                                    filterSearchCustomer(value);
                                  });
                                },
                              ),
                              trailing: IconButton(icon: Icon(Icons.cancel,),
                                onPressed: () {
                                  customer_search_Controller.clear();
                                  setState(() {
                                    search_customer.clear();
                                    search_customer.addAll(catalog_cc.customers_cc);
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
                            itemCount: search_customer.length,
                            separatorBuilder: (BuildContext context, int index) =>
                                Divider(color: Colors.black, thickness: 1,),
                            itemBuilder: (BuildContext context, int ind) {
                              return RadioListTile<String>(
                                // controlAffinity: ListTileControlAffinity.leading,
                                title: Text('${search_customer[ind].email_address}',
                                    style: TextStyle(color: Colors.black87,
                                        fontFamily: 'Overpass', fontSize: 16)),
                                groupValue: selectedRadioTile_customer,
                                onChanged: (val) async{
                                  setState(()  {
                                    print("Radio Tile pressed $val");
                                    selectedRadioTile_customer = val;
                                    this_customer = search_customer[ind].email_address.toString();
                                    ref_id_from_select = search_customer[ind].reference_id.toString();
                                  });

                                },
                                selected: true,
                                value: search_customer[ind].id,
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
                          selectedRadioTile_location = '';
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
                                    locations_list_search!.addAll(locations_list!);
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


  _showFullModal(context, Objects objects) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    selectedRadioTile = null;
    value = '0';
    quantity_Controller.text = '1';
    quantity = 1;
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // should dialog be dismissed when tapped outside
      barrierLabel: "Modal", // label for barrier
      transitionDuration: Duration(milliseconds: 200), // how long it takes to popup dialog after button click
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
                        item_sale =
                            Model_order(
                              id: '$count',
                              id_from_catalog_item: catalog_retrive.object.id,
                              name: catalog_retrive.object.item_data.name,
                              descriptions: 'Из списка',
                              quantity: int.parse(quantity_Controller.text),
                              price: int.parse(catalog_retrive.object.item_data.price_money.amount.toString()),
                              value: int.parse(value),
                              is_customize: false,);
                        all_items_sale.add(item_sale);
                        count++;
                        selectedRadioTile = '';
                        print('Это item_sale:    $item_sale');
                        print('Это all_items_sale:    $all_items_sale');
                        this.setState((){
                          final_value();
                          sum;
                          //take_list_sale();

                        });
                        hideKeyboard();
                        Navigator.pop(context);
                      },
                      child: Text('Добавить', style: TextStyle(color: Colors.black87,
                          fontFamily: 'Overpass',
                          fontSize: 14,)),
                    ),
                  ),

                ],
                title: Text(
                  '${objects.item_data.name}  ${int.parse(value)/100}',
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
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
               //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(

                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${objects.item_data.name}   ', style: TextStyle(color: Colors.black87,
                              fontFamily: 'Overpass', fontSize: 16, fontWeight: FontWeight.bold )),
                          Text('Выберите одну разновидность', style: TextStyle(color: Colors.black87,
                              fontFamily: 'Overpass', fontSize: 12)),
                        ],),
                    flex: 2,
                  ),

                 // SizedBox(height: 10.0,),
                  Divider(color: Colors.black, thickness: 1,),

                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                        itemCount: objects.item_data.variations.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(color: Colors.black, thickness: 1,),
                        itemBuilder: (BuildContext context, int ind) {
                          return RadioListTile<String>(
                           // controlAffinity: ListTileControlAffinity.leading,
                            title: Text('${objects.item_data.variations[ind].item_variation_data.name}',
                                style: TextStyle(color: Colors.black87,
                                fontFamily: 'Overpass', fontSize: 16)),
                            secondary: Text('${objects.item_data.variations[ind].item_variation_data.price_money.amount/100}',
                                style: TextStyle(color: Colors.black87,
                                    fontFamily: 'Overpass', fontSize: 16)),
                            groupValue: selectedRadioTile,
                            onChanged: (val) async{
                              await retrive_item(val);
                              setState(()  {
                                print("Radio Tile pressed $val");
                                selectedRadioTile = val;
                                Value();
                              });

                            },
                            selected: true,
                            value: objects.item_data.variations[ind].id,
                          );
                        }),
                    flex:5,
                  ),

                  SizedBox(height: 10.0,),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Выберите количество', style: TextStyle(color: Colors.black87,
                            fontFamily: 'Overpass', fontSize: 16, fontWeight: FontWeight.bold )),

                        SizedBox(height: 20.0,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child:  IconButton(
                                onPressed: () {
                                  setState((){
                                    if(quantity<1){

                                    } else{
                                      quantity--;
                                      quantity_Controller.text = quantity.toString();
                                      Value();
                                    }
                                  });
                                } ,
                                icon: Icon(Icons.remove)),),


                            Expanded(child: TextField(
                              onChanged: (String){
                                Value();
                              },
                              controller: quantity_Controller,
                              style: TextStyle(color: Colors.black87,
                                fontFamily: 'Overpass', fontSize: 16,),
                              textAlign: TextAlign.center,
                            ),),
                            Expanded(child: IconButton(
                                onPressed: () {
                                  setState((){
                                    quantity++;
                                    quantity_Controller.text = quantity.toString();
                                    Value();
                                  });
                                } ,
                                icon: Icon(Icons.add)),),
                        ],),
                      ],
                    ),
                    flex:5,
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }


  _showAdd_invoice(context, List<Model_order> all_items_sale) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    selectedRadioTile = null;
    value = '0';
    quantity_Controller.text = '1';
    quantity = 1;
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Modal",
      transitionDuration: Duration(milliseconds: 100),
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
                          ref_id_from_select = '';
                          selectedRadioTile_location = '';
                          selectedRadioTile_customer = '';
                          this_location = '';
                          this_customer = '';
                          datepicker_invoice_Controller.clear();
                          location_Controller.clear();
                          customer_invoice_Controller.clear();
                          message_invoice_Controller.clear();
                          Navigator.pop(context);
                        }
                    ),
                    actions: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(124, 58, 237, 0.8),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            await new_order_post();
                            setState(()  {
                              new_invoice();
                              app_bar_title = 'Покупка';
                            });
                          },
                          child: Text('Создать', style: TextStyle(color: Colors.black87,
                            fontFamily: 'Overpass',
                            fontSize: 14,)),
                        ),
                      ),

                    ],
                    title: Text(
                       'Счет ${sum/100}',
                      style: TextStyle(color: Colors.black87,
                          fontFamily: 'Overpass',
                          fontSize: 16),
                    ),
                    elevation: 0.0
                ),
                backgroundColor: Colors.white.withOpacity(0.95),
                body:  SingleChildScrollView(
                child:
                Container(
                  height: screenHeight,
                  width: screenWidth,
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      SizedBox(height: 10.0,),

                  Visibility(
                    visible: widget.customer_email_address == '' ? true : false ,
                    child:
                      TextField(
                        readOnly: true,
                        controller: customer_invoice_Controller,
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
                          hintText: 'Выберите покупателя',),
                        onTap: () async {
                          await get_customers();
                          setState((){
                            _showChooseCustomer(context);
                          });
                        },
                      ),),
                      SizedBox(height: 10.0,),
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
                        //flex: 2,
                      SizedBox(height: 10.0,),
                      TextFormField(
                        readOnly: true,
                        controller: datepicker_invoice_Controller,
                        decoration:  InputDecoration(
                            prefixIcon:
                            IconButton(
                              icon: const Icon(Icons.today),
                              iconSize: 20.0,
                              splashColor: Color.fromRGBO(124, 58, 237, 0.8),
                              splashRadius: 10,
                              color: Color.fromRGBO(124, 58, 237, 0.8),
                              onPressed: () {
                                _selectDate(context);
                              },
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color.fromRGBO(124, 58, 237, 0.8)),
                            ),
                            labelText: 'Срок оплаты',
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(124, 58, 237, 0.8)
                            )
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Container(
                        height: 70,
                        child: userInput(message_invoice_Controller, 'Сообщение', TextInputType.text, false),
                        //flex: 4,
                      ),

                      SizedBox(height: 10.0,),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Опции оплаты', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700,)),
                              ],
                            ),

                            Column(children: <Widget>[
                               Row(children: [
                                    Expanded(
                                        child: RadioListTile<String>(
                                          title: Text(payment_options[0], style: TextStyle(color: Colors.black),),
                                          groupValue: selected_payment_option,
                                          onChanged: (val) {
                                            setState(()  {
                                              print("Payment option $val");
                                              selected_payment_option = val;
                                            });
                                          },
                                          selected: true,
                                          value: payment_options[0],
                                        ),),
                                  ],),
                            ],),
                          ]),

                      SizedBox(height: 10.0,),

                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Способ связи', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700,)),
                              ],
                            ),

                            Column(children: <Widget>[
                              Row(children: [
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: Text(communications[0], style: TextStyle(color: Colors.black),),
                                    groupValue: selected_communication,
                                    onChanged: (val) {
                                      setState(()  {
                                        print("Payment option $val");
                                        selected_communication = val;
                                      });

                                    },
                                    selected: true,
                                    value: communications[0],
                                  ),),
                              ],),
                            ],),
                          ]),

                      TextButton(
                        child: Text('Создать персонализированный продукт', style: TextStyle(color: Color.fromRGBO(124, 58, 237, 0.8), fontSize: 20,
                          fontWeight: FontWeight.w700,), textAlign: TextAlign.center,),
                        onPressed: (){
                          hideKeyboard();
                          showDialog(
                              context: context,
                              builder: (BuildContext context)
                              {

                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0)),
                                        child: Container(
                                          constraints: BoxConstraints(maxHeight: screenHeight-350, minHeight: screenHeight-350),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                userInput(name_custom_Controller, 'Введите название продукта',
                                                    TextInputType.streetAddress, false),
                                                SizedBox(height: 10.0),
                                                userInput(quantity_custom_Controller, 'Введите количество',
                                                    TextInputType.text, false),
                                                SizedBox(height: 10.0),
                                                userInput(price_custom_Controller, 'Введите цену единицы продукта',
                                                    TextInputType.text, false),
                                                SizedBox(height: 10.0),
                                                Container(
                                                  height: 55,
                                                  alignment: Alignment.center,
                                                  child: RaisedButton(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(
                                                            25)),
                                                    color: Color.fromRGBO(
                                                        124, 58, 237, 0.8),
                                                    onPressed: () {
                                                      item_sale = Model_order(name: name_custom_Controller.text, descriptions: 'Кастомный', quantity: int.parse(quantity_custom_Controller.text),
                                                          price: int.parse(price_custom_Controller.text)*100, value: int.parse(price_custom_Controller.text) * int.parse(quantity_custom_Controller.text)*100, is_customize: true, id: '$count', id_from_catalog_item: '');
                                                      setState(() {
                                                        add_item(item_sale);
                                                        count++;
                                                        name_custom_Controller.clear();
                                                        quantity_custom_Controller.clear();
                                                        price_custom_Controller.clear();
                                                        print('Список всех itemов  $all_items_sale');
                                                        final_value();
                                                      });
                                                      hideKeyboard();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Добавить продукт', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                                                      color: Colors.white,),),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                              });
                        },
                      ),

                      Expanded(
                        child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            itemCount: all_items_sale.length,
                            separatorBuilder: (BuildContext context, int index) =>
                                Divider(color: Colors.black, thickness: 1,),
                            itemBuilder: (BuildContext context, int ind) {
                              return ListTile(
                                // controlAffinity: ListTileControlAffinity.leading,
                                title: Row(children: [
                                  Expanded(
                                      child: Text('${all_items_sale[ind].name} ',
                                          style: TextStyle(color: Colors.black87,
                                              fontFamily: 'Overpass', fontSize: 16)),
                                  flex: 5,
                                  ),

                                  Expanded(
                                      child: Text('x ${all_items_sale[ind].quantity}',
                                          style: TextStyle(color: Colors.grey,
                                              fontFamily: 'Overpass', fontSize: 16), textAlign: TextAlign.left,),
                                    flex: 1,
                                  ),

                                  Expanded(
                                      child: Text('${all_items_sale[ind].value/100}',
                                          style: TextStyle(color: Colors.grey,
                                              fontFamily: 'Overpass', fontSize: 16,), textAlign: TextAlign.right,),
                                    flex: 3,
                                  ),

                                  Expanded(
                                    child: IconButton(
                                        onPressed: (){
                                          setState((){
                                            delet_item(all_items_sale[ind].id,);
                                            final_value();
                                          });

                                        },
                                        icon: Icon(Icons.delete)),
                                    flex: 1,
                                  ),

                                ],),
                                subtitle: Text('${all_items_sale[ind].descriptions}',
                                  style: TextStyle(color: Colors.grey,
                                    fontFamily: 'Overpass', fontSize: 12,), textAlign: TextAlign.left,),

                              );
                            }),
                        flex:5,
                      ),
                    ],
                  ),
                ),)
              );
            });
      },
    );
  }


  Future _refreshData() async {
    _refreshIndicatorKey.currentState!.show();
    return get().then((_user) {
      setState(() => catalog = _user);
    });

  }


  Widget payButton(String pay){
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 70,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            height: 50,
            width: screenWidth - 50,
            child: ElevatedButton(
                onPressed: ()  {
                  setState(() {
                    _showAdd_invoice(context, all_items_sale);
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo.shade600,
                ),
                child: Text('К оплате ${pay}')),
          ),
        ],),
    );
}


  Widget list_order_Widjet() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
        width: screenWidth,
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: future_items,
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
                    else if(snapshot.connectionState == ConnectionState.done && snapshot.data.toString().length == 21 && isInternetOn == true){
                      return Column(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text('Каталог продукции пуст', style: TextStyle(fontSize: 24, color: Color.fromRGBO(124, 58, 237, 0.8)), textAlign: TextAlign.center,),
                                  )
                              ), ),

                            Expanded(
                              flex: 1,
                              child: payButton((sum/100).toString()),),


                          ]);
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
                                            hintText: 'Поиск по названию', border: InputBorder.none),
                                        onChanged: (value) {
                                          filterSearchResults(value);
                                        },
                                      ),
                                      trailing: IconButton(icon: Icon(Icons.cancel,),
                                        onPressed: () {
                                        controller.clear();
                                        setState(() {
                                          items.clear();
                                          items.addAll(catalog.objects);
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

                                            title: Text('${items[index].item_data.name}', style: TextStyle(color: Colors.black),),

                                            onTap: (){
                                              print('НАЖАЛ $index');
                                              _showFullModal(context, items[index]);
                                            },
                                          );
                                        }
                                    ),
                                    key: _refreshIndicatorKey,
                                    onRefresh: _refreshData,)
                              ),

                              payButton((sum/100).toString()),

                            ]);
                    }
                  }
              ),
            )
          ],
        ),
    );
  }


  setSelectedRadioTile(String val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title: Text( app_bar_title, style: TextStyle(color: Colors.white70)),
      ),
      body:  Padding(padding: EdgeInsets.only(top: 10.0),
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: list_order_Widjet(),
                    ),
                ],
              ),),
            ),

          );
                  }
                }
