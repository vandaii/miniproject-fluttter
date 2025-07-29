import 'dart:math' as math;
import 'dart:ui';
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
import 'package:miniproject_flutter/screens/Resource/Stock_Management/Waste_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/UserProfile_Page.dart';
import 'package:miniproject_flutter/screens/DashboardPage.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/LoginPage.dart';
import 'package:miniproject_flutter/component/HeaderAppBar.dart';
import 'package:miniproject_flutter/component/Sidebar.dart';
import 'package:miniproject_flutter/widgets/TransferStock/TitleCardTransferStock.dart';
import 'package:miniproject_flutter/widgets/TransferStock/TransferStockCard.dart';
import 'package:miniproject_flutter/widgets/TransferStock/TransferInModal.dart';
import 'package:miniproject_flutter/widgets/TransferStock/TransferOutModal.dart';

class TransferStockPage extends StatefulWidget {
  final int selectedIndex;
  const TransferStockPage({this.selectedIndex = 23, Key? key})
    : super(key: key);

  @override
  _TransferStockPageState createState() => _TransferStockPageState();
}

class _TransferStockPageState extends State<TransferStockPage> with TickerProviderStateMixin {
  // Sidebar states & variables
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? _expandedMenuIndex;
  int get _selectedIndex => widget.selectedIndex;
  TabController? _tabController;

  final Color deepPink = const Color.fromARGB(255, 233, 30, 99);
  final Color lightPink = const Color(0xFFFCE4EC);

  // Konstanta untuk menu index
  static const int PURCHASING_MENU = 1;
  static const int STOCK_MANAGEMENT_MENU = 2;

  final AuthService _authService = AuthService();



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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Set expanded menu otomatis sesuai submenu yang sedang selected
    if ([11, 12].contains(_selectedIndex)) {
      _expandedMenuIndex = PURCHASING_MENU;
    } else if ([21, 22, 23, 24, 25].contains(_selectedIndex)) {
      _expandedMenuIndex = STOCK_MANAGEMENT_MENU;
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: SidebarWidget(
          selectedIndex: _selectedIndex,
          onMenuTap: (index) {
            // Handle navigation based on menu index
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => _getPageRouteByIndex(index),
              ),
            );
          },
          isSidebarExpanded: true,
          expandedMenuIndex: _expandedMenuIndex,
          onToggleMenu: _toggleMenu,
          deepPink: deepPink,
          lightPink: lightPink,
          isMobile: true,
          closeDrawer: () => _scaffoldKey.currentState?.closeDrawer(),
          onLogout: _handleLogout,
        ),
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Builder(
                builder: (context) => HeaderFloatingCard(
                  isMobile: MediaQuery.of(context).size.width < 700,
                  onMenuTap: () {
                    if (MediaQuery.of(context).size.width < 700) {
                      Scaffold.of(context).openDrawer();
                    } else {
                      // Handle desktop sidebar toggle if needed
                    }
                  },
                  onEmailTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EmailPage())),
                  onNotifTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage())),
                  onAvatarTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserprofilePage())),
                  searchController: TextEditingController(),
                  searchFocusNode: FocusNode(),
                  onSearchChanged: (value) {
                    // Handle search
                  },
                  avatarInitial: 'J',
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                    // Title Card dengan Tab
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: _tabController != null ? TitleCardTransferStock(
                        isMobile: MediaQuery.of(context).size.width < 700,
                        tabController: _tabController!,
                      ) : Container(), // Placeholder while tabController is null
                    ),
                    // TabBarView untuk konten
          Expanded(
                      child: _tabController != null ? TabBarView(
                        controller: _tabController!,
                        children: [
                          // Transfer Out Tab
                          SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 90),
              child: Column(
                children: [
                                TransferStockCard(
                                  noTransfer: 'TO-2023-1',
                                  outlet: 'Outlet A',
                                  total: 'Rp 1.000.000',
                                  status: 'Shipping',
                                  date: '15/03/2024',
                                  items: [],
                                ),
                                TransferStockCard(
                                  noTransfer: 'TO-2023-2',
                                  outlet: 'Outlet B',
                                  total: 'Rp 1.000.000',
                                  status: 'Pending',
                                  date: '15/03/2024',
                                  items: [],
                                ),
                                TransferStockCard(
                                  noTransfer: 'TO-2023-3',
                                  outlet: 'Outlet C',
                                  total: 'Rp 1.000.000',
                                  status: 'Completed',
                                  date: '15/03/2024',
                                  items: [],
                        ),
                      ],
                    ),
                  ),
                          // Transfer In Tab
                          SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 90),
                            child: Column(
                    children: [
                                TransferStockCard(
                                  noTransfer: 'TI-2023-4',
                                  outlet: 'Outlet D',
                                  total: 'Rp 2.000.000',
                                  status: 'Pending',
                                  date: '15/03/2024',
                                  items: [],
                                ),
                                TransferStockCard(
                                  noTransfer: 'TI-2023-5',
                                  outlet: 'Outlet E',
                                  total: 'Rp 2.500.000',
                                  status: 'Received',
                                  date: '15/03/2024',
                                  items: [],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ) : Container(), // Placeholder while tabController is null
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
      floatingActionButton: _FabMenuTransferStock(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }



  Widget _getPageRouteByIndex(int index) {
    switch (index) {
      case 0:
        return DashboardPage(selectedIndex: 0);
      case 11:
        return DirectPurchasePage(selectedIndex: 11);
      case 12:
        return GRPO_Page(selectedIndex: 12);
      case 21:
        return MaterialRequestPage(selectedIndex: 21);
      case 22:
        return StockOpnamePage(selectedIndex: 22);
      case 23:
        return TransferStockPage(selectedIndex: 23);
      case 24:
        return WastePage(selectedIndex: 24);
      case 25:
        return MaterialCalculatePage(selectedIndex: 25);
      case 4:
        return UserprofilePage();
      case 5:
        return HelpPage();
      default:
        return DashboardPage(selectedIndex: 0);
    }
  }





  void _showTransferInModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) => const TransferInModal(),
    );
  }
}

class _FabMenuTransferStock extends StatefulWidget {
  @override
  State<_FabMenuTransferStock> createState() => _FabMenuTransferStockState();
}

class _FabMenuTransferStockState extends State<_FabMenuTransferStock>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _showTransferInModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TransferInModal(),
    );
  }

  void _showTransferOutModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TransferOutModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (_isOpen) ...[
          Positioned(
            bottom: 90,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildMenuItem(
                  label: 'Transfer Out',
                  icon: Icons.upload,
                  onTap: () {
                    print('Transfer Out tapped');
                  },
                ),
                SizedBox(height: 16),
                _buildMenuItem(
                  label: 'Transfer In',
                  icon: Icons.download,
                  onTap: () {
                    print('Transfer In tapped');
                  },
                ),
              ],
            ),
          ),
        ],
        Positioned(
          bottom: 16,
          right: 0,
          child: FloatingActionButton(
            backgroundColor: Color(0xFFE91E63),
            onPressed: _toggle,
            child: AnimatedRotation(
              turns: _isOpen ? 0.125 : 0,
              duration: Duration(milliseconds: 200),
              child: Icon(Icons.add, size: 30, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              if (label == 'Transfer In') {
                _showTransferInModal(context);
              } else if (label == 'Transfer Out') {
                _showTransferOutModal(context);
              } else {
                onTap();
              }
              _toggle();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Color(0xFFE91E63), size: 22),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: Color(0xFFE91E63),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


