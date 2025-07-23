import 'package:flutter/material.dart';

class CartSummary extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  const CartSummary({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalQty = 0;
    double totalHarga = 0;
    for (var item in cartItems) {
      totalQty += int.tryParse(item['quantity']?.toString() ?? '0') ?? 0;
      totalHarga += double.tryParse(item['price']?.toString() ?? '0') ?? 0 * (int.tryParse(item['qty']?.toString() ?? '1') ?? 1);
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Qty: $totalQty', style: const TextStyle(fontWeight: FontWeight.w600)),
          Text('Total: Rp${totalHarga.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
} 