import 'package:flutter/material.dart';


class AppColors {
  static const Color MAIN_COLOR = Colors.black;
  static const Color MEATS = Color(0xFFC02828);
  static const Color FRUITS = Color(0xFFC028BA);
  static const Color VEGS = Color(0xFF28C080);
  static const Color SEEDS = Color(0xFFC05D28);
  static const Color PASTRIES = Color(0xFF5D28C0);
  static const Color SPICES = Color(0xFF1BB1DE);

  // other colors
  static const Color DARK_GREEN = Color(0xFF1B6948);
  static const Color DARKER_GREEN = Color(0xFF0B452C);
  static const Color HIGHTLIGHT_DEFAULT = Color(0xFF5A8E12);
  static const Color LIGHTER_GREEN = Color(0xFFC1E09E);
}


class ThemeButton extends StatelessWidget {

  String? label;
  Function onClick;
  Color color;
  Color? highlight;
  Widget? icon;
  Color borderColor;
  Color labelColor;
  double borderWidth;

  ThemeButton({
    this.label,
    this.labelColor = Colors.white,
    this.color = AppColors.MAIN_COLOR,
    this.highlight = AppColors.HIGHTLIGHT_DEFAULT,
    this.icon,
    this.borderColor = Colors.transparent,
    this.borderWidth = 4,
    required this.onClick });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Material(
            color: this.color,
            child: InkWell(
              splashColor: this.highlight,
              highlightColor: this.highlight,
              onTap: () {
                this.onClick();
              },
              child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: this.borderColor,
                          width: this.borderWidth)
                  ),
                  child: this.icon == null ?
                  Text(this.label!,
                      style: TextStyle(
                          fontSize: 16,
                          color: this.labelColor,
                          fontWeight: FontWeight.bold)) :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      this.icon!,
                      SizedBox(width: 10),
                      Text(this.label!,
                          style: TextStyle(
                              fontSize: 16,
                              color: this.labelColor,
                              fontWeight: FontWeight.bold)),
                    ],
                  )
              ),
            ),
          )),
    );
  }
}