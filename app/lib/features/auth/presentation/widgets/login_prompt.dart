import 'package:flutter/material.dart';

class LoginPrompt extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const LoginPrompt({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Text(text, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
