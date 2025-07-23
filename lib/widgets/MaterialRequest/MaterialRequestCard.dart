import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaterialRequestSimpleCard extends StatelessWidget {
  final String requestNo;
  final String status;
  final String date;
  final String outlet;
  final String qty;
  final String dueDate;
  final VoidCallback? onViewDetails;
  final Map<String, dynamic>? data;
  
  const MaterialRequestSimpleCard({
    Key? key,
    required this.requestNo,
    required this.status,
    required this.date,
    required this.outlet,
    required this.qty,
    required this.dueDate,
    this.onViewDetails,
    this.data,
  }) : super(key: key);

  Color _statusColor(String status) {
    if (status.toLowerCase().contains('approved')) {
      return Colors.green;
    } else if (status.toLowerCase().contains('pending')) {
      return Colors.orange;
    } else if (status.toLowerCase().contains('rejected')) {
      return Colors.red;
    } else if (status.toLowerCase().contains('revision')) {
      return Colors.orangeAccent;
    } else {
      return Colors.purple; // default
    }
  }

  @override
  Widget build(BuildContext context) {
    const deeppink = Color.fromARGB(255, 255,0,85 );
    final statusColor = _statusColor(status);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(26),
        color: Colors.white.withOpacity(0.80),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
          child: Column(
            children: [
              // Icon di dalam card utama, atas tengah
              Center(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: deeppink.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 1,
                      color: Colors.black.withOpacity(0.24),
                    )
                  ),
                  
                  child: const Icon(
                    Icons.inventory_2_outlined,
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
                      // No Request dan status sejajar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              requestNo,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: deeppink,
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
                        iconBg: deeppink.withOpacity(0.13),
                        label: 'Outlet',
                        value: outlet,
                        iconColor: deeppink,
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
                        icon: Icons.date_range,
                        iconBg: Colors.teal.withOpacity(0.13),
                        label: 'Due Date',
                        value: dueDate,
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
                  onPressed: onViewDetails ?? () {
                    _showDetailDialog(context);
                  },
                  icon: const Icon(Icons.visibility, size: 18),
                  label: Text(
                    'View Details',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deeppink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.all(20),
              width: screenWidth,
              constraints: BoxConstraints(
                maxHeight: screenHeight * 0.60,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 80),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Detail Material Request',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Color.fromARGB(255, 233, 30, 99),
                                ),
                              ),
                              Icon(Icons.inventory_2_outlined, color: Color.fromARGB(255, 233, 30, 99), size: 28),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Divider(thickness: 1, color: const Color.fromARGB(255, 62, 56, 56)),
                           const SizedBox(height: 10),
                          _DetailRow(label: 'No Request', value: requestNo),
                          _DetailRow(label: 'Status', value: status),
                          _DetailRow(label: 'Tanggal', value: date),
                          _DetailRow(label: 'Outlet', value: outlet),
                          _DetailRow(label: 'Qty', value: qty),
                          _DetailRow(label: 'Due Date', value: dueDate),
                          if (data != null && data!['note'] != null && data!['note'].toString().isNotEmpty) ...[  
                            const SizedBox(height: 8),
                            _DetailRow(label: 'Catatan', value: data!['note'].toString()),
                          ],
                          if (data != null && data!['items'] != null && data!['items'] is List && (data!['items'] as List).isNotEmpty)
                            PaginatedItemDetails(items: data!['items'] as List, deeppink: Color.fromARGB(255, 233, 30, 99))
                          else
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Tidak ada item barang.',
                                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Sticky button bar
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text('Approve', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text('Reject', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 14),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
} 

class PaginatedItemDetails extends StatefulWidget {
  final List items;
  final Color deeppink;

  const PaginatedItemDetails({Key? key, required this.items, required this.deeppink}) : super(key: key);

  @override
  _PaginatedItemDetailsState createState() => _PaginatedItemDetailsState();
}

class _PaginatedItemDetailsState extends State<PaginatedItemDetails> {
  int _currentPage = 0;
  final int _itemsPerPage = 3;

  @override
  Widget build(BuildContext context) {
    final int totalPages = (widget.items.length / _itemsPerPage).ceil();
    final int startIndex = _currentPage * _itemsPerPage;
    final int endIndex = (startIndex + _itemsPerPage) > widget.items.length ? widget.items.length : startIndex + _itemsPerPage;
    final List currentItems = widget.items.sublist(startIndex, endIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Text('Items:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        ...currentItems.map((item) => _buildItemCard(item)).toList(),
        if (totalPages > 1) ...[  
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 18),
                onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                color: widget.deeppink,
                disabledColor: Colors.grey.withOpacity(0.3),
              ),
              Text(
                '${_currentPage + 1} / $totalPages',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios, size: 18),
                onPressed: _currentPage < totalPages - 1 ? () => setState(() => _currentPage++) : null,
                color: widget.deeppink,
                disabledColor: Colors.grey.withOpacity(0.3),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildItemCard(dynamic item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item['name'] ?? item['item_name'] ?? 'Unknown Item',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.deeppink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${item['qty'] ?? item['quantity'] ?? '0'} ${item['unit'] ?? ''}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: widget.deeppink,
                    ),
                  ),
                ),
              ],
            ),
            if (item['description'] != null && item['description'].toString().isNotEmpty) ...[  
              const SizedBox(height: 4),
              Text(
                item['description'],
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}