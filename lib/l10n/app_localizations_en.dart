// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get todoList => 'To Do List';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get state => 'Dark Mode';

  @override
  String get logout => 'Logout';

  @override
  String get addTask => 'Add New Task';

  @override
  String get taskTitle => 'Enter Task Title';

  @override
  String get taskDescription => 'Enter Task Description';

  @override
  String get date => 'Select Date';

  @override
  String get submit => 'Submit';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Log in';

  @override
  String get dontHaveAccount => 'Don\'t Have An Account !';

  @override
  String get name => 'Name';

  @override
  String get createAccount => 'Create Account';

  @override
  String get alreadyHaveAccount => 'Already Have An Account ?';

  @override
  String get delte => 'Delete';

  @override
  String get isDone => 'Done !';

  @override
  String get editTask => 'Edit Task';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get taskAdded => 'Task Added Successfully';

  @override
  String get taskdeleted => 'Task Deleted';

  @override
  String get taskEdited => 'Task Edited Successfully';

  @override
  String get somethingError => 'Something Went Wrong';

  @override
  String get emailval => 'Email Can Not Be Less than 5 Characters';

  @override
  String get paswwordval => 'Password Can Not Be Less than 8 Characters';

  @override
  String get nameval => 'Name Can Not Be Less than 3 Characters';

  @override
  String get titleval => 'Title Can Not Be Empty !';

  @override
  String get descriptionval => 'Description Can Not Be Empty !';

  @override
  String get time => 'Time';
}
