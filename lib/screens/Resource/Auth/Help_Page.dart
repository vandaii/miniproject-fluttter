import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Help & Support',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF880E4F),
          elevation: 4,
        ),
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.help_outline, color: Color(0xFF880E4F), size: 32),
                const SizedBox(width: 10),
                Text(
                  "How can we help you?",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF880E4F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // List of Help Topics
            Expanded(
              child: ListView(
                children: [
                  _buildHelpCard(
                    icon: Icons.account_circle,
                    title: "Account Settings",
                    description:
                        "Learn how to update your profile, change your password, and manage your account information.",
                  ),
                  _buildHelpCard(
                    icon: Icons.inventory_2,
                    title: "Stock Management",
                    description:
                        "Find out how to add, edit, and track your stock and inventory.",
                  ),
                  _buildHelpCard(
                    icon: Icons.shopping_cart,
                    title: "Purchasing",
                    description:
                        "Get help with creating purchase requests, approvals, and tracking orders.",
                  ),
                  _buildHelpCard(
                    icon: Icons.receipt_long,
                    title: "Reports",
                    description:
                        "Understand how to generate and export various reports from the app.",
                  ),
                  _buildHelpCard(
                    icon: Icons.support_agent,
                    title: "Contact Support",
                    description:
                        "Need more help? Contact our support team for further assistance.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Contact Support Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Action to contact support
                },
                icon: Icon(Icons.chat_bubble_outline, color: Colors.white),
                label: Text(
                  "Contact Support",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF880E4F),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xFF880E4F).withOpacity(0.12),
          child: Icon(icon, color: Color(0xFF880E4F)),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF880E4F),
          ),
        ),
        subtitle: Text(
          description,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
        onTap: () {
          // Bisa diarahkan ke detail/topik bantuan tertentu
        },
      ),
    );
  }
}
