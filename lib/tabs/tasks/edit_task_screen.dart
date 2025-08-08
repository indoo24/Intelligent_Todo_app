import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:todo_app/tabs/tasks/tasks_provider.dart';

import '../../app_theme.dart';
import '../../auth/user_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/task_model.dart';
import '../settings/settings_provider.dart';
import 'default_elevated_button.dart';
import 'default_text_form_field.dart';
import 'firebase_functions.dart';

class EditTaskScreen extends StatefulWidget {
  static const String routename = '/editTAskScreen';

  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  // State variables
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  String? selectedPriority;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Task object and initialization flag
  TaskModel? task;
  bool isInitialized = false;

  // List of priority options
  final List<String> priorityOptions = const [
    'High',
    'Medium',
    'Low',
    'Uncategorized'
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      task = ModalRoute.of(context)!.settings.arguments as TaskModel;
      titleController.text = task!.title;
      descriptionController.text = task!.description;
      selectedDate = task!.date;
      selectedTime = TimeOfDay.fromDateTime(task!.date);

      // Safely initialize priority
      if (priorityOptions.contains(task!.priority)) {
        selectedPriority = task!.priority;
      } else {
        selectedPriority = 'Uncategorized';
      }
      isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
    SettingsProvider settingsProvider = Provider.of(context);

    return Scaffold(
      backgroundColor: settingsProvider.isDark
          ? AppTheme.backGroundDark
          : AppTheme.backGroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        centerTitle: true,
        iconTheme: IconThemeData(
            color: settingsProvider.isDark ? AppTheme.black : AppTheme.white),
        title: Text(
          AppLocalizations.of(context)!.editTask,
          style: titleMediumStyle?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: settingsProvider.isDark ? AppTheme.black : AppTheme.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: settingsProvider.isDark
                ? AppTheme.backGroundDark
                : AppTheme.white,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DefaultTextFormField(
                  controller: titleController,
                  hintText: AppLocalizations.of(context)!.taskTitle,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return AppLocalizations.of(context)!.titleval;
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DefaultTextFormField(
                  controller: descriptionController,
                  hintText: AppLocalizations.of(context)!.taskDescription,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return AppLocalizations.of(context)!.descriptionval;
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    labelStyle: titleMediumStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.primary)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.primary)),
                  ),
                  items: priorityOptions.map((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedPriority = newValue;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(AppLocalizations.of(context)!.date,
                            style: titleMediumStyle),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _selectDate,
                          child: Text(
                              DateFormat('dd/MM/yyyy').format(selectedDate),
                              style: titleMediumStyle?.copyWith(
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Time", style: titleMediumStyle),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _selectTime,
                          child: Text(selectedTime.format(context),
                              style: titleMediumStyle?.copyWith(
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                DefaultElevatedButton(
                  label: AppLocalizations.of(context)!.saveChanges,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      editTask();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: selectedDate,
    );
    if (dateTime != null) {
      setState(() => selectedDate = dateTime);
    }
  }

  void _selectTime() async {
    TimeOfDay? timeOfDay =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (timeOfDay != null) {
      setState(() => selectedTime = timeOfDay);
    }
  }

  Future<void> editTask() async {
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;

    task!.title = titleController.text;
    task!.description = descriptionController.text;
    task!.date = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    task!.priority = selectedPriority;

    try {
      await FirebaseFunctions.editTaskToFireStore(task!, userId);

      // Update provider state BEFORE popping the screen
      Provider.of<TasksProvider>(context, listen: false)
          .getTasksForSelectedDate(userId);

      if (mounted) {
        Navigator.of(context).pop();
      }

      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.taskEdited,
        backgroundColor: AppTheme.green,
        textColor: Colors.white,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.somethingError,
        backgroundColor: AppTheme.red,
        textColor: Colors.white,
      );
    }
  }
}
