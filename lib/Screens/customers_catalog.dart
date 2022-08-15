//import 'package:auth_ui/Widjets/accordion.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:auth_ui/Screens/add_customers.dart';
import 'package:auth_ui/Screens/update_pers_info.dart';
import 'package:auth_ui/api/add_customer.dart';
import 'package:auth_ui/api/api_catalog.dart';
import 'package:auth_ui/api/catalog_cc.dart';
import 'package:auth_ui/api/catalog_update_object.dart';
import 'package:auth_ui/api/customer.dart';
import 'package:auth_ui/api/customers_cc.dart';
import 'package:auth_ui/others/change_options.dart';
import 'package:auth_ui/test/test.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert' show utf8;
import 'package:connectivity/connectivity.dart';
import 'add_item.dart';
import 'auth_200.dart';
import 'package:auth_ui/others/on_session.dart' as globals;


class Customers_CatalogScreen extends StatefulWidget {

  static const routeName = '/customers_catalog';

  late int check_customer;

  Customers_CatalogScreen(int CHECK_CUSTOMER, ){

    check_customer = CHECK_CUSTOMER;


  }


  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    //title: 'Shared preferences demo',
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title: Text( 'Каталог клиентов', style: TextStyle(color: Colors.white70)),
      ),
    );
  }


  @override
  State<Customers_CatalogScreen> createState() => _Customers_CatalogScreenState();
}

class _Customers_CatalogScreenState extends State<Customers_CatalogScreen> {
  // final List<Item> _data = generateItems(3);

  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);

  int selectedIndex = -1;
  late ScrollController _scrollController;
  late int flag = 1;
  bool _loading = false;
  late Catalog_cc catalog_cc;
  late Customer catalog_r;
  //late Catalog_retrive catalog_retrive;
  late Add_Customer retrive_customer;
  late Color _head_color;

  late bool result;
  late final snack_bar;
  late final snack_bar_nul;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  late Future myFuture;
  late bool _isConnected;
  late bool isInternetOn;
  List<Customers_cc> items = [];
  TextEditingController controller = TextEditingController();


  Future<Catalog_cc> get() async {

    setState(() {
      _loading = true;
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

    if(response.body.length < 3){
      if(widget.check_customer == 1){
      }
      else{
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
      }
  }else{
    if(widget.check_customer ==1){
      print("Дааааа");

      snack_bar =
      SnackBar(
      backgroundColor: Colors.green.shade600,
      content: const Text('Клиент успешно добавлен!', style: TextStyle(fontSize: 20, color: Colors.white70), textAlign: TextAlign.center,),
      duration: const Duration(milliseconds: 3000),
      //width: 280.0, // Width of the SnackBar.
      /*padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, // Inner padding for SnackBar content.
                                      ),*/
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      ),
      );
      scaffoldKey.currentState!
          .showSnackBar(snack_bar);
      widget.check_customer == 0;
    }

  };
    catalog_cc = Catalog_cc.fromJson(jsonToString);
    items.clear();
    items.addAll(catalog_cc.customers_cc);
    print(catalog_cc);
    setState(() {
      _loading = false;
    });

    return catalog_cc;
  }

  void filterSearchResults(String query) {
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


  Future<Customer> update_customer(id) async {

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    var response = await http.get('${Change_options.url_api_server}/customers/$id',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t') ?
        globals.before_restart_token :  token}','Content-Type':'application/json'} /*, body: jsonToString*/);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print("ЭТО response.body.length  ${response.body.length}");
    final jsonToString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
    print('jsonToString:   $jsonToString');
    catalog_r = Customer.fromJson(jsonToString);
    print(catalog_r);


    catalog_r.customer.first_name ??= '';
    catalog_r.customer.second_name ??= '';
    catalog_r.customer.last_name ??= '';
    catalog_r.customer.phone_number ??= '';
    catalog_r.customer.company_name ??= '';
    catalog_r.customer.reference_id ??= '';
    catalog_r.customer.created_at ??= '';

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Update_CustomerScreen(catalog_r.customer.id,catalog_r.customer.first_name, catalog_r.customer.second_name, catalog_r.customer.last_name, catalog_r.customer.phone_number,
            catalog_r.customer.email_address, catalog_r.customer.company_name, catalog_r.customer.reference_id, catalog_r.customer.created_at,catalog_r.customer.creation_source)));

    return catalog_r;
  }


  /*Future<void> _checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('https://www.google.com/');
      if (response.isNotEmpty) {
        setState(() {
          _isConnected = true;
        });
      }
    } on SocketException catch (err) {
      setState(() {
        _isConnected = false;
      });
      if (kDebugMode) {
        print(err);
      }
    }
  }*/
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

    isInternetOn = true;
    GetConnect();
    //_checkInternetConnection();
    myFuture = get();

  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
          title: Text( 'Каталог клиентов', style: TextStyle(color: Colors.white70)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => AfterAuthScreen(false))),),
          actions: <Widget> [
            IconButton(
              padding: EdgeInsets.only(right: 23.0),
              icon: Icon(Icons.add),
              onPressed: () async => {
                result = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddCustomersScreen())),
                if(result!=null && result==true){
                  print("Дааааа"),
                  get(),
                  snack_bar =
                      SnackBar(
                        backgroundColor: Colors.green.shade600,
                        content: const Text('Клиент успешно добавлен!', style: TextStyle(fontSize: 20, color: Colors.white70), textAlign: TextAlign.center,),
                        duration: const Duration(milliseconds: 1500),
                        //width: 280.0, // Width of the SnackBar.
                        /*padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, // Inner padding for SnackBar content.
                              ),*/
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                  scaffoldKey.currentState!
                      .showSnackBar(snack_bar),
                }else{
                  print("Неееет"),
                  //Some other action if your work is not done
                },
                print("Click on upload button"),
                /*Navigator.push(context, MaterialPageRoute(
          builder: (context) => AddItemScreen())),*/

              },
            ),]
      ),
      body:
      FutureBuilder(
        future: myFuture,
        builder: (BuildContext context, snapshot){

          print("snapshot.data: ${snapshot.data.toString()}");
          if(snapshot.connectionState == ConnectionState.waiting &&
          snapshot.data == null){
            return Container(
              color: Colors.white,
              child: SafeArea(
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (BuildContext ctx, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Shimmer.fromColors(
                        highlightColor: Colors.deepPurpleAccent,
                        baseColor: Color.fromRGBO(124, 58, 237, 0.8),
                        child: Container(
                          margin: EdgeInsets.only(right : 0),
                          height: 80,
                          width: 270,
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
          else if(snapshot.connectionState == ConnectionState.done && snapshot.data.toString().length == 30 && isInternetOn ==true/*_isConnected == true*/){
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
            return SingleChildScrollView(

              child: SizedBox(
                height: screenHeight,
                child: Column(children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          leading: Icon(Icons.search, color: Color.fromRGBO(124, 58, 237, 0.8)),
                          title: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                                hintText: 'Поиск по email', border: InputBorder.none),
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
                      child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index){
                            print('CATALOG ${items.length}');
                            return Container(
                              height: screenHeight,
                              margin: EdgeInsets.only(bottom: 10.0),
                              child: ListView(
                                children: [
                                  SizedBox(
                                    height: 70.0 * items.length,
                                    child: ListView.separated(

                                        itemCount: items.length,
                                        separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black, thickness: 1,),
                                        itemBuilder: (BuildContext context, int ind){

                                          //print('COUNT ${itemData[index].discription.length}');
                                          return ListTile(
                                            title: Text('${items[ind].email_address}', style: TextStyle(color: Colors.black), textDirection: TextDirection.ltr,),

                                            onTap: (){
                                              print('НАЖАЛ $ind');
                                              update_customer(items[ind].id);
                                              // update_item(catalog.objects[index].id);
                                            },
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            );
                          }
                      ),),


                ],),

              ),
            );
          }
        }
    )
    );
  }
}

