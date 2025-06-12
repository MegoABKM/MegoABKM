import 'package:flutter/material.dart';

class Customtextformauth extends StatelessWidget {
  final String texthint;
  final String label;
  final IconData iconData;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;
  final bool isNumber;
  final bool? obscureText;
  final void Function()? onTapIcon;

  const Customtextformauth({
    super.key,
    required this.texthint,
    required this.label,
    required this.iconData,
    required this.mycontroller,
    required this.validator,
    required this.isNumber,
    this.obscureText,
    this.onTapIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        obscureText: obscureText ?? false,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        validator: validator,
        controller: mycontroller,
        decoration: InputDecoration(
          hintStyle: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor, // Dynamically set hint text color
          ),
          hintText: texthint,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          suffixIcon: InkWell(
            onTap: onTapIcon,
            child: Icon(
              iconData,
              color: theme.iconTheme.color, // Dynamically set icon color
            ),
          ),
          label: Container(
            margin: const EdgeInsets.symmetric(horizontal: 7),
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ), // Dynamic label style
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: theme.dividerColor, // Dynamic border color
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: theme.colorScheme.primary, // Primary color on focus
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: theme.dividerColor, // Divider color when not focused
            ),
          ),
        ),
      ),
    );
  }
}
