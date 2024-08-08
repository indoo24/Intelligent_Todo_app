import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/home/task_list/task_list_item.dart';
import 'package:todo_app/provider/list_provider.dart';

class TaskListTab extends StatefulWidget {
  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);

    ListProvider.getAllTasksFromFireStore();

    return Column(children: [
      EasyDateTimeLine(
        initialDate: DateTime.now(),
        onDateChange: (selectedDate) {
          //`selectedDate` the new date selected.
        },
        headerProps: const EasyHeaderProps(
          monthPickerType: MonthPickerType.switcher,
        ),
        dayProps: const EasyDayProps(
          dayStructure: DayStructure.dayStrDayNumMonth,
          activeDayStyle: DayStyle(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff3371FF),
                  Color(0xff8426D6),
                ],
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Expanded(
        child: ListView.builder(
          itemBuilder: (contest, index) {
            return TaskListItem(
              task: ListProvider.tasksList[index],
            );
          },
          itemCount: ListProvider.tasksList.length,
        ),
      )
    ]);
  }
}
