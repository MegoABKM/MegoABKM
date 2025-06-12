import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  final String textbutton;
  final void Function()? onPressed;

  const CustomButtonAuth({
    super.key,
    required this.textbutton,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 13),
        color: theme.colorScheme.primary, // Dynamically set button color
        onPressed: onPressed,
        child: Text(
          textbutton,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary, // Use color for text contrast
            fontWeight: FontWeight.bold, // Ensure readability
          ),
        ),
      ),
    );
  }
}
