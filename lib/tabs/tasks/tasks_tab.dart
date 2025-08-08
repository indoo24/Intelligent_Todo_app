import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:todo_app/tabs/tasks/task_item.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';

import '../../app_theme.dart';
import '../../auth/user_provider.dart';
import '../settings/settings_provider.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  // --- START: The fixed logic ---
  @override
  void initState() {
    super.initState();
    // This ensures that the code runs after the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get the user ID and fetch the initial list of tasks
      final userId =
          Provider.of<UserProvider>(context, listen: false).currentUser!.id;
      Provider.of<TasksProvider>(context, listen: false)
          .getTasksForSelectedDate(userId);
    });
  }

  // --- END: The fixed logic ---

  @override
  Widget build(BuildContext context) {
    // This line now listens for changes from the provider
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    SettingsProvider settingsProvider = Provider.of(context);

    // We removed the 'shouldGetTasks' logic from here

    final priorityOrder = {
      'High': 0,
      'Medium': 1,
      'Low': 2,
      'Uncategorized': 3
    };
    final sortedTasks = [...tasksProvider.tasks]..sort((a, b) {
        final aPriority = priorityOrder[a.priority] ?? 99;
        final bPriority = priorityOrder[b.priority] ?? 99;
        int priorityComparison = aPriority.compareTo(bPriority);
        if (priorityComparison == 0) {
          return a.date.compareTo(b.date);
        }
        return priorityComparison;
      });

    return Column(children: [
      Stack(
        children: [
          Container(
            color: AppTheme.primary,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.06,
          ),
          EasyInfiniteDateTimeLine(
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            focusDate: tasksProvider.selectedDate,
            lastDate: DateTime.now().add(const Duration(days: 365)),
            showTimelineHeader: false,
            onDateChange: (selectedDate) {
              // When date changes, we fetch tasks for the new date
              tasksProvider.changeSelectedDate(selectedDate);
              final userId = Provider.of<UserProvider>(context, listen: false)
                  .currentUser!
                  .id;
              tasksProvider.getTasksForSelectedDate(userId);
            },
            dayProps: EasyDayProps(
              height: 90,
              width: 60,
              activeDayStyle: DayStyle(
                decoration: BoxDecoration(
                  color:
                      settingsProvider.isDark ? AppTheme.black : AppTheme.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                dayStrStyle: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                dayNumStyle: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              inactiveDayStyle: DayStyle(
                decoration: BoxDecoration(
                  color:
                      settingsProvider.isDark ? AppTheme.black : AppTheme.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                dayStrStyle: TextStyle(
                  color:
                      settingsProvider.isDark ? AppTheme.white : AppTheme.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                dayNumStyle: TextStyle(
                  color:
                      settingsProvider.isDark ? AppTheme.white : AppTheme.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              todayStyle: DayStyle(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:
                      settingsProvider.isDark ? AppTheme.black : AppTheme.white,
                ),
              ),
            ),
          ),
        ],
      ),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 20),
          itemCount: sortedTasks.length,
          itemBuilder: (_, index) => TaskItem(sortedTasks[index]),
        ),
      ),
    ]);
  }
}
