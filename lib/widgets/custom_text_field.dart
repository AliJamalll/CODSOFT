import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
   CustomTextField({super.key, required this.hintText, required this.textInputType, this.onTap, required this.controller,  this.isPass = false});

  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
   final VoidCallback? onTap;
   final bool isPass;

   @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide:Divider.createBorderSide(context)
    );
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText,
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          filled: true,
          contentPadding: EdgeInsets.all(8)
      ),
      keyboardType: textInputType,
      onTap: onTap,
      obscureText: isPass,
    );
  }
}
