import 'dart:convert';
import 'dart:ui';
import 'package:auth_ui/Screens/authentification_screen.dart';
import 'package:auth_ui/Widjets/drawer.dart';
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

class AfterAuthScreen extends StatefulWidget {

  static const routeName = '/auth_200';


 late bool isDialogShow;


  AfterAuthScreen(bool IS_SHOW){

    isDialogShow = IS_SHOW;

  }


  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title: Text( 'Главная страница', style: TextStyle(color: Colors.white70)),
      ),
      //title: 'Shared preferences demo',
    );
  }

  @override
  State<AfterAuthScreen> createState() => _AfterAuthState();

}


class _AfterAuthState extends State<AfterAuthScreen> {


  late String? email_storeg;
  late String? password_storeg;
  late List<String> statusis;
  late final welcome_alert;
  late Welcome_stat welcome_stat;
  List<String> type_pay = <String>['Сеансы оплаты','Счета за заказы','Счета за подписки'];
  late List<int> type_pay_value;
  late Future myFuture;
  late bool isInternetOn;
  String token = '';

  @override
  void initState() {
    super.initState();
    statusis= ['PAID','SENT', 'DRAFT'];
    myFuture = get_stat();
    isInternetOn = true;
    type_pay_value = [];

    if(widget.isDialogShow) {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return const AlertDialog(
              title: Text('С возвращением!',
                style: TextStyle(color: Colors.black, fontSize: 20,
                  fontWeight: FontWeight.w700,),
                softWrap: true,
                textAlign: TextAlign.center,),
              content: Text(
                'Представляем краткую сводку по вашему бизнесу.',
                style: TextStyle(color: Colors.black, fontSize: 18,
                  fontWeight: FontWeight.w700,),
                softWrap: true,
                textAlign: TextAlign.center,),
            );

          }

        );
    });
    }
  }


  Future<Welcome_stat> get_stat() async {

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();

   // print('TOKEN ${token.isEmpty}');
    print('Глобальная переменная на главной ${globals.before_restart_token}');

    var response = await http.get('${Change_options.url_api_server}/welcome-stat',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t') ?
        globals.before_restart_token :  token}','Content-Type':'application/json', 'Accept':'application/json'} /*, body: jsonToString*/);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print("ЭТО response.body.length  ${response.body.length}");
    final jsonToString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
    print('jsonToString:   ${jsonToString}');
    Map<String, dynamic> response_dec = jsonDecode(
        response.body);

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      welcome_stat = Welcome_stat.fromJson(jsonToString);
      print(welcome_stat);
      type_pay_value.clear();
      type_pay_value.add(welcome_stat.sum_of.checkouts);
      type_pay_value.add(welcome_stat.sum_of.order_invoices);
      type_pay_value.add(welcome_stat.sum_of.subscription_invoices);

    } else if(response.statusCode >300) {

      print('ДО');
      if(response_dec['message'] == 'Unauthenticated.'){
        print('ВНУТРИ');
        showDialog<String>(
            context: context,
            builder: (BuildContext context) =>
                AlertDialog(
                  title: Text("Ошибка!"),
                  content: Text("Данная сессия истекла."),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        encryptedSharedPreferences.clear();

                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => AuthentificationScreen()));
                      },
                      child: const Text('OK'),
                    ),
                  ],
                  elevation: 24.0,
                  backgroundColor: Colors.white,
                )
        );
      }
    }


    return welcome_stat;
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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title:  Text('Главная страница', style: TextStyle(color: Colors.white70)),
        centerTitle: true,

      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: myFuture,
          builder: (BuildContext context, snapshot){

            print("snapshot.data: ${snapshot.data.toString()}");
            if(snapshot.connectionState == ConnectionState.waiting &&
                snapshot.data == null){
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
                                        height: 120,
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
                                        height: 120,
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
                    child: Text('Подключение к интернету отсутствует', style: TextStyle(fontSize: 24, color: Color.fromRGBO(124, 58, 237, 0.8)), textAlign: TextAlign.center,),
                  )
              );
            }
            else if(snapshot.connectionState == ConnectionState.done && snapshot.data.toString().length == 21 && isInternetOn == true){
              return Container(
                  alignment: Alignment.center,
                  child: Padding(

                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Статистика пуста', style: TextStyle(fontSize: 24, color: Color.fromRGBO(124, 58, 237, 0.8)), textAlign: TextAlign.center,),
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
                              padding:   const EdgeInsets.only(left: 20.0, right: 10,top: 10.0, /*bottom: 10.0*/),
                              child: Row(
                                children: [
                                  Text('За текущий день', style: TextStyle(color: Colors.black, fontSize: screenWidth/19,
                                    fontWeight: FontWeight.w700,), softWrap: true, textAlign: TextAlign.left,),
                                ],
                              ),
                            ),

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
                                          children: [
                                            Text('Валовые продажи', style: TextStyle(color: Colors.black38,
                                              fontSize: screenWidth/19,
                                              fontWeight: FontWeight.w700,), softWrap: true,),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('${welcome_stat.full_sum/100 ?? ''} ₽', style: TextStyle(color: Colors.black,
                                              fontSize: screenWidth/14,
                                              fontWeight: FontWeight.w700,), softWrap: true,),
                                          ],
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
                                          children: [
                                            Text('Транзакции', style: TextStyle(color: Colors.black38,
                                              fontSize: screenWidth/19,
                                              fontWeight: FontWeight.w700,), softWrap: true,),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('${welcome_stat.transactions_count ?? ''}', style: TextStyle(color: Colors.black,
                                              fontSize: screenWidth/14,
                                              fontWeight: FontWeight.w700,), softWrap: true,),
                                          ],
                                        ),

                                      ])
                              ),
                            ),

                            Padding(
                              padding:   const EdgeInsets.only(left: 10.0, right: 10,top: 0.0, /*bottom: 10.0*/),
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
                                          children: [
                                            Text('Типы произведенных оплат', style: TextStyle(color: Colors.black,
                                              fontSize: screenWidth/19,
                                              fontWeight: FontWeight.w700,), softWrap: true,),
                                          ],
                                        ),
                                        SizedBox(height: 20,),

                                        ListView.separated(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: type_pay.length,
                                            separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black26, thickness: 1,),
                                            itemBuilder: (BuildContext context, int ind){

                                              //print('COUNT ${itemData[index].discription.length}');
                                              return ListTile(
                                                leading:  CircleAvatar(
                                                  radius: 8,
                                                  backgroundColor:  Color.fromRGBO(14, 57 * (ind +1), 99, 0.8),
                                                ),
                                                title: Row(children: [
                                                  Expanded(
                                                    child: Text('${type_pay[ind]}',
                                                        style: TextStyle(color: Colors.black87,
                                                            fontFamily: 'Overpass', fontSize: 16)),
                                                    flex: 7,
                                                  ),

                                                  Expanded(
                                                    child: Text('${type_pay_value[ind]/100} ₽',
                                                      style: TextStyle(color: Colors.black,
                                                        fontFamily: 'Overpass', fontSize: 16,), textAlign: TextAlign.right,),
                                                    flex: 4,
                                                  ),
                                                ],),

                                                onTap: (){
                                                  print('НАЖАЛ $ind');
                                                  // update_item(catalog.objects[index].id);
                                                },
                                              );
                                            }),

                                      ])
                              ),


                            ),

                            Padding(
                              padding:   const EdgeInsets.only(left: 10.0, right: 10,top: 10.0, bottom: 10.0),
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
                                          children: [
                                            Text('Топ товаров по продажам', style: TextStyle(color: Colors.black,
                                              fontSize: screenWidth/19,
                                              fontWeight: FontWeight.w700,), softWrap: true,),
                                          ],
                                        ),

                                        SizedBox(height: 20,),

                                        ListView.separated(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: welcome_stat.top_items.length,
                                            separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black26, thickness: 1,),
                                            itemBuilder: (BuildContext context, int ind){

                                              //print('COUNT ${itemData[index].discription.length}');
                                              return ListTile(
                                                leading:  CircleAvatar(
                                                  radius: 8,
                                                  backgroundColor:  Color.fromRGBO(12, 57 * (ind +1), 237, 0.8),
                                                )/* Icon(Icons.brightness_1,size: 16,)*/,
                                                title: Row(children: [
                                                  Expanded(
                                                    child: Text('${welcome_stat.top_items[ind].name}',
                                                        style: TextStyle(color: Colors.black87,
                                                            fontFamily: 'Overpass', fontSize: 16)),
                                                    flex: 7,
                                                  ),

                                                  Expanded(
                                                    child: Text('${welcome_stat.top_items[ind].quantity} шт.',
                                                      style: TextStyle(color: Colors.black,
                                                        fontFamily: 'Overpass', fontSize: 16,), textAlign: TextAlign.right,),
                                                    flex: 4,
                                                  ),
                                                ],),

                                                onTap: (){
                                                  print('НАЖАЛ $ind');
                                                  // update_item(catalog.objects[index].id);
                                                },
                                              );
                                            }),
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
      )
    );
  }
}