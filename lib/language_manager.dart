import 'package:flutter/material.dart';

class LanguageManager extends ChangeNotifier {
  static final LanguageManager _instance = LanguageManager._internal();
  factory LanguageManager() => _instance;
  LanguageManager._internal();

  String _currentLanguage = 'ar'; // Default to Arabic
  final Map<String, Map<String, String>> _translations = {
    'ar': {
      // Common
      'ok': 'حسناً',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'send': 'إرسال',
      'welcome': 'مرحبا بك',
      'login': 'تسجيل الدخول',
      'signup': 'انشاء حساب',
      'forgotPassword': 'نسيت كلمة المرور؟',
      'newUser': 'مستخدم جديد؟',
      'createAccount': 'انشاء حساب',
      'happyToHaveYou': 'سعداء بانضمامك',
      'home': 'الصفحة الرئيسية',
      'personalInfo': 'المعلومات الشخصية',
      'name': 'الاسم',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirmPassword': 'تأكيد كلمة المرور',
      'age': 'العمر',
      'height': 'الطول',
      'weight': 'الوزن',
      'enterEmail': 'ادخل بريدك الإلكتروني',
      'sleepSchedule': 'منظم النوم',
      'sleepTime': 'موعد نومك',
      'wakeUpTime': 'موعد استيقاظك',
      'scheduleNotifications': 'جدولة الاشعارات',
      'sleepReminder': 'منبه النوم',
      'sleepReminderBody': 'حان وقت النوم يا بطل!',
      'wakeUpReminder': 'منبه الاستيقاظ',
      'wakeUpReminderBody': 'صباح الخير يا نشيط!',
      'physicalActivity': 'النشاط الحركي',

      'neckRotations': 'تدوير الرقبة: 10 مرات في كل اتجاه',
      'chinTucks': 'ثني الذقن: استمر لمدة 5 ثوانٍ، 10 مرات',
      'sideNeckStretches': 'تمديدات الرقبة الجانبية: ابقى على كل جانب لمدة 15 ثانية',

      'leftArmCircles': 'حركات دائرية بالذراع الأيسر: 10 تكرارات في كل اتجاه',
      'leftShoulderRolls': 'لف الكتف الأيسر: 10 تكرارات للأمام والخلف',
      'leftArmStretch': 'تمديد الذراع اليسرى عبر الجسم: استمر لمدة 15 ثانية',

      'rightArmCircles': 'حركات دائرية بالذراع اليمنى: 10 تكرارات في كل اتجاه',
      'rightShoulderRolls':
          'لف الكتف الأيمن: 10 تكرارات للأمام والخلف',
      'rightArmStretch': 'تمديد الذراع اليمنى عبر الجسم: استمر لمدة 15 ثانية',

      'chestStretch': 'تمديد الصدر عند المدخل: استمر لمدة 15 ثانية',
      'pushups': 'تمرين الضغط: 3 مجموعات من 10 مرات',
      'pecStretch': 'تمديد عضلات الصدر: استمر على كل جانب لمدة 15 ثانية',

      'pelvicTilts': 'إمالة الحوض: 10 مرات',
      'forwardBend': 'الانحناء للأمام أثناء الجلوس: استمر لمدة 15 ثانية',
      'deepBreathing': 'تمارين التنفس العميق: 5 دقائق',

      'squats': 'القرفصاء: 3 مجموعات من 10 مرات',
      'hamstringStretch': 'تمديد أوتار الركبة: استمر لمدة 15 ثانية لكل ساق',
      'calfRaises': 'رفع الساق: 3 مجموعات من 15 مرة',

      'supportCommunity': 'مجتمع الدعم',
      'whatDoYouThink': 'بم تفكر؟',
      'deletePost': 'حذف المنشور',
      'areYouSureYouWantToDelete': 'هل انت متأكد من حذف المنشور؟',
      'noData': 'لا يوجد بيانات',
      'comingSoon': 'قادم قريبا',
      'foodAssistant': 'مساعد الغذاء',
      'usernameExists': 'اسم المستخدم مستعمل بالفعل',
      'emailExists': 'البريد مستعمل بالفعل',
      'fillAllFields': 'يجب ملء جميع الحقول',
      'passwordsNotMatch': 'كلمة المرور وتأكيد كلمة المرور لا يتطابقان',
      'passwordRequirements':
          'كلمة المرور يجب ان تكون 8 أحرف على الأقل وتحتوي على احرف وارقام',
      'invalidEmail': 'البريد الإلكتروني غير صحيح',
      'accountCreated': 'تم انشاء الحساب بنجاح',
      'loginSuccess': 'تم تسجيل الدخول بنجاح',
      'loginFailed': 'البريد الإلكتروني او كلمة المرور غير صحيحة',
      'errorOccurred': 'حدث خطأ اثناء التسجيل يرجى المحاولة مرة أخرى',
      'passwordResetSent':
          'تم ارسال رابط تحديث كلمة المرور الى بريدك الإلكتروني',
      'tryAgain': 'حدث خطأ، الرجاء المحاولة مرة أخرى',

      // Body parts
      'head': 'الرأس',
      'leftArm': 'الذراع الأيسر',
      'rightArm': 'الذراع الأيمن',
      'chest': 'الصدر',
      'abdomen': 'البطن',
      'legs': 'الأرجل',
      'exercisesFor': 'تمارين {bodyPart}',
    },
    'en': {
      // Common
      'ok': 'OK',
      'cancel': 'Cancel',
      'delete': 'delete',
      'send': 'Send',
      'welcome': 'Welcome',
      'login': 'Login',
      'signup': 'Sign Up',
      'forgotPassword': 'Forgot Password?',
      'newUser': 'New User?',
      'createAccount': 'Create Account',
      'happyToHaveYou': 'We Are Happy to Have You',
      'home': 'Home page',
      'personalInfo': 'Personal Information',
      'name': 'Name',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'age': 'Age',
      'height': 'Height',
      'weight': 'Weight',
      'enterEmail': 'enter your email',
      'sleepSchedule': 'Sleep Schedule',
      'sleepTime': 'Sleep Time',
      'wakeUpTime': 'Wake Up Time',
      'scheduleNotifications': 'Schedule Notifications',
      'sleepReminder': 'Sleep Reminder',
      'sleepReminderBody': 'Time to sleep, champion!',
      'wakeUpReminder': 'Wake Up Reminder',
      'wakeUpReminderBody': 'Good morning, active one!',
      'physicalActivity': 'Physical Activity',

      'neckRotations': 'Neck rotations: 10 reps each direction',
      'chinTucks': 'Chin tucks: Hold for 5 seconds, 10 reps',
      'sideNeckStretches': 'Side neck stretches: Hold each side for 15 seconds',

      'leftArmCircles': 'Left arm circles: 10 reps each direction',
      'leftShoulderRolls': 'Left shoulder rolls: 10 reps forward and backward',
      'leftArmStretch': 'Left cross-body arm stretch: Hold for 15 seconds',

      'rightArmCircles': 'Right arm circles: 10 reps each direction',
      'rightShoulderRolls':
          'Right shoulder rolls: 10 reps forward and backward',
      'rightArmStretch': 'Right cross-body arm stretch: Hold for 15 seconds',

      'chestStretch': 'Doorway chest stretch: Hold for 15 seconds',
      'pushups': 'Push-ups: 3 sets of 10 reps',
      'pecStretch': 'Pec stretch: Hold each side for 15 seconds',

      'pelvicTilts': 'Pelvic tilts: 10 reps',
      'forwardBend': 'Seated forward bend: Hold for 15 seconds',
      'deepBreathing': 'Deep breathing exercises: 5 minutes',

      'squats': 'Squats: 3 sets of 10 reps',
      'hamstringStretch': 'Hamstring stretch: Hold for 15 seconds each leg',
      'calfRaises': 'Calf raises: 3 sets of 15 reps',

      'supportCommunity': 'Supp Community',
      'whatDoYouThink': 'What do you think?',
      'deletePost': 'delete post',
      'areYouSureYouWantToDelete': 'are you sure you want to delete post?',
      'noData': 'No data available',
      'comingSoon': 'Coming soon',
      'foodAssistant': 'Food Assistant',
      'usernameExists': 'Username already exists',
      'emailExists': 'Email already exists',
      'fillAllFields': 'Please fill all fields',
      'passwordsNotMatch': 'Password and confirm password do not match',
      'passwordRequirements':
          'Password must be at least 8 characters with letters and numbers',
      'invalidEmail': 'Invalid email format',
      'accountCreated': 'Account created successfully',
      'loginSuccess': 'Login successful',
      'loginFailed': 'Incorrect email or password',
      'errorOccurred': 'An error occurred, please try again',
      'passwordResetSent': 'Password reset link sent to your email',
      'tryAgain': 'An error occurred, please try again',

      // Body parts
      'head': 'Head',
      'leftArm': 'Left Arm',
      'rightArm': 'Right Arm',
      'chest': 'Chest',
      'abdomen': 'Abdomen',
      'legs': 'Legs',
      'exercisesFor': 'Exercises for {bodyPart}',
    },
  };

  String get currentLanguage => _currentLanguage;

  void setLanguage(String lang) {
    _currentLanguage = lang;
  }

  String translate(String key, {Map<String, String>? params}) {
    String translation = _translations[_currentLanguage]?[key] ?? key;

    if (params != null) {
      params.forEach((paramKey, paramValue) {
        translation = translation.replaceAll('{$paramKey}', paramValue);
      });
    }

    return translation;
  }
}

final languageManager = LanguageManager();
