import 'package:flutter/material.dart';
import 'package:myschedule/components/utils.dart';

import '../components/textfield.dart';

class toDoPage extends StatefulWidget {
  const toDoPage({super.key});

  @override
  State<toDoPage> createState() => _toDoPageState();
}

class _toDoPageState extends State<toDoPage> {
  //ToDoItem class is at bottom
  List<ToDoItem> toDoWork = [];
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    print(day);
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

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(children: [
          Container(
            height: h,
            color: Colors.deepPurple,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Today",
                            style: TextStyle(
                                fontFamily: 'mainFont',
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "$weekDayName ,${DateTime.now().day} $monthName ",
                            style: TextStyle(
                                fontFamily: 'mainFont',
                                color: Colors.white,
                                fontSize: 16),
                          )
                        ],
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: calenderPicker,
                          icon: Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: addToDo,
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  SizedBox(height: 20),
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
                                    title: Text('Edit ToDo'),
                                    content: TextField(
                                      onChanged: (value) {
                                        editedToDo = value;
                                      },
                                      decoration: InputDecoration(
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
                                            toDoWork.insert(
                                                index,
                                                ToDoItem(
                                                    toDoText: editedToDo,
                                                    isChecked: false));
                                            print(toDoWork);
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          }
                                        },
                                        child: Text('Add'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: Text('Cancel'),
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
                                  color: Color.fromARGB(
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
                                    style: TextStyle(
                                      fontFamily: 'mainFont',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text('Wednesday, 9 AM'),
                                  trailing: Container(
                                    height: 50,
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: editToDo,
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.deepPurple,
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                toDoWork.removeAt(index);
                                              });
                                            },
                                            icon: Icon(
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
        ]),
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
          title: Text('Add ToDo'),
          content: TextField(
            onChanged: (value) {
              editedToDo = value;
            },
            decoration: InputDecoration(
              labelText: 'Add Here',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (editedToDo.isNotEmpty) {
                  toDoWork
                      .add(ToDoItem(toDoText: editedToDo, isChecked: false));

                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

//isChecked variable should be stored separatly for each item in toDoWork list,
// So ToDoItem class has been created
//
class ToDoItem {
  String toDoText;
  bool isChecked;

  ToDoItem({required this.toDoText, required this.isChecked});
}
