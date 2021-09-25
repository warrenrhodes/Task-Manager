import 'package:flutter/material.dart';

// class Themedata{
//   static Themedata value = Themedata();
//   ThemeData darkTheme = ThemeData.dark().copyWith(
//     primaryTextTheme: TextTheme(title: TextStyle(color: Colors.white70, )),
//     floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Color.fromRGBO(0, 183, 183, 10), elevation: 15.0,),
//       primaryColor: Color(0xff1f655d),
//       accentColor: Color.fromRGBO(0, 25, 25, 10),
//       appBarTheme: AppBarTheme(backgroundColor: Color.fromRGBO(0, 65, 65, 10), titleTextStyle: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
//       centerTitle: true));
//   ThemeData lightTheme = ThemeData.light().copyWith(
//       primaryColor: Color(0xfff5f5f5),
//       accentColor: Color(0xff40bf7a),
//       floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.green[600], elevation: 15.0,),
//       primaryTextTheme: TextTheme(title: TextStyle(color: Colors.black54), ),
//       textTheme: TextTheme(
//           title: TextStyle(color: Colors.black54),
//           subtitle: TextStyle(color: Colors.grey),
//           subhead: TextStyle(color: Colors.white)),
//       appBarTheme: AppBarTheme(backgroundColor: Colors.teal,centerTitle: true , titleTextStyle: TextStyle(color: Colors.white30, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
//           actionsIconTheme: IconThemeData(color: Colors.white70, size: 20))
//   );
// }

// class Styles {
//   static ThemeData themeData(bool isDarkTheme, BuildContext context) {
//     return ThemeData(
//         snackBarTheme: isDarkTheme
//             ? SnackBarThemeData(
//                 backgroundColor: Color.fromRGBO(80, 100, 100, 1))
//             : SnackBarThemeData(backgroundColor: Colors.grey),
//         primaryTextTheme: TextTheme(headline1: TextStyle(color: Colors.white)),
//         primarySwatch: isDarkTheme ? Colors.blue : Colors.purple,
//         primaryColor: isDarkTheme ? Color(0xff1f655d) : Colors.green,
//         backgroundColor:
//             isDarkTheme ? Color.fromRGBO(0, 25, 25, 10) : Color(0xffF1F5FB),
//         indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
//         buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
//         hintColor: isDarkTheme ? Colors.white70 : Colors.black54,
//         highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
//         hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
//         focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
//         disabledColor: Colors.grey,
//         cardColor: isDarkTheme ? HexColor("#212121") : Colors.white,
//         canvasColor: isDarkTheme ? Color.fromRGBO(0, 25, 25, 10) : Colors.white,
//         brightness: isDarkTheme ? Brightness.dark : Brightness.light,
//         buttonTheme: Theme.of(context).buttonTheme.copyWith(
//             colorScheme:
//                 isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
//         floatingActionButtonTheme: isDarkTheme
//             ? FloatingActionButtonThemeData(
//                 backgroundColor: Color.fromRGBO(0, 183, 183, 10),
//                 elevation: 15.0,
//               )
//             : FloatingActionButtonThemeData(
//                 backgroundColor: Colors.red,
//                 elevation: 15.0,
//               ),
//         appBarTheme: isDarkTheme
//             ? AppBarTheme(
//                 backgroundColor: Color.fromRGBO(0, 65, 65, 10),
//                 titleTextStyle: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     fontStyle: FontStyle.italic),
//                 centerTitle: true)
//             : AppBarTheme(
//                 backgroundColor: Colors.teal,
//                 titleTextStyle: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     fontStyle: FontStyle.italic),
//                 centerTitle: true));
//   }
// }
class Themes {
  static final light = ThemeData.light().copyWith(
    backgroundColor: Colors.white,
    buttonColor: Colors.blue,
  );
  static final dark = ThemeData.dark().copyWith(
    backgroundColor: Colors.black,
    buttonColor: Colors.red,
  );
}
