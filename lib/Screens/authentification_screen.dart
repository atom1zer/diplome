import 'dart:convert';
import 'package:auth_ui/api/auth.dart';
import 'package:auth_ui/others/change_options.dart';
import 'package:device_info/device_info.dart';
import 'package:auth_ui/Screens/auth_200.dart';
import 'package:auth_ui/Screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:auth_ui/others/on_session.dart' as globals;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class AuthentificationScreen extends StatefulWidget {

  static const routeName = '/authentification-screen';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title: Text( 'Авторизация', style: TextStyle(color: Colors.white70)),
      ),
      //title: 'Shared preferences demo',
    );
  }

  @override
  State<AuthentificationScreen> createState() => _AuthentificationState();

}



class _AuthentificationState extends State<AuthentificationScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late String email_name;
  late String device;
  late String password;
  late String email_storeg;
  late String password_storeg;
  late String bearer_token;
  late String date_auth;
  late String token_storage;
  late Auth auth_post;
  late String requare;
  bool isCheck = false;
  late final snack_bar;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin(); // instantiate device info plugin
  late String url_reg;
  late String modal_name;
  /*final prefs = await SharedPreferences.getInstance();

  final email_storeg = prefs.getString('email') ?? 0;
  final password_storeg = prefs.getString('password') ?? 0;*/

  @override
  void initState() {
    super.initState();
    _loadToken();
    url_reg = 'https://both-fix-original-lexus.trycloudflare.com/register';//ЗАМЕНИТЬ НА ССЫЛКУ РЕГИСТРАЦИИ В БИЛЛИ
    print("isCheck:  $isCheck");
    snack_bar =
        SnackBar(
          backgroundColor: Colors.green.shade600,
          content: const Text('Успешная авторизация!', style: TextStyle(fontSize: 20, color: Colors.white70), textAlign: TextAlign.center,),
          duration: const Duration(milliseconds: 2000),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
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
            {
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
                    title:  Text(
                        modal_name,
                        style: TextStyle(color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Overpass',
                            fontSize: 16), softWrap: true,
                      ),
                    elevation: 0.0
                ),
                backgroundColor: Colors.white.withOpacity(0.95),
                body: Container(
                  height: screenHeight,
                  width: screenWidth,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: WebView(
                          initialUrl: url_reg,
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

  Future<void> auth() async {

    auth_post = Auth(email: emailController.text, password: passwordController.text);
    var body = jsonEncode(auth_post);
    print(body);
    var response = await http.post('${Change_options.url_api_server}/sanctum/token',
        headers: {'Content-Type':'application/json', 'Accept':'application/json'} , body: body);
    print(response);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    Map<String, dynamic> response_dec = jsonDecode(
        response.body);

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      print("Авторизация прошла успешно: ${response.body}");
      hideKeyboard();
      final prefs = await SharedPreferences.getInstance();
      final EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences(prefs: prefs);
     // final prefs = await SharedPreferences.getInstance();
      bearer_token = response_dec['token'];
      print("bearer_token: ${response_dec['token']}");
      emailController.clear();
      passwordController.clear();
      //_sendDataToSecondScreen(context);
      email_name = emailController.text;
      encryptedSharedPreferences.setString('date_auth', DateTime.now().microsecondsSinceEpoch.toString());

      if(isCheck == true){
        // установить значение
        encryptedSharedPreferences.prefs!.clear();
        encryptedSharedPreferences.prefs!.setString('email', emailController.text);
        encryptedSharedPreferences.prefs!.setString('password', passwordController.text);
        encryptedSharedPreferences.prefs!.setString('bearer_t', bearer_token);
      }
      else{
        globals.before_restart_token = bearer_token;
        print('Глобальная переменная ${globals.before_restart_token}');
       // final prefs = await SharedPreferences.getInstance();
        encryptedSharedPreferences.prefs!.clear();
       /* encryptedSharedPreferences.remove("password");*/
        //encryptedSharedPreferences.prefs!.setString('bearer_t', '');
      }

      setState(() {
        scaffoldKey.currentState!
            .showSnackBar(snack_bar);
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => AfterAuthScreen(true)));
        });
      });
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
    hideKeyboard();
  }

  void _loadToken()  async{
    final prefs = await SharedPreferences.getInstance();
    final EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences(prefs: prefs);


    setState(() {
      encryptedSharedPreferences.clear();
       email_storeg = encryptedSharedPreferences.prefs!.getString('email').toString();
      password_storeg = encryptedSharedPreferences.prefs!.getString('password').toString();
      token_storage = encryptedSharedPreferences.prefs!.getString('bearer_t').toString();
    });
    bool CheckValue = encryptedSharedPreferences.prefs!.containsKey('bearer_t');
    print("Сохраненные данные email: $email_storeg  password: $password_storeg "
        "value_email: $CheckValue token: $token_storage");
    if(CheckValue == true){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => AfterAuthScreen(true)));
    }
  }

  Widget userInput(TextEditingController userInput, String label,
      TextInputType keyboardType, obscure) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25),
        child: TextField(

          obscureText: obscure,
          controller: userInput,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38),
            ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(124, 58, 237, 0.8),
        title:  Text("Авторизация", style: TextStyle(color: Colors.white70)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>  Navigator.push(context, MaterialPageRoute(
              builder: (context) => WelcomeScreen())),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: screenHeight,
            width: screenWidth,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding:   const EdgeInsets.only(left: 15.0, right: 15, top: 45.0, bottom: 45.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: userInput(
                              emailController, 'Введите email', TextInputType.emailAddress,false),),

                        Expanded(
                          flex: 2,
                          child: userInput(passwordController, 'Введите пароль',
                              TextInputType.visiblePassword, true),),

                        Expanded(
                          flex: 1,
                          child: Container(
                            padding:  const EdgeInsets.only(left:100.0, bottom: 20),
                            child: Row(
                              children: <Widget> [
                                Text("Запомнить меня"),
                                Checkbox(
                                    value: isCheck,
                                    checkColor: Colors.white,  // color of tick Mark
                                    activeColor: Color.fromRGBO(124, 58, 237, 0.8),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isCheck = value!;
                                      });
                                      print("isCheck:  $isCheck");
                                    }),
                              ],
                            ),
                          ),),

                        Container(
                          height: 55,
                          // for an exact replicate, remove the padding.
                          // pour une réplique exact, enlever le padding.
                          padding: const EdgeInsets.only(
                              top: 5, left: 70, right: 70),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            color: Color.fromRGBO(124, 58, 237, 0.8),
                            onPressed: () async {
                              hideKeyboard();
                              await auth();
                            },
                            child: Text('Авторизоваться', style: TextStyle(fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,),),
                          ),
                        ),

                        SizedBox(height: 10,),

                        Expanded(
                          flex: 2,
                          child:   new RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Используя данное приложение вы соглашаетесь с ',
                                  style: new TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'Пользовательским соглашением',
                                  style: new TextStyle(color: Colors.blue),
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      setState(() {
                                        url_reg = 'http://sigma-billing.herokuapp.com/terms-of-service';
                                        modal_name = 'Пользовательское соглашение';
                                      });

                                    _showWeb(context);
                                   // launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                    },
                                ),

                                TextSpan(
                                  text: ' и ',
                                  style: new TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'Политикой конфиденциальности',
                                  style: new TextStyle(color: Colors.blue),
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      setState(() {
                                        url_reg = 'http://sigma-billing.herokuapp.com/privacy-policy';
                                        modal_name = 'Политика конфиденциальности';
                                      });
                                      _showWeb(context);
                                      // launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                                    },
                                ),
                              ],
                            ),
                          ),



                         /* Row(_showWeb(context);
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: screenWidth-40,
                                child: Text('Используя данное приложение вы соглашаетесь с Пользовательским соглашением и Политикой конфиденциальности', textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey,
                                      fontStyle: FontStyle.italic), softWrap: true,),),

                            ],
                          ),*/),

                        Expanded(
                          flex: 5,
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Нет аккаунта в Трастпэй? ',
                                style: TextStyle(color: Colors.grey,
                                    fontStyle: FontStyle.italic),),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    modal_name = 'Регистрация';
                                    url_reg = 'http://sigma-billing.herokuapp.com/register';
                                  });
                                  _showWeb(context);
                                },
                                child: Text(
                                  'Зарегистрироваться',
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),),
                      ],
                    ),
                  ),),
              ],
            ),),
      ),
    );
  }

  void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

}

