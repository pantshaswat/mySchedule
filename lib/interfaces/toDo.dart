import 'package:flutter/material.dart';
import 'package:myschedule/components/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:uuid/uuid.dart";

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
        .then((value) => print(value));
  }

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
    prefs.getKeys().forEach((key) {
      print(prefs.getStringList(key)![0]);
      ToDoItem newItem = ToDoItem(
          toDoText: prefs.getStringList(key)![1],
          isChecked: convertToBoolean(prefs.getStringList(key)![2]),
          ID: key);
      toDoWork.add(newItem);
      setState(() {});
    });
  }

  //ToDoItem class is at bottom
  List<ToDoItem> toDoWork = [];
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAllItems();
    weekDay();
    month();
    weekDay();
    month();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  var weekDayName;
  void weekDay() {
    int day = DateTime.now().weekday;
    if (day == 1) {
      weekDayName = 'Monday';
    }
    if (day == 2) {
      weekDayName = 'Tuesday';
    }
    if (day == 3) {
      weekDayName = 'Wednesday';
    }
    if (day == 4) {
      weekDayName = 'Thursday';
    }
    if (day == 5) {
      weekDayName = 'Friday';
    }
    if (day == 6) {
      weekDayName = 'Saturday';
    }
    if (day == 7) {
      weekDayName = 'Sunday';
    }
  }

  var monthName;
  void month() {
    int monthNum = DateTime.now().month;

    if (monthNum == 1) {
      monthName = 'January';
    }
    if (monthNum == 2) {
      monthName = 'February';
    }
    if (monthNum == 3) {
      monthName = 'March';
    }
    if (monthNum == 4) {
      monthName = 'April';
    }
    if (monthNum == 5) {
      monthName = 'May';
    }
    if (monthNum == 6) {
      monthName = 'June';
    }
    if (monthNum == 7) {
      monthName = 'July';
    }
    if (monthNum == 8) {
      monthName = 'August';
    }
    if (monthNum == 9) {
      monthName = 'September';
    }
    if (monthNum == 10) {
      monthName = 'October';
    }
    if (monthNum == 11) {
      monthName = 'November';
    }
    if (monthNum == 12) {
      monthName = 'December';
    }
  }

//Initialing a unique key to assign each to-do item
  var uuid = Uuid();
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
                  "$weekDayName ,${DateTime.now().day} $monthName ",
                  style: const TextStyle(
                      fontFamily: 'mainFont',
                      color: Colors.white,
                      fontSize: 16),
                )
              ],
            ),
            const Spacer(),
            IconButton(
                onPressed: calenderPicker,
                icon: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                )),
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
                                        decoration: const InputDecoration(
                                          labelText: 'Edit Here',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            if (editedToDo.isNotEmpty) {
                                              //first removing the value at index
                                              toDoWork.removeAt(index);
                                              //then inserting the new value at the same index
                                              String id = uuid.v1();
                                              ToDoItem newTodo = ToDoItem(
                                                  toDoText: editedToDo,
                                                  isChecked: false,
                                                  ID: id);
                                              _setItems(id, [
                                                newTodo.ID,
                                                newTodo.toDoText,
                                                newTodo.isChecked.toString()
                                              ]);
                                              toDoWork.insert(
                                                index,
                                                ToDoItem(
                                                  toDoText: editedToDo,
                                                  isChecked: false,
                                                  ID: id,
                                                ),
                                              );
                                              print(toDoWork);
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            }
                                          },
                                          child: const Text('Add'),
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

                              return Opacity(
                                opacity: toDoWork[index].isChecked ? 0.5 : 1.0,
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
                                    leading: Checkbox(
                                      activeColor: Colors.deepPurple,
                                      value: toDoWork[index].isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          toDoWork[index].isChecked =
                                              value ?? false;
                                        });
                                      },
                                    ),
                                    title: Text(
                                      toDoWork[index].toDoText,
                                      style: const TextStyle(
                                        fontFamily: 'mainFont',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: const Text('Wednesday, 9 AM'),
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
                                                setState(() {
                                                  toDoWork.removeAt(index);
                                                });
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
                              );
                            })))
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void calenderPicker() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DatePickerDialog(
            initialDate: DateTime.now(),
            firstDate: kFirstDay,
            lastDate: kLastDay,
          );
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
            decoration: const InputDecoration(
              labelText: 'Add Here',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String id = uuid.v1();
                if (editedToDo.isNotEmpty) {
                  toDoWork.add(
                      ToDoItem(toDoText: editedToDo, isChecked: false, ID: id));
                  ToDoItem newTodo =
                      ToDoItem(toDoText: editedToDo, isChecked: false, ID: id);
                  _setItems(id, [
                    newTodo.ID,
                    newTodo.toDoText,
                    newTodo.isChecked.toString()
                  ]);
                  setState(() {});
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
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
  ToDoItem({required this.toDoText, required this.isChecked, required this.ID});
}
