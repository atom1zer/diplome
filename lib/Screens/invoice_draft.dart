  import 'dart:async';
  import 'dart:convert';
  import 'package:auth_ui/api/add_order.dart';
  import 'package:auth_ui/api/api_catalog.dart';
  import 'package:auth_ui/api/catalog_cc.dart';
  import 'package:auth_ui/api/create_invoice.dart';
  import 'package:auth_ui/api/customers_cc.dart';
  import 'package:auth_ui/api/line_include.dart';
  import 'package:auth_ui/api/line_item_include_2.dart';
  import 'package:auth_ui/api/location.dart';
  import 'package:auth_ui/api/locations_catalog.dart';
  import 'package:auth_ui/api/objects.dart';
  import 'package:auth_ui/api/parse_order.dart';
  import 'package:auth_ui/api/take_invoice_status.dart';
  import 'package:auth_ui/api/variation_retrive_id.dart';
  import 'package:auth_ui/class/model_order.dart';
  import 'package:auth_ui/others/change_options.dart';
  import 'package:connectivity/connectivity.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:http/http.dart' as http;
  import 'package:intl/intl.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'customer_invoices.dart';
  import 'package:auth_ui/others/on_session.dart' as globals;

  class Invoice_draft_Screen extends StatefulWidget {

    static const routeName = '/invoice_draft';

    late String? id_customer;
    late String id;
    late String invoice_customer;
    late String invoice_location;
    late List<Model_order> invoice_list_sale;
    late String invoice_payment_option;
    late String invoice_communication;
    late String due_date;
    late String message;


    Invoice_draft_Screen(String? ID_CUSTOMER,String ID,String INVOICE_CUSTOMER, String INVOICE_LOCATION, List<Model_order> INVOICE_LIST_SALE,
        String INVOICE_PAYMENT_OPTION, String INVOICE_COMMUNICATION, String DUE_DATE, String MESSAGE){

      id_customer = ID_CUSTOMER;
      id = ID;
      invoice_customer = INVOICE_CUSTOMER;
      invoice_location = INVOICE_LOCATION;
      invoice_list_sale = INVOICE_LIST_SALE;
      invoice_payment_option = INVOICE_PAYMENT_OPTION;
      invoice_communication = INVOICE_COMMUNICATION;
      due_date = DUE_DATE;
      message = MESSAGE;
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
          title: Text( 'Редактирование', style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    @override
    State<Invoice_draft_Screen> createState() => _Invoice_draft_ScreenState();

  }


  class _Invoice_draft_ScreenState extends State<Invoice_draft_Screen> {

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
    late List<Location>? locations_list;
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
    late bool is_done;
    late String status;
    late String app_bar_title;
    int sum = 0;
    late int count;
    late String _selectedDate;
    late List<String> payment_options;
    late List<String> communications;
    late Parse_order order;
    late Create_invoice create_invoice;
    late String cust_id;
    late String ref_id;
    late bool done;
    late Take_invoice_status take_invoice;
    late Future future_items;
    late String value;
    late String ref_id_from_select;
    late int quantity;
    List<Objects> items = [];
    List<Customers_cc> search_customer = [];
    TextEditingController controller = TextEditingController();
    late Locations_catalog locations_catalog;
    late List<Location>? locations_list_search;
    final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

    /*Future<Catalog> get() async {

      final prefs = await SharedPreferences.getInstance();
      var response = await http.get('${Change_options.url_api_server}/catalog/list',
          headers: {'Authorization':'Bearer ${prefs.getString('bearer_t') == '' ?
          globals.before_restart_token :  prefs.getString('bearer_t')}','Content-Type':'application/json'} /*, body: jsonToString*/);
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
    }*/

   /* Future<Locations_catalog> get_locations() async {

      final prefs = await SharedPreferences.getInstance();
      var response = await http.get('${Change_options.url_api_server}/locations',
          headers: {'Authorization':'Bearer ${prefs.getString('bearer_t') == '' ?
          globals.before_restart_token :  prefs.getString('bearer_t')}','Content-Type':'application/json'} /*, body: jsonToString*/);
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
    }*/


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


    List<Model_order> take_list_sale(){
      setState(() {
        all_items_sale;
      });
      return all_items_sale;
    }

   /* Future<Variation_retrive_id> retrive_item(id) async {

      setState(() {
        _loading = true;
      });

      final prefs = await SharedPreferences.getInstance();
      var response = await http.get('${Change_options.url_api_server}/catalog/object/$id',
          headers: {'Authorization':'Bearer ${prefs.getString('bearer_t') == '' ?
          globals.before_restart_token :  prefs.getString('bearer_t')}','Content-Type':'application/json'} /*, body: jsonToString*/);
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
    }*/


    /*Future<Catalog_cc> get_customers() async {
      setState(() {
        get_customers_ready = true;
      });

      final prefs = await SharedPreferences.getInstance();
      var response = await http.get('${Change_options.url_api_server}/customers',
          headers: {'Authorization':'Bearer ${prefs.getString('bearer_t') == '' ?
          globals.before_restart_token :  prefs.getString('bearer_t')}','Content-Type':'application/json'} /*, body: jsonToString*/);
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
    }*/

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
      get_customers_ready = true;
      locations_list = [];
      all_customers = [];
      this_location = '';
      this_customer = '';
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
      //future_items = get();
      value = '';
      quantity = 1;
      GetConnect();
      locations_list_search = [];
      locations_list_search!.addAll(locations_list!);
      ref_id_from_select = '';
      customer_invoice_Controller.text = widget.invoice_customer;
      location_Controller.text = widget.invoice_location;
      all_items_sale = widget.invoice_list_sale;
      datepicker_invoice_Controller.text = widget.due_date;
      message_invoice_Controller.text = widget.message;
      selected_payment_option = widget.invoice_payment_option;
      selected_communication = widget.invoice_communication;
      final_value();
    }

    SnackBar snack_bar_action(text) => SnackBar(
      backgroundColor: Colors.green.shade600,
      content: Text('$text', style: TextStyle(fontSize: 20, color: Colors.white70), textAlign: TextAlign.center,),
      duration: const Duration(milliseconds: 2000),
      //width: 280.0, // Width of the SnackBar.
      /*padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, // Inner padding for SnackBar content.
                                  ),*/
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );


    Future<void> action_invoice(id) async {


      final prefs = await SharedPreferences.getInstance();
      final EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences(prefs: prefs);

      String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
      var response = await http.get('${Change_options.url_api_server}/publish-invoice/$id',
          headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t') ?
          globals.before_restart_token :  token}','Content-Type':'application/json'} /*, body: jsonToString*/);
      print(response);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      print("ЭТО response.body.length  ${response.body.length}");
      Map<String, dynamic> response_dec = jsonDecode(
          response.body);

      if (response.statusCode >= 200 && response.statusCode <= 300) {

        scaffoldKey.currentState!.showSnackBar(snack_bar_action(response_dec['message']));


        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Customer_InvoicesScreen(false, widget.id_customer, widget.invoice_customer)));

      }else{

        showDialog<String>(
            context: context,
            builder: (BuildContext context) =>
                AlertDialog(
                  title: Text("Ошибка!"),
                  content: Text("${response_dec['errors']['detail']}"),
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

    void hideKeyboard() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }

    void Value(){
      value = '${catalog_retrive.object.item_data.price_money.amount*
          int.parse(quantity_Controller.text)}';
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
      selectedRadioTile = null;
      value = '';
      quantity_Controller.text = '1';
      quantity = 1;
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
                    ref_id_from_select = '';
                    selectedRadioTile_location = '';
                    selectedRadioTile_customer = '';
                    this_location = '';
                    this_customer = '';
                    location_Controller.clear();
                    customer_invoice_Controller.clear();
                    message_invoice_Controller.clear();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Customer_InvoicesScreen(false,widget.id_customer,widget.invoice_customer)));
                  }
              ),
              actions: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(124, 58, 237, 0.8),
                  ),
                  child: TextButton(
                    onPressed: () async {

                      await action_invoice(widget.id);



                    },
                    child: Text('Опубликовать', style: TextStyle(color: Colors.black87,
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
            scrollDirection: Axis.vertical,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: screenHeight,
              width: screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Публикация', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700,)),
                      ],
                    ),),
                  SizedBox(height: 10.0,),
                  Expanded(
                    flex: 3,
                    child: TextField(
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
                     /* onTap: () async {
                        await get_customers();
                        setState((){
                          _showChooseCustomer(context);
                        });
                      },*/
                    ),),

                 // SizedBox(height: 10.0,),
                  Expanded(
                    flex: 3,
                    child: TextField(
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
                      /*onTap: (){
                        setState((){
                          _showChooseLocation(context);
                        });
                      },*/
                    ), ),

                  //flex: 2,
                 // SizedBox(height: 10.0,),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      readOnly: true,
                      controller: datepicker_invoice_Controller,
                      decoration:  InputDecoration(
                          /*prefixIcon:
                          IconButton(
                            icon: const Icon(Icons.today),
                            iconSize: 20.0,
                            splashColor: Color.fromRGBO(124, 58, 237, 0.8),
                            splashRadius: 10,
                            color: Color.fromRGBO(124, 58, 237, 0.8),
                            onPressed: () {
                              _selectDate(context);
                            },
                          ),*/
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(124, 58, 237, 0.8)),
                          ),
                          labelText: 'Срок действия',
                          labelStyle: TextStyle(
                              color: Color.fromRGBO(124, 58, 237, 0.8)
                          )
                      ),
                    ),),

                  //SizedBox(height: 10.0,),
                  Container(
                    height: 70,
                    child: userInput(message_invoice_Controller, 'Сообщение', TextInputType.text, true),
                    //flex: 4,
                  ),

                 // SizedBox(height: 10.0,),
                  Expanded(
                    flex: 3,
                    child: Column(
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
                      ]),),


                  //SizedBox(height: 10.0,),

                  Expanded(
                    flex: 3,
                    child: Column(
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
                      ]),),

                  Expanded(
                    flex: 5,
                    child: ListView.separated(
                      //physics: NeverScrollableScrollPhysics(),
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
                                  flex: 2,
                                ),

                                Expanded(
                                  child: Text('x ${all_items_sale[ind].quantity}',
                                      style: TextStyle(color: Colors.grey,
                                          fontFamily: 'Overpass', fontSize: 16)),
                                  flex: 1,
                                ),

                                Expanded(
                                  child: Text('${all_items_sale[ind].value/100}',
                                    style: TextStyle(color: Colors.grey,
                                      fontFamily: 'Overpass', fontSize: 16,), textAlign: TextAlign.right,),
                                  flex: 3,
                                ),

                               /* Expanded(
                                  child: IconButton(
                                      onPressed: (){
                                        setState((){
                                          delet_item(all_items_sale[ind].id,);
                                          final_value();
                                        });

                                      },
                                      icon: Icon(Icons.delete)),
                                  flex: 1,
                                ),*/

                              ],),
                              subtitle: Text('${all_items_sale[ind].descriptions}',
                                style: TextStyle(color: Colors.grey,
                                  fontFamily: 'Overpass', fontSize: 12,), textAlign: TextAlign.left,),

                            );
                          }),
                    ),
                ],
              ),),
        )
      );

    }
  }


