import 'dart:convert';
import 'package:auth_ui/api/all_info_invoice.dart';
import 'package:auth_ui/api/catalog_update_object.dart';
import 'package:auth_ui/api/invoice_in_list.dart';
import 'package:auth_ui/others/change_options.dart';
import 'package:connectivity/connectivity.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timelines/timelines.dart';
import 'package:auth_ui/others/on_session.dart' as globals;

class Info_About_InvoiceScreen extends StatefulWidget {

  static const routeName = '/info_about_invoice';

  late Invoice_in_list det_invoice;
  late String customer_email;


  Info_About_InvoiceScreen(Invoice_in_list DET_INVOICE, String EMAIL){

    det_invoice = DET_INVOICE;
    customer_email = EMAIL;

  }

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title: Text( 'Invoice for', style: TextStyle(color: Colors.white70)),
      ),
      //title: 'Shared preferences demo',
    );
  }

  @override
  State<Info_About_InvoiceScreen> createState() => _Info_About_InvoiceState();

}


class _Info_About_InvoiceState extends State<Info_About_InvoiceScreen> {

  late List<String> statusis;
  late All_info_invoice _all_info_invoice;
  late Catalog_retrive catalog_retrive;
  late bool isInternetOn;
  late Future info_Future;
  List<String> rus_status = [];
  late Color status_color;
  String cadence_rus = '';
  String status_rus = '';
  String invoice_status_r = '';

  get invoices => null;



  @override
  void initState() {
    super.initState();
    statusis= ['PAID','SENT', 'DRAFT'];
    isInternetOn = true;
    info_Future = get_info_invoice(widget.det_invoice.id);
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


  Future<All_info_invoice> get_info_invoice(id_inv) async {

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    var response = await http.get('${Change_options.url_api_server}/invoice-activities/$id_inv',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t') ?
        globals.before_restart_token :  token}','Content-Type':'application/json'} /*, body: jsonToString*/);
    print('123 $response');
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print("ЭТО response.body.length  ${response.body.length}");
    final jsonToString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
    print('jsonToString:   ${jsonToString}');

    print('order_details ${jsonToString.containsKey("order_details")}');
    print('subscription_details ${jsonToString.containsKey("subscription_details")}');


    try {
      _all_info_invoice = All_info_invoice.fromJson(jsonToString);
      print("ЭТО _all_info_invoice  $_all_info_invoice");
    }catch(e){
      print("E  $e");
    }
    rus_status.clear();

    if(_all_info_invoice.subscription_details != null){
      if(_all_info_invoice.subscription_details!.subscription_plan.cadence == 'WEEKLY'){
        cadence_rus = 'Еженедельно';
      } else if(_all_info_invoice.subscription_details!.subscription_plan.cadence == 'MONTHLY'){
        cadence_rus = 'Ежемесячно';
      }
    }


    if(_all_info_invoice.subscription_details != null){

      if(_all_info_invoice.subscription_details!.status == 'ACTIVE'){
        status_rus = 'Активна';
      } else if(_all_info_invoice.subscription_details!.subscription_plan.cadence == 'CLOSED'){
        status_rus = 'Закрыта';
      }

      if(_all_info_invoice.subscription_details!.invoices[0].status == 'PAID'){

      }

      if(_all_info_invoice.subscription_details!.invoices[0].status == 'PAID'){
        invoice_status_r == 'ОПЛАЧЕН';
      } else if(_all_info_invoice.subscription_details!.invoices[0].status == 'UNPAID'){
        invoice_status_r == 'НЕОПЛАЧЕН';
      }else if(_all_info_invoice.subscription_details!.invoices[0].status == 'OVERDUE'){
        invoice_status_r == 'ПРОСРОЧЕН';
      }else if(_all_info_invoice.subscription_details!.invoices[0].status == 'DRAFT'){
        invoice_status_r == 'ЧЕРНОВИК';
      }

    }



    for(int i = 0; i<_all_info_invoice.invoice_activities.length; i++){

      if(_all_info_invoice.invoice_activities[i].activity_type == 'PAID'){

        rus_status.add('ОПЛАЧЕНО');

      }else if(_all_info_invoice.invoice_activities[i].activity_type == 'SENT'){

        rus_status.add('ОТПРАВЛЕНО');

      }else if(_all_info_invoice.invoice_activities[i].activity_type == 'DRAFT'){

        rus_status.add('ЧЕРНОВИК');
      }else if(_all_info_invoice.invoice_activities[i].activity_type == 'REMINDER_SENT'){

        rus_status.add('НАПОМИНАНИЕ ОТПРАВЛЕНО');
      }else if(_all_info_invoice.invoice_activities[i].activity_type == 'OVERDUE'){

        rus_status.add('ПРОСРОЧЕНО');
      }
    }

    return _all_info_invoice;
  }


  Widget info_invoice_Widjet() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: info_Future,
        builder: (BuildContext context, snapshot){

          print("snapshot.data: ${snapshot.data.toString()}");
          if(snapshot.connectionState == ConnectionState.waiting &&
              snapshot.data == null){
            return
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal:38),
                  child: Center(
                    child: LinearProgressIndicator()
                  ))
              /*Container(
                color: Colors.white,
                child: SafeArea(
                  child: ListView.builder(
                    /*gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                          maxCrossAxisExtent: 200,
                                                          childAspectRatio: 3 / 4,
                                                          crossAxisSpacing: 20,
                                                          mainAxisSpacing: 20),*/
                      itemCount: 8,
                      itemBuilder: (BuildContext ctx, index) {
                        /*offset += 5;
                                                        time = 800 + offset;*/
                        return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            child: Shimmer.fromColors(
                              highlightColor: Colors.deepPurpleAccent,
                              baseColor: Color.fromRGBO(124, 58, 237, 0.8)/*Colors.grey[500]*/,
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
            )*/;
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
                  child: Text('Перезагрузите страницу', style: TextStyle(fontSize: screenWidth/16, color: Color.fromRGBO(124, 58, 237, 0.8)), textAlign: TextAlign.center,),
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
                                              Text('Финальная стоимость', style: TextStyle(color: Colors.black, fontSize: screenWidth/16, fontWeight: FontWeight.w700,)),
                                            ],
                                          ),
                                          const SizedBox(height: 20,),
                                          Row(
                                            children: [
                                              Text('${_all_info_invoice.order_details == null ?
                                  _all_info_invoice.subscription_details!.subscription_plan.recurring_price_money.amount/100 :
                                  _all_info_invoice.order_details!.total_amount.amount/100} ₽',
                                                  style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w700,)),
                                            ],
                                          ),
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
                                              Text('Активность', style: TextStyle(color: Colors.black, fontSize: screenWidth/16, fontWeight: FontWeight.w700,)),

                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: FixedTimeline.tileBuilder(

                                                    builder: TimelineTileBuilder.connected(
                                                      /* firstConnectorBuilder: ConnectorStyle.transparent,
             lastConnectorBuilder: ConnectorStyle.transparent,*/
                                                      //connectionDirection: ConnectionDirection.before,
                                                      connectorBuilder: (context, index, er) => SolidLineConnector(
                                                        color: Colors.grey.shade400,
                                                      ),
                                                      indicatorBuilder: (context, index) =>
                                                      /*_all_info_invoice.invoice_activities[index].activity_type*/rus_status[index] == 'ОПЛАЧЕНО' ||
                                                          /*_all_info_invoice.invoice_activities[index].activity_type*/ rus_status[index] == 'ПРОСРОЧЕНО' ? OutlinedDotIndicator(
                                                        color: rus_status[index] == 'ОПЛАЧЕНО' ?
                                                        Colors.lightGreenAccent.shade700 :
                                                        Colors.redAccent ,
                                                            child: Padding(
                                                              padding: EdgeInsets.all(3),
                                                              child: DotIndicator(
                                                                color: rus_status[index] == 'ОПЛАЧЕНО' ?
                                                                Colors.lightGreenAccent.shade700 :
                                                                Colors.redAccent ,
                                                              ),),

                                                      ): DotIndicator(
                                                        color: Colors.black,
                                                      ),

                                                      contentsAlign: ContentsAlign.reverse,
                                                      oppositeContentsBuilder: (context, index) => Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${_all_info_invoice.invoice_activities[index].date}'),
                                                      ),
                                                      contentsBuilder: (context, index) => Card(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text('${rus_status[index] }'),
                                                        ),
                                                      ),
                                                      itemExtent: 70.0,
                                                      itemCount: rus_status.length,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ])
                                ),
                              ),

                             Visibility(
                                visible: _all_info_invoice.order_details == null ? false : true,
                                child: Padding(
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
                                                Text('Детали заказа', style: TextStyle(color: Colors.black, fontSize: screenWidth/16, fontWeight: FontWeight.w700,)),
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
                                                      itemCount: _all_info_invoice.order_details != null ? _all_info_invoice.order_details!.line_items.length : 0,
                                                      separatorBuilder: (BuildContext context, int index) =>
                                                          Divider(color: Colors.black, thickness: 1,),
                                                      itemBuilder: (BuildContext context, int ind) {
                                                        return ListTile(
                                                          // controlAffinity: ListTileControlAffinity.leading,
                                                          title: Row(children: [
                                                            Expanded(
                                                              child: Text('${_all_info_invoice.order_details!.line_items[ind].name} ',
                                                                  style: TextStyle(color: Colors.black87,
                                                                      fontFamily: 'Overpass', fontSize: 16)),
                                                              flex: 3,
                                                            ),

                                                            Expanded(
                                                              child: Text('x ${_all_info_invoice.order_details!.line_items[ind].quantity}',
                                                                  style: TextStyle(color: Colors.grey,
                                                                      fontFamily: 'Overpass', fontSize: 16)),
                                                              flex: 1,
                                                            ),

                                                            Expanded(
                                                              child: Text('${_all_info_invoice.order_details!.line_items[ind].bace_price_money.amount/100} ₽',
                                                                style: TextStyle(color: Colors.grey,
                                                                  fontFamily: 'Overpass', fontSize: 16,), textAlign: TextAlign.right,),
                                                              flex: 2,
                                                            ),
                                                          ],),
                                                          /*subtitle: Text('${all_items_sale[ind].descriptions}',
                                                  style: TextStyle(color: Colors.grey,
                                                    fontFamily: 'Overpass', fontSize: 12,), textAlign: TextAlign.left,),*/

                                                        );
                                                      }),
                                                  // flex:5,
                                                ),
                                              ],
                                            ),
                                          ])
                                  ),
                                ),

                              ),


                             Visibility(
                               visible: _all_info_invoice.subscription_details == null ? false : true,
                                child: Padding(
                                  padding:   const EdgeInsets.only(left: 10.0, right: 10,top: 5.0, bottom: 5.0),
                                  child: Container(
                                            padding:  const EdgeInsets.all(20.0),
                                           // height: 80,
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
                                                        Text('Детали подписки', style: TextStyle(color: Colors.black, fontSize: screenWidth/16, fontWeight: FontWeight.w700,)),
                                                      ],
                                                    ),

                                                    SizedBox(height: 20,),

                                                    Text('Детали плана', style: TextStyle(color: Colors.black,
                                                      fontSize: 22, fontWeight: FontWeight.w700,)),
                                                    SizedBox(height: 12,),

                                                        Row(
                                                          children: [
                                                            Text('Имя  ', style: TextStyle(color: Colors.black,
                                                              fontSize: 20, fontWeight: FontWeight.w700,)),

                                                            Text('${_all_info_invoice.subscription_details != null ? _all_info_invoice.subscription_details!.subscription_plan.name : null}', style: TextStyle(color: Colors.black,
                                                              fontSize: 18,)),
                                                          ],
                                                        ),
                                                    SizedBox(height: 10,),

                                                        Row(
                                                          children: [
                                                            Text('Периодичность  ', style: TextStyle(color: Colors.black,
                                                              fontSize: 20, fontWeight: FontWeight.w700,)),

                                                            Text('${_all_info_invoice.subscription_details != null ? cadence_rus : null}',
                                                                style: TextStyle(color: Colors.black,
                                                                  fontSize: 18,)),
                                                          ],
                                                        ),
                                                  SizedBox(height: 10,),

                                                        Row(
                                                          children: [
                                                            Text('Стоимость  ', style: TextStyle(color: Colors.black,
                                                              fontSize: 20, fontWeight: FontWeight.w700,)),

                                                            Text('${_all_info_invoice.subscription_details != null ? _all_info_invoice.subscription_details!.subscription_plan.recurring_price_money.amount/100 : null} ₽',
                                                                style: TextStyle(color: Colors.black,
                                                                  fontSize: 18,)),
                                                          ],
                                                        ),
                                                  SizedBox(height: 12,),

                                                        Text('Информация о подписке', style: TextStyle(color: Colors.black,
                                                          fontSize: 22, fontWeight: FontWeight.w700,)),
                                                  SizedBox(height: 12,),

                                                        Row(
                                                          children: [
                                                            Text('Дата активации  ', style: TextStyle(color: Colors.black,
                                                              fontSize: 20, fontWeight: FontWeight.w700,)),

                                                            Text('${_all_info_invoice.subscription_details != null ? _all_info_invoice.subscription_details!.start_date : null}', style: TextStyle(color: Colors.black,
                                                              fontSize: 18,)),
                                                          ],
                                                        ),
                                                  SizedBox(height: 10,),

                                                        Row(
                                                          children: [
                                                            Text('Статус подписки  ', style: TextStyle(color: Colors.black,
                                                              fontSize: 20, fontWeight: FontWeight.w700,)),

                                                            Text('${_all_info_invoice.subscription_details != null ? status_rus : null}', style: TextStyle(color: Colors.black,
                                                              fontSize: 18,)),
                                                          ],
                                                        ),
                                                  SizedBox(height: 12,),

                                                        Text('Информация о последнем заказе', style: TextStyle(color: Colors.black,
                                                          fontSize: 22, fontWeight: FontWeight.w700,)),

                                                  SizedBox(height: 12,),
                                                        Row(
                                                          children: [
                                                            Text('Статус  ', style: TextStyle(color: Colors.black,
                                                              fontSize: 20, fontWeight: FontWeight.w700,)),

                                                            Text('${_all_info_invoice.subscription_details != null ? invoice_status_r : null}',
                                                                style: TextStyle(color: Colors.black,
                                                                  fontSize: 18,)),
                                                          ],
                                                        ),
                                                  SizedBox(height: 10,),

                                                        Row(
                                                          children: [
                                                            Text('Срок  ', style: TextStyle(color: Colors.black,
                                                              fontSize: 20, fontWeight: FontWeight.w700,)),

                                                            Text('${_all_info_invoice.subscription_details != null ? _all_info_invoice.subscription_details!.invoices[0].due_date : null}',
                                                                style: TextStyle(color: Colors.black,
                                                                  fontSize: 18,)),
                                                          ],
                                                        ),

                                                      ],
                                                    ),

                                                    // flex:5,

                                        ),
                                ),

                              ),


                             Padding(
                                padding:   const EdgeInsets.only(left: 10.0, right: 10,top: 5.0, bottom: 10.0),
                                child: Container(
                                    padding:  const EdgeInsets.all(20.0),
                                    // height: 60,
                                   // width: screenWidth-20,
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
                                              Text('Информация о заказе', style: TextStyle(color: Colors.black,
                                                fontSize: screenWidth/16, fontWeight: FontWeight.w700,)),
                                            ],
                                          ),
                                          SizedBox(height: 20,),

                                          Text('Заказ #', style: TextStyle(color: Colors.black,
                                            fontSize: 20, fontWeight: FontWeight.w700,), maxLines: 2),

                                          SizedBox(height: 5,),

                                          Text('${widget.det_invoice.id}',  textDirection: TextDirection.ltr,
                                              style: TextStyle(color: Colors.black, fontSize: 18,),softWrap: true, maxLines: 2,),

                                          SizedBox(height: 10,),

                                          Row(
                                            children: [
                                              Text('Срок заказа  ', style: TextStyle(color: Colors.black,
                                                fontSize: 20, fontWeight: FontWeight.w700,)),
                                              Text('${widget.det_invoice.due_date}',
                                                  style: TextStyle(color: Colors.black, fontSize: 18,)),
                                            ],
                                          ),

                                          SizedBox(height: 10,),

                                          Text('Покупатель', style: TextStyle(color: Colors.black,
                                            fontSize: 20, fontWeight: FontWeight.w700,)),
                                          SizedBox(height: 5,),
                                          Text('${widget.customer_email}',
                                              style: TextStyle(color: Colors.black, fontSize: 18,)),

                                        ])
                                ),
                              ),
                          ],
                        ),),),
                ],
              ),


            );
          }
        }
    );

  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title: Text( 'Счет клиента ${widget.customer_email}', style: TextStyle(color: Colors.white70, fontSize: screenWidth/21)),
      ),
      body: info_invoice_Widjet(),
    );
  }
}