import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SidebarExpandableMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isExpanded;
  final bool isActive;
  final List<Widget> children;
  final VoidCallback onTap;

  const SidebarExpandableMenu({
    Key? key,
    required this.icon,
    required this.title,
    required this.isExpanded,
    required this.isActive,
    required this.children,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color deepPink = const Color.fromARGB(255, 255, 0, 85);
    final Color lightPink = const Color(0xFFFCE4EC);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isExpanded ? lightPink.withOpacity(0.3) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isActive ? deepPink.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: isActive ? deepPink : Colors.grey, size: 20),
              ),
              title: Text(
                title,
                style: GoogleFonts.poppins(
                  color: isActive ? deepPink : Colors.grey,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              trailing: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: isActive ? deepPink : Colors.grey,
              ),
              onTap: onTap,
              dense: true,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: SizedBox.shrink(),
          secondChild: Container(
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 220),
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );
  }
} 