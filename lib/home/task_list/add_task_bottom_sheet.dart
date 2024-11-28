import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/home/firebase_utils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/list_provider.dart';
import 'package:todo_app/provider/user_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();
  String title = '';
  String desc = '';
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    return Container(
        margin: EdgeInsets.all(15),
        color: AppColors.whiteColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Add new task',
                  style: Theme.of(context).textTheme.bodyMedium),
              Form(
                  key: formKey,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        onChanged: (text) {
                          title = text;
                        },
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please enter task title';
                          }
                          return null;
                        },
                        decoration:
                            InputDecoration(hintText: 'Enter task title'),
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        onChanged: (text) {
                          desc = text;
                        },
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please enter task des';
                          }
                          return null;
                        },
                        decoration:
                            InputDecoration(hintText: 'Enter task description'),
                        maxLines: 4,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Select Date',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 25)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        onPressed: () {
                          showCalender();
                        },
                        child: Text(
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 20, fontWeight: FontWeight.w400)),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        addTask();
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.check,
                        size: 30,
                      ),
                    ),
                  ]))
            ],
          ),
        ));
  }

  void showCalender() async {
    var chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    selectedDate = chosenDate ?? selectedDate;
    setState(() {});
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      /// add task
      Task task = Task(
        title: title,
        dateTime: selectedDate,
        desc: desc,
      );
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      FirebaseUtils.addTaskToFireStore(task, userProvider.currentUser!.id!)
          .then((value) {
        print('Task added successfully');
        listProvider.getAllTasksFromFireStore(userProvider.currentUser!.id!);
        Navigator.pop(context);
      }).timeout(Duration(seconds: 1), onTimeout: () {
        print('Task added successfully');
        listProvider.getAllTasksFromFireStore(userProvider.currentUser!.id!);
        Navigator.pop(context);
      });
    }
  }
}
