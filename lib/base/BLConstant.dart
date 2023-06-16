import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

enum REPORT_TYPE {
  Others, //其他
  Bing_Li, //病历
  Hua_Yan_Dan, //化验单
  Cai_Chao_Dan, //彩超报告单

}

class BLConstant {
  static Color primaryColor = Color(0xff67E9FF);

  static Color foodItemBgColor = Color(0xffFFFBBD);

  static Color waterBorderColor = Color(0xff71474C);

  static Color bingliThemeColor = Color(0xff7191E4);
  static Color shujuBGColor = Color(0xffDAF6DF);
  static Color shujuTextColor = Color(0xff3F80C8);
  static Color shujuTootipBgColor = Color(0xffFFD559);
  static Color shujuChartAreaBgColor = Color(0x19FFF3D1);

  static LinearGradient chartLinearGradient = new LinearGradient(
      colors: [
        Color(0xfffce29c),
        Color(0x0cFFF3D1),
      ],
      stops: [
        0.0,
        1.0
      ],
      begin: FractionalOffset.topCenter,
      end: FractionalOffset.bottomCenter,
      tileMode: TileMode.repeated);

  static Color FoodTextColor = Color(0xffD1801E);
  static Color bingliTitleColor = Color(0xff7191E4);

  static Color addRecordBorderColor = Color(0xff1B1464);

  static Color duanshiBGColor = Color(0xffFFEA9E);

  static Color bingliBGColor = Color(0xffE2EAFD);

  static Color weight_bgcolor = Color(0xFFc5effd);
  static Color calory_bgcolor = Color(0xFFc6eee6);
  static Color binlgi_bgcolor = Color(0x5fdde2e2);
  static Color addrecord_bgcolor = Color(0xffA7ECD5);
  static Color water_bgcolor = Color(0xffDAEF9B);
  static Color water_textcolor = Color(0xff00B26E);
  // Material Design Color
  static Color lightPrimary = Color(0xfffcfcff);
  static Color lightAccent = Color(0xff4adede);
  static Color lightBackground = Color(0xfffcfcff);

  static Color darkPrimary = Colors.black;
  static Color darkAccent = Color(0xFF3B72FF);
  static Color darkBackground = Colors.black;

  static Color grey = Color(0xff707070);

  static Color greyTableLine = Color(0xffe6ebed);
  static Color textPrimary = Color(0xFF486581);
  static Color textDark = Color(0xFF102A43);

  static Color backgroundColor = Color(0xFFF5F5F7);

  // Green
  static Color darkGreen = Color(0xFF3ABD6F);
  static Color lightGreen = Color(0xFFA1ECBF);

  // Yellow
  static Color darkYellow = Color(0xFF3ABD6F);
  static Color lightYellow = Color(0xFFFFDA7A);

  // Blue
  static Color darkBlue = Color(0xFF3B72FF);
  static Color lightBlue = Color(0xFF3EC6FF);

  // Orange
  static Color darkOrange = Color(0xFFFFB74D);

  static ThemeData lighTheme(BuildContext context) {
    return ThemeData(
      backgroundColor: lightBackground,
      primaryColor: lightPrimary,
      accentColor: lightAccent,
      // cursorColor: lightAccent,
      scaffoldBackgroundColor: lightBackground,

      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: lightAccent,
        ),
      ),
    );
  }

  static double headerHeight = 228.5;
  static double paddingSide = 15.0;
  static var currentPeople = {};
  static var chartColors = [
    Colors.blue,
    const Color.fromARGB(255, 188, 143, 143),
    const Color.fromARGB(255, 131, 111, 255),
    const Color.fromRGBO(75, 135, 185, 1),
    const Color.fromRGBO(192, 108, 132, 1),
    const Color.fromRGBO(246, 114, 128, 1),
    const Color.fromRGBO(248, 177, 149, 1),
    const Color.fromRGBO(116, 180, 155, 1),
    const Color.fromRGBO(0, 168, 181, 1),
    const Color.fromRGBO(73, 76, 162, 1),
    const Color.fromRGBO(255, 205, 96, 1),
    const Color.fromRGBO(255, 240, 219, 1),
    const Color.fromRGBO(238, 238, 238, 1)
  ];

  static String MdateStr = "";

  static var todayHomeList0Calorie = 0.0;
  static var todayHomeList1Calorie = 0.0;
  static var todayHomeList2Calorie = 0.0;
  static var todayHomeList3Calorie = 0.0;

  static var eatfoods;

  static var appName;

  static var local;
  static var packageName;
  static var version = "";
  static var buildNumber;

  static bool Logined = false;

  static var platform = "ios";

  static MacOsDeviceInfo? macOsDeviceInfo;
  static IosDeviceInfo? iosDeviceInfo;
  static AndroidDeviceInfo? androidDeviceInfo;

  static var totalCal = 1749;

  static var nickname = "";

  static var userdata;

  static num userWeight = 0;

  static var pickedBottle;

  static bool isVip = false;
  static var huiyuan;

  static bool privacy_agreed = false;

  static GlobalKey<NavigatorState> globalKey = new GlobalKey<NavigatorState>();

  static var deviceToken = "";

  static var brand = "";

  static var screenWidth = 0.0;
  static var screenHeight = 0.0;

  static var DefaultWaterTarget = 2000;

  // static bool isIPad = false;

  static String showWeightUnit = "kg";

  static List<Color> weekRecipesColors = [
    Color(0xffFFFBBD),
    Color(0xffCFEFFF),
    Color(0xffFFFBBD),
    Color(0xffCFEFFF),
    Color(0xffFFFBBD),
    Color(0xffCFEFFF),
    Color(0xffFFFBBD)
  ];

  static List<Color> weekRecipesColors2 = [
    Color(0xffFFF435),
    Color(0xff00B4E9),
    Color(0xffFFF435),
    Color(0xff00B4E9),
    Color(0xffFFF435),
    Color(0xff00B4E9),
    Color(0xffFFF435)
  ];
}
