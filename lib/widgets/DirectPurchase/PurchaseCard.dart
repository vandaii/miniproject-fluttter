import 'package:flutter/material.dart';

class PurchaseCard extends StatelessWidget {
  static const Color primary = Color.fromARGB(255, 255, 0, 85);
  final bool isApproved;
  final VoidCallback? onViewDetails;
  const PurchaseCard({Key? key, required this.isApproved, this.onViewDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E7FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_cart, color: primary, size: 32),
          ),
          const SizedBox(width: 20),
          // Info
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'TRX-2024-001',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isApproved ? Colors.green[100] : Colors.amber[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isApproved ? Icons.verified : Icons.hourglass_top,
                                color: isApproved ? Colors.green[700] : Colors.amber[800],
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  isApproved ? 'Approved' : 'Pending Area Manager',
                                  style: TextStyle(
                                    color: isApproved ? Colors.green[800] : Colors.amber[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'PT. Supplier Abadi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      Icon(Icons.calendar_today, size: 15, color: Colors.black38),
                      SizedBox(width: 4),
                      Text('12 Jun 2024', style: TextStyle(fontSize: 13, color: Colors.black54)),
                      SizedBox(width: 16),
                      Icon(Icons.list_alt, size: 15, color: Colors.black38),
                      SizedBox(width: 4),
                      Text('5 item', style: TextStyle(fontSize: 13, color: Colors.black54)),
                      SizedBox(width: 16),
                      Icon(Icons.attach_money, size: 15, color: Colors.black38),
                      SizedBox(width: 4),
                      Text('Rp 2.500.000', style: TextStyle(fontSize: 13, color: Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primary,
                      elevation: 0,
                      side: const BorderSide(color: primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    onPressed: onViewDetails,
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('View Details'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 