import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';
import 'package:task_manager2/provider/dartThemePorvider.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> with SingleTickerProviderStateMixin {
  String themes = "";
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Setting"),
        ),
        body: ListView(children: [
          Card(
              child: ListTile(
                  title: Text('Theme'),
                  subtitle: Text("Mode Sombre"),
                  onTap: () => buildShowGeneralDialog(context, themeChange))),
        ]));
  }

  Future<Object?> buildShowGeneralDialog(
      BuildContext context, DarkThemeProvider themeChange) {
    int themeselected;
    if (themeChange.darkTheme == true) {
      themes = "Dark Theme";
      themeselected = 1;
    } else {
      themes = "Light Theme";
      themeselected = 0;
    }
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final themeactu =
              Provider.of<DarkThemeProvider>(context, listen: false);
          return FractionalTranslation(
            translation: Offset(0, 1 - a1.value),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                  title: Text("Select a theme"),
                  content: GroupButton(
                    spacing: 5,
                    isRadio: true,
                    direction: Axis.horizontal,
                    onSelected: (index, isSelected) {
                      final themeactu = Provider.of<DarkThemeProvider>(context,
                          listen: false);
                      setState(() {
                        if (index == 0) {
                          themeactu.setdarkTheme = false;
                        } else {
                          themeactu.setdarkTheme = true;
                        }
                      });
                      Navigator.of(context).pop();
                    },
                    buttons: [
                      "Light Theme",
                      "Dark Theme",
                    ],
                    selectedButton: themeselected,
                    selectedTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                    unselectedTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    selectedColor: Colors.white,
                    unselectedColor: Colors.grey[300],
                    selectedBorderColor: Colors.red,
                    unselectedBorderColor: Colors.grey[500],
                    borderRadius: BorderRadius.circular(5.0),
                    selectedShadow: <BoxShadow>[
                      BoxShadow(color: Colors.transparent)
                    ],
                    unselectedShadow: <BoxShadow>[
                      BoxShadow(color: Colors.transparent)
                    ],
                  )),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Transform.rotate(angle: animation1.value);
        });
  }
}
