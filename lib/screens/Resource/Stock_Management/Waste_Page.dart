import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Email_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Help_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Notification_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/DirectPurchasePage.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/GRPO_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialCalculate_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialRequest_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/StockOpname_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/TransferStock_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/UserProfile_Page.dart';
import 'package:miniproject_flutter/screens/DashboardPage.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/LoginPage.dart';

class WastePage extends StatefulWidget {
  final int selectedIndex;
  const WastePage({this.selectedIndex = 24, Key? key}) : super(key: key);

  @override
  _WastePageState createState() => _WastePageState();
}

class _WastePageState extends State<WastePage> {
  // Sidebar states & variables
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isProfileMenuOpen = false;
  bool _isStoreMenuOpen = false;
  int? _expandedMenuIndex;
  int? _hoveredIndex;
  int get _selectedIndex => widget.selectedIndex;

  final Color primaryColor = const Color(0xFFF8BBD0);
  final Color deepPink = const Color.fromARGB(255, 233, 30, 99);
  final Color lightPink = const Color(0xFFFCE4EC);

  // Konstanta untuk menu index
  static const int PURCHASING_MENU = 1;
  static const int STOCK_MANAGEMENT_MENU = 2;

  final AuthService _authService = AuthService();

  bool _isMainMenuActive(int index) {
    return _selectedIndex == index;
  }

  bool _isSubMenuActive(int index) {
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
            content: Text('Gagal logout:  ${e.toString()}'),
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
  void initState() {
    super.initState();
    // Set expanded menu otomatis sesuai submenu yang sedang selected
    if ([11, 12].contains(_selectedIndex)) {
      _expandedMenuIndex = PURCHASING_MENU;
    } else if ([21, 22, 23, 24, 25].contains(_selectedIndex)) {
      _expandedMenuIndex = STOCK_MANAGEMENT_MENU;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(child: _buildSidebar()),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color(0xFFE91E63),
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
              'Waste',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.mail_outline, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailPage()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isProfileMenuOpen = !_isProfileMenuOpen;
                    _isStoreMenuOpen = false;
                  });
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 16,
                  child: Text(
                    'J',
                    style: TextStyle(
                      color: Color(0xFFE91E63),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar & Filter
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFF8BBD0), Color(0xFFE91E63)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFE91E63).withOpacity(0.10),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFFE91E63),
                            size: 22,
                          ),
                          hintText: 'Cari waste',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 18,
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFF8BBD0), Color(0xFFE91E63)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFE91E63).withOpacity(0.10),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.filter_alt, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            // Taskbar for Pending/Approved
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isOutstandingSelected = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: isOutstandingSelected
                          ? LinearGradient(
                              colors: [Color(0xFFE91E63), Color(0xFFF8BBD0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isOutstandingSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFE91E63).withOpacity(0.08),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: isOutstandingSelected
                            ? Colors.transparent
                            : Color(0xFFE91E63),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      'Pending',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: isOutstandingSelected
                            ? Colors.white
                            : Color(0xFFE91E63),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isOutstandingSelected = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: !isOutstandingSelected
                          ? LinearGradient(
                              colors: [Color(0xFFE91E63), Color(0xFFF8BBD0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: !isOutstandingSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFE91E63).withOpacity(0.08),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: !isOutstandingSelected
                            ? Colors.transparent
                            : Color(0xFFE91E63),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      'Approved',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: !isOutstandingSelected
                            ? Colors.white
                            : Color(0xFFE91E63),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Card List
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: isOutstandingSelected
                      ? [
                          _buildWasteModernCard(
                            'SO-2024-0125',
                            '15/03/2024',
                            'HAUS Jakarta',
                            '1500',
                            'Pending Area Manager',
                          ),
                          _buildWasteModernCard(
                            'SO-2024-0125',
                            '15/03/2024',
                            'HAUS Jakarta',
                            '1500',
                            'Pending Area Manager',
                          ),
                          _buildWasteModernCard(
                            'SO-2024-0125',
                            '15/03/2024',
                            'HAUS Jakarta',
                            '1500',
                            'Pending Accounting',
                          ),
                        ]
                      : [
                          _buildWasteModernCard(
                            'WS-2023-3',
                            '15/03/2024',
                            'Outlet C',
                            '12',
                            'Approved Accounting ',
                          ),
                          _buildWasteModernCard(
                            'WS-2023-4',
                            '15/03/2024',
                            'Outlet D',
                            '7',
                            'Approved Accounting ',
                          ),
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Tooltip(
        message: "Add New Waste",
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFE91E63),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => Container(
                height: MediaQuery.of(context).size.height * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: _AddWasteModal(),
              ),
            );
          },
          child: Icon(Icons.add, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                      _navigateToPage(24);
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
    final isActive = _isMainMenuActive(index);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? lightPink.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive
                ? deepPink.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: isActive ? deepPink : Colors.grey, size: 20),
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
    final isActive = _isSubMenuActive(index);
    return MouseRegion(
      onEnter: (_) {
        if (!isActive) {
          setState(() => _hoveredIndex = index);
        }
      },
      onExit: (_) {
        if (!isActive) {
          setState(() => _hoveredIndex = null);
        }
      },
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
              color: isActive
                  ? deepPink.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
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
              setState(() {
                // Pastikan parent menu tetap expanded
                if ([11, 12].contains(index)) {
                  _expandedMenuIndex = PURCHASING_MENU;
                } else if ([21, 22, 23, 24, 25].contains(index)) {
                  _expandedMenuIndex = STOCK_MANAGEMENT_MENU;
                }
              });
              Navigator.pushReplacement(context, _getPageRouteByIndex(index));
              if (isMobile && closeDrawer != null) closeDrawer();
            }
          },
          dense: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
        ),
      ),
    );
  }

  Route _getPageRouteByIndex(int index) {
    switch (index) {
      case 0:
        return MaterialPageRoute(
          builder: (context) => DashboardPage(selectedIndex: 0),
        );
      case 11:
        return MaterialPageRoute(
          builder: (context) => DirectPurchasePage(selectedIndex: 11),
        );
      case 12:
        return MaterialPageRoute(
          builder: (context) => GRPO_Page(selectedIndex: 12),
        );
      case 21:
        return MaterialPageRoute(
          builder: (context) => MaterialRequestPage(selectedIndex: 21),
        );
      case 22:
        return MaterialPageRoute(
          builder: (context) => StockOpnamePage(selectedIndex: 22),
        );
      case 23:
        return MaterialPageRoute(
          builder: (context) => TransferStockPage(selectedIndex: 23),
        );
      case 24:
        return MaterialPageRoute(
          builder: (context) => WastePage(selectedIndex: 24),
        );
      case 25:
        return MaterialPageRoute(
          builder: (context) => MaterialCalculatePage(selectedIndex: 25),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => DirectPurchasePage(selectedIndex: 11),
        );
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

  // Tambahkan widget card baru
  Widget _buildWasteModernCard(
    String docNo,
    String date,
    String outlet,
    String qty,
    String status,
  ) {
    Color badgeColor;
    Color badgeTextColor;
    IconData badgeIcon;
    if (status == 'Pending Area Manager') {
      badgeColor = Colors.yellow[200]!;
      badgeTextColor = Colors.amber[800]!;
      badgeIcon = Icons.pending_actions;
    } else if (status == 'Pending Accounting') {
      badgeColor = Colors.purple[100]!;
      badgeTextColor = Colors.purple[800]!;
      badgeIcon = Icons.pending_actions;
    } else if (status.trim() == 'Approved Accounting') {
      badgeColor = Color(0xFFC8E6C9);
      badgeTextColor = Color(0xFF388E3C);
      badgeIcon = Icons.verified_rounded;
    } else {
      badgeColor = Color(0xFFF8BBD0);
      badgeTextColor = Color(0xFFE91E63);
      badgeIcon = Icons.info_outline_rounded;
    }
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      child: SizedBox(
        height: 180,
        child: Stack(
          children: [
            // Badge status kanan atas
            Positioned(
              top: 18,
              right: 24,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 120),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: badgeColor.withOpacity(0.18),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(badgeIcon, color: badgeTextColor, size: 15),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        status,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          color: badgeTextColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Tombol detail kanan bawah
            Positioned(
              bottom: 18,
              right: 24,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFFE91E63),
                  size: 18,
                ),
                label: Text(
                  'Detail',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE91E63),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide(color: Color(0xFFE91E63), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  elevation: 0,
                  minimumSize: Size(120, 44),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
            // Data isi kiri di atas secara vertikal
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 180, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'No. Doc: ',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE91E63),
                            fontSize: 14,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            docNo,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Color(0xFFE91E63),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Date Picker: ',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.grey[800],
                          ),
                        ),
                        Flexible(
                          child: Text(
                            date,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[800],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Outlet: ',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.grey[800],
                          ),
                        ),
                        Flexible(
                          child: Text(
                            outlet,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[800],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Qty: ',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.grey[900],
                          ),
                        ),
                        Flexible(
                          child: Text(
                            qty,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[900],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddWasteModal extends StatefulWidget {
  @override
  State<_AddWasteModal> createState() => _AddWasteModalState();
}

class _AddWasteModalState extends State<_AddWasteModal> {
  final TextEditingController _docController = TextEditingController(
    text: 'GI - 1234',
  );
  final TextEditingController _dateController = TextEditingController(
    text: '15/03/2025',
  );
  final TextEditingController _preparedByController = TextEditingController(
    text: 'John Doe',
  );
  final TextEditingController _remarksController = TextEditingController();
  List<Map<String, dynamic>> _items = [
    {
      'code': 'BV-001',
      'name': 'Bubuk Vanilla',
      'qty': 100,
      'uom': 'PCS',
      'notes': 'Expired',
    },
  ];
  final List<String> _itemCodes = ['BV-001', 'BV-002'];
  final List<String> _itemNames = ['Bubuk Vanilla', 'Bubuk Coklat'];
  final List<String> _uoms = ['PCS', 'GR', 'ML'];
  final List<String> _notes = ['Expired', 'Rusak', 'Lainnya'];
  String? _fileName;
  final Color deepPink = const Color.fromARGB(255, 233, 30, 99);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Center(
              child: Text(
                'Add New Waste',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: Color.fromARGB(255, 230, 230, 230)),
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    title: 'Waste Information',
                    icon: Icons.info_outline,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildModernTextField(
                              label: 'No. Doc',
                              controller: _docController,
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildModernTextField(
                              label: 'Waste Date',
                              controller: _dateController,
                              readOnly: true,
                              prefixIcon: Icons.calendar_today,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildModernTextField(
                        label: 'Prepared by',
                        controller: _preparedByController,
                        readOnly: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Item',
                    icon: Icons.inventory_2_outlined,
                    children: [
                      ..._items.asMap().entries.map((entry) {
                        int idx = entry.key;
                        var item = entry.value;
                        return _buildItemCard(idx, item);
                      }).toList(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: _items.length > 1
                                ? () => setState(() => _items.removeLast())
                                : null,
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text(
                              'Remove Item',
                              style: TextStyle(color: Colors.red),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                          const Spacer(),
                          FilledButton.icon(
                            onPressed: () {
                              setState(() {
                                _items.add({
                                  'code': _itemCodes.first,
                                  'name': _itemNames.first,
                                  'qty': 1,
                                  'uom': _uoms.first,
                                  'notes': _notes.first,
                                });
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add Item'),
                            style: FilledButton.styleFrom(
                              backgroundColor: deepPink,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Upload & Remarks',
                    icon: Icons.upload_file,
                    children: [
                      _buildFileUploadSection(),
                      const SizedBox(height: 16),
                      _buildModernTextField(
                        label: 'Remarks',
                        controller: _remarksController,
                        maxLines: 3,
                        hint: 'Enter reason / remarks',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1D8FB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Color(0xFF7C3AED)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Waste will require approval from the Area Manager and Supply Chain before being processed.',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Color(0xFF7C3AED),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomButtons(context, deepPink),
        ],
      ),
    );
  }

  Widget _buildItemCard(int idx, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: item['code'],
                  isExpanded: true,
                  items: _itemCodes
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => item['code'] = val),
                  decoration: InputDecoration(
                    labelText: 'Item Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: item['name'],
                  isExpanded: true,
                  items: _itemNames
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => item['name'] = val),
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: item['qty'].toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Qty',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (val) =>
                      setState(() => item['qty'] = int.tryParse(val) ?? 1),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: item['uom'],
                  isExpanded: true,
                  items: _uoms
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => item['uom'] = val),
                  decoration: InputDecoration(
                    labelText: 'UoM',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: item['notes'],
                  isExpanded: true,
                  items: _notes
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => item['notes'] = val),
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required String label,
    TextEditingController? controller,
    bool readOnly = false,
    IconData? prefixIcon,
    int maxLines = 1,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint ?? 'Enter $label',
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[400],
              fontSize: 13,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: Colors.grey[600])
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: deepPink),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload file',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Icon(Icons.attach_file, color: Colors.grey[600]),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _fileName ?? 'Choose File...',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Supported formats: JPG, PNG, PDF (Max. 5MB)',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: deepPink, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, Color deepPink) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey[300]!),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: deepPink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                shadowColor: deepPink.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
