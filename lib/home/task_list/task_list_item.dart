import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../app_colors.dart';
import '../../firebase_utils.dart';
import '../../model/task.dart';
import '../../provider/list_provider.dart';
import '../../provider/user_provider.dart';

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
        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          extentRatio: 0.25,
          // A motion is a widget used to control how the pane animates.
          motion: const DrawerMotion(),
          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              onPressed: (context) {
                /// delete task
                FirebaseUtils.deleteTaskFromFireStore(
                        task, userProvider.currentUser!.id!)
                    .then((value) {
                  print('task delete successfully');
                  listProvider
                      .getAllTasksFromFireStore(userProvider.currentUser!.id!);
                }).timeout(
                        Duration(
                          seconds: 1,
                        ), onTimeout: () {
                  print('task delete successfully');
                  listProvider
                      .getAllTasksFromFireStore(userProvider.currentUser!.id!);
                });
              },
              backgroundColor: AppColors.redColor,
              foregroundColor: AppColors.whiteColor,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          // margin: EdgeInsets.all(12),
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
                height: MediaQuery.of(context).size.height * 0.1,
                width: 3,
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: AppColors.primaryColor),
                  ),
                  Text(
                    task.description,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              )),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                  ),
                  onPressed: () {},
                  child: Icon(
                    Icons.check,
                    size: 30,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
