import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:auth_ui/api/catalog_parse_checkout.dart';
import 'package:auth_ui/api/parse_checkout.dart';
import 'package:auth_ui/others/change_options.dart';
import 'package:connectivity/connectivity.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:auth_ui/others/on_session.dart' as globals;
import 'package:webview_flutter/webview_flutter.dart';

class Customer_checkouts_Screen extends StatefulWidget {

  static const routeName = '/customer_checkouts';

  late String id;
  late String email;

  Customer_checkouts_Screen(String ID, String EMAIL){

    id = ID;
    email = EMAIL;

  }

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title: Text( 'Подписки', style: TextStyle(color: Colors.white70)),
      ),
      //title: 'Shared preferences demo',
    );
  }

  @override
  State<Customer_checkouts_Screen> createState() => _Customer_checkouts_State();

}


class _Customer_checkouts_State extends State<Customer_checkouts_Screen> {

  late Future myFuture;
  late bool isInternetOn;
  TextEditingController controller = TextEditingController();
  late Catalog_parse_checkout _catalog_checkouts;
  List<Parse_checkout> items = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  late String url;
  List<String> rus_status = [];

  @override
  void initState() {
    super.initState();
    myFuture = get_catalog_check(widget.id);
    isInternetOn = true;
    url = '';
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }

  }


  Future<Catalog_parse_checkout> get_catalog_check(id) async {

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();

    var response = await http.get('${Change_options.url_api_server}/checkouts_of/$id',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t')?
        globals.before_restart_token :  token}','Content-Type':'application/json', 'Accept':'application/json'} /*, body: jsonToString*/);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print("ЭТО response.body.length  ${response.body.length}");
    final jsonToString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
    print('jsonToString:   ${jsonToString}');

    _catalog_checkouts = Catalog_parse_checkout.fromJson(jsonToString);
    print(_catalog_checkouts);

    rus_status.clear();
    for(int i = 0; i<_catalog_checkouts.catalog_checkout.length; i++){

      if(_catalog_checkouts.catalog_checkout[i].payment_status == 'PAID'){

        rus_status.add('ОПЛАЧЕН');

      }else if(_catalog_checkouts.catalog_checkout[i].payment_status  == 'UNPAID'){

        rus_status.add('НЕОПЛАЧЕН');

      }else if(_catalog_checkouts.catalog_checkout[i].payment_status == 'OVERDUE'){

        rus_status.add('ПРОСРОЧЕН');
      }
    }

    items.clear();
    items.addAll(_catalog_checkouts.catalog_checkout);

    return _catalog_checkouts;
  }

  void filterSearchResults(String query) {
    List<Parse_checkout> dummySearchList = <Parse_checkout>[];
    /* for(int i = 0; i<catalog.objects.length; i++){
      dummySearchList.add(catalog.objects[i].item_data.name);
    }*/
    dummySearchList.addAll(_catalog_checkouts.catalog_checkout);
    if(query.isNotEmpty) {
      List<Parse_checkout> dummyListData = <Parse_checkout>[];
      dummySearchList.forEach((item) {
        if(item.payment_status.contains(query)) {
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
        items.addAll(_catalog_checkouts.catalog_checkout);
      });
    }

  }

  _showWeb(context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
                          Navigator.pop(context);
                        }
                    ),
                    title: Text(
                      'Ссылка сеанса',
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
                      Expanded(
                          child: WebView(
                            initialUrl: url,
                            javascriptMode: JavascriptMode.unrestricted,
                          ),),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }


  Future _refreshCheck() async {
    _refreshIndicatorKey.currentState!.show();
    return get_catalog_check(widget.id).then((_check) {
      setState(() => _catalog_checkouts = _check);
    });
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

  void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
          title:  Text('Сеансы оплаты', style: TextStyle(color: Colors.white70)),
          centerTitle: true,

        ),
        body: FutureBuilder(
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
              else if(snapshot.connectionState == ConnectionState.done && snapshot.data.toString().length == 21 && isInternetOn == true){
                return Container(
                    alignment: Alignment.center,
                    child: Padding(

                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Сеансы оплаты отсутствуют', style: TextStyle(fontSize: 24, color: Color.fromRGBO(124, 58, 237, 0.8)), textAlign: TextAlign.center,),
                    )
                );
              }
              else{
                print('В ОСНОВНУЮ ЧАСТЬ');
                return  SizedBox(
                  height: screenHeight,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ListTile(
                                leading: Icon(Icons.search, color: Color.fromRGBO(124, 58, 237, 0.8)),
                                title: TextField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                      hintText: 'Поиск по статусу', border: InputBorder.none),
                                  onChanged: (value) {
                                    filterSearchResults(value);
                                  },
                                ),
                                trailing: IconButton(icon: Icon(Icons.cancel,), onPressed: () {
                                  controller.clear();
                                  setState(() {
                                    items.clear();
                                    items.addAll(_catalog_checkouts.catalog_checkout);
                                  });
                                  //onSearchTextChanged('');
                                },),
                              ),
                            ),
                          ),
                        ),),
                      Expanded(
                        flex: 17,
                        child:   RefreshIndicator(
                          displacement: 30,
                          strokeWidth: 4.0,
                          color: Color.fromRGBO(124, 58, 237, 0.8),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, int index){
                                print('items.length ${items.length}');
                                return Container(
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  child:
                                  ExpansionPanelList(
                                    animationDuration: Duration(milliseconds: 1000),
                                    children: [
                                      ExpansionPanel(
                                        backgroundColor: Colors.grey.shade300,
                                        headerBuilder: (context, isExpanded) {

                                          return ListTile(
                                            // controlAffinity: ListTileControlAffinity.leading,
                                            title: Row(children: [
                                              Expanded(
                                                child: Text('${rus_status[index]}',
                                                    style: TextStyle(color: rus_status[index] == 'ПРОСРОЧЕН' ? Colors.redAccent : Colors.green.shade500,
                                                        fontFamily: 'Overpass', fontSize: screenWidth/24)),
                                                flex: 3,
                                              ),

                                              Expanded(
                                                child: Text('${widget.email}', textAlign: TextAlign.center,
                                                    style: TextStyle(color: Colors.black,
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
                                                child: Text('${items[index].order.total_amount.amount/100} ₽',
                                                  style: TextStyle(color: Colors.black87,
                                                      fontFamily: 'Overpass', fontSize: 16), textAlign: TextAlign.right,),
                                                flex: 3,
                                              ),

                                            ],),
                                            subtitle: Text('${items[index].order.location.name}',
                                              style: TextStyle(color: Colors.black,
                                                fontFamily: 'Overpass', fontSize: 12,), textAlign: TextAlign.left,),
                                          );
                                        },
                                        body: Column(
                                          children: [
                                             Column(
                                                children: [

                                                  Padding(
                                                    padding:   const EdgeInsets.only(left: 20.0, right: 10,top: 10.0, /*bottom: 10.0*/),
                                                    child: Row(
                                                      children: [
                                                        Text('Информация о сеансе оплаты', style: TextStyle(color: Colors.black, fontSize: screenWidth/19,
                                                          fontWeight: FontWeight.w700,), softWrap: true, textAlign: TextAlign.left,),
                                                      ],
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding:   const EdgeInsets.only(left: 10.0, right: 10,top: 10.0, bottom: 5.0),
                                                    child: Container(
                                                        padding:  const EdgeInsets.all(20.0)/*only(left: 10.0, right: 10,top: 10.0, bottom: 10.0)*/,
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
                                                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text('Ссылка на сеанс оплаты', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),

                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      ElevatedButton(
                                                                        onPressed: () {
                                                                          Clipboard.setData(ClipboardData(text: items[index].checkout_page_url));
                                                                        },
                                                                        child: const Text('Скопировать'),
                                                                        style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.all(Color.fromRGBO(124, 58, 237, 0.8)),
                                                                        ),
                                                                      ),
                                                                    ],),

                                                                  Column(
                                                                    children: [
                                                                      ElevatedButton(
                                                                        onPressed: () {
                                                                           url = items[index].checkout_page_url;
                                                                           _showWeb(context);
                                                                        },
                                                                        child: const Text('Перейти по ссылке'),
                                                                        style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.all(Color.fromRGBO(124, 58, 237, 0.8)),
                                                                        ),
                                                                      ),
                                                                    ],),
                                                                ],),


                                                              const SizedBox(height: 10,),
                                                              Container(
                                                                child: Text('${items[index].checkout_page_url}',
                                                                    style: TextStyle(color: Colors.black, fontSize: screenWidth/19,)),),
                                                            ])
                                                    ),
                                                  ),

                                                   Padding(
                                                      padding:   const EdgeInsets.only(left: 10.0, right: 10,top: 5.0, bottom: 5.0),
                                                      child: Container(
                                                          padding:  const EdgeInsets.all(20.0),
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
                                                                    Text('Детали заказа', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10,),
                                                                Row(
                                                                  children: [
                                                                    //Text('Тут по ордер id', style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w700,)),
                                                                    Expanded(
                                                                      child: ListView.separated(
                                                                          physics: NeverScrollableScrollPhysics(),
                                                                          scrollDirection: Axis.vertical,
                                                                          shrinkWrap: true,
                                                                          itemCount: items[index].order.line_items.length != null ? items[index].order.line_items.length : 0,
                                                                          separatorBuilder: (BuildContext context, int index) =>
                                                                              Divider(color: Colors.black, thickness: 1,),
                                                                          itemBuilder: (BuildContext context, int ind) {
                                                                            return ListTile(
                                                                              // controlAffinity: ListTileControlAffinity.leading,
                                                                              title: Row(children: [
                                                                                Expanded(
                                                                                  child: Text('${items[index].order.line_items[ind].name} ',
                                                                                      style: TextStyle(color: Colors.black87,
                                                                                          fontFamily: 'Overpass', fontSize: 16)),
                                                                                  flex: 2,
                                                                                ),

                                                                                Expanded(
                                                                                  child: Text('x ${items[index].order.line_items[ind].quantity}',
                                                                                      style: TextStyle(color: Colors.grey,
                                                                                          fontFamily: 'Overpass', fontSize: 16)),
                                                                                  flex: 1,
                                                                                ),

                                                                                Expanded(
                                                                                  child: Text('${items[index].order.line_items[ind].bace_price_money.amount/100} ₽',
                                                                                    style: TextStyle(color: Colors.grey,
                                                                                      fontFamily: 'Overpass', fontSize: 16,), textAlign: TextAlign.right,),
                                                                                  flex: 3,
                                                                                ),
                                                                              ],),
                                                                            );
                                                                          }),
                                                                      // flex:5,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ])
                                                      ),
                                                    ),
                                                ],
                                              ),
                                          ],),
                                        isExpanded: items[index].isExpended,
                                        canTapOnHeader: true,
                                      ),
                                    ],
                                    //dividerColor: Colors.red,
                                    expansionCallback: (panelIndex, isExpanded) {
                                      setState(() {
                                        items[index].isExpended = !items[index].isExpended;
                                      });
                                    },
                                  ),
                                );
                              }
                          ),
                          key: _refreshIndicatorKey,
                          onRefresh: _refreshCheck,),
                      ),
                    ],
                  ),

                );
              }
            }
        )
    );
  }
}