//import 'package:auth_ui/Widjets/accordion.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:auth_ui/api/api_catalog.dart';
import 'package:auth_ui/api/catalog_update_object.dart';
import 'package:auth_ui/api/objects.dart';
import 'package:auth_ui/others/change_options.dart';
import 'package:auth_ui/test/test.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert' show utf8;
import 'package:async/async.dart';
import 'add_item.dart';
import 'auth_200.dart';
import 'package:connectivity/connectivity.dart';
import 'package:auth_ui/others/on_session.dart' as globals;


class CatalogScreen extends StatefulWidget {

  late int check;

  CatalogScreen(int CHECK, ){

    check = CHECK;


  }

  static const routeName = '/catalog';
  late int? flag;

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
      //title: 'Shared preferences demo',
        return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
          title: Text( 'Каталог', style: TextStyle(color: Colors.white70)),
        ),
      );
  }


  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
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
  late Catalog catalog;
  late Catalog_retrive catalog_retrive;
  late Color _head_color;

  late bool result;
  late final snack_bar;
  late final snack_bar_nul;
  bool snack_status = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //final _getMemo = AsyncMemoizer();
  late Future myFuture;
  late bool isInternetOn;
  TextEditingController controller = TextEditingController();
  List<Objects> items = [];

  Future<Catalog> get() async {

    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();


      var response = await http.get('${Change_options.url_api_server}/catalog/list',
          headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t')?
          globals.before_restart_token :  token}','Content-Type':'application/json'} /*, body: jsonToString*/);
      print(response);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      print("ЭТО response.body.length  ${response.body.length}");
      final jsonToString = jsonDecode(utf8.decode(response.bodyBytes)/*response.body*/);
      print('jsonToString:   ${jsonToString}');
    /*if(response.body.length < 3){

      if(widget.check == 1){
      if(widget.check == 1){
      }
      else{
        snack_bar_nul =
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: const Text('Каталог продукции пуст!', style: TextStyle(fontSize: 20, color: Colors.white70), textAlign: TextAlign.center, ),
              duration: const Duration(milliseconds: 5000),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            );
        scaffoldKey.currentState!
            .showSnackBar(snack_bar_nul);
      }
    }else{*/
      if(widget.check ==1){
        print("Дааааа");

        snack_bar =
            SnackBar(
              backgroundColor: Colors.green.shade600,
              content: const Text('Продукт успешно добавлен!', style: TextStyle(fontSize: 20, color: Colors.white70), textAlign: TextAlign.center,),
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
        widget.check == 0;
      }

    //};
      catalog = Catalog.fromJson(jsonToString);
      for(int i = 0; i<catalog.objects.length; i++){
        for(int m = 0; m<catalog.objects[i].item_data.variations.length; m++){
          catalog.objects[i].item_data.variations[m].item_variation_data.price_money.amount = (catalog.objects[i].item_data.variations[m].item_variation_data.price_money.amount/100).toInt();
        }

      }
     // print(catalog.toMap().length);
      /*setState(() {
        _loading = false;
      });*/
      items.clear();
      items.addAll(catalog.objects);

    return catalog;
  }


  Future<Catalog_retrive> update_item(id) async {

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
    catalog_retrive = Catalog_retrive.fromJson(jsonToString);
    for(int i = 0; i<catalog_retrive.add_object.add_item_data.add_variations.length; i++){
      catalog_retrive.add_object.add_item_data.add_variations[i].item_variation_data.price_money.amount =
      (catalog_retrive.add_object.add_item_data.add_variations[i].item_variation_data.price_money.amount/100).toInt();
    }
    print(catalog_retrive);

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => AddItemScreen(false,catalog_retrive.add_object.add_item_data.name, catalog_retrive.add_object.add_item_data.description, catalog_retrive.add_object.add_item_data.add_variations)));

    return catalog_retrive;
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
    _head_color = Colors.black;
    super.initState();
    //get();
    isInternetOn = true;
    GetConnect();
    myFuture = get();

  }

  /*onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      print('ВОООТ $_searchResult');
      return;
    }}*/

  void filterSearchResults(String query) {
    List<Objects> dummySearchList = <Objects>[];
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

  /*Widget _buildSearchResults() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _searchResult.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child:
            ExpansionPanelList(
              animationDuration: Duration(milliseconds: 1000),
              children: [
                ExpansionPanel(
                  // backgroundColor: Colors.indigoAccent.shade100,
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      title: Text(_searchResult[index].item_data.name, style: TextStyle(color: _head_color, fontFamily: 'SweetSansPro',fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 20), ),
                      onLongPress: (){
                        update_item(_searchResult[index].id);
                      },
                    );
                  },
                  body: SizedBox(
                    height: 65.0 * _searchResult[index].item_data.variations.length,
                    child: ListView.separated(
                        itemCount: _searchResult[index].item_data.variations.length,
                        separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black, thickness: 1,),
                        itemBuilder: (BuildContext context, int ind){

                          //print('COUNT ${itemData[index].discription.length}');
                          return ListTile(
                            title: Text('${_searchResult[index].item_data.variations[ind].item_variation_data.name}', style: TextStyle(color: Colors.black),),
                          );
                        }),

                  ),

                  isExpanded: _searchResult[index].isExpended,
                  //canTapOnHeader: true,
                ),
              ],
              //dividerColor: Colors.red,
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  _searchResult[index].isExpended = !_searchResult[index].isExpended;
                });
              },
            ),
          );
        }
    );
  }*/

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
          title: Text( 'Каталог', style: TextStyle(color: Colors.white70)),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => AfterAuthScreen(false))),),
            actions: <Widget> [
        IconButton(
          padding: EdgeInsets.only(right: 23.0),
        icon: Icon(Icons.add),
        onPressed: () => {
         Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddItemScreen(true,'', '',[]))),
          /*if(widget.check == 1){
        print("Дааааа"),
            get(),
        snack_bar =
          SnackBar(
            backgroundColor: Colors.green.shade600,
            content: const Text('Продукт успешно добавлен!', style: TextStyle(fontSize: 20, color: Colors.white70), textAlign: TextAlign.center,),
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
           // result = false,
          }else{
            print("Неееет"),
            //Some other action if your work is not done
          },*/
          print("Click on upload button"),
        /*Navigator.push(context, MaterialPageRoute(
          builder: (context) => AddItemScreen())),*/

        },
      ),]
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
                    child: Text('Каталог продукции пуст', style: TextStyle(fontSize: 24, color: Color.fromRGBO(124, 58, 237, 0.8)), textAlign: TextAlign.center,),
                  )
              );
            }
            else{
              print('В ОСНОВНУЮ ЧАСТЬ');
          return SingleChildScrollView(
                  child: SizedBox(
                  height: screenHeight,
                    child: Column(
                      children: [
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
                                trailing: IconButton(icon: Icon(Icons.cancel,), onPressed: () {
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
                            child:
                            ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: items.length,
                                itemBuilder: (BuildContext context, int index){
                                  print('CATALOG ${items.length}');
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    child:
                                    ExpansionPanelList(
                                      animationDuration: Duration(milliseconds: 1000),
                                      children: [
                                        ExpansionPanel(
                                          headerBuilder: (context, isExpanded) {
                                            return ListTile(
                                              title: Text(items[index].item_data.name, style: TextStyle(color: _head_color, fontFamily: 'SweetSansPro',fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 20), ),
                                              onLongPress: (){
                                                update_item(items[index].id);
                                              },
                                            );
                                          },
                                          body: SizedBox(
                                            height: 65.0 * items[index].item_data.variations.length,
                                            child: ListView.separated(
                                                itemCount: items[index].item_data.variations.length,
                                                separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black, thickness: 1,),
                                                itemBuilder: (BuildContext context, int ind){
                                                  return ListTile(
                                                    title: Text('${items[index].item_data.variations[ind].item_variation_data.name}', style: TextStyle(color: Colors.black),),
                                                  );
                                                }),
                                          ),
                                          isExpanded: items[index].isExpended,
                                          //canTapOnHeader: true,
                                        ),
                                      ],
                                      expansionCallback: (panelIndex, isExpanded) {
                                        setState(() {
                                          items[index].isExpended = !items[index].isExpended;
                                        });
                                      },
                                    ),
                                  );
                                }
                            ),),

                      ],
                    ),

                  ),
                );
    }
    }
      ));
  }
}

