# miniproject_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

color by web
-FB773C
-EB3678
-4F1787
-180161


code 
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Purchasing/GRPO_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/StockOpname_Page.dart';
import 'Dashboard_Resouce/Purchasing/DirectPurchase_Page.dart';
import 'Dashboard_Resouce/Stock_Management/TransferStock_Page.dart';
import 'Dashboard_Resouce/Stock_Management/MaterialRequest_Page.dart';
import 'Dashboard_Resouce/Auth/UserProfile_Page.dart';
import 'Dashboard_Resouce/Stock_Management/Waste_Page.dart';
import 'Dashboard_Resouce/Auth/Help_Page.dart';
import 'Dashboard_Resouce/Auth/Notification_Page.dart';
import 'Dashboard_Resouce/Auth/Email_Page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  bool _isSidebarExpanded = true;

  int _selectedOpenItemTab = 0; // 0: PO, 1: Direct Purchase, 2: Transfer Out

  final Color primaryColor = const Color(0xFFF8BBD0);
  final Color accentColor = const Color(0xFFE91E63);
  final Color deepPink = const Color(0xFF880E4F);
  final Color lightPink = const Color(0xFFFCE4EC);

  // Dummy data untuk masing-masing tab
  final List<List<DataRow>> _openItemRows = [
    // PO
    [
      DataRow(
        cells: [
          DataCell(Text('PO-2024-0125')),
          DataCell(Text('15/03/2024')),
          DataCell(Text('PT Kurnia Alam')),
          DataCell(Text('Open', style: TextStyle(color: Colors.green))),
          DataCell(
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF880E4F),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text('Detail'),
            ),
          ),
        ],
      ),
    ],
    // Direct Purchase
    [
      DataRow(
        cells: [
          DataCell(Text('DP-2024-0001')),
          DataCell(Text('16/03/2024')),
          DataCell(Text('PT Direct Sukses')),
          DataCell(Text('Open', style: TextStyle(color: Colors.green))),
          DataCell(
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF880E4F),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text('Detail'),
            ),
          ),
        ],
      ),
    ],
    // Transfer Out
    [
      DataRow(
        cells: [
          DataCell(Text('TO-2024-0002')),
          DataCell(Text('17/03/2024')),
          DataCell(Text('PT Transfer Jaya')),
          DataCell(Text('Open', style: TextStyle(color: Colors.green))),
          DataCell(
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF880E4F),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text('Detail'),
            ),
          ),
        ],
      ),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isSidebarExpanded ? 250 : 70,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Logo dan Toggle Button
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: _isSidebarExpanded
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      if (_isSidebarExpanded)
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/images/icons-haus.png',
                            height: 40,
                            width: 40,
                          ),
                        ),
                      IconButton(
                        icon: Icon(
                          _isSidebarExpanded
                              ? Icons.chevron_left
                              : Icons.chevron_right,
                          color: deepPink,
                        ),
                        onPressed: () {
                          setState(() {
                            _isSidebarExpanded = !_isSidebarExpanded;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Menu Items
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildMenuItem(
                        icon: Icons.home,
                        title: 'Dashboard',
                        isSelected: _selectedIndex == 0,
                        onTap: () => setState(() => _selectedIndex = 0),
                      ),
                      _buildMenuItem(
                        icon: Icons.shopping_cart,
                        title: 'Direct Purchase',
                        isSelected: _selectedIndex == 1,
                        onTap: () {
                          setState(() => _selectedIndex = 1);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DirectPurchasePage()),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.assignment_turned_in,
                        title: 'GRPO',
                        isSelected: _selectedIndex == 2,
                        onTap: () {
                          setState(() => _selectedIndex = 2);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GRPO_Page()),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.request_page,
                        title: 'Material Request',
                        isSelected: _selectedIndex == 3,
                        onTap: () {
                          setState(() => _selectedIndex = 3);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MaterialRequestPage()),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.inventory,
                        title: 'Stock Opname',
                        isSelected: _selectedIndex == 4,
                        onTap: () {
                          setState(() => _selectedIndex = 4);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const StockOpnamePage()),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.compare_arrows,
                        title: 'Transfer Stock',
                        isSelected: _selectedIndex == 5,
                        onTap: () {
                          setState(() => _selectedIndex = 5);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TransferStockPage()),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.delete,
                        title: 'Waste',
                        isSelected: _selectedIndex == 6,
                        onTap: () {
                          setState(() => _selectedIndex = 6);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WastePage()),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _buildMenuItem(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        isSelected: _selectedIndex == 7,
                        onTap: () {
                          setState(() => _selectedIndex = 7);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage()),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.mail_outline,
                        title: 'Email',
                        isSelected: _selectedIndex == 8,
                        onTap: () {
                          setState(() => _selectedIndex = 8);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmailPage()),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        title: 'Help',
                        isSelected: _selectedIndex == 9,
                        onTap: () {
                          setState(() => _selectedIndex = 9);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HelpPage()),
                          );
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.person,
                        title: 'Profile',
                        isSelected: _selectedIndex == 10,
                        onTap: () {
                          setState(() => _selectedIndex = 10);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserprofilePage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(screenWidth),
                  const SizedBox(height: 130),
                  _buildTaskSection(),
                  const SizedBox(height: 60),
                  _buildOutstandingCards(),
                  const SizedBox(height: 40),
                  _buildOpenItemList(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? deepPink : Colors.grey,
      ),
      title: _isSidebarExpanded
          ? Text(
              title,
              style: GoogleFonts.poppins(
                color: isSelected ? deepPink : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            )
          : null,
      selected: isSelected,
      onTap: onTap,
      tileColor: isSelected ? lightPink.withOpacity(0.3) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: _isSidebarExpanded ? 20 : 0,
        vertical: 8,
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: screenWidth * 0.6,
          decoration: BoxDecoration(
            color: deepPink,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              _buildHeaderRow(),
              const SizedBox(height: 30),
              _buildWelcomeText(),
            ],
          ),
        ),
        Positioned(
          top: screenWidth * 0.45,
          left: 16,
          right: 16,
          child: _buildSearchBar(),
        ),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/icons-haus.png', height: 60, width: 60),
        _buildProfileIcons(),
      ],
    );
  }

  Widget _buildProfileIcons() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage()),
            );
          },
          child: const Icon(Icons.notifications, color: Colors.white),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmailPage()),
            );
          },
          child: const Icon(Icons.mail_outline, color: Colors.white),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserprofilePage()),
            );
          },
          child: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.jpg'),
            radius: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Welcome to the Dashboard',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
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
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: deepPink),
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _actionButton(Icons.shopping_cart, 'Purchasing'),
        _actionButton(Icons.assignment, 'Stock'),
        _actionButton(Icons.report, 'Report'),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: deepPink, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildTaskSection() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tasks",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Handle "Show All" press
                },
                child: Row(
                  children: [
                    Text(
                      "Show All",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_outward_rounded,
                      size: 14,
                      color: const Color.fromARGB(246, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTaskCard(
            "Stock Opname has not been performed",
            "12/03/2025 09:42",
            "High Priority",
            "Needs Attention",
          ),
          _buildTaskCard(
            "PO-2024-0125 awaiting acceptance from PTK",
            "12/03/2025 09:42",
            "Medium Priority",
            "Waiting for Action",
          ),
          _buildTaskCard(
            "PO-2025-0222 awaiting acceptance from PTK",
            "12/03/2025 09:42",
            "High Priority",
            "Needs Attention",
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(
    String taskTitle,
    String date,
    String priority,
    String status,
  ) {
    Color priorityColor;
    IconData priorityIcon;
    Color statusColor;
    String statusText;

    if (priority == "High Priority") {
      priorityColor = Colors.red;
      priorityIcon = Icons.error;
    } else if (priority == "Medium Priority") {
      priorityColor = Colors.orange;
      priorityIcon = Icons.warning;
    } else {
      priorityColor = Colors.green;
      priorityIcon = Icons.check_circle;
    }

    if (status == "Needs Attention") {
      statusColor = Colors.red;
      statusText = "Needs Attention";
    } else if (status == "Waiting for Action") {
      statusColor = Colors.orange;
      statusText = "Waiting for Action";
    } else {
      statusColor = Colors.green;
      statusText = "Resolved";
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(priorityIcon, color: priorityColor, size: 30),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        taskTitle,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      icon: Icon(Icons.chevron_right, color: Colors.grey),
                      onPressed: () {
                        // Handle task click (navigate or show details)
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey.withOpacity(0.3), thickness: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildOutstandingCards() {
    final List<Map<String, String>> items = [
      {'title': 'Outstanding PO', 'count': '5', 'icon': 'shopping_cart'},
      {'title': 'Outstanding Transfer Out', 'count': '3', 'icon': 'swap_horiz'},
      {
        'title': 'Outstanding Direct Purchase',
        'count': '2',
        'icon': 'local_mall',
      },
    ];

    final List<IconData> icons = [
      Icons.shopping_cart,
      Icons.swap_horiz,
      Icons.local_mall,
    ];

    final List<Color> gradients = [
      const Color(0xFFE91E63),
      const Color(0xFF42A5F5),
      const Color(0xFFFFB300),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(0),
        ),
        height: 200,
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.7),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      gradients[index].withOpacity(0.92),
                      gradients[index].withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: gradients[index].withOpacity(0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 18,
                      right: 18,
                      child: Icon(
                        icons[index],
                        color: Colors.white.withOpacity(0.18),
                        size: 60,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.18),
                            radius: 22,
                            child: Icon(
                              icons[index],
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            item['title']!,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['count']!,
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 18,
                      right: 18,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOpenItemList() {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      padding: EdgeInsets.all(screenWidth * 0.05),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Open Item List",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.045,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Handle Filter icon tap
                },
                child: Row(
                  children: [
                    Icon(Icons.filter_list, size: 16, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      "Filter",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: _buildTaskBar(),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: screenWidth - 32),
              child: DataTable(
                headingRowHeight: 50,
                columns: [
                  DataColumn(
                    label: SizedBox(
                      width: 100,
                      child: Text(
                        'PO Number',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 80,
                      child: Text(
                        'Date',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 120,
                      child: Text(
                        'Supplier',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 70,
                      child: Text(
                        'Status',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 70,
                      child: Text(
                        'Action',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                rows: _openItemRows[_selectedOpenItemTab],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Page on',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    splashRadius: 20,
                    onPressed: () {
                      // Handle previous page
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          '1',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: deepPink,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '2',
                          style: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '3',
                          style: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    splashRadius: 20,
                    onPressed: () {
                      // Handle next page
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskBar() {
    final tabLabels = ['PO', 'Direct Purchase', 'Transfer Out'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabLabels.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedOpenItemTab = i;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: _selectedOpenItemTab == i
                      ? deepPink
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedOpenItemTab == i
                        ? deepPink
                        : Colors.black12,
                  ),
                ),
                child: Text(
                  tabLabels[i],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _selectedOpenItemTab == i
                        ? Colors.white
                        : Colors.black54,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
} 










