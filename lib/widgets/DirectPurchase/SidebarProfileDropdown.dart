import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SidebarProfileDropdown extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onTap;
  final String userName;
  final String userRole;
  final VoidCallback onProfile;
  final VoidCallback onSettings;
  final VoidCallback onHelp;
  final VoidCallback onLogout;

  const SidebarProfileDropdown({
    Key? key,
    required this.isOpen,
    required this.onTap,
    required this.userName,
    required this.userRole,
    required this.onProfile,
    required this.onSettings,
    required this.onHelp,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color deepPink = const Color.fromARGB(255, 255, 0, 85);
    final Color lightPink = const Color(0xFFFCE4EC);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightPink,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: deepPink.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: deepPink,
                child: Text(userName.isNotEmpty ? userName[0] : '', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: deepPink,
                      ),
                    ),
                    Text(
                      userRole,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Icon(
                  isOpen ? Icons.expand_less : Icons.expand_more,
                  color: deepPink,
                ),
              ),
            ],
          ),
          AnimatedCrossFade(
            firstChild: SizedBox.shrink(),
            secondChild: Container(
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  _buildProfileMenuItem(Icons.person_outline, 'Profile', onProfile, false),
                  _buildProfileMenuItem(Icons.settings_outlined, 'Settings', onSettings, false),
                  _buildProfileMenuItem(Icons.help_outline, 'Help & Support', onHelp, false),
                  _buildProfileMenuItem(Icons.logout, 'Logout', onLogout, true),
                ],
              ),
            ),
            crossFadeState: isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 220),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem(IconData icon, String title, VoidCallback onTap, bool isLogout) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          dense: true,
          leading: Icon(
            icon,
            size: 20,
            color: isLogout ? Colors.red : Colors.black87,
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isLogout ? Colors.red : Colors.black87,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
} 