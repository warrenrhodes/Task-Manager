import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_manager2/controller/Controller.dart';
import 'package:task_manager2/manageTask/taskForm.dart';
import 'package:task_manager2/model/todo_Task.dart';
import 'package:task_manager2/provider/dartThemePorvider.dart';

Map repeats = {};
Map dateAndtime = {};

class AddTodoTimeAndDateDialogueWidget extends StatefulWidget {
  TodoTask? oldtasks;
  AddTodoTimeAndDateDialogueWidget({this.oldtasks});
  @override
  _AddTodoTimeAndDateDialogueWidgetState createState() =>
      _AddTodoTimeAndDateDialogueWidgetState();
}

class _AddTodoTimeAndDateDialogueWidgetState
    extends State<AddTodoTimeAndDateDialogueWidget> {
  Controller controller = Get.find<Controller>();

  ///date and time value
  DateTime dates = DateTime.now();
  TimeOfDay times = TimeOfDay.now();
  FocusNode focusNode = FocusNode();

  ///repeat value of date , time and another
  DateTime _repeatDate = DateTime.now();
  TimeOfDay _repeatTime = TimeOfDay.now();
  String _week = "Day";
  int _data = 1;
  String _rangeOfDayForMonth = "First";
  String _validWeekOfMonth =
  "${formatDate(DateTime.now(), ['DD'])}".toLowerCase();
  List<String> _validWeek = [];
  List<WeekAndMonth> _listWeek = [
    WeekAndMonth({'monday': 'M'}, false),
    WeekAndMonth({'tuesday': 'T'}, false),
    WeekAndMonth({'wednesday': 'W'}, false),
    WeekAndMonth({'thursday': 'T'}, false),
    WeekAndMonth({'friday': 'F'}, false),
    WeekAndMonth({'saturday': 'S'}, false),
    WeekAndMonth({'sunday': 'S'}, false)
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.oldtasks != null) {
      dates = widget.oldtasks!.date!;
      times = TaskForm.stringToTimeOfDay(widget.oldtasks!.time!);
      setState(() {
        repeats = {};
        dateAndtime = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(formatDate(
        DateTime(_repeatDate.year, _repeatDate.month, _repeatDate.day),
        ['DD']));
    List<String> months = [];
    for (var i = _repeatDate.month; i <= 12; i++) {
      months.add(
          formatDate(DateTime(_repeatDate.year, i, _repeatDate.day), ['MM']));
    }
    var choiseMonth = months.elementAt(0);
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    print("Tttttttttttttttttttttttttttttttttttttttt${controller.alert}");
    return AlertDialog(
      content: AnimatedContainer(
        duration: Duration(seconds: 1),
        child: controller.alert == 0
            ? Container(
          height: Get.height / 2 + 80,
          child: Column(
            children: [
              Expanded(
                child: CalendarCarousel(
                  onDayPressed: (DateTime datee, List<Event> events) {
                    setState(() => dates = datee);
                  },
                  selectedDateTime: dates,
                  todayButtonColor: dates == DateTime.now()
                      ? Colors.blue
                      : Colors.transparent,
                  todayTextStyle: TextStyle(
                      color: dates == DateTime.now()
                          ? Colors.white
                          : Colors.blue),
                  selectedDayTextStyle: TextStyle(color: Colors.white),
                  selectedDayButtonColor:
                  dates == DateTime.now() ? Colors.blue : Colors.red,
                  todayBorderColor: Colors.blue,
                  height: Get.height / 3 + 60,
                  width: Get.width + 20,
                  weekdayTextStyle: TextStyle(color: Colors.white60),
                  headerTextStyle: TextStyle(color: Colors.white),
                  weekendTextStyle: TextStyle(color: Colors.white70),
                  daysTextStyle: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                child: GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.timer_outlined),
                      SizedBox(
                        width: 7,
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          child: FormBuilderDateTimePicker(
                            name: "time",
                            alwaysUse24HourFormat: true,
                            autovalidateMode: AutovalidateMode.always,
                            format: DateFormat('h:mm a'),
                            inputType: InputType.time,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              contentPadding: EdgeInsets.only(
                                  left: 10,
                                  bottom: 9,
                                  top: 15,
                                  right: 10),
                              hintText: "Time",
                            ),
                            onChanged: (value) =>
                            times = TimeOfDay.fromDateTime(value!),
                            initialTime: TimeOfDay.now(),
                            initialValue: DateTime(
                                1, 1, 0, times.hour, times.minute),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: Row(
                  children: [
                    Icon(Icons.repeat),
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: InkWell(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Repeat",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              controller.setalert(1);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          repeats = {};
                        });
                        Get.back();
                      },
                      child: Text("Cancel",
                          style: TextStyle(
                              color: Colors.white70, fontSize: 15))),
                  TextButton(
                    child: Text("Enregistre",
                        style:
                        TextStyle(color: Colors.blue, fontSize: 15)),
                    onPressed: () {
                      dateAndtime["day"] = dates;
                      dateAndtime["time"] = times;
                      repeats = {};
                      Get.back();
                    },
                  ),
                ],
              ),
            ],
          ),
        )
            : Container(
          height: Get.height / 2 + 80,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('All the ')),
                  Expanded(
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.black38.withOpacity(0.2),
                      ),
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 30,
                                height: 30,
                                child: Text(
                                  '$_data',
                                )),
                            Column(
                              children: [
                                InkWell(
                                    child:
                                    Icon(Icons.arrow_drop_up_sharp),
                                    onTap: () {
                                      if (_data != 99) {
                                        setState(() {
                                          _data = _data + 1;
                                        });
                                      }
                                    }),
                                InkWell(
                                  child:
                                  Icon(Icons.arrow_drop_down_sharp),
                                  onTap: () {
                                    if (_data != 1) {
                                      setState(() {
                                        _data = _data - 1;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FormBuilderDropdown(
                        iconEnabledColor: Colors.white,
                        name: "selectedStyle",
                        items: ["Day", "Week", "Month", "Years"]
                            .map((value) =>
                            DropdownMenuItem(
                              value: value,
                              child: Text('$value'),
                            ))
                            .toList(),
                        initialValue: _week,
                        enabled: true,
                        onChanged: (value) =>
                            setState(() {
                              _week = value.toString();
                            })),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // build _weekcreateTime
              if (_week == 'Week')
                Wrap(
                  spacing: 2,
                  runSpacing: 2,
                  direction: Axis.horizontal,
                  children: _weekday(),
                ),
              //build  Month
              if (_week == "Month")
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: FormBuilderDropdown(
                        name: "selectedStyle",
                        items:
                        ["First", "Second", "Third", "Fourth", "Last"]
                            .map((value) =>
                            DropdownMenuItem(
                              value: value,
                              child: Text('$value'),
                            ))
                            .toList(),
                        initialValue: _rangeOfDayForMonth,
                        enabled: true,
                        onChanged: (value) =>
                            setState(() {
                              _rangeOfDayForMonth = value.toString();
                              print(_rangeOfDayForMonth);
                            }),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      flex: 1,
                      child: FormBuilderDropdown(
                        name: "selectedStyle",
                        items: [
                          "monday",
                          "tuesday",
                          "wednesday",
                          "thursday",
                          "friday",
                          "saturday",
                          "sunday"
                        ]
                            .map((value) =>
                            DropdownMenuItem(
                              value: value,
                              child: Text('$value'),
                            ))
                            .toList(),
                        enabled: true,
                        initialValue: _validWeekOfMonth,
                        onChanged: (value) =>
                            setState(() {
                              _validWeekOfMonth = value.toString();
                              print(_validWeekOfMonth);
                            }),
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Start On "),
                  SizedBox(height: 10),
                  (_week == "Week" || _week == "Years" || _week == "Day")
                      ? Expanded(
                    child: FormBuilderDateTimePicker(
                      transitionBuilder: (context, child) =>
                          Theme(
                            data: ThemeData(
                              primarySwatch: themeProvider.darkTheme
                                  ? Colors.blue
                                  : Colors.purple,
                              brightness: themeProvider.darkTheme
                                  ? Brightness.dark
                                  : Brightness.light,
                            ),
                            child: child!,
                          ),
                      enabled: true,
                      onChanged: (value) => _repeatDate = value!,
                      initialValue: _repeatDate,
                      name: '_weekday',
                      format: DateFormat("EE, d MMM yyyy"),
                      inputType: InputType.date,
                      decoration: InputDecoration(
                          hintText: 'Input Date',
                          filled: true,
                          fillColor:
                          Colors.black38.withOpacity(0.2),
                          contentPadding: EdgeInsets.only(
                              left: 10,
                              bottom: 9,
                              top: 9,
                              right: 10),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          border: InputBorder.none),
                    ),
                  )
                      : Expanded(
                    child: FormBuilderDropdown(
                      name: "months",
                      items: months
                          .map((value) =>
                          DropdownMenuItem(
                            value: value,
                            child:
                            Center(child: Text('$value')),
                          ))
                          .toList(),
                      initialValue: months.elementAt(0),
                      enabled: true,
                      onChanged: (value) =>
                          setState(() {
                            choiseMonth = value.toString();
                          }),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              FormBuilderDateTimePicker(
                transitionBuilder: (context, child) =>
                    Theme(
                      data: ThemeData(
                        primarySwatch: themeProvider.darkTheme
                            ? Colors.blue
                            : Colors.purple,
                        brightness: themeProvider.darkTheme
                            ? Brightness.dark
                            : Brightness.light,
                      ),
                      child: child!,
                    ),
                format: DateFormat('h:mm a'),
                enabled: true,
                name: "time",
                inputType: InputType.time,
                initialTime: TimeOfDay.now(),
                onChanged: (value) =>
                    setState(() {
                      _repeatTime = TimeOfDay.fromDateTime(value!);
                    }),
                initialValue: DateTime(
                    1, 1, 0, _repeatTime.hour, _repeatTime.minute),
                decoration: InputDecoration(
                    filled: true,
                    hintText: "Input Time",
                    fillColor: Colors.black38.withOpacity(0.2),
                    contentPadding: EdgeInsets.only(
                        left: 10, bottom: 9, top: 9, right: 10),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    border: InputBorder.none),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          setState(() {
                            repeats = {};
                          });
                          Get.back();
                          controller.setalert(0);
                        }),
                    TextButton(
                      child: Text("Finishe"),
                      onPressed: () {
                        var y = _listWeek
                            .where(
                                (element) => element.isSelected == true)
                            .toList();
                        for (int i = 0; i < y.length; i++) {
                          _validWeek.add(y[i]._week.keys.elementAt(0));
                        }
                        print(_validWeek);
                        if (_week == "Day") {
                          repeats["Day"] = [
                            _data,
                            _repeatDate,
                            TaskForm.formatTimeOfDay(_repeatTime)
                          ];
                        } else if (_week == "Week") {
                          repeats["Week"] = [
                            _data,
                            _validWeek,
                            _repeatDate,
                            TaskForm.formatTimeOfDay(_repeatTime)
                          ];
                        } else if (_week == "Month") {
                          repeats["Month"] = [
                            _data,
                            _rangeOfDayForMonth,
                            _validWeekOfMonth,
                            choiseMonth.length == 0
                                ? months.elementAt(0)
                                : choiseMonth,
                            TaskForm.formatTimeOfDay(_repeatTime)
                          ];
                        } else {
                          repeats["Year"] = [
                            _data,
                            _repeatDate,
                            TaskForm.formatTimeOfDay(_repeatTime)
                          ];
                        }
                        dateAndtime = {};
                        Get.back();
                        controller.setalert(0);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _weekday() {
    List<Widget> chips = [];
    for (int i = 0; i < _listWeek.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 2),
        child: FilterChip(
          showCheckmark: false,
          selectedColor: Colors.lightBlueAccent,
          label: Text(_listWeek[i]._week.values.elementAt(0)),
          labelStyle: TextStyle(color: Colors.white),
          selected: _listWeek[i].isSelected,
          onSelected: (bool value) {
            setState(() {
              _listWeek[i].isSelected = value;
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }
}
class WeekAndMonth {
  Map _week = {};
  bool isSelected;
  WeekAndMonth(this._week, this.isSelected);
}