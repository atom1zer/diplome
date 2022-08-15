import 'dart:convert';
import 'dart:ui';
import 'package:auth_ui/Widjets/drawer.dart';
import 'package:auth_ui/api/catalog_subscriptions.dart';
import 'package:auth_ui/api/subscription_details.dart';
import 'package:auth_ui/api/welcome_stat.dart';
import 'package:auth_ui/others/change_options.dart';
import 'package:connectivity/connectivity.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:auth_ui/others/on_session.dart' as globals;

class Subscriptions_Screen extends StatefulWidget {

  static const routeName = '/subscriptions';

 /* Subscriptions(bool IS_SHOW){

    isDialogShow = IS_SHOW;

  }*/

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
  State<Subscriptions_Screen> createState() => _Subscriptions_ScreenState();

}


class _Subscriptions_ScreenState extends State<Subscriptions_Screen> {

  late Future myFuture;
  late bool isInternetOn;
  TextEditingController controller = TextEditingController();
  late Catalog_subscriptions _catalog_subscriptions;
  List<Subscription_details> items = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  late List<String> rus_cadence;
  late String sub_action;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> rus_status = [];
  List<String> rus_status_invoice = [];

  @override
  void initState() {
    super.initState();
    myFuture = get_catalog_sub();
    isInternetOn = true;
    rus_cadence = [];
  }


  Future<Catalog_subscriptions> get_catalog_sub() async {

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();

    var response = await http.get('${Change_options.url_api_server}/subscriptions-list',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t') ?
        globals.before_restart_token :  token}','Content-Type':'application/json', 'Accept':'application/json'} /*, body: jsonToString*/);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print("ЭТО response.body.length  ${response.body.length}");
    final jsonToString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
    print('jsonToString:   ${jsonToString}');

    _catalog_subscriptions = Catalog_subscriptions.fromJson(jsonToString);
    for(int i = 0; i<_catalog_subscriptions.catalog_subscriptions.length; i++){
      if(_catalog_subscriptions.catalog_subscriptions[i].subscription_plan.cadence == 'WEEKLY'){
        rus_cadence.add('Еженедельно');
      } else if(_catalog_subscriptions.catalog_subscriptions[i].subscription_plan.cadence == 'MONTHLY'){
        rus_cadence.add('Ежемесячно');
      }
    }

    rus_status.clear();
    rus_status_invoice.clear();
    for(int i = 0; i<_catalog_subscriptions.catalog_subscriptions.length; i++){

      if(_catalog_subscriptions.catalog_subscriptions[i].status == 'ACTIVE'){

        rus_status.add('АКТИВНА');

      }else if(_catalog_subscriptions.catalog_subscriptions[i].status == 'CLOSED'){

        rus_status.add('ЗАКРЫТА');

      }


      if(_catalog_subscriptions.catalog_subscriptions[i].invoices[0].status == 'PAID'){

        rus_status_invoice.add('ОПЛАЧЕН');

      }else if(_catalog_subscriptions.catalog_subscriptions[i].invoices[0].status == 'UNPAID'){

        rus_status_invoice.add('НЕОПЛАЧЕН');

      }else if(_catalog_subscriptions.catalog_subscriptions[i].invoices[0].status== 'OVERDUE'){

        rus_status_invoice.add('ПРОСРОЧЕН');
      }else if(_catalog_subscriptions.catalog_subscriptions[i].invoices[0].status == 'DRAFT'){

        rus_status_invoice.add('ЧЕРНОВИК');
      }

    }

    print(_catalog_subscriptions);
    items.clear();
    items.addAll(_catalog_subscriptions.catalog_subscriptions);

    return _catalog_subscriptions;
  }

  void filterSearchResults(String query) {
    List<Subscription_details> dummySearchList = <Subscription_details>[];
    /* for(int i = 0; i<catalog.objects.length; i++){
      dummySearchList.add(catalog.objects[i].item_data.name);
    }*/
    dummySearchList.addAll(_catalog_subscriptions.catalog_subscriptions);
    if(query.isNotEmpty) {
      List<Subscription_details> dummyListData = <Subscription_details>[];
      dummySearchList.forEach((item) {
        if(item.status.contains(query)) {
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
        items.addAll(_catalog_subscriptions.catalog_subscriptions);
      });
    }

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

  Future<void> action_sub(sub_action) async {

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    var response = await http.get('${Change_options.url_api_server}/$sub_action',
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
        myFuture = get_catalog_sub();
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
          sub_action = value + '/' + index.toString();
          print(sub_action);
        });
        await action_sub(sub_action);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: 'stop-subscription',
          child: Text('Приостановить'),
        ),
      ]);

  Future _refreshSub() async {
    _refreshIndicatorKey.currentState!.show();
    return get_catalog_sub().then((_sub) {
      setState(() => _catalog_subscriptions = _sub);
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
      key: scaffoldKey,
       // backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
          title:  Text('Подписки', style: TextStyle(color: Colors.white70)),
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
              else if(snapshot.connectionState == ConnectionState.done && snapshot.data.toString().length == 50 && isInternetOn == true){
                return Container(
                    alignment: Alignment.center,
                    child: Padding(

                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Каталог подписок пуст', style: TextStyle(fontSize: 24, color: Color.fromRGBO(124, 58, 237, 0.8)), textAlign: TextAlign.center,),
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
                                        items.addAll(_catalog_subscriptions.catalog_subscriptions);
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
                                              canTapOnHeader: true,
                                              headerBuilder: (context, isExpanded) {

                                                return ListTile(
                                                  // controlAffinity: ListTileControlAffinity.leading,
                                                  title: Row(children: [

                                                    Expanded(
                                                      child: Text('${rus_status[index]}',
                                                          style: TextStyle(color: rus_status[index] == 'ЗАКРЫТА' ? Colors.redAccent : Colors.green.shade500,
                                                              fontFamily: 'Overpass', fontSize: 16)),
                                                      flex: 4,
                                                    ),

                                                    Expanded(
                                                      child: Text('${items[index].customer.email_address}',
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
                                                      child: Text('${items[index].subscription_plan.recurring_price_money.amount/100} ₽',
                                                        style: TextStyle(color: Colors.black87,
                                                            fontFamily: 'Overpass', fontSize: 16), textAlign: TextAlign.right,),
                                                      flex: 3,
                                                    ),

                                                    Expanded(
                                                        child: _itemDown(items[index].id)),

                                                  ],),
                                                  subtitle: Row(children: [
                                                    Expanded(
                                                      flex: 3,
                                                        child: Text('${items[index].subscription_plan.name}',
                                                          style: TextStyle(color: Colors.black,
                                                            fontFamily: 'Overpass', fontSize: 12,), textAlign: TextAlign.left,),),

                                                    Expanded(
                                                      flex: 8,
                                                        child: Text('',
                                                          style: TextStyle(color: Colors.black,
                                                            fontFamily: 'Overpass', fontSize: 12,), textAlign: TextAlign.left,),),

                                                    ],),
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
                                                              Text('Информация о подписке', style: TextStyle(color: Colors.black, fontSize: screenWidth/19,
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
                                                                        Text('Детали плана', style: TextStyle(color: Colors.black, fontSize: screenWidth/15, fontWeight: FontWeight.w700,)),
                                                                      ],
                                                                    ),
                                                                    SizedBox(height: 20,),

                                                                    Row(
                                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Название', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      children: [
                                                                        Text('${_catalog_subscriptions.catalog_subscriptions[index].subscription_plan.name}',
                                                                            style: TextStyle(color: Colors.black, fontSize: screenWidth/19,)),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 20,),

                                                                    Row(
                                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Стоимость', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      children: [
                                                                        Text('${_catalog_subscriptions.catalog_subscriptions[index].subscription_plan.recurring_price_money.amount/100} ₽',
                                                                            style: TextStyle(color: Colors.black, fontSize: screenWidth/19,)),
                                                                      ],
                                                                    ),

                                                                    const SizedBox(height: 20,),


                                                                    Row(
                                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Периодичность', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      children: [
                                                                        Text('${rus_cadence[index]}',
                                                                            style: TextStyle(color: Colors.black, fontSize: screenWidth/19,)),
                                                                      ],
                                                                    ),
                                                                  ])
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
                                                                        Text('Детали подписки', style: TextStyle(color: Colors.black, fontSize: screenWidth/15, fontWeight: FontWeight.w700,)),
                                                                      ],
                                                                    ),

                                                                    SizedBox(height: 20,),

                                                                    Row(
                                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Клиент', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      children: [
                                                                        Text('${_catalog_subscriptions.catalog_subscriptions[index].customer.email_address}',
                                                                            style: TextStyle(color: Colors.black, fontSize: screenWidth/19, )),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 20,),

                                                                    Row(
                                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Статус', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      children: [
                                                                        Text('${rus_status[index]}',
                                                                            style: TextStyle(color: Colors.black, fontSize: screenWidth/19, )),
                                                                      ],
                                                                    ),

                                                                    const SizedBox(height: 20,),


                                                                    Row(
                                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Дата начала', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      children: [
                                                                        Text('${_catalog_subscriptions.catalog_subscriptions[index].start_date}',
                                                                            style: TextStyle(color: Colors.black, fontSize: screenWidth/19,)),
                                                                      ],
                                                                    ),

                                                                    const SizedBox(height: 20,),

                                                                    Row(
                                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Торговая точка', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      children: [
                                                                        Text('${_catalog_subscriptions.catalog_subscriptions[index].location.name}',
                                                                            style: TextStyle(color: Colors.black, fontSize: screenWidth/19,)),
                                                                      ],
                                                                    ),

                                                                  ])
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
                                                                  //mainAxisAlignment: MainAxisAlignment.start,
                                                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Text('Детали крайней платежной \n активности',
                                                                          style: TextStyle(color: Colors.black, fontSize: screenWidth/18, fontWeight: FontWeight.w700,),
                                                                          softWrap: true,textAlign: TextAlign.center,),
                                                                      ],
                                                                    ),

                                                                    SizedBox(height: 20,),

                                                                    Row(
                                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Статус', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      children: [
                                                                        Text('${rus_status_invoice[index]}',
                                                                            style: TextStyle(color: Colors.black, fontSize: screenWidth/19,)),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 20,),

                                                                    Row(
                                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Срок', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      children: [
                                                                        Text('${_catalog_subscriptions.catalog_subscriptions[index].invoices[0].due_date}',
                                                                            style: TextStyle(color: Colors.black, fontSize: screenWidth/19,)),
                                                                      ],
                                                                    ),

                                                                    const SizedBox(height: 20,),


                                                                    Row(
                                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Стоимость', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      children: [
                                                                        Text('${_catalog_subscriptions.catalog_subscriptions[index].invoices[0].amount_money/100} ₽',
                                                                            style: TextStyle(color: Colors.black, fontSize: screenWidth/19,)),
                                                                      ],
                                                                    ),

                                                                    Visibility(
                                                                      visible: _catalog_subscriptions.catalog_subscriptions[index].invoices[0].status == 'PAID' ?
                                                                      false : true,
                                                                        child: Column(
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Column(
                                                                                  children: [
                                                                                    const SizedBox(height: 20,),
                                                                                    Text('Url оплаты', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,), textAlign: TextAlign.left,),
                                                                                  ],),
                                                                                Column(
                                                                                  children: [
                                                                                    const SizedBox(height: 20,),
                                                                                    ElevatedButton(
                                                                                      onPressed: () {
                                                                                        Clipboard.setData(ClipboardData(text: _catalog_subscriptions.catalog_subscriptions[index].invoices[0].pay_invoice_url));
                                                                                      },
                                                                                      child: const Text('Скопировать'),
                                                                                      style: ButtonStyle(
                                                                                        backgroundColor: MaterialStateProperty.all(Color.fromRGBO(124, 58, 237, 0.8)),
                                                                                      ),
                                                                                    ),
                                                                                  ],),
                                                                              ],),


                                                                            const SizedBox(height: 10,),
                                                                            Container(
                                                                              child:
                                                                              Text('${_catalog_subscriptions.catalog_subscriptions[index].invoices[0].pay_invoice_url}', textDirection: TextDirection.ltr,
                                                                                style: TextStyle(color: Colors.black, fontSize: screenWidth/19,), softWrap: true,),
                                                                            ),
                                                                          ],),),
                                                                  ])
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                ],),
                                              isExpanded: items[index].isExpended,
                                              //canTapOnHeader: true,
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
                                onRefresh: _refreshSub,),
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