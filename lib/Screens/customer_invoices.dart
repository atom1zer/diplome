import 'dart:convert';
import 'package:auth_ui/Screens/auth_200.dart';
import 'package:auth_ui/api/catalog_invoices.dart';
import 'package:auth_ui/api/invoice_in_list.dart';
import 'package:auth_ui/class/actions_popup.dart';
import 'package:auth_ui/others/change_options.dart';
import 'package:connectivity/connectivity.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'info_about_invoice.dart';
import 'package:auth_ui/others/on_session.dart' as globals;

class Customer_InvoicesScreen extends StatefulWidget {

  static const routeName = '/customer_invoices';

  late bool check;
  late String? id;
  late String email_address;

  Customer_InvoicesScreen(bool CHECK,String? ID,String EMAIL/*,String FIRST_NAME, String SECOND_NAME, String LAST_NAME, String PHONE,
      String EMAIL, String COMPANY, String REF_ID, String CREATED_AT*/){

    check = CHECK;
    id = ID;
    email_address = EMAIL;
    /*first_name = FIRST_NAME;
    second_name = SECOND_NAME;
    last_name = LAST_NAME;
    phone_number = PHONE;

    company_name = COMPANY;
    reference_id = REF_ID;
    created_at = CREATED_AT;*/
  }

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title: Text( 'Каталог invoice', style: TextStyle(color: Colors.white70)),
      ),
      //title: 'Shared preferences demo',
    );
  }

  @override
  State<Customer_InvoicesScreen> createState() => _Customer_InvoicesState();

}


class _Customer_InvoicesState extends State<Customer_InvoicesScreen> {

  late Future future_invoices;
  late Catalog_invoices catalog_invoices;
  late bool isInternetOn;
  final catalog_invoices_Controller = TextEditingController();
  List<Invoice_in_list> invoices = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  late Invoice_in_list det_invoice;
  late String invoice_action;
  late List<Actions_popup> list_actions_popup;
  List<String> rus_status = [];

  //late Invoice_in_list retrive_invoice;

  @override
  void initState() {
    super.initState();
    future_invoices = get_invoices();
    isInternetOn = true;
    invoice_action = 'send-reminder';
    list_actions_popup = <Actions_popup>[Actions_popup(name: 'Опубликовать', url: 'publish-invoice'),
      Actions_popup(name: 'Отправить напоминание', url: 'send-reminder')];
    det_invoice = Invoice_in_list(id: '', location_id: '', order_id: '', subscription_id: '',
        status: '', due_date: '', payment_method: '', delivery_method: '',
        amount_money: 0, pay_invoice_url: '', message: '');

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

    rus_status.clear();
    for(int i = 0; i<catalog_invoices.catalog_invoices.length; i++){

      if(catalog_invoices.catalog_invoices[i].status == 'PAID'){

        rus_status.add('ОПЛАЧЕН');

      }else if(catalog_invoices.catalog_invoices[i].status == 'UNPAID'){

        rus_status.add('НЕОПЛАЧЕН');

      }else if(catalog_invoices.catalog_invoices[i].status == 'OVERDUE'){

        rus_status.add('ПРОСРОЧЕН');
      }else if(catalog_invoices.catalog_invoices[i].status == 'DRAFT'){

        rus_status.add('ЧЕРНОВИК');
      }
    }

    invoices.clear();
    invoices.addAll(catalog_invoices.catalog_invoices);


    return catalog_invoices;
  }

  Future<void> action_invoice(invoice_action) async {


    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    var response = await http.get('${Change_options.url_api_server}/$invoice_action',
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
      setState(() {
        future_invoices = get_invoices();
      });


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

  PopupMenuButton _itemDown(index) => PopupMenuButton<String>(
    // Callback that sets the selected popup menu item.
      onSelected: (value) async {
        setState(() {
          invoice_action = value + '/' + index.toString();
          print(invoice_action);
        });
        await action_invoice(invoice_action);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
         PopupMenuItem(
          value: list_actions_popup[0].url,
          child: Text('${list_actions_popup[0].name}'),
        ),
         PopupMenuItem(
           value: list_actions_popup[1].url,
           child: Text('${list_actions_popup[1].name}'),
        ),
      ]);

  void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
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

  void filterSearchInvoices(String query) {
    List<Invoice_in_list> dummySearchList = <Invoice_in_list>[];
    /* for(int i = 0; i<catalog.objects.length; i++){
      dummySearchList.add(catalog.objects[i].item_data.name);
    }*/
    dummySearchList.addAll(catalog_invoices.catalog_invoices);
    if(query.isNotEmpty) {
      List<Invoice_in_list> dummyListData = <Invoice_in_list>[];
      dummySearchList.forEach((item) {
        if(item.status.contains(query)) {
          print('СОДЕРЖИТ!!!');
          dummyListData.add(item);
        }
      });
      setState(() {
        invoices.clear();
        invoices.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        invoices.clear();
        invoices.addAll(catalog_invoices.catalog_invoices);
      });
    }

  }

  Future _refreshInvoices() async {
    _refreshIndicatorKey.currentState!.show();
    return get_invoices().then((_invoice) {
      setState(() => catalog_invoices = _invoice);
    });

  }


  Widget list_invoices_Widjet() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: future_invoices,
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
                  else if(snapshot.connectionState == ConnectionState.done && snapshot.data.toString().length == 40 && isInternetOn == true){
                    return Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Список счетов пуст', style: TextStyle(fontSize: 24, color: Color.fromRGBO(124, 58, 237, 0.8)), textAlign: TextAlign.center,),
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
                                      controller: catalog_invoices_Controller,
                                      decoration: InputDecoration(
                                          hintText: 'Поиск по статусу', border: InputBorder.none),
                                      onChanged: (value) {
                                        filterSearchInvoices(value);
                                      },
                                    ),
                                    trailing: IconButton(icon: Icon(Icons.cancel,),
                                      onPressed: () {
                                        catalog_invoices_Controller.clear();
                                        setState(() {
                                          invoices.clear();
                                          invoices.addAll(catalog_invoices.catalog_invoices);
                                        });
                                        //onSearchTextChanged('');
                                      },),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(children: [
                                Row(children: [

                                  Expanded(
                                    child: Text('Статус',
                                      style: TextStyle(color: Colors.black,
                                          fontFamily: 'Overpass', fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center,),
                                    flex: 3,
                                  ),

                                  Expanded(
                                    child: Text('Сообщение',
                                      style: TextStyle(color: Colors.black,
                                          fontFamily: 'Overpass', fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center,),
                                    flex: 6,
                                  ),

                                  Expanded(
                                    child: Text('Стоимость',
                                      style: TextStyle(color: Colors.black,
                                          fontFamily: 'Overpass', fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center,),
                                    flex: 3,
                                  ),

                                ],),
                                /*SizedBox(height: 5,),
                                Row(children: [
                                  Expanded(
                                    child: Text('Оплатить до',
                                      style: TextStyle(color: Colors.black,
                                          fontFamily: 'Overpass', fontSize: 16), textAlign: TextAlign.left,),
                                    flex: 1,
                                  ),
                                ],),*/
                              ],),
                              ),
                            Expanded(
                                flex: 15,
                                child:  RefreshIndicator(
                                  displacement: 30,
                                  strokeWidth: 4.0,
                                  color: Color.fromRGBO(124, 58, 237, 0.8),
                                  child: ListView.separated(
                                    //scrollDirection: Axis.vertical,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      itemCount: invoices.length,
                                      separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black, thickness: 1,),
                                      itemBuilder: (BuildContext context, int index){
                                        print('CATALOG ${invoices.length}');
                                        return ListTile(
                                          // controlAffinity: ListTileControlAffinity.leading,
                                          title: Row(children: [
                                            Expanded(
                                              child: Text('${rus_status[index]}',
                                                  style: TextStyle(color: rus_status[index] == 'ПРОСРОЧЕН' ? Colors.redAccent : Colors.green.shade500,
                                                      fontFamily: 'Overpass', fontSize: screenWidth/30)),
                                              flex: 3,
                                            ),

                                            Expanded(
                                              child: Text('${invoices[index].message}',
                                                  style: TextStyle(color: Colors.grey.shade600,
                                                      fontFamily: 'Overpass', fontSize: 16)),
                                              flex: 5,
                                            ),

                                           /* Expanded(
                                              child: Text('${invoices[index].due_date}',
                                                style: TextStyle(color: Colors.grey,
                                                  fontFamily: 'Overpass', fontSize: 16,), textAlign: TextAlign.right,),
                                              flex: 3,
                                            ),*/

                                            Expanded(
                                              child: Text('${invoices[index].amount_money/100} ₽',
                                                  style: TextStyle(color: Colors.black87,
                                                      fontFamily: 'Overpass', fontSize: 16), textAlign: TextAlign.right,),
                                              flex: 3,
                                            ),
                                            Expanded(
                                                child: _itemDown(invoices[index].id)),

                                          ],),
                                          subtitle: Text('${invoices[index].due_date}',
                                            style: TextStyle(color: Colors.grey.shade600,
                                              fontFamily: 'Overpass', fontSize: 12,), textAlign: TextAlign.left,),

                                          onTap: ()  {
                                            det_invoice = catalog_invoices.catalog_invoices[index];
                                            print(det_invoice);
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => Info_About_InvoiceScreen(det_invoice, widget.email_address)));

                                          },
                                        );
                                      }
                                  ),
                                 key: _refreshIndicatorKey,
                                 onRefresh: _refreshInvoices,)
                            ),

                           // payButton(sum.toString()),

                          ]);
                  }
                }
            ),
          )
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title: Text("Платежная активность \n ${widget.email_address}", style: TextStyle(color: Colors.white70)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.check == true ?
            Navigator.pop(context) :
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => AfterAuthScreen(false),));
          }),
      ),
      body:  Padding(padding: EdgeInsets.only(top: 10.0),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: list_invoices_Widjet(),
              ),
            ],
          ),),
      ),

    );
  }
}