import 'package:flutter/material.dart';

class DirectPurchaseTabBar extends StatelessWidget {
  static const Color primary = Color.fromARGB(255, 255, 0, 85);
  final TabController controller;
  const DirectPurchaseTabBar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: primary.withOpacity(0.1),
        ),
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        labelColor: primary,
        unselectedLabelColor: Colors.black54,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(icon: Icon(Icons.pending_actions), text: 'Outstanding'),
          Tab(icon: Icon(Icons.verified), text: 'Approved'),
        ],
      ),
    );
  }
} 