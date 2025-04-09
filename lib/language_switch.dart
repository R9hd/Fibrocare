import 'package:fibercare/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_manager.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageNotifier>(
      builder: (context, languageNotifier, child) {
        return DropdownButton<String>(
          value: languageNotifier.currentLanguage,
          items: [
            DropdownMenuItem(
              value: 'ar',
              child: Text(languageManager.translate('arabic')),
            ),
            DropdownMenuItem(
              value: 'en',
              child: Text(languageManager.translate('english')),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              languageNotifier.setLanguage(value);
            }
          },
        );
      },
    );
  }
}