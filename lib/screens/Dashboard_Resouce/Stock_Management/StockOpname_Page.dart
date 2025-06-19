import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Auth/Help_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Purchasing/DirectPurchase_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Purchasing/GRPO_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/MaterialCalculate_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/MaterialRequest_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/TransferStock_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/Waste_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Auth/UserProfile_Page.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Auth/LoginPage.dart';

class StockOpnamePage extends StatefulWidget {
  final int selectedIndex;
  const StockOpnamePage({this.selectedIndex = 22, Key? key}) : super(key: key);

  @override
  _StockOpnamePageState createState() => _StockOpnamePageState();
}

class _StockOpnamePageState extends State<StockOpnamePage> {
  // Sidebar states & variables
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isProfileMenuOpen = false;
  bool _isStoreMenuOpen = false;
  int? _expandedMenuIndex;
  int get _selectedIndex => widget.selectedIndex;

  final Color primaryColor = const Color(0xFFF8BBD0);
  final Color deepPink = const Color.fromARGB(255, 233, 30, 99);
  final Color lightPink = const Color(0xFFFCE4EC);

  // Konstanta untuk menu index
  static const int PURCHASING_MENU = 1;
  static const int STOCK_MANAGEMENT_MENU = 2;

  final AuthService _authService = AuthService();

  int? _hoveredIndex;
  bool _isMenuActive(int index) {
    return _selectedIndex == index || _hoveredIndex == index;
  }

  void _toggleMenu(int menuIndex) {
    setState(() {
      if (_expandedMenuIndex == menuIndex) {
        _expandedMenuIndex = null;
      } else {
        _expandedMenuIndex = menuIndex;
      }
    });
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
            content: Text('Gagal logout: [${e.toString()}'),
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

  bool isOutstandingSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(child: _buildSidebar()),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE91E63), Color(0xFFFF4081)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFE91E63).withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Stock Opname',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: Icon(Icons.filter_alt, color: Colors.white, size: 20),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFF8F9FA),
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
                      color: Colors.grey.withOpacity(0.06),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  style: GoogleFonts.poppins(fontSize: 13),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Color(0xFFE91E63), size: 20),
                    hintText: 'Search by DocNum, Date, Outlet, or Status',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
            ),
            // Taskbar for Outstanding and Approved
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.06),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isOutstandingSelected = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isOutstandingSelected
                              ? Color(0xFFE91E63)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Ongoing',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: isOutstandingSelected
                                ? Colors.white
                                : Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isOutstandingSelected = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !isOutstandingSelected
                              ? Color(0xFFE91E63)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Completed',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: !isOutstandingSelected
                                ? Colors.white
                                : Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Display content based on the selected tab (Outstanding or Approved)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: isOutstandingSelected
                      ? [
                          _buildStockOpnameCard(
                            docNum: 'SO-2023-1',
                            date: '2023-06-01',
                            outlet: 'Outlet A',
                            qty: '10',
                            status: 'Pending',
                          ),
                          _buildStockOpnameCard(
                            docNum: 'SO-2023-2',
                            date: '2023-06-02',
                            outlet: 'Outlet B',
                            qty: '8',
                            status: 'Pending',
                          ),
                          _buildStockOpnameCard(
                            docNum: 'SO-2023-3',
                            date: '2023-06-03',
                            outlet: 'Outlet C',
                            qty: '5',
                            status: 'Pending',
                          ),
                        ]
                      : [
                          _buildStockOpnameCard(
                            docNum: 'SO-2023-4',
                            date: '2023-05-28',
                            outlet: 'Outlet D',
                            qty: '12',
                            status: 'Completed',
                          ),
                          _buildStockOpnameCard(
                            docNum: 'SO-2023-5',
                            date: '2023-05-30',
                            outlet: 'Outlet E',
                            qty: '7',
                            status: 'Completed',
                          ),
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE91E63), Color(0xFFFF4081)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFE91E63).withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => _StockOpnameModal(),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add, size: 24),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
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
                const SizedBox(width: 12),
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
          _buildStoreDropdown(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
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
                      _navigateToPage(0);
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
                      _navigateToPage(11);
                    },
                    isMobile: true,
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
                      _navigateToPage(22);
                    },
                    isMobile: true,
                  ),
                  _buildMenuItem(
                    icon: Icons.assessment_outlined,
                    title: 'Inventory Report',
                    index: 3,
                    onTap: () {
                      _navigateToPage(3);
                    },
                  ),
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
                      _navigateToPage(4);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Help',
                    index: 5,
                    onTap: () {
                      _navigateToPage(5);
                    },
                  ),
                ],
              ),
            ),
          ),
          _buildProfileDropdown(),
        ],
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
    bool isMobile = false,
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
        if (isMenuExpanded)
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
        return MaterialPageRoute(builder: (context) => DirectPurchasePage(selectedIndex: 0));
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
            builder: (context) => DirectPurchasePage(selectedIndex: 0),
          ),
        );
        break;
      case 11: // Direct Purchase
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DirectPurchasePage(selectedIndex: 11)),
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
          MaterialPageRoute(builder: (context) => MaterialRequestPage(selectedIndex: 21)),
        );
        break;
      case 22: // Stock Opname
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StockOpnamePage(selectedIndex: 22)),
        );
        break;
      case 23: // Transfer Stock
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TransferStockPage(selectedIndex: 23)),
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
          MaterialPageRoute(builder: (context) => MaterialCalculatePage(selectedIndex: 25)),
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

  // Helper function to build the card layout for each direct purchase item
  Widget _buildStockOpnameCard({
    required String docNum,
    required String date,
    required String outlet,
    required String qty,
    required String status,
  }) {
    Color statusColor = status == "Completed"
        ? Colors.green[600]!
        : status == "Pending"
            ? Colors.orange[600]!
            : Color(0xFFE91E63);

    Color statusBg = status == "Completed"
        ? Colors.green[50]!
        : status == "Pending"
            ? Colors.orange[50]!
            : Color(0xFFE91E63).withOpacity(0.08);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: Color(0xFFE91E63), size: 20),
                const SizedBox(width: 8),
                Text(
                  docNum,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFFE91E63),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[600], size: 16),
                const SizedBox(width: 8),
                Text(
                  "Date: ",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.store, color: Colors.grey[600], size: 16),
                const SizedBox(width: 8),
                Text(
                  "Outlet: ",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                Text(
                  outlet,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.confirmation_number, color: Colors.grey[600], size: 16),
                const SizedBox(width: 8),
                Text(
                  "Qty: ",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                Text(
                  qty,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        status == "Completed"
                            ? Icons.check_circle
                            : status == "Pending"
                                ? Icons.pending
                                : Icons.info,
                        color: statusColor,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        status,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFFE91E63),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  icon: Icon(Icons.info_outline, size: 16),
                  label: Text(
                    'Detail',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StockOpnameModal extends StatefulWidget {
  @override
  State<_StockOpnameModal> createState() => _StockOpnameModalState();
}

class _StockOpnameModalState extends State<_StockOpnameModal> {
  String? _noStockOpname = '';
  DateTime? _stockOpnameDate = DateTime.now();
  DateTime? _inputStockOpnameDate = DateTime.now();
  String? _countedBy = '';
  String? _preparedBy = 'John Doe';
  String? _outlet = 'Haus Jakarta';
  List<Map<String, dynamic>> _items = [
    {'code': 'BV-001', 'name': 'Boba', 'qty': 100, 'uom': 'gram'},
  ];

  final List<String> _itemCodes = ['BV-001', 'BV-002', 'BV-003'];
  final List<String> _itemNames = ['Boba', 'Cincau', 'Susu'];
  final List<String> _uoms = ['gram', 'pcs', 'ml'];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add New Stock Opname',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'No. Stock Opname',
                        hint: 'SO - 1234',
                        onChanged: (v) => setState(() => _noStockOpname = v),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'Stock Opname Date',
                        hint: _stockOpnameDate != null
                            ? _stockOpnameDate!.toString().substring(0, 10)
                            : 'Select Date',
                        readOnly: true,
                        suffixIcon: Icons.calendar_today,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _stockOpnameDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => _stockOpnameDate = picked);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Input Stock Opname Date',
                        hint: _inputStockOpnameDate != null
                            ? _inputStockOpnameDate!.toString().substring(0, 10)
                            : 'Select Date',
                        readOnly: true,
                        suffixIcon: Icons.calendar_today,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _inputStockOpnameDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => _inputStockOpnameDate = picked);
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'Counted By',
                        hint: 'Emy',
                        onChanged: (v) => setState(() => _countedBy = v),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Prepared by',
                        hint: _preparedBy,
                        readOnly: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'Outlet/Store',
                        hint: _outlet,
                        readOnly: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Text('Item', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ..._items.asMap().entries.map((entry) {
                        int idx = entry.key;
                        var item = entry.value;
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            bool isMobile = constraints.maxWidth < 500;
                            if (isMobile) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: _modernLabeledDropdown(
                                            label: 'Item Code',
                                            hint: 'Pilih kode barang',
                                            value: item['code'],
                                            items: _itemCodes,
                                            onChanged: (v) => setState(() => _items[idx]['code'] = v),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          flex: 2,
                                          child: _modernLabeledDropdown(
                                            label: 'Item Name',
                                            hint: 'Pilih nama barang',
                                            value: item['name'],
                                            items: _itemNames,
                                            onChanged: (v) => setState(() => _items[idx]['name'] = v),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: _modernLabeledInput(
                                            label: 'Qty',
                                            hint: 'Jumlah',
                                            value: item['qty'].toString(),
                                            keyboardType: TextInputType.number,
                                            onChanged: (v) => setState(() => _items[idx]['qty'] = int.tryParse(v) ?? 1),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          flex: 1,
                                          child: _modernLabeledInput(
                                            label: 'UoM',
                                            hint: 'Satuan',
                                            value: item['uom'],
                                            readOnly: true,
                                            fillColor: Colors.grey[200],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: _modernLabeledDropdown(
                                        label: 'Item Code',
                                        hint: 'Pilih kode barang',
                                        value: item['code'],
                                        items: _itemCodes,
                                        onChanged: (v) => setState(() => _items[idx]['code'] = v),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      flex: 2,
                                      child: _modernLabeledDropdown(
                                        label: 'Item Name',
                                        hint: 'Pilih nama barang',
                                        value: item['name'],
                                        items: _itemNames,
                                        onChanged: (v) => setState(() => _items[idx]['name'] = v),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      flex: 1,
                                      child: _modernLabeledInput(
                                        label: 'Qty',
                                        hint: 'Jumlah',
                                        value: item['qty'].toString(),
                                        keyboardType: TextInputType.number,
                                        onChanged: (v) => setState(() => _items[idx]['qty'] = int.tryParse(v) ?? 1),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      flex: 1,
                                      child: _modernLabeledInput(
                                        label: 'UoM',
                                        hint: 'Satuan',
                                        value: item['uom'],
                                        readOnly: true,
                                        fillColor: Colors.grey[200],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      }).toList(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            bool isMobile = constraints.maxWidth < 500;
                            if (isMobile) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      if (_items.isNotEmpty) {
                                        setState(() => _items.removeLast());
                                      }
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    label: Text('Delete item', style: GoogleFonts.poppins(color: Colors.red)),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.red),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _items.add({'code': _itemCodes.first, 'name': _itemNames.first, 'qty': 1, 'uom': _uoms.first});
                                      });
                                    },
                                    icon: Icon(Icons.add, color: Color(0xFFE91E63)),
                                    label: Text('Add item', style: GoogleFonts.poppins(color: Color(0xFFE91E63))),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Color(0xFFE91E63)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        if (_items.isNotEmpty) {
                                          setState(() => _items.removeLast());
                                        }
                                      },
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      label: Text('Delete item', style: GoogleFonts.poppins(color: Colors.red)),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.red),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _items.add({'code': _itemCodes.first, 'name': _itemNames.first, 'qty': 1, 'uom': _uoms.first});
                                        });
                                      },
                                      icon: Icon(Icons.add, color: Color(0xFFE91E63)),
                                      label: Text('Add item', style: GoogleFonts.poppins(color: Color(0xFFE91E63))),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Color(0xFFE91E63)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel', style: GoogleFonts.poppins(color: Color(0xFFE91E63), fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE91E63),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      ),
                      child: Text('Add', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    String? hint,
    bool readOnly = false,
    Color? fillColor,
    IconData? suffixIcon,
    void Function()? onTap,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
        SizedBox(height: 6),
        TextField(
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 18) : null,
            filled: fillColor != null,
            fillColor: fillColor,
          ),
        ),
      ],
    );
  }

  Widget _modernLabeledInput({
    required String label,
    String? hint,
    String? value,
    TextInputType? keyboardType,
    bool readOnly = false,
    Color? fillColor,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF6B7280))),
        SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          keyboardType: keyboardType,
          readOnly: readOnly,
          style: GoogleFonts.poppins(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            filled: fillColor != null,
            fillColor: fillColor,
          ),
        ),
      ],
    );
  }

  Widget _modernLabeledDropdown({
    required String label,
    String? hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF6B7280))),
        SizedBox(height: 4),
        Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              filled: true,
              fillColor: Colors.grey[100],
              hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400]),
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
            icon: Icon(Icons.arrow_drop_down, size: 18),
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              filled: true,
              fillColor: Colors.grey[100],
              hintText: hint,
              hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400]),
              constraints: BoxConstraints(minHeight: 44),
            ),
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
            dropdownColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
