import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleCardDirectPurchase extends StatelessWidget {
  final bool isMobile;
  final TabController tabController;
  const TitleCardDirectPurchase({Key? key, this.isMobile = false, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const deepPink = Color.fromARGB(255, 255, 0, 85);
    return Material(
      color: deepPink,
      elevation: 2,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 36,
          vertical: isMobile ? 22 : 32,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.shopping_cart_checkout_rounded,
                    color: deepPink,
                    size: 28,
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Direct Purchase',
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 18 : 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage and monitor your store purchases easily.',
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 12 : 14,
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 18),
            TabBar(
              controller: tabController,
              isScrollable: true,
              indicatorColor: const Color.fromRGBO(255, 255, 255, 1),
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Outstanding'),
                Tab(text: 'Approved'),
                Tab(text: 'Rejected'),
                Tab(text: 'Revision'),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 