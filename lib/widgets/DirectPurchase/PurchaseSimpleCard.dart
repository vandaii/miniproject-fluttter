import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io';

class PurchaseSimpleCard extends StatelessWidget {
  final String noDirect;
  final String status;
  final String date;
  final String supplier;
  final String items;
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
                        value: items,
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
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.noHeader,
                      animType: AnimType.bottomSlide,
                      title: 'Detail Direct Purchase',
                      body: Center(
                        child: Material(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 600), // dari sebelumnya 420
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Detail Direct Purchase',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: deeppink,
                                        ),
                                      ),
                                      Icon(Icons.shopping_cart_checkout_rounded, color: deeppink, size: 28),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Divider(thickness: 1, color: Colors.grey[200]),
                                  const SizedBox(height: 10),
                                  _DetailRow(label: 'No DP', value: noDirect),
                                  _DetailRow(label: 'Status', value: status),
                                  _DetailRow(label: 'Tanggal', value: date),
                                  _DetailRow(label: 'Supplier', value: supplier),
                                  _DetailRow(label: 'Items', value: items),
                                  _DetailRow(label: 'Total', value: total),
                                  if (data!['note'] != null && data!['note'].toString().isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    _DetailRow(label: 'Catatan', value: data!['note'].toString()),
                                  ],
                                  if (images.isNotEmpty) ...[
                                    const SizedBox(height: 18),
                                    Text('Bukti Pembelian:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                                    const SizedBox(height: 8),
                                    ...images.map((img) {
                                      String url = img.startsWith('http') ? img : 'http://192.168.1.5:8000/storage/purchase_proofs/' + img;
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Material(
                                          elevation: 3,
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
                                      );
                                    }).toList(),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      btnOkOnPress: () {},
                      useRootNavigator: true,
                    ).show();
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