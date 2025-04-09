import 'package:flutter/material.dart' hide DatePickerTheme;

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {

    Color primaryColor = Theme.of(context).colorScheme.primary; // dark grey
    Color secondary = Theme.of(context).colorScheme.secondary; // light gray
    Color tertiary = Theme.of(context).colorScheme.tertiary; // white
    Color inversePrimary = Theme.of(context).colorScheme.inversePrimary; // black

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
            enabledBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: tertiary),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20.0),
                )),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: secondary, fontWeight: FontWeight.bold,)),
      ),
    );
  }
}
