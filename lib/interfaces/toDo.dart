import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myschedule/components/textfield.dart';
import 'package:myschedule/utils/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:uuid/uuid.dart";
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class toDoPage extends StatefulWidget {
  const toDoPage({super.key});

  @override
  State<toDoPage> createState() => _toDoPageState();
}

class _toDoPageState extends State<toDoPage> {
  //Initializing the list of to-do items from the shared_preferences
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> _setItems(String key, List<String> OtherItems) async {
    final SharedPreferences prefs = await _prefs;
    prefs
        .setStringList(
          key,
          OtherItems,
        )
        .then((value) => print(OtherItems[2]));
  }

//Functions for using shared preferences
  Future<void> _getItems(String key) async {
    final SharedPreferences prefs = await _prefs;
    prefs.getStringList(key);
  }

  Future<void> _removeItem(String key) async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove(key);
  }

  Future<void> _removeAllItems() async {
    final SharedPreferences prefs = await _prefs;
    prefs.clear();
  }

  Future<void> _getAllItems() async {
    final SharedPreferences prefs = await _prefs;
    //Gets all the keys from the shared preferences
    //and then adds them to the list of to-do items
    //which is then displayed on the screen
    prefs.getKeys().forEach((key) {
      print(prefs.getStringList(key)![3]);
      List<String> temp = prefs.getStringList(key)!;
      if (temp.length >= 4) {
        ToDoItem newItem = ToDoItem(
            toDoText: temp[1],
            isChecked: convertToBoolean(temp[2]),
            ID: key,
            date: DateTime.parse(temp[3]));

        // ToDoItem newItem = ToDoItem(
        //   toDoText: prefs.getStringList(key)![1],
        //   isChecked: convertToBoolean(prefs.getStringList(key)![2]),
        //   ID: key,
        //   // date: DateTime.now(),
        //   date: DateTime.parse(prefs.getStringList(key)![3]),
        // );
        toDoWork.add(newItem);
        print(newItem.isChecked);
        setState(() {});
      } else {
        // Handle the case when the list or its elements are not available
        print('Invalid or incomplete list');
      }
    });
  }

  //Till here

  //ToDoItem class is at bottom
  List<ToDoItem> toDoWork = [];
  final TextEditingController _textEditingController = TextEditingController();

  //Initializing date Time selector
  DateTime _selectedDate = DateTime.now();

  Future<void> setRemainder(ToDoItem item) async {
    //Balla Talla kam garne vako cha koi chune haina yo code lai
    //AM/PM setter
    String m;
    if (item.date.hour < 12) {
      m = 'AM';
    } else {
      m = 'PM';
    }
    print(item.date);
    print(DateTime.now());
    Duration difference = item.date.difference(DateTime.now());
    int differenceInSeconds = difference.inSeconds;
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kathmandu'));

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestPermission();
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
      item.ID.hashCode,
      '${item.toDoText} is due today',
      '${item.date.hour >= 12 || item.date.hour == 0 ? (item.date.hour - 12).abs() : item.date.hour}:${item.date.minute} $m',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: differenceInSeconds)),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name',
              channelDescription: 'your channel description',
              sound: RawResourceAndroidNotificationSound('tune'))),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> deleteNotification(int notificationId) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  @override
  void initState() {
    super.initState();

    _getAllItems();
    weekDay(DateTime.now());
    month(DateTime.now());
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  weekDay(DateTime dateTime) {
    var weekDayName;
    int day = dateTime.weekday;
    if (day == 1) {
      weekDayName = 'Monday';
    } else if (day == 2) {
      weekDayName = 'Tuesday';
    } else if (day == 3) {
      weekDayName = 'Wednesday';
    } else if (day == 4) {
      weekDayName = 'Thursday';
    } else if (day == 5) {
      weekDayName = 'Friday';
    } else if (day == 6) {
      weekDayName = 'Saturday';
    } else if (day == 7) {
      weekDayName = 'Sunday';
    }
    return weekDayName;
  }

  month(DateTime dateTime) {
    String monthName = '';
    int monthNum = dateTime.month;

    if (monthNum == 1) {
      monthName = 'January';
    } else if (monthNum == 2) {
      monthName = 'February';
    } else if (monthNum == 3) {
      monthName = 'March';
    } else if (monthNum == 4) {
      monthName = 'April';
    } else if (monthNum == 5) {
      monthName = 'May';
    } else if (monthNum == 6) {
      monthName = 'June';
    } else if (monthNum == 7) {
      monthName = 'July';
    } else if (monthNum == 8) {
      monthName = 'August';
    } else if (monthNum == 9) {
      monthName = 'September';
    } else if (monthNum == 10) {
      monthName = 'October';
    } else if (monthNum == 11) {
      monthName = 'November';
    } else if (monthNum == 12) {
      monthName = 'December';
    }
    return monthName;
  }

//Initialing a unique key to assign each to-do item
  var uuid = const Uuid();
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        toolbarHeight: 60,
        title: Row(
          children: [
            Column(
              children: [
                const Text(
                  "Today",
                  style: TextStyle(
                      fontFamily: 'mainFont',
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "${weekDay(DateTime.now())} ,${DateTime.now().day} ${month(DateTime.now())} ",
                  style: const TextStyle(
                      fontFamily: 'mainFont',
                      color: Colors.white,
                      fontSize: 16),
                )
              ],
            ),
            const Spacer(),
            IconButton(
                onPressed: addToDo,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ))
          ],
        ),
      ),
      body: Container(
          color: Colors.deepPurple,
          child: SingleChildScrollView(
            child: SizedBox(
              height: h,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    //listview builder for todo list
                    Expanded(
                        child: ListView.builder(
                            itemCount: toDoWork.length,
                            itemBuilder: ((context, index) {
                              int reversedIndex = toDoWork.length - 1 - index;
                              //function to edit the list
                              void editToDo() {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String editedToDo = '';
                                    return AlertDialog(
                                      title: const Text('Edit ToDo'),
                                      content: TextField(
                                        onChanged: (value) {
                                          editedToDo = value;
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Edit Here',
                                            suffixIcon: SuffixIconButton1(
                                                icon: Image.asset(
                                                    "assets/images/calendar (2).png"),
                                                onTap: () {
                                                  dateTimePicker();
                                                })),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            if (editedToDo.isNotEmpty) {
                                              //get the key of required todo
                                              String delKey =
                                                  toDoWork[reversedIndex].ID;
                                              // removing the value at index from list
                                              toDoWork.removeAt(reversedIndex);

                                              //removing the value from shared preferences and notification
                                              deleteNotification(
                                                  delKey.hashCode);
                                              _removeItem(delKey);

                                              if (_selectedDate
                                                      .difference(
                                                          DateTime.now())
                                                      .inSeconds <
                                                  0) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Please select a valid date'),
                                                  ),
                                                );
                                                return;
                                              }
                                              //then inserting the new value at the same index
                                              String id = uuid.v1();
                                              toDoWork.insert(
                                                reversedIndex,
                                                ToDoItem(
                                                  toDoText: editedToDo,
                                                  isChecked: false,
                                                  ID: id,
                                                  date: _selectedDate,
                                                ),
                                              );
                                              ToDoItem newTodo = ToDoItem(
                                                  toDoText: editedToDo,
                                                  isChecked: false,
                                                  ID: id,
                                                  date: _selectedDate);
                                              _setItems(id, [
                                                newTodo.ID,
                                                newTodo.toDoText,
                                                newTodo.isChecked.toString(),
                                                newTodo.date.toString(),
                                              ]);
                                              //setting the notification
                                              setRemainder(newTodo);
                                              setState(() {});
                                              print(toDoWork);
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            }
                                          },
                                          child: const Text('Edit'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }

                              //AM/PM setter
                              String m;
                              if (toDoWork[reversedIndex].date.hour < 12) {
                                m = 'AM';
                              } else {
                                m = 'PM';
                              }
                              return Container(
                                margin: const EdgeInsets.only(bottom: 7),
                                child: Opacity(
                                  opacity: toDoWork[reversedIndex].isChecked
                                      ? 0.5
                                      : 1.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color: const Color.fromARGB(
                                        155,
                                        236,
                                        182,
                                        246,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        print(reversedIndex);
                                        print(
                                            "${toDoWork[reversedIndex].ID.hashCode}");
                                        NotificationService().showNotification(
                                          id: index,
                                          title: 'To-Do Task',
                                          body:
                                              '${toDoWork[reversedIndex].toDoText} is due today',
                                          payLoad: index.toString(),
                                        );
                                      },
                                      leading: Checkbox(
                                        activeColor: Colors.deepPurple,
                                        value:
                                            toDoWork[reversedIndex].isChecked,
                                        onChanged: (bool? value) {
                                          bool update = !toDoWork[reversedIndex]
                                              .isChecked;

                                          if (update == true) {
                                            // Checkbox is checked, cancel the notification
                                            deleteNotification(
                                                toDoWork[reversedIndex]
                                                    .ID
                                                    .hashCode);
                                          } else {
                                            // Checkbox is unchecked, schedule the notification
                                            setRemainder(
                                                toDoWork[reversedIndex]);
                                          }
                                          _setItems(
                                              toDoWork[reversedIndex].ID, [
                                            toDoWork[reversedIndex].ID,
                                            toDoWork[reversedIndex].toDoText,
                                            update.toString(),
                                            toDoWork[reversedIndex]
                                                .date
                                                .toString(),
                                          ]);
                                          setState(() {
                                            toDoWork[reversedIndex].isChecked =
                                                !toDoWork[reversedIndex]
                                                    .isChecked;
                                          });
                                        },
                                      ),
                                      title: Text(
                                        toDoWork[reversedIndex].toDoText,
                                        style: const TextStyle(
                                          fontFamily: 'mainFont',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${toDoWork[reversedIndex].date.hour >= 12 || toDoWork[reversedIndex].date.hour == 0 ? (toDoWork[reversedIndex].date.hour - 12).abs() : toDoWork[reversedIndex].date.hour}:${toDoWork[reversedIndex].date.minute} $m,  ${toDoWork[reversedIndex].date.day} ${month(toDoWork[reversedIndex].date).toString().substring(0, 3)} ${toDoWork[reversedIndex].date.year}',
                                        style: const TextStyle(
                                          fontFamily: 'mainFont',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: SizedBox(
                                        height: 50,
                                        width: 100,
                                        child: Row(
                                          children: [
                                            IconButton(
                                                onPressed: editToDo,
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.deepPurple,
                                                )),
                                            IconButton(
                                                onPressed: () {
                                                  if (toDoWork.isNotEmpty) {
                                                    deleteNotification(
                                                        toDoWork[reversedIndex]
                                                            .ID
                                                            .hashCode);
                                                    _removeItem(
                                                        toDoWork[reversedIndex]
                                                            .ID);
                                                    setState(() {
                                                      toDoWork.removeAt(
                                                          reversedIndex);
                                                    });
                                                  } else {
                                                    print(
                                                        'The list is already empty.');
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.deepPurple,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })))
                  ],
                ),
              ),
            ),
          )),
    );
  }

  dateTimePicker() async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      isForce2Digits: true,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );
    setState(() {
      print(dateTime);
      _selectedDate = dateTime ?? DateTime.now();
    });
  }

//function to add new list
  void addToDo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String editedToDo = '';
        return AlertDialog(
          title: const Text('Add ToDo'),
          content: TextField(
            onChanged: (value) {
              editedToDo = value;
            },
            decoration: InputDecoration(
                labelText: 'Add Here',
                suffixIcon: SuffixIconButton1(
                    icon: Image.asset("assets/images/calendar (2).png"),
                    onTap: () {
                      dateTimePicker();
                    })),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String id = uuid.v1();
                if (_selectedDate.difference(DateTime.now()).inSeconds < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a valid date'),
                    ),
                  );
                  return;
                }
                if (editedToDo.isNotEmpty) {
                  //TODO date are now set to current date
                  //change them later on
                  toDoWork.add(
                    ToDoItem(
                      toDoText: editedToDo,
                      isChecked: false,
                      ID: id,
                      date: _selectedDate,
                    ),
                  );

                  ToDoItem newTodo = ToDoItem(
                    toDoText: editedToDo,
                    isChecked: false,
                    ID: id,
                    date: _selectedDate,
                  );

                  _setItems(id, [
                    newTodo.ID,
                    newTodo.toDoText,
                    newTodo.isChecked.toString(),
                    newTodo.date.toString(),
                  ]);
                  setRemainder(newTodo);
                  setState(() {});
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  convertToBoolean(param0) {
    if (param0 == 'true') {
      return true;
    } else {
      return false;
    }
  }
}

//isChecked variable should be stored separatly for each item in toDoWork list,
// So ToDoItem class has been created
//
class ToDoItem {
  String toDoText;
  bool isChecked;
  String ID;
  DateTime date;
  ToDoItem(
      {required this.toDoText,
      required this.isChecked,
      required this.ID,
      required this.date});
}
