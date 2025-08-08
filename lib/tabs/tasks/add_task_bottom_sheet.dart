import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:todo_app/tabs/tasks/tasks_provider.dart';

import '../../ai_service.dart';
import '../../app_theme.dart';
import '../../auth/user_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/task_model.dart';
import '../settings/settings_provider.dart';
import 'default_elevated_button.dart';
import 'default_text_form_field.dart';
import 'firebase_functions.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: settingsProvider.isDark
              ? AppTheme.backGroundDark
              : AppTheme.white,
          border: Border.all(
            width: 3,
            color: settingsProvider.isDark ? AppTheme.white : AppTheme.black,
          ),
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(22),
            topEnd: Radius.circular(22),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.addTask,
                  style: titleMediumStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                DefaultTextFormField(
                  controller: titleController,
                  hintText: AppLocalizations.of(context)!.taskTitle,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.titleval;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DefaultTextFormField(
                  controller: descriptionController,
                  hintText: AppLocalizations.of(context)!.taskDescription,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.descriptionval;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // --- Date Picker ---
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.date,
                          style: titleMediumStyle,
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: Text(
                            DateFormat('dd/MM/yyyy').format(selectedDate),
                            style: titleMediumStyle?.copyWith(
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    // --- Time Picker ---
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.time,
                          style: titleMediumStyle,
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectTime(context),
                          child: Text(
                            selectedTime.format(context),
                            style: titleMediumStyle?.copyWith(
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                DefaultElevatedButton(
                    label: AppLocalizations.of(context)!.submit,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        analyzeAndAddTasks();
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: selectedDate,
    );
    if (dateTime != null) {
      selectedDate = dateTime;
      setState(() {});
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (timeOfDay != null) {
      selectedTime = timeOfDay;
      setState(() {});
    }
  }

  void analyzeAndAddTasks() async {
    Navigator.of(context).pop();
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;
    String priority = 'Uncategorized';

    // Combine date and time
    final finalDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    try {
      final results = await AiService.classifyTasks([titleController.text]);
      if (results.isNotEmpty) {
        priority = results[0]['priority'] ?? 'Uncategorized';
      }
      if (!mounted) return;

      await FirebaseFunctions.addTaskToFirestore(
        TaskModel(
          title: titleController.text,
          description: descriptionController.text,
          date: finalDateTime, // Use the combined DateTime
          priority: priority,
        ),
        userId,
      );

      if (context.mounted) {
        Navigator.of(context).pop();
        Provider.of<TasksProvider>(context, listen: false)
            .getTasksForSelectedDate(userId);

        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.taskAdded,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppTheme.green,
          textColor: AppTheme.white,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'حدث خطأ أثناء التصنيف، سيتم الإضافة بدون تصنيف.',
        backgroundColor: Colors.orange,
      );

      // Add task without classification on error
      await FirebaseFunctions.addTaskToFirestore(
        TaskModel(
          title: titleController.text,
          description: descriptionController.text,
          date: finalDateTime,
          priority: 'Uncategorized',
        ),
        userId,
      );

      if (context.mounted) {
        Navigator.of(context).pop();
        Provider.of<TasksProvider>(context, listen: false)
            .getTasksForSelectedDate(userId);
      }
    }
  }
}

// Add this to your localization file `app_en.arb` and `app_ar.arb`
// "time": "Time",
