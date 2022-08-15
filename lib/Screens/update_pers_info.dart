import 'dart:convert';
import 'package:auth_ui/Screens/customer_checkouts.dart';
import 'package:auth_ui/Screens/customer_invoices.dart';
import 'package:auth_ui/api/add_customer.dart';
import 'package:auth_ui/api/adres_add_customer.dart';
import 'package:auth_ui/api/catalog_invoices.dart';
import 'package:auth_ui/api/catalog_parse_checkout.dart';
import 'package:auth_ui/api/customers_cc.dart';
import 'package:auth_ui/api/preferences_cc.dart';
import 'package:auth_ui/class/idemp_key.dart';
import 'package:auth_ui/others/change_options.dart';
import 'package:connectivity/connectivity.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'customers_catalog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:auth_ui/others/on_session.dart' as globals;
import 'new_order.dart';

class Update_CustomerScreen extends StatefulWidget {

  static const routeName = '/update_customers';

  late String id;
  late String first_name;
  late String second_name;
  late String last_name;
  late String phone_number;
  late String email_address;
  late String company_name;
  late String reference_id;
  late String birthday;
  late String created_at;
  late String creation_source;


  Update_CustomerScreen(String ID,String FIRST_NAME, String SECOND_NAME, String LAST_NAME, String PHONE,
      String EMAIL, String COMPANY, String REF_ID, String CREATED_AT, String CREATION_SOURCE){

    id = ID;
    first_name = FIRST_NAME;
    second_name = SECOND_NAME;
    last_name = LAST_NAME;
    phone_number = PHONE;
    email_address = EMAIL;
    company_name = COMPANY;
    reference_id = REF_ID;
    created_at = CREATED_AT;
    creation_source = CREATION_SOURCE;


  }


  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    //title: 'Shared preferences demo',
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title: Text( 'Информация о клиенте', style: TextStyle(color: Colors.white70)),
      ),
    );
  }


  @override
  State<Update_CustomerScreen> createState() => _Update_CustomerScreenState();
}

class _Update_CustomerScreenState extends State<Update_CustomerScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final String uuid = GUIDGen.generate();
  final first_nameController = TextEditingController();
  final last_nameController = TextEditingController();
  final phone_numberController = TextEditingController();
  final emailController = TextEditingController();
  final country_Controller = TextEditingController();
  final street_Controller = TextEditingController();
  final apt_Controller = TextEditingController();
  final city_Controller = TextEditingController();
  final state_Controller = TextEditingController();
  final zip_Controller = TextEditingController();
  final group_Controller = TextEditingController();
  final company_Controller = TextEditingController();
  final reference_id_Controller = TextEditingController();
  final birthday_Controller = TextEditingController();
  late String create_at;
  DateFormat dateFormat = DateFormat("d MMM yyyy HH:mm:ss");
  int check_customer = 0;
  late Catalog_invoices catalog_invoices;
  late Future myFuture_invoice;
  late Future myFuture_check;
  late bool isInternetOn;
  late int count_invoice_paid;
  late int sum_invoice_paid;
  late int count_check_paid;
  late int sum_check_paid;
  late Catalog_parse_checkout _catalog_checkouts;
  late bool check;

  @override
  void initState() {
    super.initState();
    isInternetOn = true;
    count_invoice_paid = 0;
    sum_invoice_paid = 0;
    count_check_paid = 0;
    sum_check_paid = 0;
    check = true;
    myFuture_invoice = get_invoices();
    myFuture_check = get_catalog_check();
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

  Future<Catalog_invoices> get_invoices() async {

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    var response = await http.get('${Change_options.url_api_server}/invoices_of/${widget.id}',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t') ?
        globals.before_restart_token :  token}','Content-Type':'application/json'} /*, body: jsonToString*/);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print("ЭТО response.body.length  ${response.body.length}");
    final jsonToString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
    print('jsonToString:   ${jsonToString}');
    catalog_invoices = Catalog_invoices.fromJson(jsonToString);
    print(catalog_invoices);

    for(int i = 0; i<catalog_invoices.catalog_invoices.length; i++){

      if(catalog_invoices.catalog_invoices[i].status == 'PAID'){
        count_invoice_paid ++;
        sum_invoice_paid = sum_invoice_paid + catalog_invoices.catalog_invoices[i].amount_money;
      };
    }

    return catalog_invoices;
  }

  Future<Catalog_parse_checkout> get_catalog_check() async {

    setState(() {
      check = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    var response = await http.get('${Change_options.url_api_server}/checkouts_of/${widget.id}',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t') ?
        globals.before_restart_token :  token}','Content-Type':'application/json', 'Accept':'application/json'} /*, body: jsonToString*/);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print("ЭТО response.body.length  ${response.body.length}");
    final jsonToString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
    print('jsonToString:   ${jsonToString}');
    _catalog_checkouts = Catalog_parse_checkout.fromJson(jsonToString);

    for(int i = 0; i<_catalog_checkouts.catalog_checkout.length; i++){

      if(_catalog_checkouts.catalog_checkout[i].payment_status == 'PAID'){
        count_check_paid ++;
        sum_check_paid = sum_check_paid + _catalog_checkouts.catalog_checkout[i].order.total_amount.amount;
      };
    }

    setState(() {
      check = false;
    });

    return _catalog_checkouts;
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title:  Text(widget.email_address, style: TextStyle(color: Colors.white70)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>  Navigator.push(context, MaterialPageRoute(
              builder: (context) => Customers_CatalogScreen(0))),

        ),
        centerTitle: true,

      ),
      body: FutureBuilder(
            future: myFuture_check,
            builder: (BuildContext context, snapshot){

            print("snapshot.data: ${snapshot.data.toString()}");
            if(snapshot.connectionState == ConnectionState.waiting &&
            snapshot.data == null && check == true){
              return Container(
                  height: screenHeight,
                  width: screenWidth,
                  color: Colors.white,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: screenWidth,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:   const EdgeInsets.only(left: 10.0, right: 10,top: 10.0, /*bottom: 10.0*/),
                                    child: Shimmer.fromColors(
                                      highlightColor: Colors.white70,
                                      baseColor: Color.fromRGBO(124, 58, 237, 0.8)/*Colors.grey[500]*/,
                                      child: Container(
                                        clipBehavior : Clip.antiAlias,
                                        margin: EdgeInsets.only(right : 0),
                                        height: 325,
                                        width: screenWidth-20,
                                        decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      period: Duration(milliseconds: 805),
                                    ),
                                  ),
                                  Padding(
                                    padding:   const EdgeInsets.only(left: 10.0, right: 10,top: 10.0, /*bottom: 10.0*/),
                                    child: Shimmer.fromColors(
                                      highlightColor: Colors.white70,
                                      baseColor: Color.fromRGBO(124, 58, 237, 0.8)/*Colors.grey[500]*/,
                                      child: Container(
                                        clipBehavior : Clip.antiAlias,
                                        margin: EdgeInsets.only(right : 0),
                                        height: 200,
                                        width: screenWidth-20,
                                        decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      period: Duration(milliseconds: 805),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              );
            }else if(isInternetOn == false){
              return Container(
                alignment: Alignment.center,
                child: Padding(

                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Подключение к интернету отсутствует', style: TextStyle(fontSize: screenWidth/16, color: Color.fromRGBO(124, 58, 237, 0.8)), textAlign: TextAlign.center,),
                )
              );
            }
            else if(snapshot.connectionState == ConnectionState.done && snapshot.data == null && isInternetOn == true){
              return Container(
              alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Перезагрузите страницу. \n Данные отсутствуют.', style: TextStyle(fontSize: screenWidth/16, color: Color.fromRGBO(124, 58, 237, 0.8)), textAlign: TextAlign.center,),
                )
              );
            }
            else{
            print('В ОСНОВНУЮ ЧАСТЬ');
            return SingleChildScrollView(

                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: screenWidth,
                        child: Column(
                          children: [
                            Padding(
                              padding:   const EdgeInsets.only(left: 10.0, right: 10,top: 10.0, /*bottom: 10.0*/),
                              child: Container(
                                    padding:  const EdgeInsets.all(20),
                                    //height: 480,
                                    clipBehavior : Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                             Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text('Персональная информация', style: TextStyle(color: Colors.black, fontSize: screenWidth/19,
                                                    fontWeight: FontWeight.w700,), softWrap: true,),
                                                ],

                                              ),
                                          SizedBox(height: 10,),


                                          Visibility(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('ФИО', style: TextStyle(color: Colors.black26, fontSize: 18,
                                                    fontWeight: FontWeight.w700,)),
                                                  SizedBox(height: 10),
                                                  Text(widget.last_name + ' ' + widget.first_name + ' ' + widget.second_name, style: TextStyle(color: Colors.black, fontSize: 18,)),
                                                  SizedBox(height: 20),

                                                ],
                                              ),

                                            visible: widget.first_name == '' && widget.second_name == '' && widget.last_name == '' ? false : true,
                                          ),

                                          Text('EMAIL', style: TextStyle(color: Colors.black26, fontSize: 18,
                                            fontWeight: FontWeight.w700,)),
                                          SizedBox(height: 10),
                                          Text(widget.email_address, style: TextStyle(color: Colors.black, fontSize: 18,)),
                                          SizedBox(height: 20),

                                          Visibility(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('КОМПАНИЯ', style: TextStyle(color: Colors.black26, fontSize: 18,
                                                  fontWeight: FontWeight.w700,)),
                                                SizedBox(height: 10),
                                                Text(widget.company_name, style: TextStyle(color: Colors.black, fontSize: 18,)),
                                                SizedBox(height: 20),
                                              ],
                                            ),

                                            visible: widget.company_name == '' ? false : true,
                                          ),

                                          Visibility(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('ТЕЛЕФОН', style: TextStyle(color: Colors.black26, fontSize: 18,
                                                  fontWeight: FontWeight.w700,)),
                                                SizedBox(height: 10),
                                                Text(widget.phone_number, style: TextStyle(color: Colors.black, fontSize: 18,)),
                                                SizedBox(height: 20),
                                              ],
                                            ),
                                            visible: widget.phone_number == '' ? false : true,
                                          ),


                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('ИСТОЧНИК', style: TextStyle(color: Colors.black26, fontSize: 18,
                                                fontWeight: FontWeight.w700,)),
                                              SizedBox(height: 10),
                                              Text(widget.creation_source, style: TextStyle(color: Colors.black, fontSize: 18,)),
                                              SizedBox(height: 20),
                                            ],
                                          ),

                                          Visibility(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('ИДЕНТИФИКАТОР', style: TextStyle(color: Colors.black26, fontSize: 18,
                                                  fontWeight: FontWeight.w700,)),
                                                SizedBox(height: 10),
                                                Text(widget.reference_id, style: TextStyle(color: Colors.black, fontSize: 18,)),
                                                SizedBox(height: 10),
                                              ],
                                            ),

                                            visible: widget.reference_id == '' ? false : true,
                                          ),
                                        ])
                                ),
                            ),

                            Padding(
                              padding:   const EdgeInsets.only(left: 10.0, right: 10,top: 10.0, bottom: 10.0),
                              child: Container(
                                  padding:  const EdgeInsets.all(20),
                                  // height: 60,
                                  clipBehavior : Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Платежная активность', style: TextStyle(color: Colors.black, fontSize: screenWidth/18, fontWeight: FontWeight.w700,)),
                                          ],
                                        ),
                                        SizedBox(height: 20,),

                                        Row(
                                          //mainAxisAlignment: MainAxisAlignment,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text('Оплачено счетов', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,), textAlign: TextAlign.left,),
                                                ],),),
                                            Expanded(
                                                child: Column(
                                                  children: [
                                                  Text('Сумма', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                                ],),),
                                          ],
                                        ),

                                        SizedBox(height: 10,),

                                        Row(
                                          //mainAxisAlignment: MainAxisAlignment,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                Text('$count_invoice_paid', style: TextStyle(color: Colors.black, fontSize: screenWidth/18,)),
                                              ],),),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                Text('${sum_invoice_paid/100}', style: TextStyle(color: Colors.black, fontSize: screenWidth/18,)),
                                              ],),),
                                          ],
                                        ),
                                        SizedBox(height: 20,),


                                        Row(
                                          //mainAxisAlignment: MainAxisAlignment,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                Text('Завершенных сеансов оплаты', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                              ],),),
                                            Expanded(
                                              child: Column(children: [
                                                Text('Сумма', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                              ],),),
                                          ],
                                        ),

                                        SizedBox(height: 10,),

                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                Text('${count_check_paid}', style: TextStyle(color: Colors.black, fontSize: screenWidth/18,),),
                                              ],),),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                Text('${sum_check_paid/100}', style: TextStyle(color: Colors.black, fontSize: screenWidth/18,)),
                                              ],),),
                                          ],
                                        ),

                                        SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              child: Text('Создать счет', style: TextStyle(color: Color.fromRGBO(124, 58, 237, 0.8), fontSize: 19,
                                                fontWeight: FontWeight.w700,)),
                                              onPressed: (){
                                                hideKeyboard();
                                                Navigator.push(context, MaterialPageRoute(
                                                    builder: (context) => New_OrderScreen(widget.email_address, widget.reference_id, widget.id)));
                                              },
                                            ),
                                          ],
                                        ),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              child: Text('Посмотреть счета', style: TextStyle(color: Color.fromRGBO(124, 58, 237, 0.8), fontSize: 19,
                                                fontWeight: FontWeight.w700,)),
                                              onPressed: (){
                                                hideKeyboard();
                                                Navigator.push(context, MaterialPageRoute(
                                                    builder: (context) => Customer_InvoicesScreen(true, widget.id, widget.email_address)));
                                              },
                                            ),
                                          ],
                                        ),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              child: Text('Посмотреть сеансы оплаты', style: TextStyle(color: Color.fromRGBO(124, 58, 237, 0.8), fontSize: 19,
                                                fontWeight: FontWeight.w700,)),
                                              onPressed: (){
                                                hideKeyboard();
                                                Navigator.push(context, MaterialPageRoute(
                                                    builder: (context) => Customer_checkouts_Screen(widget.id, widget.email_address)));
                                              },
                                            ),
                                          ],
                                        ),
                                      ])
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                );
                  }
               }
            ),
    );
  }

  void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}