import 'package:flutter/material.dart';

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
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
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
                            "Monday, 13 June",
                            style: TextStyle(
                                fontFamily: 'mainFont',
                                color: Colors.white,
                                fontSize: 16),
                          )
                        ],
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {},
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
