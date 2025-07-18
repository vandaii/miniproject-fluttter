import 'package:flutter/material.dart';

class HeaderForLogin extends StatelessWidget {
  final Color primaryColor = Color.fromARGB(255, 255, 0, 85);

  HeaderForLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/icons-haus.png', height: 100),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              text: 'HAUS',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text: ' Inventory',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'HAUS Inventory Management System',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
