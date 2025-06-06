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
    if (index == 1) {
      _showFeatureModal();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showFeatureModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          children: [
            _featureItem(Icons.shopping_bag, 'Purchasing'),
            _featureItem(Icons.inventory, 'Stock'),
            _featureItem(Icons.insert_chart, 'Reports'),
            _featureItem(Icons.settings, 'Settings'),
            _featureItem(Icons.help, 'Help'),
            _featureItem(Icons.more_horiz, 'Lainnya'),
          ],
        ),
      ),
    );
  }

  Widget _featureItem(IconData icon, String title) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 135, 171, 208),
          child: Icon(icon, color: Color.fromARGB(255, 84, 75, 107)),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/icons-haus.png', height: 40),
                      const SizedBox(width: 8),
                      Text(
                        'HAUS Inventory',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(Icons.search, size: 26),
                      SizedBox(width: 12),
                      Icon(Icons.mail_outline, size: 26),
                      SizedBox(width: 12),
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/avatar.jpg'),
                        radius: 18,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                'Dashboard',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Tasks Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _taskItem(
                      'Stock Opname has not been performed',
                      'High Priority',
                      'Needs Attention',
                      Colors.red,
                    ),
                    const Divider(),
                    _taskItem(
                      'PO-2024-0125 awaiting acceptance',
                      'Medium Priority',
                      'Waiting for Action',
                      Colors.orange,
                    ),
                    const Divider(),
                    _taskItem(
                      'PO-2025-0222 awaiting acceptance',
                      'High Priority',
                      'Needs Attention',
                      Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Status Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statusBox('Outstanding PO', '3', Colors.purple),
                  _statusBox('Outstanding Direct Purchase', '5', Colors.red),
                  _statusBox('Outstanding Transfer Out', '8', Colors.orange),
                ],
              ),
              const SizedBox(height: 20),

              // Open Item List Table (Mock)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Open Item List',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _tableHeader(),
                    const Divider(),
                    _tableRow('PO-2024-0125', '15/03/2024', 'PT Karunia Alam'),
                    _tableRow('PO-2024-0125', '15/03/2024', 'PT Kurnia Abadi'),
                    _tableRow('PO-2024-0125', '15/03/2024', 'PT Boba Supply'),
                    _tableRow('PO-2024-0125', '15/03/2024', 'PT Kemasan Prima'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: navigationKey,
        backgroundColor: Colors.transparent,
        color: const Color.fromARGB(255, 135, 171, 208),
        buttonBackgroundColor: const Color.fromARGB(255, 84, 75, 107),
        height: 60,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        items: const <Widget>[
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.apps, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _taskItem(String title, String priority, String status, Color color) {
    return Row(
      children: [
        Icon(Icons.error_outline, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins()),
              Row(
                children: [
                  Text(
                    priority,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.poppins(fontSize: 12, color: color),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusBox(String title, String count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _headerCell('PO Number'),
        _headerCell('Date'),
        _headerCell('Supplier'),
        _headerCell('Status'),
        const Text('Action'),
      ],
    );
  }

  Widget _tableRow(String po, String date, String supplier) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _rowCell(po),
          _rowCell(date),
          _rowCell(supplier),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.yellow.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Open', style: GoogleFonts.poppins(fontSize: 12)),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            child: const Text('Detail'),
          ),
        ],
      ),
    );
  }

  Widget _headerCell(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12),
    );
  }

  Widget _rowCell(String text) {
    return SizedBox(
      width: 80,
      child: Text(text, style: GoogleFonts.poppins(fontSize: 12)),
    );
  }
}
