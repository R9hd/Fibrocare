import 'package:flutter/material.dart' hide DatePickerTheme;

class SquareTile extends StatelessWidget {
  final Icon icon;
  const SquareTile({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary; // dark grey
    Color secondary = Theme.of(context).colorScheme.secondary; // light gray
    Color tertiary = Theme.of(context).colorScheme.tertiary; // white
    Color inversePrimary = Theme.of(context).colorScheme.inversePrimary; // black
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: icon
    );
  }
}

