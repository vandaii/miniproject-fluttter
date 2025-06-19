import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'icon': Icons.shopping_cart,
      'title': 'Purchase Approved',
      'message': 'Your direct purchase request has been approved.',
      'time': '2 min ago',
      'color': Colors.green,
    },
    {
      'icon': Icons.assignment_turned_in,
      'title': 'GRPO Received',
      'message': 'Goods receipt has been completed for PO-2023-12.',
      'time': '10 min ago',
      'color': Colors.blue,
    },
    {
      'icon': Icons.warning_amber_rounded,
      'title': 'Stock Low',
      'message': 'Stock for Item ABC is below minimum level.',
      'time': '1 hour ago',
      'color': Colors.orange,
    },
    {
      'icon': Icons.info_outline,
      'title': 'System Update',
      'message': 'The app will be updated tonight at 11:00 PM.',
      'time': 'Yesterday',
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF880E4F),
        elevation: 4,
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: notifications.isEmpty
          ? Center(
              child: Text(
                'No notifications yet.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  color: Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: notif['color'].withOpacity(0.15),
                      child: Icon(notif['icon'], color: notif['color']),
                    ),
                    title: Text(
                      notif['title'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF880E4F),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notif['message'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notif['time'],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
