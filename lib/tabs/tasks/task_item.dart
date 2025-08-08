import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';
import '../../app_theme.dart';
import '../../auth/user_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/task_model.dart';
import '../settings/settings_provider.dart';
import 'edit_task_screen.dart';
import 'firebase_functions.dart';

class TaskItem extends StatefulWidget {
  const TaskItem(this.task, {super.key});

  final TaskModel task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  Color getPriorityColor(String? priority) {
    switch (priority) {
      case 'High':
      case 'Urgent':
        return Colors.redAccent;
      case 'Medium':
      case 'Important':
        return Colors.orangeAccent;
      case 'Low':
      case 'Normal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);
    final priorityColor = getPriorityColor(widget.task.priority);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Slidable(
        key: ValueKey(widget.task.id),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _deleteTask(context),
              backgroundColor: AppTheme.red,
              foregroundColor: AppTheme.white,
              icon: Icons.delete,
              label: AppLocalizations.of(context)!.delte,
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(EditTaskScreen.routename, arguments: widget.task);
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: settingsProvider.isDark
                  ? AppTheme.backGroundDark
                  : AppTheme.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: priorityColor, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  height: 80,
                  width: 4,
                  color: priorityColor,
                  margin: const EdgeInsetsDirectional.only(end: 12),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: priorityColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.task.description,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 16, color: theme.primaryColor),
                          const SizedBox(width: 4),
                          // --- Display Time ---
                          Text(
                            DateFormat.jm().format(widget.task.date),
                            // Using intl package for time formatting
                            style: theme.textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      if (widget.task.priority != null &&
                          widget.task.priority != "Uncategorized")
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Priority: ${widget.task.priority}",
                            style: TextStyle(
                              fontSize: 12,
                              color: priorityColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => _changeStatusTask(context),
                  child: widget.task.isDone
                      ? Text(
                          AppLocalizations.of(context)!.isDone,
                          style: const TextStyle(
                            color: AppTheme.green,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: AppTheme.white,
                            size: 32,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteTask(BuildContext context) {
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;
    FirebaseFunctions.deleteTaskFromFirestore(widget.task.id, userId).then((_) {
      Provider.of<TasksProvider>(context, listen: false)
          .getTasksForSelectedDate(userId);
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.taskdeleted);
    }).catchError((_) {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.somethingError);
    });
  }

  Future<void> _changeStatusTask(BuildContext context) async {
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;
    widget.task.isDone = !widget.task.isDone;
    await FirebaseFunctions.editTaskToFireStore(widget.task, userId);
    // No need to call getTasks here, as the UI will update through setState in the parent if needed.
    // Or if you want a full refresh:
    // Provider.of<TasksProvider>(context, listen: false).getTasks(userId);
    setState(() {});
  }
}
