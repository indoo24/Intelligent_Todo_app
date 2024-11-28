import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/home/firebase_utils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/list_provider.dart';
import 'package:todo_app/provider/user_provider.dart';

class TaskListItem extends StatelessWidget {
  Task task;

  TaskListItem({required this.task});

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    return Container(
      margin: EdgeInsets.all(12),
      child: Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          extentRatio: 0.25,
          motion: DrawerMotion(),
          dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              backgroundColor: AppColors.redColor,
              foregroundColor: AppColors.whiteColor,
              icon: Icons.delete,
              label: 'Delete',
              onPressed: (context) {
                /// delete task
                FirebaseUtils.deleteTaskFromFireStore(
                        task, userProvider.currentUser!.id!)
                    .then((value) {
                  listProvider
                      .getAllTasksFromFireStore(userProvider.currentUser!.id!);
                }).timeout(
                        Duration(
                          seconds: 1,
                        ), onTimeout: () {
                  print('task delete successfully');
                });
              },
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(12),
                color: AppColors.primaryColor,
                height: MediaQuery.of(context).size.height * 0.0991,
                width: 3,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    task.title,
                    style:
                        TextStyle(color: AppColors.primaryColor, fontSize: 25),
                  ),
                  Text(
                    task.desc,
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(AppColors.primaryColor),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)))),
                onPressed: () {},
                child: Icon(
                  Icons.check,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteTask() {}
}
