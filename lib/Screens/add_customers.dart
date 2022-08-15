import 'dart:convert';
import 'package:auth_ui/api/add_customer.dart';
import 'package:auth_ui/api/adres_add_customer.dart';
import 'package:auth_ui/api/customers_cc.dart';
import 'package:auth_ui/api/preferences_cc.dart';
import 'package:auth_ui/class/idemp_key.dart';
import 'package:auth_ui/others/change_options.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customers_catalog.dart';
import 'package:http/http.dart' as http;
import 'package:auth_ui/others/on_session.dart' as globals;
import 'package:flutter_guid/flutter_guid.dart';

class AddCustomersScreen extends StatefulWidget {

  static const routeName = '/add_customers';


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
  State<AddCustomersScreen> createState() => _AddCustomersScreenState();
}

class _AddCustomersScreenState extends State<AddCustomersScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> form = new GlobalKey<FormState>();

  final String uuid = GUIDGen.generate();
  final first_nameController = TextEditingController();
  final second_nameController = TextEditingController();
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
  int check_customer = 0;

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

    phone_numberController.text = '8';
   // count = 0;
    /*add_variation_list = <Add_Variations>[];
    all_variations = <Add_Variations>[];
    random = new Random();
    flag_accept = 0;

    nameController.text = widget.name;
    descriptionsController.text = widget.description;
    add_variation_list = widget.variations;*/
    //final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  }


  Future<void> new_customer_post() async {

    final employeeId = Guid.newGuid;
    /*Adres_Customer new_adress = Adres_Customer(address_line_1: street_Controller.text, address_line_2: apt_Controller.text,
        locality: city_Controller.text, administrative_district_level_1: state_Controller.text,
        postal_code: zip_Controller.text, country: dropdownValue_2);*/

    Add_Customer new_customer = Add_Customer(id: '', created_at: '', updated_at: '', first_name: first_nameController.text, second_name: second_nameController.text,
        last_name: last_nameController.text, email_address: emailController.text, phone_number: phone_numberController.text.length <= 1 ? '' : phone_numberController.text,
        reference_id: reference_id_Controller.text, company_name: company_Controller.text,
        creation_source: '', version: '', idempotency_key: employeeId.toString());
    print('phone_numberController.text  ${phone_numberController.text.runtimeType}');

    // Add_Item_data add_item_data = Add_Item_data(abbreviation: 'T.E.S.T.', description: descriptionsController.text, name: nameController.text, add_variations: add_variation_list);
    // Add_Objects add_object = Add_Objects(id: '#test', type: 'ITEM', add_item_data: add_item_data);
    // Add_Catalog new_item = Add_Catalog(idempotency_key: uuid, add_object: add_object);
    //final obj = new_item.map((e) => e.toJson()).toList();
    final jsonToString = jsonEncode(new_customer);
    print('jsonToString  $jsonToString');
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

    var response = await http.post('${Change_options.url_api_server}/customers',
        headers: {'Authorization':'Bearer ${!encryptedSharedPreferences.prefs!.containsKey('bearer_t') ?
        globals.before_restart_token :  token}','Content-Type':'application/json', 'Accept':'application/json'} , body: jsonToString);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    Map<String, dynamic> response_dec = jsonDecode(
        response.body);

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      //email_name = emailController.text;
      // получить общие настройки

      print("Клиент успешно добавлен: ${response.body}");
      hideKeyboard();
      first_nameController.clear();
      last_nameController.clear();
      phone_numberController.clear();
      emailController.clear();
      street_Controller.clear();
      apt_Controller.clear();
      city_Controller.clear();
      state_Controller.clear();
      zip_Controller.clear();
      company_Controller.clear();
      reference_id_Controller.clear();
      birthday_Controller.clear();
      check_customer = 1;
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => Customers_CatalogScreen(check_customer)));
      //Navigator.of(context).pop(true);

    } else {
      /* Map<String, dynamic> mess = jsonDecode(
                                                      response.body);*/

      // print("Requare: ${mess['message']}");
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


  /*void delet_item_var(id){

    add_variation_list.removeWhere((Add_Variations add_variations) => add_variations.id == id);
  }*/

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title:  Text("Создание покупателя", style: TextStyle(color: Colors.white70)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>  Navigator.push(context, MaterialPageRoute(
              builder: (context) => Customers_CatalogScreen(0))),

        ),
        actions: <Widget> [
          IconButton(
            padding: EdgeInsets.only(right: 20.0),
            icon: Icon(Icons.add_task_outlined),
            onPressed: ()  async {
             await new_customer_post();
            },
          ),],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Padding(
            padding:   const EdgeInsets.only(left: 15.0, right: 15,/* top: 10.0, bottom: 10.0*/),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                     // Text('Создание клиента', style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w700,)),
                      //SizedBox(height: 10),
                      userInput(last_nameController, 'Введите фамилию',
                          TextInputType.name),
                      userInput(
                          first_nameController, 'Введите имя', TextInputType.name),
                      //SizedBox(height: 10),
                      userInput(second_nameController, 'Введите отчество',
                          TextInputType.name),
                     // SizedBox(height: 10),

                      TextFormField(
                          controller: phone_numberController,
                          keyboardType: TextInputType.phone,
                          validator: (val) => val!.length < 11 || val.length >11 ? 'Номер телефона некоректен' : null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(124, 58, 237, 0.8)),
                              ),
                              labelText: ('Введите номер телефона'),
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(124, 58, 237, 0.8)
                              )
                          ),
                      ),
                     // SizedBox(height: 10),
                      userInput(
                          emailController, '* Введите email', TextInputType.emailAddress),
                      //SizedBox(height: 10),

                      userInput(
                          company_Controller, 'Введите название компании', TextInputType.text),
                      //SizedBox(height: 10),
                      userInput(
                          reference_id_Controller, 'Введите ID', TextInputType.text),
                     // SizedBox(height: 10),
                    ])),
            ),),
        );
  }

  void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}