import 'package:flutter/material.dart' hide DatePickerTheme;

class MyButton extends StatelessWidget {
  final String buttonTitle; 
  final Function()? onTap;

  const MyButton({super.key, required this.buttonTitle, required this.onTap});

  @override
  Widget build(BuildContext context) {

    Color primaryColor = Theme.of(context).colorScheme.primary; // dark grey
    Color secondary = Theme.of(context).colorScheme.secondary; // light grey
    Color tertiary = Theme.of(context).colorScheme.tertiary; // white
    Color inversePrimary = Theme.of(context).colorScheme.inversePrimary; // black

     // To make the code fit for any screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.020, horizontal: screenWidth * 0.020,),
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
        decoration: BoxDecoration(
          color: const Color(0xFF22455A),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            buttonTitle, // Use the parameter here
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}