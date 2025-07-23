import 'package:flutter/material.dart';
import 'CartList.dart';
import 'CartSummary.dart';
import 'CartReviewSubmit.dart';

class CartDialog extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final VoidCallback onClose;
  final VoidCallback onReview;
  final VoidCallback onSubmit;

  const CartDialog({
    Key? key,
    required this.cartItems,
    required this.onClose,
    required this.onReview,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar item Barang ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: onClose,
                  ),
                ],
              ),
            ),
            Expanded(
              child: CartList(cartItems: cartItems),
            ),
            CartSummary(cartItems: cartItems),
            // CartReviewSubmit(onReview: onReview, onSubmit: onSubmit), // Dihapus sesuai permintaan
          ],
        ),
      ),
    );
  }
} 