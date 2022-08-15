import 'dart:convert';
import 'dart:math';

import 'package:auth_ui/Screens/catalog.dart';
import 'package:auth_ui/api/add_item_data.dart';
import 'package:auth_ui/api/add_item_to_base.dart';
import 'package:auth_ui/api/add_item_var.dart';
import 'package:auth_ui/api/add_object.dart';
import 'package:auth_ui/api/add_variations.dart';
import 'package:auth_ui/api/catalog_update_object.dart';
import 'package:auth_ui/api/item_data.dart';
import 'package:auth_ui/api/price_money.dart';
import 'package:auth_ui/api/variations.dart';
import 'package:auth_ui/class/idemp_key.dart';
import 'package:auth_ui/class/model_var.dart';
import 'package:auth_ui/others/change_options.dart';
import 'package:auth_ui/test/test.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:http/http.dart' as http;
import 'package:auth_ui/others/on_session.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class AddItemScreen extends StatefulWidget {


  static const routeName = '/add_item';

  late bool vis_b;
  late String name;
  late  List<Add_Variations> variations;
  late String description;


  AddItemScreen(bool VIS_B,String NAME, String DESCRIPTIONS,List<Add_Variations> VARIATIONS){

    vis_b = VIS_B;
    name = NAME;
    variations = VARIATIONS;
    description = DESCRIPTIONS;

  }

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Аккаунт & настройки'),
      //title: 'Shared preferences demo',

    );
  }
  @override
  _AddItemPageState createState() => _AddItemPageState();
}


class _AddItemPageState extends State<AddItemScreen> {

  final nameController = TextEditingController();
  final descriptionsController = TextEditingController();
  final name_variationController = TextEditingController();
  final price_variationController = TextEditingController();
  late int count;
  //List<String> tables = [];
  //List<List<String>> tables_variations = [];

  late List<Add_Variations> add_variation_list;
  late List<Add_Variations> all_variations;
  late Add_Catalog new_item;
  var random;
  int flag = 0;
  late int flag_accept;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int check = 0;
  final snack_bar =
  SnackBar(
    backgroundColor: Colors.green.shade600,
    content: const Text('Продукт успешно добавлен!', style: TextStyle(fontSize: 20, color: Colors.white70), ),
    duration: const Duration(milliseconds: 1500),
    //width: 280.0, // Width of the SnackBar.
    /*padding: const EdgeInsets.symmetric(
              horizontal: 25.0, // Inner padding for SnackBar content.
              ),*/
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  void showInSnackBar() {
    scaffoldKey.currentState!
        .showSnackBar(snack_bar);}

  Future<void> new_item_post() async {

    final employeeId = Guid.newGuid;

    for(int i = 0; i<add_variation_list.length; i++) {
      add_variation_list[i].item_variation_data.price_money.amount =
          add_variation_list[i].item_variation_data.price_money.amount * 100;
    }

    Add_Item_data add_item_data = Add_Item_data(description: descriptionsController.text, name: nameController.text, add_variations: add_variation_list);
    Add_Objects add_object = Add_Objects(id: '#test', type: 'ITEM', add_item_data: add_item_data);
    Add_Catalog new_item = Add_Catalog(idempotency_key: employeeId.toString(), add_object: add_object);
    //final obj = new_item.map((e) => e.toJson()).toList();
    final jsonToString = jsonEncode(new_item);
    /*print("ЭТО jsonToString ДО  $jsonToString");
                                          List<String> jsonString = jsonToString.split("");
                                          print("Разделение  $jsonString");
                                          jsonString.removeAt(0);
                                          print("Удалили  $jsonString");
                                          jsonString.removeAt(jsonString.length-1);
                                          String jsonFromString = jsonString.join();*/
    //print("ЭТО jsonToString после энкода  $jsonToString");


    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);

    String token = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    var response = await http.post('${Change_options.url_api_server}/catalog/object',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t') ?
        globals.before_restart_token :  token}',
          'Content-Type':'application/json', 'Accept':'application/json'} , body: jsonToString);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    Map<String, dynamic> response_dec = jsonDecode(
        response.body);

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      //email_name = emailController.text;
      // получить общие настройки

      print("Продукт успешно добавлен: ${response.body}");
      hideKeyboard();
      nameController.clear();
      descriptionsController.clear();
      //_sendDataToSecondScreen(context);
      check = 1;
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => CatalogScreen(check)));
      //Navigator.of(context).pop(true);

    } else {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) =>
              AlertDialog(
                title: Text("Ошибка!"),
                content: Text("${response_dec['message']}"),
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

 /* void _sendDataToSecondScreen(BuildContext context) {
    flag_accept = 1;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CatalogScreen(flag: flag_accept,),
        ));
  }*/

  Widget userInput(TextEditingController userInput, String label,
      TextInputType keyboardType) {
    return Container(
      // margin: EdgeInsets.only(top: 10),

      child:  TextField(

        controller: userInput,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38),
            ),
            //label: const Text("Привет"),


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

  @override
  void initState() {
    super.initState();
    count = 0;
    add_variation_list = <Add_Variations>[];
    all_variations = <Add_Variations>[];
    random = new Random();
    flag_accept = 0;
    final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
    nameController.text = widget.name;
    descriptionsController.text = widget.description;
    add_variation_list = widget.variations;
  }


  void delet_item_var(id){

    add_variation_list.removeWhere((Add_Variations add_variations) => add_variations.id == id);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title:  Text("Добавить продукт", style: TextStyle(color: Colors.white70, fontSize: 16)),
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () =>  Navigator.push(context, MaterialPageRoute(
           builder: (context) => CatalogScreen(0))),

    ),
          actions: <Widget> [
            Visibility(
                visible: widget.vis_b,
                child: IconButton(
                  padding: EdgeInsets.only(right: 20.0),
                  icon: Icon(Icons.add_task_outlined),
                  onPressed: () => {
                    new_item_post(),
                  },
                ),),
            ],
        centerTitle: true,

    ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        /* decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),*/
        child: Padding(
          padding:   const EdgeInsets.only(left: 15.0, right: 15, top: 40.0, bottom: 45.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Детали', style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w700,)),
              SizedBox(height: 20),
              userInput(
                  nameController, 'Введите название продукта', TextInputType.emailAddress),
              SizedBox(height: 20),
              userInput(descriptionsController, 'Введите описание продукта',
                  TextInputType.visiblePassword),
              SizedBox(height: 20),
              TextButton(
                child: Text('Добавить разновидность', style: TextStyle(color: Color.fromRGBO(124, 58, 237, 0.8), fontSize: 20,
                  fontWeight: FontWeight.w700,)),
                onPressed: (){
                  hideKeyboard();
                  showModalBottomSheet<void>(
                    useRootNavigator: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        color: Colors.white,
                        child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              //mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                            Padding(
                            padding:  const EdgeInsets.only(left: 15.0, top: 10.0 ,right: 15, bottom: 45.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  userInput(name_variationController, 'Введите название разновидности', TextInputType.text),
                                  SizedBox(height: 20.0),
                                  userInput(price_variationController, 'Введите стоимость разновидности', TextInputType.text),
                                  SizedBox(height: 20.0),
                                  Container(
                                    height: 65,
                                    width: screenWidth/14,
                                    // for an exact replicate, remove the padding.
                                    // pour une réplique exact, enlever le padding.
                                    padding: const EdgeInsets.only(
                                        top: 5, left: 70, right: 70),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)),
                                      color: Color.fromRGBO(124, 58, 237, 0.8),
                                      onPressed: ()  {
                                        setState(() {
                                          count++;

                                          Price_money price_money = Price_money(amount: int.parse(price_variationController.text), currency: 'RUB');
                                          Add_Item_Var item_variation_data = Add_Item_Var(name: name_variationController.text, price_money: price_money, pricing_type: 'FIXED_PRICING', item_id: '#test');
                                          //add_variation_list = <Add_Variations>[Add_Variations(id:'#test', type: 'ITEM_VARIATION', item_variation_data:  item_variation_data,)];

                                          add_variation_list.add(Add_Variations(id:'#' + random.nextInt(10000).toString(), type: 'ITEM_VARIATION', item_variation_data:  item_variation_data));

                                          //Add_Variations add_variations = Add_Variations(id: '#test_var', type: 'ITEM_VARIATION', item_variation_data: item_variation_data);

                                        });
                                          print('ADD_ITEM_VAR_LIST:   $add_variation_list');


                                          /*Price_money price_money = Price_money(amount: int.parse(price_variationController.text), currency: 'USD');
                                          Add_Item_Var item_variation_data = Add_Item_Var(name: name_variationController.text, price_money: price_money, pricing_type: 'FIXED_PRICING', item_id: '#test');*/




                                        name_variationController.clear();
                                        price_variationController.clear();
                                        hideKeyboard();
                                        Navigator.pop(context);
                                      },
                                      child: Text('Добавить', style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,),),
                                    ),

                                  ),
                                ])),

                                ],
                            ),
                          ),
                      );
                    },
          );
                },

              ),
              SizedBox(height: 5),

              //435345345345345435

             /* SingleChildScrollView(
                child:  SizedBox(
                  height: 300,
                  child: ListView.builder(
                      itemCount: count,
                      itemBuilder: (BuildContext context, int index){
                        return Text('123');

                      }
                  ),
                ),
              ),*/

                /*Padding(
                  padding: const EdgeInsets.all(8.0),
                ),*/
              Expanded(

                child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: add_variation_list.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(color: Colors.black, thickness: 1,),
                    itemBuilder: (BuildContext context, int ind) {
                      return ListTile(
                        // controlAffinity: ListTileControlAffinity.leading,
                        title: Row(children: [
                          Expanded(
                            child: Text('${add_variation_list[ind].item_variation_data.name} ',
                                style: TextStyle(color: Colors.black87,
                                    fontFamily: 'Overpass', fontSize: 16)),
                            flex: 8,
                          ),

                          /*Expanded(
                            child: Text('x ${all_items_sale[ind].quantity}',
                                style: TextStyle(color: Colors.grey,
                                    fontFamily: 'Overpass', fontSize: 16)),
                            flex: 1,
                          ),*/

                          Expanded(
                            child: Text('${add_variation_list[ind].item_variation_data.price_money.amount} ₽',
                              style: TextStyle(color: Colors.grey,
                                fontFamily: 'Overpass', fontSize: 16,), textAlign: TextAlign.right,),
                            flex: 3,
                          ),

                          Expanded(
                            child: IconButton(
                                onPressed: (){
                                  print({add_variation_list.length});

                                  setState(() {
                                    delet_item_var(add_variation_list[ind].id);
                                    //all_variations.removeWhere((Add_Variations add_variations) => add_variations.id == add_variation_list.id);
                                  });

                                },
                                icon: Icon(Icons.delete)),
                            flex: 1,
                          ),

                        ],),
                       /* subtitle: Text('${add_variation_list[ind].type}',
                          style: TextStyle(color: Colors.grey,
                            fontFamily: 'Overpass', fontSize: 12,), textAlign: TextAlign.left,),*/

                      );
                    }),
                flex:5,
              ),
              /*Container(
                  padding: const EdgeInsets.all(0.0),
                  child: DataTable(

                    columnSpacing: 30.0,

                    columns: [
                      DataColumn(label: Text('Название', style: TextStyle(fontStyle: FontStyle.italic))),
                      DataColumn(label: Text('Валюта', style: TextStyle(fontStyle: FontStyle.italic))),
                      DataColumn(label: Text('Стоимость', style: TextStyle(fontStyle: FontStyle.italic))),
                      DataColumn(label: Text('123', style: TextStyle(fontStyle: FontStyle.italic))),
                    ],
                    rows:
                    add_variation_list
                        .map(
                          (add_variation_list) => DataRow(
                          selected: all_variations.contains(add_variation_list),

                          cells: [

                            DataCell(
                              Text(add_variation_list.item_variation_data.name),
                              onTap: () {
                                // write your code..
                              },
                            ),
                            DataCell(
                              Text(add_variation_list.item_variation_data.price_money.currency),
                             /* onTap: () {
                                // write your code..
                              },*/
                            ),
                            DataCell(
                              Text(add_variation_list.item_variation_data.price_money.amount.toString()),
                            ),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Удалить',
                                onPressed: () {
                                  print({all_variations.length});

                                  setState(() {
                                    delet_item_var(add_variation_list.id);
                                    //all_variations.removeWhere((Add_Variations add_variations) => add_variations.id == add_variation_list.id);
                                  });

                                },
                              ),
                            )
                          ]),
                    )
                        .toList(),



                    /*const <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Sarah')),
                          DataCell(Text('19')),
                          DataCell(Text('Student')),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Janine')),
                          DataCell(Text('43')),
                          DataCell(Text('Professor')),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('William')),
                          DataCell(Text('27')),
                          DataCell(Text('Associate Professor')),
                        ],
                      ),
                    ],*/

                     /* listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
                          .map(
                        ((element) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(element["Name_var"].toString())),
                            DataCell(Text('USD')),//Extracting from Map element the value
                            DataCell(Text(element["Price_var"].toString())),
                          ],
                        )),
                      )
                          .toList(),*/

                  ),

                  /*Table(

                    // textDirection: TextDirection.rtl,
                    // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                    // border:TableBorder.all(width: 2.0,color: Colors.red),
                    children: tableRows,

                  ),*/
                ),*/



            ],
          ),

        ),
      ),
    );
  }

  void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

}