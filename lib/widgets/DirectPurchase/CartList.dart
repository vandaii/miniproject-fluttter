import 'package:flutter/material.dart';

class CartList extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  const CartList({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return const Center(child: Text('Cart kosong.'));
    }
    // Kelompokkan item berdasarkan supplier
    final supplierMap = <String, List<Map<String, dynamic>>>{};
    for (var item in cartItems) {
      final supplier = item['supplier'] ?? 'Unknown Supplier';
      supplierMap.putIfAbsent(supplier, () => []).add(item);
    }
    return ListView(
      shrinkWrap: true,
      children: supplierMap.entries.map((entry) {
        final supplier = entry.key;
        final items = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18),
              child: Row(
                children: [
                  Icon(Icons.store, color: Colors.pink.shade400, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    supplier,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFD81B60)),
                  ),
                ],
              ),
            ),
            ...items.map((item) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                shadowColor: Colors.pink.shade50,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.pink.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Icon(Icons.inventory_2, color: Colors.pink.shade300, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 70), // beri ruang untuk badge UOM
                                      child: Text(
                                        item['itemName']?.toString() ?? '-',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF22223B)),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (item['itemDescription'] != null && item['itemDescription'].toString().isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0, right: 70), // padding kanan juga untuk deskripsi
                                        child: Text(
                                          item['itemDescription']?.toString() ?? '-',
                                          style: const TextStyle(fontSize: 13, color: Color(0xFF4A4E69)),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.pink.shade100.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.tag, size: 15, color: Colors.pink.shade300),
                                    const SizedBox(width: 4),
                                    Text('Qty:', style: TextStyle(fontSize: 13, color: Colors.pink.shade400)),
                                    const SizedBox(width: 2),
                                    Text(item['quantity']?.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.attach_money, size: 15, color: Colors.teal.shade400),
                                    const SizedBox(width: 4),
                                    Text('Harga:', style: TextStyle(fontSize: 13, color: Colors.teal.shade400)),
                                    const SizedBox(width: 2),
                                    Text(item['price']?.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Badge UOM di kanan atas
                    if (item['unit'] != null && item['unit'].toString().isNotEmpty)
                      Positioned(
                        top: 12,
                        right: 18,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.purple.shade100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.shade50.withOpacity(0.18),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            item['unit'].toString(),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6C3483)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )),
          ],
        );
      }).toList(),
    );
  }
} 