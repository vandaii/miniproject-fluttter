import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Purchasing/GRPO_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/MaterialCalculate_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/StockOpname_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/TransferStock_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/MaterialRequest_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Auth/UserProfile_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Auth/Help_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/Waste_Page.dart';
import 'package:miniproject_flutter/screens/dashboard_page_new.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Auth/LoginPage.dart';

class DirectPurchasePage extends StatefulWidget {
  final int selectedIndex;
  const DirectPurchasePage({this.selectedIndex = 11, Key? key})
    : super(key: key);

  @override
  _DirectPurchasePageState createState() => _DirectPurchasePageState();
}

class _DirectPurchasePageState extends State<DirectPurchasePage> {
  bool isOutstandingSelected =
      true; // Track selected tab (Outstanding or Approved)
  bool _isSidebarExpanded = true;
  bool _isProfileMenuOpen = false;
  bool _isStoreMenuOpen = false;
  int? _expandedMenuIndex;
  late int _selectedIndex;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  final Color primaryColor = const Color(0xFFF8BBD0);
  final Color deepPink = const Color.fromARGB(255, 233, 30, 99);
  final Color lightPink = const Color(0xFFFCE4EC);

  static const int PURCHASING_MENU = 1;
  static const int STOCK_MANAGEMENT_MENU = 2;

  final AuthService _authService = AuthService();

  bool _isMenuActive(int index) {
    return _selectedIndex == index || _hoveredIndex == index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'Direct Purchase',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: const Color(0xFF880E4F),
          elevation: 4,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(Icons.filter_alt, color: Colors.white),
                onPressed: () {
                  // Filter action here
                },
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // Logo dan nama aplikasi
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/icons-haus.png',
                      height: 36,
                      width: 36,
                    ),
                    if (_isSidebarExpanded) const SizedBox(width: 12),
                    if (_isSidebarExpanded)
                      Text(
                        'haus! Inventory',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: deepPink,
                        ),
                      ),
                  ],
                ),
              ),
              // Info toko dengan dropdown
              if (_isSidebarExpanded) _buildStoreDropdown(),

              // Menu Items dengan Expanded
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Section GENERAL
                      if (_isSidebarExpanded)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                          child: Row(
                            children: [
                              Text(
                                'GENERAL',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                height: 1,
                                width: 100,
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ],
                          ),
                        ),
                      _buildMenuItem(
                        icon: Icons.dashboard_outlined,
                        title: 'Dashboard',
                        index: 0,
                        onTap: () {
                          if (_selectedIndex != 0) {
                            _navigateToPage(0);
                          }
                        },
                      ),
                      _buildExpandableMenu(
                        icon: Icons.shopping_cart_outlined,
                        title: 'Purchasing',
                        isExpanded: _selectedIndex == PURCHASING_MENU,
                        menuIndex: PURCHASING_MENU,
                        children: [
                          _buildSubMenuItem('Direct Purchase', 11),
                          _buildSubMenuItem('GRPO', 12),
                        ],
                        onTap: () {
                          if (_selectedIndex != PURCHASING_MENU) {
                            _navigateToPage(PURCHASING_MENU);
                          }
                        },
                      ),
                      _buildExpandableMenu(
                        icon: Icons.inventory_2_outlined,
                        title: 'Stock Management',
                        isExpanded: _selectedIndex == STOCK_MANAGEMENT_MENU,
                        menuIndex: STOCK_MANAGEMENT_MENU,
                        children: [
                          _buildSubMenuItem('Material Request', 21),
                          _buildSubMenuItem('Material Calculate', 25),
                          _buildSubMenuItem('Stock Opname', 22),
                          _buildSubMenuItem('Transfer Stock', 23),
                          _buildSubMenuItem('Waste', 24),
                        ],
                        onTap: () {
                          if (_selectedIndex != STOCK_MANAGEMENT_MENU) {
                            _navigateToPage(STOCK_MANAGEMENT_MENU);
                          }
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.assessment_outlined,
                        title: 'Inventory Report',
                        index: 3,
                        onTap: () {
                          if (_selectedIndex != 3) {
                            _navigateToPage(3);
                          }
                        },
                      ),
                      // Section TOOLS
                      if (_isSidebarExpanded)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                          child: Row(
                            children: [
                              Text(
                                'TOOLS',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                height: 1,
                                width: 100,
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ],
                          ),
                        ),
                      _buildMenuItem(
                        icon: Icons.settings_outlined,
                        title: 'Account & Settings',
                        index: 4,
                        onTap: () {
                          if (_selectedIndex != 4) {
                            _navigateToPage(4);
                          }
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        title: 'Help',
                        index: 5,
                        onTap: () {
                          if (_selectedIndex != 5) {
                            _navigateToPage(5);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // User profile dengan dropdown (selalu di bawah)
              if (_isSidebarExpanded) _buildProfileDropdown(),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar Section
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    hintText: 'Search Direct Purchases',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
            ),
            // Taskbar for Outstanding and Approved
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Outstanding Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isOutstandingSelected = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    width: 170,
                    decoration: BoxDecoration(
                      color: isOutstandingSelected
                          ? Color(0xFF880E4F)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isOutstandingSelected
                            ? Colors.transparent
                            : Colors.grey[400]!,
                      ),
                    ),
                    child: Text(
                      'Outstanding',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: isOutstandingSelected
                            ? Colors.white
                            : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Approved Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isOutstandingSelected = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    width: 170,
                    decoration: BoxDecoration(
                      color: !isOutstandingSelected
                          ? Color(0xFF880E4F)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: !isOutstandingSelected
                            ? Colors.transparent
                            : Colors.grey[400]!,
                      ),
                    ),
                    child: Text(
                      'Approved',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: !isOutstandingSelected
                            ? Colors.white
                            : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Display content based on the selected tab (Outstanding or Approved)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: isOutstandingSelected
                      ? [
                          _buildDirectPurchaseCard(
                            'DP-2023-1',
                            'Supplier 1',
                            'Rp 1.000.000',
                            'Pending',
                          ),
                          _buildDirectPurchaseCard(
                            'DP-2023-2',
                            'Supplier 2',
                            'Rp 1.000.000',
                            'Pending',
                          ),
                          _buildDirectPurchaseCard(
                            'DP-2023-3',
                            'Supplier 3',
                            'Rp 1.000.000',
                            'Pending',
                          ),
                        ]
                      : [
                          _buildDirectPurchaseCard(
                            'DP-2023-4',
                            'Supplier 4',
                            'Rp 2.000.000',
                            'Approved',
                          ),
                          _buildDirectPurchaseCard(
                            'DP-2023-5',
                            'Supplier 5',
                            'Rp 2.500.000',
                            'Approved',
                          ),
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Tooltip(
        message: "Add New Direct Purchase",
        child: FloatingActionButton(
          onPressed: () {
            // Action to add a new direct purchase
          },
          backgroundColor: const Color(0xFF880E4F),
          child: Icon(Icons.add, size: 30), // + icon
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Helper function to build the card layout for each direct purchase item
  Widget _buildDirectPurchaseCard(
    String id,
    String supplier,
    String total,
    String status,
  ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16), // Space between cards
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No. $id',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF880E4F), // Accent color for item number
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Supplier: $supplier',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              total,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: status == 'Pending'
                    ? Colors.orange[200]
                    : Colors.green[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: status == 'Pending'
                      ? Colors.orange[700]
                      : Colors.green[700],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF880E4F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text('Detail'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required int index,
    required VoidCallback onTap,
  }) {
    final isActive = _isMenuActive(index);
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? lightPink.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? deepPink.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isActive ? deepPink : Colors.grey,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              color: isActive ? deepPink : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
          selected: isActive,
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          dense: true,
        ),
      ),
    );
  }

  Widget _buildExpandableMenu({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required List<Widget> children,
    required VoidCallback onTap,
    required int menuIndex,
  }) {
    final isMenuExpanded = _expandedMenuIndex == menuIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isExpanded ? lightPink.withOpacity(0.3) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isExpanded
                    ? deepPink.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isExpanded ? deepPink : Colors.grey,
                size: 20,
              ),
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                color: isExpanded ? deepPink : Colors.grey,
                fontWeight: isExpanded ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            trailing: Icon(
              isMenuExpanded ? Icons.expand_less : Icons.expand_more,
              color: isExpanded ? deepPink : Colors.grey,
            ),
            onTap: () {
              setState(() {
                if (_expandedMenuIndex == menuIndex) {
                  _expandedMenuIndex = null;
                } else {
                  _expandedMenuIndex = menuIndex;
                }
              });
            },
            dense: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
        ),
        if (isMenuExpanded && _isSidebarExpanded)
          Container(
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
      ],
    );
  }

  Widget _buildSubMenuItem(
    String title,
    int index, {
    bool isMobile = false,
    VoidCallback? closeDrawer,
  }) {
    final isActive = _isMenuActive(index);
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
        decoration: BoxDecoration(
          color: isActive ? lightPink.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? deepPink.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getSubMenuIcon(index),
              color: isActive ? deepPink : Colors.grey,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isActive ? deepPink : Colors.black87,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selected: isActive,
          onTap: () {
            if (_selectedIndex != index) {
              Navigator.pushReplacement(
                context,
                _getPageRouteByIndex(index),
              );
              if (isMobile && closeDrawer != null) closeDrawer();
            }
          },
          dense: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      ),
    );
  }

  Route _getPageRouteByIndex(int index) {
    switch (index) {
      case 0:
        return MaterialPageRoute(builder: (context) => DashboardPage(selectedIndex :0));
      case 11:
        return MaterialPageRoute(builder: (context) => DirectPurchasePage(selectedIndex: 11));
      case 12:
        return MaterialPageRoute(builder: (context) => GRPO_Page(selectedIndex: 12));
      case 21:
        return MaterialPageRoute(builder: (context) => MaterialRequestPage(selectedIndex: 21));
      case 22:
        return MaterialPageRoute(builder: (context) => StockOpnamePage(selectedIndex: 22));
      case 23:
        return MaterialPageRoute(builder: (context) => TransferStockPage(selectedIndex: 23));
      case 24:
        return MaterialPageRoute(builder: (context) => WastePage(selectedIndex: 24));
      case 25:
        return MaterialPageRoute(builder: (context) => MaterialCalculatePage(selectedIndex: 25));
      default:
        return MaterialPageRoute(builder: (context) => DirectPurchasePage(selectedIndex: 11));
    }
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0: // Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(selectedIndex: 0),
          ),
        );
        break;
      case 11: // Direct Purchase
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DirectPurchasePage(selectedIndex: 11),
          ),
        );
        break;
      case 12: // GRPO
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GRPO_Page(selectedIndex: 12)),
        );
        break;
      case 21: // Material Request
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MaterialRequestPage(selectedIndex: 21),
          ),
        );
        break;
      case 22: // Stock Opname
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StockOpnamePage(selectedIndex: 22),
          ),
        );
        break;
      case 23: // Transfer Stock
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransferStockPage(selectedIndex: 23),
          ),
        );
        break;
      case 24: // Waste
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WastePage(selectedIndex: 24)),
        );
        break;
      case 25: // Material Calculate
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MaterialCalculatePage(selectedIndex: 25),
          ),
        );
        break;
    }
  }

  IconData _getSubMenuIcon(int index) {
    switch (index) {
      case 11: // Direct Purchase
        return Icons.shopping_cart_outlined;
      case 12: // GRPO
        return Icons.receipt_long_outlined;
      case 21: // Material Request
        return Icons.inventory_2_outlined;
      case 22: // Stock Opname
        return Icons.checklist_rtl_outlined;
      case 23: // Transfer Stock
        return Icons.swap_horiz_outlined;
      case 24: // Waste
        return Icons.delete_outline;
      case 25: //material calculate
        return Icons.inventory_2_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  Widget _buildStoreDropdown() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightPink,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: deepPink.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isStoreMenuOpen = !_isStoreMenuOpen;
                _isProfileMenuOpen = false;
              });
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: deepPink.withOpacity(0.1),
                  child: Icon(Icons.store, color: deepPink),
                  radius: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Toko',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        'HAUS Jakarta',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isStoreMenuOpen ? Icons.expand_less : Icons.expand_more,
                  color: deepPink,
                ),
              ],
            ),
          ),
          if (_isStoreMenuOpen)
            Container(
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  _buildStoreMenuItem('HAUS Jakarta', true),
                  _buildStoreMenuItem('HAUS Bandung', false),
                  _buildStoreMenuItem('HAUS Surabaya', false),
                  _buildStoreMenuItem('HAUS Medan', false),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStoreMenuItem(String storeName, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? lightPink.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        title: Text(
          storeName,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? deepPink : Colors.black87,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: deepPink, size: 18)
            : null,
        onTap: () {
          setState(() {
            _isStoreMenuOpen = false;
          });
        },
      ),
    );
  }

  Widget _buildProfileDropdown() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightPink,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: deepPink.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isProfileMenuOpen = !_isProfileMenuOpen;
                _isStoreMenuOpen = false;
              });
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: deepPink,
                  child: Text('J', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Admin',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isProfileMenuOpen ? Icons.expand_less : Icons.expand_more,
                  color: deepPink,
                ),
              ],
            ),
          ),
          if (_isProfileMenuOpen)
            Container(
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  _buildProfileMenuItem(
                    Icons.person_outline,
                    'Profile',
                    onTap: () {
                      setState(() => _isProfileMenuOpen = false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserprofilePage(),
                        ),
                      );
                    },
                  ),
                  _buildProfileMenuItem(
                    Icons.settings_outlined,
                    'Settings',
                    onTap: () {
                      setState(() => _isProfileMenuOpen = false);
                    },
                  ),
                  _buildProfileMenuItem(
                    Icons.help_outline,
                    'Help & Support',
                    onTap: () {
                      setState(() => _isProfileMenuOpen = false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpPage()),
                      );
                    },
                  ),
                  _buildProfileMenuItem(
                    Icons.logout,
                    'Logout',
                    isLogout: true,
                    onTap: () async {
                      setState(() => _isProfileMenuOpen = false);
                      await _handleLogout();
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem(
    IconData icon,
    String title, {
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          size: 20,
          color: isLogout ? Colors.red : Colors.black87,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Future<void> _handleLogout() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      await _authService.logout();

      if (mounted) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil logout'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal logout: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }
}
