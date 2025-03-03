import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase_utils.dart';
import '../../model/task.dart';
import '../../provider/list_provider.dart';
import '../../provider/user_provider.dart';
import '../../style/app_colors.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    return Container(
      margin: EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              ' Add new Task',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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

                          /// valid
                        },
                        decoration:
                            InputDecoration(hintText: 'Enter task title'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        onChanged: (text) {
                          description = text;
                        },
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please enter task description';
                          }
                          return null;
                        },
                        decoration:
                            InputDecoration(hintText: 'Enter task Description'),
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Select Date',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              AppColors.backgroundLightColor),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                        ),
                        onPressed: () {
                          showCalendar();
                        },
                        child: Text(
                          '${selectedDate.day}/${selectedDate.month}'
                          '/${selectedDate.year}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                AppColors.primaryColor)),
                        onPressed: () {
                          addTask();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Add',
                          style: Theme.of(context).textTheme.titleLarge,
                        ))
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void showCalendar() async {
    var chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (chosenDate != null) {
      selectedDate = chosenDate;
      setState(() {});
    }
    // selectedDate = chosenDate ?? selectedDate ;
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      /// add task
      Task task = Task(
        title: title,
        description: description,
        dateTime: selectedDate,
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
