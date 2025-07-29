import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/DirectPurchasePage.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/GRPO_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialRequest_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialCalculate_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/StockOpname_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/TransferStock_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/Waste_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/UserProfile_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Help_Page.dart';

class SidebarWidget extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onMenuTap;
  final bool isSidebarExpanded;
  final int? expandedMenuIndex;
  final Function(int) onToggleMenu;
  final Color deepPink;
  final Color lightPink;
  final bool isMobile;
  final VoidCallback? closeDrawer;
  final VoidCallback? onLogout;

  const SidebarWidget({
    Key? key,
    required this.selectedIndex,
    required this.onMenuTap,
    required this.isSidebarExpanded,
    required this.expandedMenuIndex,
    required this.onToggleMenu,
    required this.deepPink,
    required this.lightPink,
    this.isMobile = false,
    this.closeDrawer,
    this.onLogout,
  }) : super(key: key);

  // Static const for menu index
  static const int PURCHASING_MENU = 1;
  static const int STOCK_MANAGEMENT_MENU = 2;

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  bool _isStoreMenuOpen = false;
  bool _isProfileMenuOpen = false;
  String _selectedStore = 'HAUS Jakarta';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Logo dan nama aplikasi
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isMobile ? 16 : 20,
              vertical: 24,
            ),
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
                if (widget.isSidebarExpanded || widget.isMobile)
                  const SizedBox(width: 12),
                if (widget.isSidebarExpanded || widget.isMobile)
                  Text(
                    'haus! Inventory',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: widget.deepPink,
                    ),
                  ),
              ],
            ),
          ),
          if (widget.isSidebarExpanded || widget.isMobile)
            _buildStoreDropdown(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Section GENERAL
                  if (widget.isSidebarExpanded || widget.isMobile)
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
                    icon: Icons.dashboard_customize_rounded,
                    title: 'Dashboard',
                    index: 0,
                  ),
                  _buildExpandableMenu(
                    icon: Icons.shopping_bag_rounded,
                    title: 'Purchasing',
                    isExpanded:
                        widget.selectedIndex == SidebarWidget.PURCHASING_MENU,
                    menuIndex: SidebarWidget.PURCHASING_MENU,
                    children: [
                      _buildSubMenuItem('Direct Purchase', 11),
                      _buildSubMenuItem('GRPO', 12),
                    ],
                  ),
                  _buildExpandableMenu(
                    icon: Icons.inventory_rounded,
                    title: 'Stock Management',
                    isExpanded:
                        widget.selectedIndex ==
                        SidebarWidget.STOCK_MANAGEMENT_MENU,
                    menuIndex: SidebarWidget.STOCK_MANAGEMENT_MENU,
                    children: [
                      _buildSubMenuItem('Material Request', 21),
                      _buildSubMenuItem('Material Calculate', 25),
                      _buildSubMenuItem('Stock Opname', 22),
                      _buildSubMenuItem('Transfer Stock', 23),
                      _buildSubMenuItem('Waste', 24),
                    ],
                  ),
                  _buildMenuItem(
                    icon: Icons.bar_chart_rounded,
                    title: 'Inventory Report',
                    index: 3,
                  ),
                  // Section TOOLS
                  if (widget.isSidebarExpanded || widget.isMobile)
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
                    icon: Icons.settings_suggest_rounded,
                    title: 'Account & Settings',
                    index: 4,
                  ),
                  _buildMenuItem(
                    icon: Icons.help_center_rounded,
                    title: 'Help',
                    index: 5,
                  ),
                ],
              ),
            ),
          ),
          if (widget.isSidebarExpanded || widget.isMobile)
            _buildProfileDropdown(),
        ],
      ),
    );
  }

  Widget _buildStoreDropdown() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.lightPink,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.deepPink.withOpacity(0.1), width: 1),
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
                  backgroundColor: widget.deepPink.withOpacity(0.1),
                  child: Icon(Icons.store, color: widget.deepPink),
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
                        _selectedStore,
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
                  color: Colors.black54,
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
                  _buildStoreMenuItem('HAUS Jakarta'),
                  _buildStoreMenuItem('HAUS Bandung'),
                  _buildStoreMenuItem('HAUS Surabaya'),
                  _buildStoreMenuItem('HAUS Medan'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStoreMenuItem(String storeName) {
    final isSelected = _selectedStore == storeName;
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? widget.lightPink.withOpacity(0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        title: Text(
          storeName,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? widget.deepPink : Colors.black87,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: widget.deepPink, size: 18)
            : null,
        onTap: () {
          setState(() {
            _selectedStore = storeName;
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
        color: widget.lightPink,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.deepPink.withOpacity(0.1), width: 1),
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
                  backgroundColor: widget.deepPink,
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
                  color: Colors.black54,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserprofilePage(),
                        ),
                      );
                      setState(() => _isProfileMenuOpen = false);
                    },
                  ),
                  _buildProfileMenuItem(
                    Icons.settings_outlined,
                    'Settings',
                    onTap: () {
                      setState(() => _isProfileMenuOpen = false);
                      // Tambahkan navigasi ke halaman settings jika ada
                    },
                  ),
                  _buildProfileMenuItem(
                    Icons.help_outline,
                    'Help & Support',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpPage()),
                      );
                      setState(() => _isProfileMenuOpen = false);
                    },
                  ),
                  _buildProfileMenuItem(
                    Icons.logout,
                    'Logout',
                    isLogout: true,
                    onTap: () {
                      setState(() => _isProfileMenuOpen = false);
                      if (widget.onLogout != null) {
                        widget.onLogout!();
                      }
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

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isActive = widget.selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? widget.lightPink.withOpacity(0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        horizontalTitleGap: 12,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withOpacity(0.35)
                : Colors.white.withOpacity(0.13),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? Colors.white.withOpacity(0.32)
                  : Colors.white.withOpacity(0.22),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: isActive ? widget.deepPink : Colors.grey,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: isActive ? widget.deepPink : Colors.black87,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        selected: isActive,
        onTap: () {
          widget.onMenuTap(index);
          if (widget.isMobile && widget.closeDrawer != null) {
            widget.closeDrawer!();
          }
        },
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
    required int menuIndex,
  }) {
    final isMenuExpanded = widget.expandedMenuIndex == menuIndex;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isExpanded
                ? widget.lightPink.withOpacity(0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            horizontalTitleGap: 12,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isExpanded
                    ? Colors.white.withOpacity(0.35)
                    : Colors.white.withOpacity(0.13),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isExpanded
                      ? Colors.white.withOpacity(0.32)
                      : Colors.white.withOpacity(0.22),
                  width: 1.1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: isExpanded ? widget.deepPink : Colors.grey,
                size: 20,
              ),
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                color: isExpanded ? widget.deepPink : Colors.black87,
                fontWeight: isExpanded ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            trailing: AnimatedRotation(
              turns: isMenuExpanded ? 0.5 : 0.0,
              duration: Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.expand_more,
                color: isExpanded ? widget.deepPink : Colors.grey,
              ),
            ),
            onTap: () => widget.onToggleMenu(menuIndex),
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
        if (isMenuExpanded && (widget.isSidebarExpanded || widget.isMobile))
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

  Widget _buildSubMenuItem(String title, int index) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
      decoration: BoxDecoration(
        color: widget.selectedIndex == index
            ? widget.lightPink.withOpacity(0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        horizontalTitleGap: 12,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.selectedIndex == index
                ? Colors.white.withOpacity(0.35)
                : Colors.white.withOpacity(0.13),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.selectedIndex == index
                  ? Colors.white.withOpacity(0.32)
                  : Colors.white.withOpacity(0.22),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            _getSubMenuIcon(index),
            color: widget.selectedIndex == index
                ? widget.deepPink
                : Colors.grey,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: widget.selectedIndex == index
                ? widget.deepPink
                : Colors.black87,
            fontWeight: widget.selectedIndex == index
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        selected: widget.selectedIndex == index,
        onTap: () {
          widget.onMenuTap(index);
          if (widget.isMobile && widget.closeDrawer != null) {
            widget.closeDrawer!();
          }
        },
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  IconData _getSubMenuIcon(int index) {
    switch (index) {
      case 11:
        return Icons.shopping_bag_rounded;
      case 12:
        return Icons.receipt_long_outlined;
      case 21:
        return Icons.inventory_rounded;
      case 22:
        return Icons.checklist_rtl_outlined;
      case 23:
        return Icons.swap_horiz_outlined;
      case 24:
        return Icons.delete_outline;
      case 25:
        return Icons.inventory_rounded;
      default:
        return Icons.circle_outlined;
    }
  }
}
