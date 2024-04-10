import 'package:flutter/material.dart';
class Mytextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const Mytextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder:   OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),


        fillColor: Colors.white70,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
