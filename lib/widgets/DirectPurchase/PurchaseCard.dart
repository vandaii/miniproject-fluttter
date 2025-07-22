import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io';

class PurchaseSimpleCard extends StatelessWidget {
  final String noDirect;
  final String status;
  final String date;
  final String supplier;
  final dynamic items;
  final String total;
  final VoidCallback? onViewDetails;
  final Map<String, dynamic>? data;
  const PurchaseSimpleCard({
    Key? key,
    required this.noDirect,
    required this.status,
    required this.date,
    required this.supplier,
    required this.items,
    required this.total,
    this.onViewDetails,
    this.data,
  }) : super(key: key);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'revision':
        return Colors.orangeAccent;
      default:
        return Colors.orange; // ungu
    }
  }

  @override
  Widget build(BuildContext context) {
    const deeppink = Color.fromARGB(255, 255, 0, 85);
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
              // Icon keranjang di dalam card utama, atas tengah
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
                    Icons.shopping_cart,
                    color:Colors.white,
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
                      // No DP dan status sejajar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              noDirect,
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
                        icon: Icons.person,
                        iconBg: deeppink.withOpacity(0.13),
                        label: 'Supplier',
                        value: supplier,
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
                        label: 'Items',
                        value: items is String ? items : (items is List ? items.length.toString() : ''),
                        iconColor: Colors.orange,
                      ),
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: Icons.attach_money,
                        iconBg: Colors.teal.withOpacity(0.13),
                        label: 'Total',
                        value: total,
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
                  onPressed: () {
                    if (data == null) return;
                    final proof = data!['purchase_proof'] ?? data!['purchaseProof'];
                    List<String> images = [];
                    if (proof is List) {
                      images = proof.cast<String>();
                    } else if (proof is String && proof.isNotEmpty && proof != '-') {
                      images = [proof];
                    }
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
                                                'Detail Direct Purchase',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                  color: Color.fromARGB(255, 255, 0, 85),
                                                ),
                                              ),
                                              Icon(Icons.shopping_cart_checkout_rounded, color: Color.fromARGB(255, 255, 0, 85), size: 28),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Divider(thickness: 1, color: const Color.fromARGB(255, 62, 56, 56)),
                                          const SizedBox(height: 10),
                                          _DetailRow(label: 'No DP', value: noDirect),
                                          _DetailRow(label: 'Status', value: status),
                                          _DetailRow(label: 'Tanggal', value: date),
                                          _DetailRow(label: 'Supplier', value: supplier),
                                          _DetailRow(label: 'Items', value: items is String ? items : (items is List ? items.length.toString() : '')),
                                          _DetailRow(label: 'Total', value: total),
                                          if (data!['note'] != null && data!['note'].toString().isNotEmpty) ...[
                                            const SizedBox(height: 8),
                                            _DetailRow(label: 'Catatan', value: data!['note'].toString()),
                                          ],
                                          if (items is List && items.isNotEmpty)
                                            PaginatedItemDetails(items: items as List, deeppink: Color.fromARGB(255, 255, 0, 85))
                                          else
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              child: Text(
                                                'Tidak ada item barang.',
                                                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
                                              ),
                                            ),
                                          const SizedBox(height: 18),
                                          Text('Bukti Pembelian:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                                          const SizedBox(height: 8),
                                          if (images.isNotEmpty) ...[
                                            ...images.map((img) {
                                              String url = img.startsWith('http') ? img : 'http://192.168.1.3:8000/storage/' + img;
                                              return GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    barrierColor: Colors.black.withOpacity(0.75),
                                                    builder: (context) => ImagePreviewDialog(imageUrl: url, heroTag: url),
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 8.0),
                                                  child: Hero(
                                                    tag: url,
                                                    child: Material(
                                                      elevation: 1,
                                                      borderRadius: BorderRadius.circular(14),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(14),
                                                        child: Image.network(
                                                          url,
                                                          height: 160,
                                                          width: double.infinity,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (c, e, s) => Container(
                                                            color: Colors.grey[200],
                                                            height: 160,
                                                            child: Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ]
                                          else ...[
                                            Card(
                                              color: Colors.grey[50],
                                              elevation: 1,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.image_not_supported_outlined, color: Colors.grey[400], size: 48),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Tidak ada bukti pembelian',
                                                      style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[700], fontWeight: FontWeight.w600),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'Belum diunggah atau tidak tersedia.',
                                                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[500]),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
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
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.orangeAccent,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                                ),
                                                child: Text('Revision', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
                      transitionBuilder: (context, anim1, anim2, child) {
                        final slide = Tween<Offset>(
                          begin: const Offset(1, 0), // dari kanan
                          end: Offset.zero,
                        ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeInOutQuart));
                        final fade = CurvedAnimation(parent: anim1, curve: Curves.easeInOut);
                        final scale = Tween<double>(
                          begin: 0.96,
                          end: 1.0,
                        ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeInOutQuart));
                        return FadeTransition(
                          opacity: fade,
                          child: SlideTransition(
                            position: slide,
                            child: ScaleTransition(
                              scale: scale,
                              child: child,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.visibility, size: 18, color: Colors.white),
                  label: Text('View Details', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deeppink,
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

class ImagePreviewDialog extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const ImagePreviewDialog({Key? key, required this.imageUrl, required this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(16.0),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: EdgeInsets.zero,
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.error, color: Colors.red, size: 50)),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              elevation: 4,
              color: Colors.black.withOpacity(0.6),
              shape: const CircleBorder(),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaginatedItemDetails extends StatefulWidget {
  final List<dynamic> items;
  final Color deeppink;

  const PaginatedItemDetails({
    Key? key,
    required this.items,
    required this.deeppink,
  }) : super(key: key);

  @override
  _PaginatedItemDetailsState createState() => _PaginatedItemDetailsState();
}

class _PaginatedItemDetailsState extends State<PaginatedItemDetails> {
  int _currentPage = 0;
  final int _itemsPerPage = 3;

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.items.length;
    if (totalItems <= _itemsPerPage) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text('Detail Barang:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          ...widget.items.map((item) => _buildItemCard(item)).toList(),
        ],
      );
    }

    final totalPages = (totalItems / _itemsPerPage).ceil();
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage > totalItems)
        ? totalItems
        : startIndex + _itemsPerPage;
    final paginatedItems = widget.items.sublist(startIndex, endIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text('Detail Barang:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 6),
        Column(
          children: paginatedItems.map((item) => _buildItemCard(item)).toList(),
        ),
        const SizedBox(height: 16),
        // MODERN PAGINATION
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  onPressed: _currentPage == 0 ? null : () => setState(() => _currentPage--),
                  color: widget.deeppink,
                  splashRadius: 22,
                  tooltip: 'Prev',
                  style: IconButton.styleFrom(
                    backgroundColor: _currentPage == 0 ? Colors.grey.shade200 : Colors.white,
                    shape: const CircleBorder(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Page : ${_currentPage + 1} / $totalPages',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                  onPressed: _currentPage >= totalPages - 1 ? null : () => setState(() => _currentPage++),
                  color: widget.deeppink,
                  splashRadius: 22,
                  tooltip: 'Next',
                  style: IconButton.styleFrom(
                    backgroundColor: _currentPage >= totalPages - 1 ? Colors.grey.shade200 : Colors.white,
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(dynamic item) {
    final String nama = item is Map ? (item['itemName']?.toString() ?? item['name']?.toString() ?? '-') : '-';
    final String deskripsi = item is Map ? (item['itemDescription']?.toString() ?? item['description']?.toString() ?? item['desc']?.toString() ?? '-') : '-';
    final String qty = item is Map ? (item['quantity']?.toString() ?? item['qty']?.toString() ?? '-') : '-';
    final String harga = item is Map ? (item['price']?.toString() ?? item['harga']?.toString() ?? '-') : '-';
    final String satuan = item is Map ? (item['unit']?.toString() ?? item['satuan']?.toString() ?? '-') : '-';
 
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.inventory_2, color: widget.deeppink, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    nama,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: widget.deeppink,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            Row(
              children: [
                Icon(Icons.description_outlined, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    deskripsi,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.tag, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  "Qty:",
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 4),
                Text(
                  qty,
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            // Tambahkan description satuan/uom
            Row(
              children: [
                Icon(Icons.straighten, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  "Uom:",
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 4),
                Text(
                  satuan,
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.deepPurple),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.monetization_on_outlined, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  "Price:",
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 4),
                Text(
                  harga,
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.teal),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}