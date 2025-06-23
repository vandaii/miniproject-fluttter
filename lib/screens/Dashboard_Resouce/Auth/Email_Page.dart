import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailPage extends StatelessWidget {
  final List<Map<String, dynamic>> emails = [
    {
      'avatar': 'assets/images/avatar1.jpg',
      'sender': 'HR Department',
      'subject': 'Welcome to the Company!',
      'snippet': 'We are excited to have you join our team.',
      'time': '09:12',
      'unread': true,
    },
    {
      'avatar': 'assets/images/avatar2.jpg',
      'sender': 'Manager',
      'subject': 'Monthly Report',
      'snippet': 'Please submit your monthly report by Friday.',
      'time': 'Yesterday',
      'unread': false,
    },
    {
      'avatar': 'assets/images/avatar3.jpg',
      'sender': 'IT Support',
      'subject': 'System Maintenance',
      'snippet': 'Scheduled maintenance on Saturday night.',
      'time': '2 days ago',
      'unread': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Emails',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE91E63),
        elevation: 4,
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: emails.isEmpty
          ? Center(
              child: Text(
                'No emails yet.',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              itemCount: emails.length,
              separatorBuilder: (_, __) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final email = emails[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  color: Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(email['avatar']),
                      radius: 24,
                    ),
                    title: Text(
                      email['sender'],
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
                          email['subject'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          email['snippet'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          email['time'],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        if (email['unread'])
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Color(0xFF880E4F),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    onTap: () {
                      // Action when email tapped
                    },
                  ),
                );
              },
            ),
    );
  }
}