import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StockOpnameCard extends StatelessWidget {
  final String docNum;
  final String outlet;
  final String qty;
  final String status;
  final String date;
  final String inputDate;
  final VoidCallback? onViewDetails;

  const StockOpnameCard({
    Key? key,
    required this.docNum,
    required this.outlet,
    required this.qty,
    required this.status,
    required this.date,
    required this.inputDate,
    this.onViewDetails,
  }) : super(key: key);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'running':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    const deepPink = Color.fromARGB(255, 255, 0, 85);
    final statusColor = _statusColor(status);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(26),
        color: Colors.white.withOpacity(0.80),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          child: Column(
            children: [
              // Icon checklist di dalam card utama, atas tengah
              Center(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: deepPink.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 1,
                      color: Colors.black.withOpacity(0.24),
                    )
                  ),
                  child: const Icon(
                    Icons.checklist_rtl_outlined,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Card/container pembungkus data utama
              Material(
                elevation: 1,
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DocNum dan status sejajar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              docNum,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: deepPink,
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            constraints: BoxConstraints(maxWidth: 100), // atur max lebar badge
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: statusColor.withOpacity(0.18)),
                            ),
                            child: Text(
                              status,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _InfoRow(
                        icon: Icons.store,
                        iconBg: deepPink.withOpacity(0.13),
                        label: 'Outlet',
                        value: outlet,
                        iconColor: deepPink,
                      ),
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: Icons.calendar_today,
                        iconBg: const Color(0xFFB2FF59).withOpacity(0.13),
                        label: 'Date',
                        value: date,
                        iconColor: const Color(0xFFB2FF59),
                      ),
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: Icons.inventory_2,
                        iconBg: Colors.orange.withOpacity(0.13),
                        label: 'Qty',
                        value: qty,
                        iconColor: Colors.orange,
                      ),
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: Icons.input,
                        iconBg: Colors.teal.withOpacity(0.13),
                        label: 'Input Date',
                        value: inputDate,
                        iconColor: Colors.teal,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onViewDetails,
                  icon: const Icon(Icons.visibility, size: 18, color: Colors.white),
                  label: Text('View Details', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepPink,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String label;
  final String value;
  final Color iconColor;
  const _InfoRow({
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.value,
    required this.iconColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
} 