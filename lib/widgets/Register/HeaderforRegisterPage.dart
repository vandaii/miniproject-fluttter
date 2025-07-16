import 'package:flutter/material.dart';

// Widget untuk Logo dan Header
class HeaderWithLogo extends StatelessWidget {
  final double logoSize;
  final double fontSize;
  final double subtitleSize;

  const HeaderWithLogo({
    Key? key,
    required this.logoSize,
    required this.fontSize,
    required this.subtitleSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/icons-haus.png', height: logoSize),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            text: 'HAUS ',
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: 'Inventory',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255,255,0,85),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Create a new Haus Inventory account',
          style: TextStyle(fontSize: subtitleSize, color: Colors.grey),
        ),
      ],
    );
  }
}


class FooterImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        'assets/images/icons-logoDekoration.png',
        fit: BoxFit.cover,
        height: 140,
      ),
    );
  }
}
