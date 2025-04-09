import 'package:fibercare/notification_service.dart';
import 'package:fibercare/theme/defaultcolor.dart';
import 'loginpage.dart';
import 'signuppage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:timezone/data/latest.dart' as tz;
import 'package:provider/provider.dart';
import 'language_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); 
  await NotificationService().initNotification();
  await Firebase.initializeApp();

  final languageNotifier = LanguageNotifier();
  await languageNotifier.loadLanguage();

  runApp(
    ChangeNotifierProvider.value(
      value: languageNotifier,
      child: const MyApp(),
    ),
  );
}

class LanguageNotifier with ChangeNotifier {
  String _currentLanguage = 'ar';

  String get currentLanguage => _currentLanguage;

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('language') ?? 'ar';
    languageManager.setLanguage(_currentLanguage);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _currentLanguage = lang;
    languageManager.setLanguage(lang);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageNotifier>(
      builder: (context, languageNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Builder(
            builder: (context) {
              return Directionality(
                textDirection: languageNotifier.currentLanguage == 'ar' 
                    ? TextDirection.rtl 
                    : TextDirection.ltr,
                child: const Loginpage(),
              );
            },
          ),
          theme: lightmode,
          routes: {
            'signup': (context) => const Signuppage(),
          },
        );
      },
    );
  }
}