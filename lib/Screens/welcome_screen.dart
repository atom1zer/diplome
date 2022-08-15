import 'package:auth_ui/class/themebutton.dart';
import 'package:flutter/material.dart';
import './authentification_screen.dart';
import 'auth_200.dart';

class GradientText extends StatelessWidget {
  const GradientText(
      this.text, {
        required this.gradient,
        this.style,
      });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

class WelcomeScreen extends StatelessWidget {

  static const routeName = '/welcome-screen';

  Widget authentificationButton(Color buttonColor, String title, Color textColor, BuildContext ctx) {
    return Container(
      height: 80,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 25, left: 24, right: 24),
      child: RaisedButton(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        color: buttonColor,
        onPressed: () {
         /* Navigator.push(ctx, MaterialPageRoute(
              builder: (context) => /*ListScreen()*/AfterAuthScreen(true)));*/
         Navigator.push(
              ctx,
              MaterialPageRoute(
                  builder: (context) => AuthentificationScreen()));
          /*Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
            return AuthentificationScreen();
          }));*/
        },
        child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textColor,),),
      ),
    );
  }

 /* Widget regButton(Color buttonColor, String title, Color textColor, BuildContext ctx) {
    return Container(
      height: 80,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 25, left: 24, right: 24),
      child: RaisedButton(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        color: buttonColor,
        onPressed: () {
          Navigator.push(
              ctx,
              MaterialPageRoute(
                  builder: (context) => /*ListScreen()*/RegScreen()));
          /*Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
            return AuthentificationScreen();
          }));*/
        },
        child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textColor,),),
      ),
    );
  }*/


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white/*const Color.fromRGBO(124, 58, 237, 0.8)*/,
      body: Stack(
        children: [
         /* Positioned.fill(
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                 'images/welcome.jpg',
                  fit: BoxFit.cover),
            ),
          ),*/
         /* Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    const Color.fromRGBO(124, 58, 237, 0.9),
                    const Color.fromRGBO(130, 100, 237, 0.8),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth,
                          // height: screenHeight/3,
                          child: Image.asset(
                            'images/billi.jpg',
                            width: screenWidth,
                            height: screenHeight/2,
                            /*fit: BoxFit.contain*/),),

                        //Text('Lorem ipsum dolor sit amet', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.white),),
                      ],
                    ),
                  ),),

                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Добро пожаловать!',
                          style: TextStyle(fontSize: screenWidth/13, fontWeight: FontWeight.bold, color: AppColors.MAIN_COLOR), textAlign: TextAlign.center,),
                        SizedBox(height: 10,),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            // style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(text: 'Трастпэй - биллинговая система, которая призвана упростить контроль над ',
                                style: TextStyle(fontSize: screenWidth/18, color: AppColors.MAIN_COLOR), ),
                              TextSpan(text: 'любым ',style: TextStyle(fontSize: screenWidth/18, color: AppColors.MAIN_COLOR,
                                  fontWeight: FontWeight.bold)),
                              TextSpan(text: 'бизнесом.',
                                style: TextStyle(fontSize: screenWidth/18, color: AppColors.MAIN_COLOR), ),
                            ],
                          ),
                        )
                        /*Text('Билли - биллинговая система, которая призвана упростить контроль над \n любым бизнесом.',
                        style: TextStyle(fontSize: screenWidth/18, color: AppColors.MAIN_COLOR), textAlign: TextAlign.center,
                      ),*/
                        //Text('Lorem ipsum dolor sit amet', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.white),),
                      ],
                    ),
                  ),),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0, left: 10, right: 10
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ThemeButton(
                            label: "Авторизоваться",
                            labelColor: AppColors.MAIN_COLOR,
                            color: Colors.transparent,
                            highlight: AppColors.MAIN_COLOR.withOpacity(0.5),
                            borderColor: AppColors.MAIN_COLOR,
                            borderWidth: 4,
                            onClick: ()  {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AuthentificationScreen()));
                            }
                        )
                        //authentificationButton(Color.fromRGBO(144,144,144, 1), 'Авторизоваться', Color.fromRGBO(124, 58, 237, 1), context),
                        //regButton(Colors.white, 'Sign Up', Colors.lightBlue, context),
                      ],
                    ),),

                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}