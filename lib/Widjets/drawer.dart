import 'package:auth_ui/Screens/auth_200.dart';
import 'package:auth_ui/Screens/catalog.dart';
import 'package:auth_ui/Screens/customers_catalog.dart';
import 'package:auth_ui/Screens/info_about_invoice.dart';
import 'package:auth_ui/Screens/new_order.dart';
import 'package:auth_ui/Screens/plan_sub.dart';
import 'package:auth_ui/Screens/report.dart';
import 'package:auth_ui/Screens/subscriptions.dart';
import 'package:auth_ui/Screens/welcome_screen.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_ui/others/on_session.dart' as globals;


class AppDrawer extends StatelessWidget {

  late String? email_storeg;
  late String? password_storeg;
  get obj => null;




  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(top: 0.0),
        children: <Widget>[

          Container(
            height: 180,
            child: _createHeader(),
          ),

          _createDrawerItem(
              icon: Icons.home,
              text: 'Главная страница',
              onTap: () {
                print('Домой');
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AfterAuthScreen(false)));
              }),
          _createDrawerItem(
              icon: Icons.assignment_sharp,
              text: 'Транзакции',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ReportScreen()));
              }),
          _createDrawerItem(
              icon: Icons.add_shopping_cart,
              text: 'Каталог',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => CatalogScreen(0)));
              }),
          _createDrawerItem(
              icon: Icons.accessibility_new,
              text: 'Клиенты',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Customers_CatalogScreen(0)));
              }),
          _createDrawerItem(
              icon: Icons.monetization_on,
              text: 'План & подписки',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Plan_SubScreen()));
              }),
          _createDrawerItem(
              icon: Icons.add_task,
              text: 'Быстрое создание счета',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => New_OrderScreen('','','')));
               }),
          _createDrawerItem(
              icon: Icons.library_books,
              text: 'Подписки',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Subscriptions_Screen()));
              }),
          Divider(
            thickness: 2,
          ),
          _createDrawerItem(
              icon: Icons.cancel,
              text: 'Выход',
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                final EncryptedSharedPreferences encryptedSharedPreferences =
                EncryptedSharedPreferences(prefs: prefs);
                //Remove String
                encryptedSharedPreferences.prefs!.clear();
                encryptedSharedPreferences.prefs!.remove('bearer_t');
                globals.before_restart_token = '';
                /*email_storeg = (encryptedSharedPreferences.prefs!.getString('email').toString());
                password_storeg = (encryptedSharedPreferences.prefs!.getString('password').toString());*/
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => WelcomeScreen()));
              }),

          /*_createDrawerItem(
              path: 'images/Home.JPG',
              text: 'Домой',
              onTap: () {
                print('Домой');
              }),
          _createDrawerItem(
              path: 'images/Reports.JPG',
              text: 'Отчеты',
              onTap: () {}),
          _createDrawerItem(
              path: 'images/Transactions.JPG',
              text: 'Транзакции',
              onTap: () {}),
          _createDrawerItem(
              path: 'images/Items.JPG',
              text: 'Продукты',
              onTap: () {}),
          _createDrawerItem(
              path: 'images/Customers.JPG',
              text: 'Клиенты',
              onTap: () {}),
          _createDrawerItem(
              path: 'images/Team.JPG',
              text: 'Команда',
              onTap: () {}),
          _createDrawerItem(
              path: 'images/Account.JPG',
              text: 'Аккаунт & настройки',
              onTap: () {}),
          _createDrawerItem(
              path: 'images/Orders.JPG',
              text: 'Заказы',
              onTap: () {}),*/
          /* Divider(),
          ListTile(
            title: Text('Checkout'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Checkout_Screen()));
            },
          ),
          ListTile(
            title: Text('Информация об invoice'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Info_About_InvoiceScreen(obj, '')));
            },
          ),
          ListTile(
            title: Text('Сертификаты'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Лояльность'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Подписки'),
            onTap: () {},
          ),*/

          Divider(thickness: 2,),
          ListTile(
            title: Text('0.0.1'),
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {

    return DrawerHeader(

        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(

                //fit: BoxFit.fill,
                image: AssetImage('images/Head.png'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Биллинговый сервис",
                  style: TextStyle(
                      color: Colors.indigo.shade900,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {/*required String path*/required IconData icon, required String text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          //Image.asset(path),
          Icon(icon, color: Color.fromRGBO(124, 58, 237, 0.8), size: 45),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}