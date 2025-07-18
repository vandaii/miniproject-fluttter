import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'SidebarMenuItem.dart';
import 'SidebarExpandableMenu.dart';
import 'SidebarSubMenuItem.dart';
import 'SidebarStoreDropdown.dart';
import 'SidebarProfileDropdown.dart';

class SidebarDrawer extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onNavigate;
  final bool isSidebarExpanded;
  final VoidCallback onClose;
  final List<String> storeList;
  final String selectedStore;
  final ValueChanged<String> onSelectStore;
  final String userName;
  final String userRole;
  final VoidCallback onProfile;
  final VoidCallback onSettings;
  final VoidCallback onHelp;
  final VoidCallback onLogout;

  const SidebarDrawer({
    Key? key,
    required this.selectedIndex,
    required this.onNavigate,
    required this.isSidebarExpanded,
    required this.onClose,
    required this.storeList,
    required this.selectedStore,
    required this.onSelectStore,
    required this.userName,
    required this.userRole,
    required this.onProfile,
    required this.onSettings,
    required this.onHelp,
    required this.onLogout,
  }) : super(key: key);

  @override
  State<SidebarDrawer> createState() => _SidebarDrawerState();
}

class _SidebarDrawerState extends State<SidebarDrawer> {
  bool isStoreMenuOpen = false;
  bool isProfileMenuOpen = false;
  int? expandedMenuIndex;

  static const int PURCHASING_MENU = 1;
  static const int STOCK_MANAGEMENT_MENU = 2;

  bool _isMainMenuActive(int index) {
    if (index == PURCHASING_MENU) {
      return [11, 12].contains(widget.selectedIndex);
    } else if (index == STOCK_MANAGEMENT_MENU) {
      return [21, 22, 23, 24, 25].contains(widget.selectedIndex);
    }
    return widget.selectedIndex == index;
  }

  bool _isSubMenuActive(int index) {
    return widget.selectedIndex == index;
  }

  bool _isMenuExpanded(int menuIndex, List<int> submenuIndexes) {
    return expandedMenuIndex == menuIndex ||
        submenuIndexes.contains(widget.selectedIndex);
  }

  IconData _getSubMenuIcon(int index) {
    switch (index) {
      case 11:
        return Icons.shopping_cart_outlined;
      case 12:
        return Icons.receipt_long_outlined;
      case 21:
        return Icons.inventory_2_outlined;
      case 22:
        return Icons.checklist_rtl_outlined;
      case 23:
        return Icons.swap_horiz_outlined;
      case 24:
        return Icons.delete_outline;
      case 25:
        return Icons.inventory_2_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  void _toggleStoreMenu() {
    setState(() {
      isStoreMenuOpen = !isStoreMenuOpen;
      if (isStoreMenuOpen) isProfileMenuOpen = false;
    });
  }

  void _toggleProfileMenu() {
    setState(() {
      isProfileMenuOpen = !isProfileMenuOpen;
      if (isProfileMenuOpen) isStoreMenuOpen = false;
    });
  }

  void _toggleExpandableMenu(int menuIndex) {
    setState(() {
      if (expandedMenuIndex == menuIndex) {
        expandedMenuIndex = null;
      } else {
        expandedMenuIndex = menuIndex;
        isStoreMenuOpen = false;
        isProfileMenuOpen = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color deepPink = const Color.fromARGB(255, 255, 0, 85);
    final Color lightPink = const Color(0xFFFCE4EC);
    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onClose,
          child: Container(
            color: Colors.black.withOpacity(0.3),
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeOutBack,
          width: 320,
          height: double.infinity,
          margin: EdgeInsets.only(left: 0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 24,
                offset: Offset(4, 0),
              ),
            ],
            border: Border.all(color: Color(0xFFE0E0E0), width: 1),
          ),
          child: SafeArea(
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
                      if (widget.isSidebarExpanded) const SizedBox(width: 12),
                      if (widget.isSidebarExpanded)
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
                if (widget.isSidebarExpanded)
                  SidebarStoreDropdown(
                    isOpen: isStoreMenuOpen,
                    onTap: _toggleStoreMenu,
                    storeList: widget.storeList,
                    selectedStore: widget.selectedStore,
                    onSelectStore: (store) {
                      widget.onSelectStore(store);
                      setState(() => isStoreMenuOpen = false);
                    },
                  ),
                // Menu Items
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        if (widget.isSidebarExpanded)
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
                        SidebarMenuItem(
                          icon: Icons.dashboard_outlined,
                          title: 'Dashboard',
                          isActive: _isMainMenuActive(0),
                          onTap: () => widget.onNavigate(0),
                        ),
                        SidebarExpandableMenu(
                          icon: Icons.shopping_cart_outlined,
                          title: 'Purchasing',
                          isExpanded: _isMenuExpanded(PURCHASING_MENU, [11, 12]),
                          isActive: _isMainMenuActive(PURCHASING_MENU),
                          onTap: () => _toggleExpandableMenu(PURCHASING_MENU),
                          children: [
                            SidebarSubMenuItem(
                              icon: _getSubMenuIcon(11),
                              title: 'Direct Purchase',
                              isActive: _isSubMenuActive(11),
                              onTap: () => widget.onNavigate(11),
                            ),
                            SidebarSubMenuItem(
                              icon: _getSubMenuIcon(12),
                              title: 'GRPO',
                              isActive: _isSubMenuActive(12),
                              onTap: () => widget.onNavigate(12),
                            ),
                          ],
                        ),
                        SidebarExpandableMenu(
                          icon: Icons.inventory_2_outlined,
                          title: 'Stock Management',
                          isExpanded: _isMenuExpanded(STOCK_MANAGEMENT_MENU, [21, 22, 23, 24, 25]),
                          isActive: _isMainMenuActive(STOCK_MANAGEMENT_MENU),
                          onTap: () => _toggleExpandableMenu(STOCK_MANAGEMENT_MENU),
                          children: [
                            SidebarSubMenuItem(
                              icon: _getSubMenuIcon(21),
                              title: 'Material Request',
                              isActive: _isSubMenuActive(21),
                              onTap: () => widget.onNavigate(21),
                            ),
                            SidebarSubMenuItem(
                              icon: _getSubMenuIcon(25),
                              title: 'Material Calculate',
                              isActive: _isSubMenuActive(25),
                              onTap: () => widget.onNavigate(25),
                            ),
                            SidebarSubMenuItem(
                              icon: _getSubMenuIcon(22),
                              title: 'Stock Opname',
                              isActive: _isSubMenuActive(22),
                              onTap: () => widget.onNavigate(22),
                            ),
                            SidebarSubMenuItem(
                              icon: _getSubMenuIcon(23),
                              title: 'Transfer Stock',
                              isActive: _isSubMenuActive(23),
                              onTap: () => widget.onNavigate(23),
                            ),
                            SidebarSubMenuItem(
                              icon: _getSubMenuIcon(24),
                              title: 'Waste',
                              isActive: _isSubMenuActive(24),
                              onTap: () => widget.onNavigate(24),
                            ),
                          ],
                        ),
                        SidebarMenuItem(
                          icon: Icons.assessment_outlined,
                          title: 'Inventory Report',
                          isActive: _isMainMenuActive(3),
                          onTap: () => widget.onNavigate(3),
                        ),
                        if (widget.isSidebarExpanded)
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
                        SidebarMenuItem(
                          icon: Icons.settings_outlined,
                          title: 'Account & Settings',
                          isActive: _isMainMenuActive(4),
                          onTap: () => widget.onNavigate(4),
                        ),
                        SidebarMenuItem(
                          icon: Icons.help_outline,
                          title: 'Help',
                          isActive: _isMainMenuActive(5),
                          onTap: () => widget.onNavigate(5),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.isSidebarExpanded)
                  SidebarProfileDropdown(
                    isOpen: isProfileMenuOpen,
                    onTap: _toggleProfileMenu,
                    userName: widget.userName,
                    userRole: widget.userRole,
                    onProfile: widget.onProfile,
                    onSettings: widget.onSettings,
                    onHelp: widget.onHelp,
                    onLogout: widget.onLogout,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 