import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final navigationKey = GlobalKey<CurvedNavigationBarState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    height: 250,
                    decoration: const BoxDecoration(
                      color: Color(
                        0xFF4A148C,
                      ), // Dark purple color for the header
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Replace Avatar with Logo and Title
                            Image.asset(
                              'assets/images/icons-haus.png', // Use your logo here
                              height: 60,
                              width: 60,
                            ),
                            Row(
                              children: [
                                Text(
                                  'HAUS ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'INVENTORY',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink.shade400,
                                  ),
                                ),
                              ],
                            ),
                            // Add Notification, Email, and Avatar Icons
                            Row(
                              children: [
                                const Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.mail_outline,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 12),
                                const CircleAvatar(
                                  backgroundImage: AssetImage(
                                    'assets/images/avatar.jpg', // Replace with avatar image
                                  ),
                                  radius: 15,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome to the Dashboard',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Haus ',
                                    style: GoogleFonts.cinzelDecorative(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Inventory',
                                    style: GoogleFonts.cinzelDecorative(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons Card
                  Positioned(
                    top: 200, // Adjust position to overlap the header
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _actionButton(Icons.account_balance_wallet, 'Top Up'),
                          _actionButton(Icons.send, 'Send'),
                          _actionButton(Icons.currency_exchange, 'Request'),
                          _actionButton(Icons.history, 'History'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 100), // Adjust space below the overlap
              // Payment List Section
              _paymentListSection(),

              // Promo & Discount Section
              _promoDiscountSection(),

              // Task Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tasks",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Show ALL",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _taskItem(
                      'Stock Opname has not been performed',
                      'High Priority',
                    ),
                    _taskItem(
                      'PO-2024-0125 awaiting acceptance',
                      'Medium Priority',
                    ),
                    _taskItem(
                      'PO-2025-0222 awaiting acceptance',
                      'High Priority',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Status Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _statusCard('Outstanding\nPO', Colors.pink.shade100),
                    const SizedBox(width: 8),
                    _statusCard(
                      'Outstanding\nTransfer Out',
                      Colors.red.shade100,
                      colorText: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    _statusCard(
                      'Outstanding\nDirect Purchase',
                      Colors.blue.shade100,
                      colorText: Colors.blue,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: navigationKey,
        backgroundColor: Colors.transparent,
        color: const Color(0xFF673AB7),
        buttonBackgroundColor: Colors.white,
        height: 60,
        items: const [
          Icon(Icons.home, color: Colors.black),
          Icon(Icons.search, color: Colors.black),
          Icon(Icons.add_box, color: Colors.black),
          Icon(Icons.notifications, color: Colors.black),
          Icon(Icons.person, color: Colors.black),
        ],
        onTap: _onItemTapped,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        index: _selectedIndex,
        letIndexChange: (index) => true,
      ),
    );
  }

  Widget _taskItem(String title, String priority) {
    IconData icon = Icons.error_outline;
    Color color = priority == 'High Priority'
        ? Colors.red
        : Colors.orangeAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Column(
            children: [
              Text(
                '12/03/2025 09:42',
                style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  priority,
                  style: GoogleFonts.poppins(fontSize: 10, color: color),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusCard(
    String title,
    Color bg, {
    Color colorText = Colors.purple,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colorText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple.shade50, // Light purple background
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.deepPurple), // Dark purple icon
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _paymentItem(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.deepPurple),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center, // Center text for multi-line labels
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _paymentListSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment List',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            childAspectRatio: 1,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _paymentItem(Icons.wifi, 'Internet'),
              _paymentItem(Icons.flash_on, 'Electricity'),
              _paymentItem(Icons.card_giftcard, 'Voucher'),
              _paymentItem(Icons.security, 'Assurance'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _promoDiscountSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Promo & Discount',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'See more',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _promoCard(
                  'Special Offer for Today’s Top Up',
                  'Get discount for every top up',
                  Colors.deepPurpleAccent,
                ),
                _promoCard(
                  'New User Discount',
                  'Register now and get a discount',
                  Colors.orangeAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoCard(String title, String subtitle, Color bgColor) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
