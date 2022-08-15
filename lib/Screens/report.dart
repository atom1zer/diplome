import 'dart:convert';
import 'dart:ui';
import 'package:auth_ui/Screens/auth_200.dart';
import 'package:auth_ui/Screens/welcome_screen.dart';
import 'package:auth_ui/Widjets/drawer.dart';
import 'package:auth_ui/api/catalog_reports.dart';
import 'package:auth_ui/api/list_reports.dart';
import 'package:auth_ui/api/plot_data.dart';
import 'package:auth_ui/api/welcome_stat.dart';
import 'package:auth_ui/others/change_options.dart';
import 'package:connectivity/connectivity.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:timelines/timelines.dart';
import 'package:auth_ui/others/on_session.dart' as globals;
import 'package:month_picker_dialog/month_picker_dialog.dart';

class ReportScreen extends StatefulWidget {

  static const routeName = '/report';


  late bool isDialogShow;

/*
  AfterAuthScreen(bool IS_SHOW){

    isDialogShow = IS_SHOW;

  }*/


  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title: Text( 'Отчеты', style: TextStyle(color: Colors.white70)),
      ),
      //title: 'Shared preferences demo',
    );
  }

  @override
  State<ReportScreen> createState() => _ReportState();

}


class _ReportState extends State<ReportScreen> {

  late Future myFuture;
  late bool isInternetOn;
  TextEditingController controller = TextEditingController();
  late DateTime selectedDate;
  late List<In_catalog_reports> catalog_reports;
  late String date_for_url;
  late List<String> months;
  late int sum_trans;

  get transactions => null;

  @override
  void initState() {
    super.initState();
    sum_trans = 0;
    isInternetOn = true;
    selectedDate =  DateTime.now();
    date_for_url = selectedDate.year.toString() + '-' + selectedDate.month.toString();
    myFuture = get_reports(date_for_url);
    print('СЕЙЧАС: ${selectedDate.year}-${selectedDate.month}');
    months = [];
    months = ['0','января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября','декабря',];

  }


  Future<List<In_catalog_reports>> get_reports(date) async {

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();

    var response = await http.get('${Change_options.url_api_server}/month-stat/$date',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t') ?
        globals.before_restart_token :  token}','content-type': 'application/json', 'Accept':'application/json'} /*, body: jsonToString*/);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print("ЭТО response.body.length  ${response.body.length}");
    final List jsonToString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
    print('jsonToString:   ${jsonToString}');


    try{
      catalog_reports = jsonToString.map((item) => In_catalog_reports.fromJson(item)).toList();
      //catalog_reports = List_reports.fromJson(jsonToString);
    }catch(e){
      print(e);
    }


    return catalog_reports;
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
          title:  Text('Отчеты', style: TextStyle(color: Colors.white70)),
          centerTitle: true,
            actions: <Widget> [
              IconButton(
                padding: EdgeInsets.only(right: 23.0),
                icon: Icon(Icons.insert_invitation),
                onPressed: () => {

                  showMonthPicker(
                    context: context,
                    firstDate: DateTime(DateTime.now().year - 1, 5),
                    lastDate: DateTime(DateTime.now().year + 1, 9),
                    initialDate: selectedDate,
                    locale: Locale("ru"),
                  ).then((date) {
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                        date_for_url = selectedDate.year.toString() + '-' + selectedDate.month.toString();
                        myFuture = get_reports(date_for_url);
                        print('ДАТА ДЛЯ ОТЧЕТОВ: ${selectedDate.year}-${selectedDate.month}');
                      });
                    }
                  }),

                },
              ),]
        ),
        body: FutureBuilder(
            future: myFuture,
            builder: (BuildContext context, snapshot){

              print("snapshot.data l: ${snapshot.data.toString().length}");
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
              else if(snapshot.connectionState == ConnectionState.done && snapshot.data == null && isInternetOn == true){
                return Container(
                    alignment: Alignment.center,
                    child: Padding(

                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Данные отсутствуют', style: TextStyle(fontSize: 24, color:
                      Color.fromRGBO(124, 58, 237, 0.8)), textAlign: TextAlign.center,),
                    )
                );
              }
              else{
                print('В ОСНОВНУЮ ЧАСТЬ');
                return SizedBox(
                    height: screenHeight,
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                       Expanded(
                          child:
                          ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: catalog_reports.length,
                              itemBuilder: (BuildContext context, int index){
                                sum_trans = sum_trans + catalog_reports[index].transactions!.length;
                                print('SUM ${sum_trans}');
                                return index == catalog_reports.length-1 && sum_trans == 0 ? Visibility(
                                  visible: sum_trans == 0 ? true : false,
                                  child: Column(
                                    /*mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,*/
                                    children: [
                                      Text('Данные отсутствуют', style: TextStyle(fontSize: 24, color:
                                      Color.fromRGBO(124, 58, 237, 0.8)), textAlign: TextAlign.center,),
                                    ],
                                  ),
                                   ) :
                                 Visibility(
                                    visible: catalog_reports[index].transactions!.length == 0 ? false : true,
                                    child:  Container(
                                      margin: EdgeInsets.only(bottom: 10.0),
                                      child: ExpansionPanelList(
                                        animationDuration: Duration(milliseconds: 1000),
                                        children: [
                                          ExpansionPanel(
                                          // backgroundColor: Colors.indigoAccent.shade100,
                                            headerBuilder: (context, isExpanded) {

                                              return ListTile(
                                                // controlAffinity: ListTileControlAffinity.leading,
                                                title: Row(children: [
                                                  Expanded(
                                                    child: Text('${index+1} ${months[selectedDate.month]}, ${selectedDate.year}',
                                                    style: TextStyle(color: Colors.black,
                                                    fontFamily: 'Overpass', fontSize: 16)),
                                                    flex: 3,
                                                  ),

                                                   Expanded(
                                                                  child: Text('Всего ${catalog_reports[index].plot_data!.number!}',
                                                                      style: TextStyle(color: Colors.black,
                                                                          fontFamily: 'Overpass', fontSize: 16)),
                                                                  flex: 3,
                                                                ),

                                                  /* Expanded(
                                                                child: Text('${invoices[index].due_date}',
                                                                  style: TextStyle(color: Colors.grey,
                                                                    fontFamily: 'Overpass', fontSize: 16,), textAlign: TextAlign.right,),
                                                                flex: 3,
                                                              ),*/

                                                  Expanded(
                                                    child: Text('Общая сумма ${catalog_reports[index].plot_data!.total} ₽',
                                                    style: TextStyle(color: Colors.black87,
                                                    fontFamily: 'Overpass', fontSize: 16), textAlign: TextAlign.right,),
                                                    flex: 4,
                                                  ),

                                                ],),

                                                /* subtitle: Text('${items[index].subscription_plan.name}',
                                                              style: TextStyle(color: Colors.black,
                                                                fontFamily: 'Overpass', fontSize: 12,), textAlign: TextAlign.left,),*/

                                               onTap: ()  {
                                                 print(' ${catalog_reports[25].transactions![1].subscription_delails!.plan_name.toString()}');
                                               }
                                                 /* for(int i = 0; i<catalog_reports.length; i++){
                                                    for(int m = 0; m<catalog_reports[i].transactions!.length; i++){
                                                      print('$i  ${catalog_reports[index].transactions![m].subscription_delails!.plan_name.toString()}');
                                                    }

                                                  }*/
                                                  /* det_invoice = catalog_invoices.catalog_invoices[index];
                                                          print(det_invoice);
                                                          Navigator.push(context, MaterialPageRoute(
                                                              builder: (context) => Info_About_InvoiceScreen(det_invoice, widget.email_address)));

                                                },*/
                                              );
                                            },
                                            body:  Column(
                                                children: [

                                                    ListView.builder(
                                                        physics: ScrollPhysics(),
                                                        shrinkWrap: true,
                                                        scrollDirection: Axis.vertical,
                                                        itemCount: catalog_reports[index].transactions!.length,
                                                        itemBuilder: (BuildContext context, int index_trans){
                                                          print('CATALOG ${catalog_reports.length}');
                                                          return Container(
                                                            margin: EdgeInsets.only(bottom: 10.0, left: 10),
                                                            child: ExpansionPanelList(
                                                              animationDuration: Duration(milliseconds: 1000),
                                                              children: [
                                                                ExpansionPanel(
                                                                  // backgroundColor: Colors.indigoAccent.shade100,
                                                                  headerBuilder: (context, isExpanded) {

                                                                    return ListTile(
                                                                      // controlAffinity: ListTileControlAffinity.leading,
                                                                      title: Row(children: [
                                                                        Expanded(
                                                                          child: Text('${catalog_reports[index].transactions![index_trans].transaction_type}',
                                                                              style: TextStyle(color: Colors.black,
                                                                                  fontFamily: 'Overpass', fontSize: 18)),
                                                                          flex: 3,
                                                                        ),

                                                                        Expanded(
                                                                          child: Text('Показать еще',
                                                                              style: TextStyle(color: Color.fromRGBO(124, 58, 237, 0.8),
                                                                                  fontFamily: 'Overpass', fontSize: 16)),
                                                                          flex: 3,
                                                                        ),
                                                                      ],),
                                                                    );
                                                                  },
                                                                  body:
                                                                  Column(
                                                                    children: [
                                                                      Column(
                                                                        children: [

                                                                          Padding(
                                                                            padding:   const EdgeInsets.only(left: 20.0, right: 10,top: 10.0, /*bottom: 10.0*/),
                                                                            child: Row(
                                                                              children: [
                                                                                Text('Подробная информация', style: TextStyle(color: Colors.black, fontSize: screenWidth/19,
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
                                                                                      /*Row(
                                                                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text('Детали плана', style: TextStyle(color: Colors.black, fontSize: screenWidth/15, fontWeight: FontWeight.w700,)),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(height: 20,),*/
                                                                                      Row(
                                                                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text('Финальная стоимость', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                                                                        ],
                                                                                      ),
                                                                                      const SizedBox(height: 10,),
                                                                                      Row(
                                                                                        children: [
                                                                                          Text('${catalog_reports[index].transactions![index_trans].total_amount!/100} ₽',
                                                                                              style: TextStyle(color: Colors.black, fontSize: screenWidth/19,)),
                                                                                        ],
                                                                                      ),

                                                                                      const SizedBox(height: 20,),

                                                                                      Row(
                                                                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text('Email покупателя', style: TextStyle(color: Colors.black, fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                                                                        ],
                                                                                      ),
                                                                                      const SizedBox(height: 10,),
                                                                                      Row(
                                                                                        children: [
                                                                                          Text('${catalog_reports[index].transactions![index_trans].customer_email}',
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
                                                                                          Text('${catalog_reports[index].transactions![index_trans].location_name}',
                                                                                              style: TextStyle(color: Colors.black, fontSize: screenWidth/19,)),
                                                                                        ],
                                                                                      ),
                                                                                    ])
                                                                            ),
                                                                          ),

                                                                          Visibility(
                                                                            visible: catalog_reports[index].transactions![index_trans].line_items != null ? true : false,
                                                                            child: Padding(
                                                                              padding:   const EdgeInsets.only(left: 20.0, right: 10,top: 5.0, bottom: 5.0),
                                                                              child: Container(
                                                                                  padding:  const EdgeInsets.all(10.0),
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
                                                                                                  itemCount: catalog_reports[index].transactions![index_trans].line_items == null ? 0 :
                                                                                                  catalog_reports[index].transactions![index_trans].line_items!.length,
                                                                                                  separatorBuilder: (BuildContext context, int index) =>
                                                                                                      Divider(color: Colors.black, thickness: 1,),
                                                                                                  itemBuilder: (BuildContext context, int index_line_item) {
                                                                                                    return ListTile(
                                                                                                      // controlAffinity: ListTileControlAffinity.leading,
                                                                                                      title: Row(children: [
                                                                                                        Expanded(
                                                                                                          child: Text('${catalog_reports[index].transactions![index_trans].line_items![index_line_item].name} ',
                                                                                                              style: TextStyle(color: Colors.black87,
                                                                                                                  fontFamily: 'Overpass', fontSize: 16)),
                                                                                                          flex: 5,
                                                                                                        ),

                                                                                                        Expanded(
                                                                                                          child: Text('x ${catalog_reports[index].transactions![index_trans].line_items![index_line_item].quantity}',
                                                                                                              style: TextStyle(color: Colors.grey,
                                                                                                                  fontFamily: 'Overpass', fontSize: 16)),
                                                                                                          flex: 1,
                                                                                                        ),

                                                                                                        Expanded(
                                                                                                          child: Text('${catalog_reports[index].transactions![index_trans].line_items![index_line_item].amount!/100} ₽',
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
                                                                            ),),

                                                                          Visibility(
                                                                            visible: catalog_reports[index].transactions![index_trans] != null &&
                                                                                catalog_reports[index].transactions![index_trans].subscription_delails != null ? true : false,
                                                                            child: Padding(
                                                                              padding:   const EdgeInsets.only(left: 20.0, right: 10,top: 5.0, bottom: 5.0),
                                                                              child: Container(
                                                                                  padding:  const EdgeInsets.all(10.0),
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
                                                                                            Text('Название плана', style: TextStyle(color: Colors.black,
                                                                                              fontSize: screenWidth/19, fontWeight: FontWeight.w700,)),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 10,),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text('${catalog_reports[index].transactions![index_trans].subscription_delails != null ?
                                                                                            catalog_reports[index].transactions![index_trans].subscription_delails!.plan_name : ''}', style: TextStyle(color: Colors.black,
                                                                                              fontSize: screenWidth/19,)),
                                                                                          ],
                                                                                        ),
                                                                                      ])
                                                                              ),
                                                                            ),),

                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  isExpanded: catalog_reports[index].transactions![index_trans].Expanded,
                                                                  //canTapOnHeader: true,
                                                                ),
                                                              ],
                                                              //dividerColor: Colors.red,
                                                              expansionCallback: (panelIndex, isExpanded) {
                                                                setState(() {
                                                                  catalog_reports[index].transactions![index_trans].Expanded = !catalog_reports[index].transactions![index_trans].Expanded;
                                                                });
                                                              },
                                                            ),
                                                          );

                                                        }
                                                    ),
                                                ],
                                              ),

                                            isExpanded: catalog_reports[index].isExpended,
                                            //canTapOnHeader: true,
                                          ),
                                        ],
                                        //dividerColor: Colors.red,
                                        expansionCallback: (panelIndex, isExpanded) {
                                        setState(() {
                                        catalog_reports[index].isExpended = !catalog_reports[index].isExpended;
                                        });
                                        },
                                      ),
                                )
                                );

                              }
                          ),),

                      ],
                    ),

                );
              }
            }
        ),
    );
  }
}