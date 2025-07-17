import "dart:ui";
import "package:flutter/material.dart";
import 'package:miniproject_flutter/widgets/DirectPurchase/HeaderFloatingCard.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/TitleCardDirectPurchase.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/PurchaseSimpleCard.dart';

class DirectPurchasePage extends StatefulWidget {
  final int selectedIndex;
  const DirectPurchasePage({this.selectedIndex = 11, Key? key})
    : super(key: key);

  @override
  _DirectPurchasePageState createState() => _DirectPurchasePageState();
}

class _DirectPurchasePageState extends State<DirectPurchasePage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: HeaderFloatingCard(
                isMobile: isMobile,
                onMenuTap: () {},
                onEmailTap: () {},
                onNotifTap: () {},
                onAvatarTap: () {},
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
              child: TitleCardDirectPurchase(isMobile: isMobile),
            ),
            // Konten utama
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  PurchaseSimpleCard(
                    noDirect: 'DP-2024-0001',
                    status: 'Pending',
                    date: '12/06/2024',
                    supplier: 'PT. Sumber Makmur',
                    items: '4 items', // <-- tambahkan ini
                    total: '347517',
                    onViewDetails: () {},
                  ),
                  PurchaseSimpleCard(
                    noDirect: 'DP-2024-0002',
                    status: 'Approved',
                    date: '10/06/2024',
                    supplier: 'CV. Aneka Jaya',
                    items: '4 items', // <-- tambahkan ini
                    total: '347517',
                    onViewDetails: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
