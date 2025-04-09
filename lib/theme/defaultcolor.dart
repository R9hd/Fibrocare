import 'package:flutter/material.dart' hide DatePickerTheme;

// the palette doesn't work for some reason check it latter if there is time 
// and change the theme in main Don't forget

ThemeData lightmode = ThemeData(
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    primary: Color(0xFF22455A), // dark blue
    secondary: Color(0xFF27B28B), // green
    tertiary: Color(0xFF5ABCC1), // light blue
    inversePrimary: Color.fromRGBO(0, 0, 0, 1),
  ),
);