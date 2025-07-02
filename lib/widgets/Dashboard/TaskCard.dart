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
    this.onTap, required Null Function(dynamic tapContext, dynamic tapPosition) onStatusTap, required Null Function(dynamic tapContext, dynamic tapPosition) onPriorityTap,
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
    final Color badgeBg = color.withOpacity(0.18);
    final Color badgeBorder = color.withOpacity(0.32);
    return AnimatedTooltipBadge(
      key: ValueKey(text),
      text: text,
      color: color,
      badgeBg: badgeBg,
      badgeBorder: badgeBorder,
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

class AnimatedTooltipBadge extends StatefulWidget {
  final String text;
  final Color color;
  final Color badgeBg;
  final Color badgeBorder;

  const AnimatedTooltipBadge({
    Key? key,
    required this.text,
    required this.color,
    required this.badgeBg,
    required this.badgeBorder,
  }) : super(key: key);

  // Hanya satu badge aktif di seluruh aplikasi
  static AnimatedTooltipBadgeState? _activeBadge;
  static void removeAllTooltips() {
    _activeBadge?._removeTooltip();
    _activeBadge = null;
  }

  @override
  State<AnimatedTooltipBadge> createState() => AnimatedTooltipBadgeState();
}

class AnimatedTooltipBadgeState extends State<AnimatedTooltipBadge> with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _scaleAnim = Tween<double>(begin: 0.92, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _isDisposed = true;
    _removeTooltip();
    if (AnimatedTooltipBadge._activeBadge == this) {
      AnimatedTooltipBadge._activeBadge = null;
    }
    _controller.dispose();
    super.dispose();
  }

  void _showTooltip(TapDownDetails details) async {
    // Tutup badge lain jika ada
    if (AnimatedTooltipBadge._activeBadge != null && AnimatedTooltipBadge._activeBadge != this) {
      AnimatedTooltipBadge._activeBadge!._removeTooltip();
    }
    AnimatedTooltipBadge._activeBadge = this;
    _removeTooltip();
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset badgePos = box.localToGlobal(Offset.zero);
    final Size badgeSize = box.size;
    final overlay = Overlay.of(context);
    String message = widget.text;
    if (widget.text.toLowerCase().contains('waiting')) {
      message = 'Waiting for Action';
    } else if (widget.text.toLowerCase().contains('high')) {
      message = 'High Priority';
    } else if (widget.text.toLowerCase().contains('medium')) {
      message = 'Medium Priority';
    } else if (widget.text.toLowerCase().contains('needs')) {
      message = 'Needs Attention';
    } else if (widget.text.toLowerCase().contains('done') || widget.text.toLowerCase().contains('selesai')) {
      message = 'Completed';
    }
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _removeTooltip,
          child: Stack(
            children: [
              Positioned(
                left: badgePos.dx + badgeSize.width / 2 - 70,
                top: badgePos.dy - 48,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: widget.badgeBorder, width: 1),
                            ),
                            child: Text(
                              message,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          // Arrow bawah ala macOS
                          CustomPaint(
                            size: const Size(18, 8),
                            painter: _TooltipArrowPainter(color: Colors.white, borderColor: widget.badgeBorder),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    overlay.insert(_overlayEntry!);
    if (!_isDisposed) _controller.forward();
  }

  void _removeTooltip() {
    if (!_isDisposed) _controller.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (AnimatedTooltipBadge._activeBadge == this) {
      AnimatedTooltipBadge._activeBadge = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _showTooltip,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 110),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.only(right: 0),
        decoration: BoxDecoration(
          color: widget.badgeBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: widget.badgeBorder, width: 1.1),
        ),
        child: Text(
          widget.text,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: widget.color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _TooltipArrowPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  _TooltipArrowPainter({required this.color, required this.borderColor});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }
  @override
  bool shouldRepaint(_TooltipArrowPainter oldDelegate) => false;
}
