import 'package:flutter/material.dart';

// Widget untuk Logo dan Header
class HeaderWithLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/icons-haus.png', height: 80),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            text: 'HAUS ',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: 'Inventory',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Create a new account Haus Inventory',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}

// Widget untuk form input seperti TextField
Widget buildTextField({
  required String label,
  required IconData icon,
  required TextEditingController controller,
  bool obscureText = false,
  Widget? suffixIcon,
  TextInputType keyboardType = TextInputType.text,
  Color iconColor = Colors.pink,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          prefixIconColor: iconColor,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: const Color.fromARGB(0, 95, 69, 132),
          hintText: 'Enter $label',
        ),
      ),
    ],
  );
}

class FooterImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Image.asset(
          'assets/images/icons-logoDekoration.png',
          fit: BoxFit.cover,
          height: 140,
        ),
      ),
    );
  }
}
