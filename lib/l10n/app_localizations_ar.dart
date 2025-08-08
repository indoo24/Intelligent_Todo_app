// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get todoList => 'قائمة المهام اليومية ';

  @override
  String get settings => 'الاعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get state => 'الوضع الداكن';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get addTask => 'أضف مهمة جديدة';

  @override
  String get taskTitle => 'عنوان المهمة';

  @override
  String get taskDescription => 'وصف المهمة';

  @override
  String get date => 'تحديد التاريخ';

  @override
  String get submit => 'حفظ';

  @override
  String get email => 'الايميل';

  @override
  String get password => 'الرقم السرى';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get dontHaveAccount => 'ليس لدى حساب !';

  @override
  String get name => 'الاسم';

  @override
  String get createAccount => 'انشاء حساب';

  @override
  String get alreadyHaveAccount => ' لدى حساب بالقعل ؟';

  @override
  String get delte => 'حذف';

  @override
  String get isDone => 'تمت';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get saveChanges => 'حفظ التغيرات';

  @override
  String get taskAdded => 'تمت اضافة المهمة بنجاح';

  @override
  String get taskdeleted => 'تمت حذف المهمة';

  @override
  String get taskEdited => 'تم تعديل المهمة';

  @override
  String get somethingError => 'هناك خطأ ما';

  @override
  String get emailval => 'لا يمكن تسجيل الايميل بأقل من 5 احرف';

  @override
  String get paswwordval => 'لا يمكن تسجيل الرقم السرى بأقل من 8 احرف';

  @override
  String get nameval => 'لا يمكن تسجيل الاسم بأقل من 3 احرف';

  @override
  String get titleval => 'لا يمكن ان يكون العنوان فارغ !';

  @override
  String get descriptionval => 'لا يمكن ان يكون الوصف فارغ !';

  @override
  String get time => 'الوقت';
}
