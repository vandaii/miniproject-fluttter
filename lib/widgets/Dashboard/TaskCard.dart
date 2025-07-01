import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskCard extends StatelessWidget {
  final String taskTitle;
  final String date;
  final String priority;
  final String status;
  final VoidCallback? onTap;

  const TaskCard({
    Key? key,
    required this.taskTitle,
    required this.date,
    required this.priority,
    required this.status,
    this.onTap,
  }) : super(key: key);

  Color _getColor(String value) {
    switch (value) {
      case "High Priority":
      case "Needs Attention":
        return const Color(0xFFEC407A); // pink vivid
      case "Medium Priority":
      case "Waiting for Action":
        return const Color.fromARGB(
          255,
          255,
          177,
          69,
        ); // kuning lemon pastel tegas
      default:
        return const Color(0xFF43A047); // hijau segar
    }
  }

  IconData _getIcon(String value) {
    switch (value) {
      case "High Priority":
      case "Needs Attention":
        return Icons.warning_rounded;
      case "Medium Priority":
      case "Waiting for Action":
        return Icons.schedule_rounded;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }

  Widget _buildBadge(BuildContext context, String text, Color color) {
    final Color badgeBg = color.withOpacity(0.18); // lebih tegas
    final Color badgeBorder = color.withOpacity(0.32);
    return GestureDetector(
      onTap: () {
        String message = text;
        // Mapping pesan lengkap
        if (text.toLowerCase().contains('waiting')) {
          message = 'Waiting for Action';
        } else if (text.toLowerCase().contains('high')) {
          message = 'High Priority';
        } else if (text.toLowerCase().contains('medium')) {
          message = 'Medium Priority';
        } else if (text.toLowerCase().contains('needs')) {
          message = 'Needs Attention';
        } else if (text.toLowerCase().contains('done') ||
            text.toLowerCase().contains('selesai')) {
          message = 'Completed';
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: Text(
              'Detail',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Text(message, style: GoogleFonts.poppins()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Tutup',
                  style: GoogleFonts.poppins(color: Colors.pink),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 110),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.only(right: 0),
        decoration: BoxDecoration(
          color: badgeBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: badgeBorder, width: 1.1),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color priorityColor = _getColor(priority);
    final Color statusColor = _getColor(status);
    final IconData icon = _getIcon(priority);
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    double cardWidth = isMobile ? screenWidth * 0.88 : 370;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 22, top: 12, bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFF8BBD0).withOpacity(0.55),
            width: 1.2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon modern dengan efek glass
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: [
                          priorityColor.withOpacity(0.18),
                          Colors.white.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: priorityColor.withOpacity(0.13),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: priorityColor.withOpacity(0.18),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(icon, color: priorityColor, size: 32),
                  ),
                  const SizedBox(width: 22),
                  // Konten utama
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                taskTitle,
                                style: GoogleFonts.poppins(
                                  fontSize: 18.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withOpacity(0.92),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // CTA Icon (>)
                            Container(
                              margin: const EdgeInsets.only(left: 12, top: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.10),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.blueGrey,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 17,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              date,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: Colors.grey.shade700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        // Badge priority dan status rata kiri, tidak overflow, efek glassmorphism
                        Row(
                          children: [
                            Flexible(
                              child: _buildBadge(
                                context,
                                priority.replaceAll(" Priority", ""),
                                priorityColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: _buildBadge(context, status, statusColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
