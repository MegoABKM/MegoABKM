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
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        obscureText: obscureText == null || obscureText == false ? false : true,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        validator: validator,
        controller: mycontroller,
        decoration: InputDecoration(
            hintStyle: const TextStyle(fontSize: 12),
            hintText: texthint,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            suffixIcon: InkWell(
              onTap: onTapIcon,
              child: Icon(iconData),
            ),
            label: Container(
                margin: const EdgeInsets.symmetric(horizontal: 7),
                child: Text(label)),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
      ),
    );
  }
}
