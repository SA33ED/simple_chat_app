// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class LoginBtn extends StatelessWidget {
  LoginBtn({super.key, required this.text, required this.onTap});
  final String text;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          height: 50,
          child: Center(
              child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF2B475E),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
    );
  }
}
