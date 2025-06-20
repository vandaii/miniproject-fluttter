import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onAdd;
  final VoidCallback? onClose;
  final String addLabel;
  final String closeLabel;
  final bool showAddButton;

  const ModernBottomSheet({
    Key? key,
    required this.title,
    required this.child,
    this.onAdd,
    this.onClose,
    this.addLabel = "Add",
    this.closeLabel = "Close",
    this.showAddButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deepPink = Color(0xFFE91E63);
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Center(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: child,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onClose ?? () => Navigator.pop(context),
                      child: Text(closeLabel),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey[300]!),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  if (showAddButton) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onAdd,
                        child: Text(addLabel),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: deepPink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                          shadowColor: deepPink.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 