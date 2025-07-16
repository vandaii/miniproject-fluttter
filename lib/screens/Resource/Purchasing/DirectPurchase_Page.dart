import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Email_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Notification_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/GRPO_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialCalculate_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/StockOpname_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/TransferStock_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialRequest_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/UserProfile_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Help_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/Waste_Page.dart';
import 'package:miniproject_flutter/screens/DashboardPage.dart';
import 'package:miniproject_flutter/services/DirectService.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/LoginPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:miniproject_flutter/widgets/Dashboard/AnimatedSidebar.dart';

class DirectPurchasePage extends StatefulWidget {
  final int selectedIndex;
  const DirectPurchasePage({this.selectedIndex = 11, Key? key})
    : super(key: key);

  @override
  _DirectPurchasePageState createState() => _DirectPurchasePageState();
}

class _DirectPurchasePageState extends State<DirectPurchasePage>
    with TickerProviderStateMixin {
  bool isOutstandingSelected =
      true; // Track selected tab (Outstanding or Approved)
  bool _isSidebarExpanded = true;
  bool _isProfileMenuOpen = false;
  bool _isStoreMenuOpen = false;
  int? _expandedMenuIndex;
  late int _selectedIndex;
  int? _hoveredIndex;

  // Tambahan untuk integrasi API
  final DirectService _directService = DirectService();
  List<dynamic> _directPurchases = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  final AuthService _authService = AuthService();

  late AnimationController _sidebarController;
  late Animation<double> _sidebarWidth;
  late Animation<double> _sidebarOpacity;
  late Animation<Offset> _sidebarOffset;
  late Animation<double> _sidebarScale;
  late Animation<double> _sidebarSpringAnim;

  // Tambahkan variabel dan fungsi yang diperlukan untuk header AppBar modern
  late AnimationController _headerAnimationController;

  // Dummy data notifikasi dan email
  final List<Map<String, dynamic>> notifications = [
    {
      'icon': Icons.shopping_cart,
      'title': 'Purchase Approved',
      'message': 'Your direct purchase request has been approved.',
      'time': '2 min ago',
      'color': Color(0xFFE91E63),
    },
    {
      'icon': Icons.assignment_turned_in,
      'title': 'GRPO Received',
      'message': 'Goods receipt has been completed for PO-2023-12.',
      'time': '10 min ago',
      'color': Color(0xFFE91E63),
    },
    {
      'icon': Icons.warning_amber_rounded,
      'title': 'Stock Low',
      'message': 'Stock for Item ABC is below minimum level.',
      'time': '1 hour ago',
      'color': Color(0xFFE91E63),
    },
  ];
  final List<Map<String, dynamic>> emails = [
    {
      'subject': 'Welcome to haus! Inventory',
      'from': 'admin@haus.com',
      'snippet': 'Thank you for registering your account.',
      'time': '1 min ago',
    },
    {
      'subject': 'PO-2024-0125 Approved',
      'from': 'system@haus.com',
      'snippet': 'Your PO-2024-0125 has been approved.',
      'time': '10 min ago',
    },
    {
      'subject': 'Monthly Report',
      'from': 'report@haus.com',
      'snippet': 'Your monthly inventory report is ready.',
      'time': '1 hour ago',
    },
  ];
  late AnimationController _notificationAnimationController;
  late AnimationController _emailAnimationController;
  OverlayEntry? _notificationOverlayEntry;
  final GlobalKey _notificationIconKey = GlobalKey();
  OverlayEntry? _emailOverlayEntry;
  final GlobalKey _emailIconKey = GlobalKey();

  // Tambahkan variabel state untuk tab Rejected
  int _tabIndex = 0; // 0: Outstanding, 1: Approved, 2: Rejected

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    // Set expanded menu otomatis sesuai submenu yang sedang selected
    if ([11, 12].contains(_selectedIndex)) {
      _expandedMenuIndex = PURCHASING_MENU;
    } else if ([21, 22, 23, 24, 25].contains(_selectedIndex)) {
      _expandedMenuIndex = STOCK_MANAGEMENT_MENU;
    }
    _fetchDirectPurchases();
    // Tambahkan dummy data jika kosong (untuk testing UI)
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted && _directPurchases.isEmpty) {
        setState(() {
          _directPurchases = [
            {
              'no_direct': 'DP-2024-0001',
              'supplier': 'PT. Sumber Makmur',
              'directPurchaseDate': DateTime.now().toIso8601String(),
              'status': 'Pending Area Manager',
              'items': [
                {
                  'itemName': 'Gula',
                  'quantity': 10,
                  'price': 15000,
                  'totalPrice': 150000,
                },
                {
                  'itemName': 'Kopi',
                  'quantity': 5,
                  'price': 30000,
                  'totalPrice': 150000,
                },
              ],
              'totalAmount': 300000,
              'expenseType': 'Inventory',
              'note': 'Pembelian bahan baku',
              'purchase_proof': '-',
            },
            {
              'no_direct': 'DP-2024-0002',
              'supplier': 'CV. Aneka Jaya',
              'directPurchaseDate': DateTime.now()
                  .subtract(Duration(days: 2))
                  .toIso8601String(),
              'status': 'Approved',
              'items': [
                {
                  'itemName': 'Susu',
                  'quantity': 20,
                  'price': 12000,
                  'totalPrice': 240000,
                },
              ],
              'totalAmount': 240000,
              'expenseType': 'Non Inventory',
              'note': 'Pembelian susu',
              'purchase_proof': '-',
            },
          ];
        });
      }
    });
    _headerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _notificationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _emailAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    // Hapus overlay SEBELUM dispose controller
    if (_notificationOverlayEntry != null) {
      _notificationOverlayEntry!.remove();
      _notificationOverlayEntry = null;
    }
    if (_emailOverlayEntry != null) {
      _emailOverlayEntry!.remove();
      _emailOverlayEntry = null;
    }
    _headerAnimationController.dispose();
    _notificationAnimationController.dispose();
    _emailAnimationController.dispose();
    super.dispose();
  }

  // color palate
  final Color pastelPink = const Color(0xFFF8BBD0);
  final Color deepPink = const Color.fromARGB(255, 255, 0, 85);
  final Color lightPink = const Color(0xFFFCE4EC);
  final Color accentPurple = const Color(0xFF7B1FA2);

  //define menu indexes
  static const int PURCHASING_MENU = 1;
  static const int STOCK_MANAGEMENT_MENU = 2;

  bool _isMainMenuActive(int index) {
    // Aktif jika salah satu submenu dari menu utama sedang selected
    if (index == PURCHASING_MENU) {
      return [11, 12].contains(_selectedIndex);
    } else if (index == STOCK_MANAGEMENT_MENU) {
      return [21, 22, 23, 24, 25].contains(_selectedIndex);
    }
    return _selectedIndex == index;
  }

  bool _isSubMenuActive(int index) {
    // Submenu aktif hanya jika selected
    return _selectedIndex == index;
  }

  bool _isMenuExpanded(int menuIndex, List<int> submenuIndexes) {
    return _expandedMenuIndex == menuIndex ||
        submenuIndexes.contains(_selectedIndex) ||
        submenuIndexes.contains(_hoveredIndex);
  }

  Future<void> _fetchDirectPurchases() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      String? status;
      if (_tabIndex == 1) {
        status = 'Approved';
      } else if (_tabIndex == 2) {
        status = 'Rejected';
      }
      final data = await _directService.getDirectPurchases(
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
        status: status, // Akan mengirim null untuk tab outstanding
      );
      List<dynamic> allPurchases = data['data'] ?? [];
      setState(() {
        if (_tabIndex == 0) {
          _directPurchases = allPurchases.where((item) {
            final itemStatus = item['status'] as String?;
            return itemStatus != null &&
                itemStatus != 'Approved' &&
                itemStatus != 'Rejected';
          }).toList();
        } else {
          _directPurchases = allPurchases;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data: ${e.toString()}';
      });
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    _fetchDirectPurchases();
  }

  void _onTabChanged(int index) {
    setState(() {
      _tabIndex = index;
      isOutstandingSelected = (index == 0);
    });
    _fetchDirectPurchases();
  }

  void _showAddDirectPurchaseForm() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: _AddDirectPurchaseFormContent(
            onSuccess: () {
              Navigator.pop(context, true);
            },
          ),
        );
      },
    );
    if (result == true) {
      _fetchDirectPurchases();
    }
  }

  @override
  //===================================================================================================================== //
  //Todo:Rangkaian fungsi dan styling untuk header dan item lain
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 700;
    return Scaffold(
      backgroundColor: const Color.fromARGB(238, 255, 255, 255),
      extendBody: true, // penting agar Stack bisa sampai ke bawah
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 72 : 84),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 255, 30, 105),
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: isMobile ? 72 : 84,
            titleSpacing: 0,
            title: Padding(
              padding: EdgeInsets.only(
                left: isMobile ? 12 : 24,
                right: isMobile ? 10 : 24,
                top: isMobile ? 8 : 12,
                bottom: isMobile ? 12 : 16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isMobile)
                    Builder(
                      builder: (context) => Container(
                        margin: const EdgeInsets.only(left: 4),
                        child: _modernHeaderIcon(
                          icon: Icons.grid_view_rounded,
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          isMobile: isMobile,
                          glass: true,
                          iconSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    )
                  else
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      child: _modernHeaderIcon(
                        icon: Icons.grid_view_rounded,
                        onTap: () {
                          setState(() {
                            _isSidebarExpanded = !_isSidebarExpanded;
                          });
                        },
                        isMobile: false,
                        glass: true,
                        iconSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  if (isMobile) const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Haus Inventory',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 20 : 24,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _modernHeaderIconBarNoSearch(isMobile),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
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
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Column(
                children: [
                  // Logo dan nama aplikasi
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(32),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF8BBD0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(6),
                          child: Image.asset(
                            'assets/images/icons-haus.png',
                            height: 32,
                            width: 32,
                          ),
                        ),
                        if (_isSidebarExpanded) const SizedBox(width: 14),
                        if (_isSidebarExpanded)
                          Text(
                            'haus! Inventory',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Color(0xFFE91E63),
                              letterSpacing: 0.2,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (_isSidebarExpanded) _buildStoreDropdown(),
                  // Menu Items dengan Expanded
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
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
                                    width: 80,
                                    color: Colors.grey.withOpacity(0.13),
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
                            isExpanded: _isMenuExpanded(PURCHASING_MENU, [
                              11,
                              12,
                            ]),
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
                            isExpanded: _isMenuExpanded(STOCK_MANAGEMENT_MENU, [
                              21,
                              22,
                              23,
                              24,
                              25,
                            ]),
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
                                    width: 80,
                                    color: Colors.grey.withOpacity(0.13),
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
                  if (_isSidebarExpanded)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _buildProfileDropdown(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 32,
                  vertical: isMobile ? 16 : 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    _buildAIHeaderSection(),
                    SizedBox(height: 24),
                    SizedBox(height: 16),
                    // Card besar pembungkus tab dan data
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
                      margin: EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildQuantumTabNavigation(),
                          SizedBox(height: 16),
                          _isLoading
                              ? _buildHolographicLoading()
                              : _errorMessage != null
                              ? _buildErrorDisplay()
                              : _directPurchases.isEmpty
                              ? _buildHolographicEmptyState()
                              : _buildHolographicDataGrid(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isMobile)
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Center(child: _MobileFloatingNavBarGlass()),
            ),
        ],
      ),
    );
  }

  // AI-Powered Header Section
  Widget _buildAIHeaderSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFFE91E63), // solid merah muda mencolok
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.shopping_cart_checkout_rounded,
                  color: Color(0xFFE91E63),
                  size: 32,
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Haus Inventory',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Inventory Management System',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Search and Filter Row
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    onChanged: _onSearchChanged,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[600],
                        size: 22,
                      ),
                      hintText: 'Search for direct purchases...',
                      hintStyle: GoogleFonts.roboto(
                        color: Colors.grey[500],
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _fetchDirectPurchases,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.tune,
                        color: Color(0xFFE91E63),
                        size: 22,
                      ),
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

  // Quantum Tab Navigation
  Widget _buildQuantumTabNavigation() {
    final tabData = [
      {'label': 'Outstanding', 'icon': Icons.timelapse},
      {'label': 'Approved', 'icon': Icons.verified},
      {'label': 'Rejected', 'icon': Icons.close},
    ];
    final List<GlobalKey> tabKeys = List.generate(
      tabData.length,
      (_) => GlobalKey(),
    );
    return StatefulBuilder(
      builder: (context, setTabState) {
        double indicatorLeft = 0;
        double indicatorWidth = 60; // fallback default width
        void updateIndicator() {
          final keyContext = tabKeys[_tabIndex].currentContext;
          if (keyContext != null) {
            final box = keyContext.findRenderObject() as RenderBox;
            final offset = box.localToGlobal(
              Offset.zero,
              ancestor: context.findRenderObject(),
            );
            final parentOffset = (context.findRenderObject() as RenderBox)
                .localToGlobal(Offset.zero);
            final newLeft = offset.dx - parentOffset.dx;
            final newWidth = box.size.width;
            if (indicatorLeft != newLeft || indicatorWidth != newWidth) {
              setTabState(() {
                indicatorLeft = newLeft;
                indicatorWidth = newWidth;
              });
            }
          } else {
            setTabState(() {
              indicatorLeft = 0;
              indicatorWidth = 60;
            });
          }
        }

        WidgetsBinding.instance.addPostFrameCallback((_) => updateIndicator());
        return Container(
          padding: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SizedBox(
            height: 48,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notif) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => updateIndicator(),
                );
                return false;
              },
              child: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(tabData.length, (i) {
                        final isSelected = _tabIndex == i;
                        return Container(
                          key: tabKeys[i],
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () {
                              _onTabChanged(i);
                              setTabState(() {});
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 250),
                              curve: Curves.ease,
                              padding: EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    tabData[i]['icon'] as IconData,
                                    color: isSelected
                                        ? Color(0xFF1976D2)
                                        : Colors.grey[500],
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    tabData[i]['label'] as String,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Color(0xFF1976D2)
                                          : Colors.grey[700],
                                      fontSize: 15,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  // Animated border indicator di bawah tab
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 350),
                    curve: Curves.easeInOutCubic,
                    left: indicatorLeft,
                    bottom: 0,
                    width: indicatorWidth,
                    height: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          colors: [Color(0xFF1976D2), Color(0xFF7B1FA2)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuantumTabButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [Color(0xFFE040FB), Color(0xFF7B1FA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isSelected ? null : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Color(0xFFE040FB).withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey[600],
                  size: 20,
                ),
                SizedBox(width: 8),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.orbitron(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Holographic Data Grid
  Widget _buildHolographicDataGrid() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 20),
      itemCount: _directPurchases.length,
      itemBuilder: (context, index) {
        return _buildHolographicCard(_directPurchases[index]);
      },
    );
  }

  Widget _buildHolographicCard(dynamic item) {
    String status = item['status'] ?? '';
    Color statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // Tidak ada color, transparan agar menyatu dengan card besar
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFE040FB), Color(0xFF7B1FA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFE040FB).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getNoDirect(item),
                          style: GoogleFonts.orbitron(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF1A1A2E),
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: statusColor.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            status,
                            style: GoogleFonts.orbitron(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildDataRow(
                icon: Icons.store,
                label: 'Supplier',
                value: item['supplier'] ?? '-',
                iconColor: Color(0xFFE040FB),
              ),
              SizedBox(height: 12),
              _buildDataRow(
                icon: Icons.calendar_today,
                label: 'Date',
                value: getDate(item),
                iconColor: Color(0xFF4CAF50),
              ),
              SizedBox(height: 12),
              _buildDataRow(
                icon: Icons.inventory_2,
                label: 'Items',
                value: '${item['items']?.length ?? 0} items',
                iconColor: Color(0xFFFF9800),
              ),
              SizedBox(height: 12),
              if (item['totalAmount'] != null)
                _buildDataRow(
                  icon: Icons.attach_money,
                  label: 'Total',
                  value: item['totalAmount'].toString(),
                  iconColor: Color(0xFF4CAF50),
                ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showDetailPopup(item),
                  icon: Icon(Icons.visibility, size: 18),
                  label: Text(
                    'View Details',
                    style: GoogleFonts.orbitron(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE040FB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.orbitron(
                  fontSize: 13,
                  color: Color(0xFF1A1A2E),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending Area Manager':
        return Color(0xFFFF9800);
      case 'Approved Area Manager':
        return Color.fromARGB(255, 53, 39, 176);
      case 'Approved':
        return Color(0xFF4CAF50);
      default:
        return Colors.grey;
    }
  }

  // Holographic Loading
  Widget _buildHolographicLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE040FB), Color(0xFF7B1FA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFE040FB).withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Loading Neural Data...',
            style: GoogleFonts.orbitron(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE040FB),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // Error Display
  Widget _buildErrorDisplay() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFFFF5722).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: Color(0xFFFF5722)),
            SizedBox(height: 16),
            Text(
              'Neural Error',
              style: GoogleFonts.orbitron(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF5722),
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Holographic Empty State
  Widget _buildHolographicEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color(0xFFE040FB).withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE040FB), Color(0xFF7B1FA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFE040FB).withOpacity(0.3),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(Icons.inbox, size: 48, color: Colors.white),
              ),
              SizedBox(height: 24),
              Text(
                'No Data Found',
                style: GoogleFonts.orbitron(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE040FB),
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Neural network detected no direct purchase data',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailPopup(dynamic item) async {
    final GlobalKey<FormState> _detailKey = GlobalKey<FormState>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, -5),
                ),
              ],
            ),

            // todo : styling for detail popup items
            child: Form(
              key: _detailKey,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 60,
                          height: 6,
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      Text(
                        'Detail Direct Purchase',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE91E63),
                        ),
                      ),
                      SizedBox(height: 18),
                      _buildDetailRow('No Direct', getNoDirect(item)),
                      _buildDetailRow('Supplier', item['supplier'] ?? '-'),
                      _buildDetailRow('Date', getDate(item)),
                      _buildDetailRow(
                        'Expense Type',
                        item['expenseType'] ?? '-',
                      ),
                      _buildDetailRow('Status', item['status'] ?? '-'),
                      _buildDetailRow('Note', item['note'] ?? '-'),
                      _buildDetailRow('Image', item['purchase_proof']),
                      SizedBox(height: 12),
                      Text(
                        'Items:',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      ...((item['items'] as List?)
                              ?.map(
                                (itm) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Text(
                                    '- ${itm['itemName'] ?? itm['item_name'] ?? '-'} | Qty: ${itm['quantity']} | Price: ${itm['price']} | Total: ${itm['totalPrice'] ?? itm['total_price']} ',
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ),
                              )
                              .toList() ??
                          []),
                      SizedBox(height: 18),
                      if ((item['status'] ?? '').toLowerCase() ==
                          'pending area manager')
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.check, color: Colors.white),
                            label: Text(
                              'Approve',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF388E3C),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _approveDirectPurchase(item);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value, style: GoogleFonts.poppins())),
        ],
      ),
    );
  }

  Future<void> _approveDirectPurchase(dynamic item) async {
    try {
      final id = item['id'];
      await _directService.approveByAreaManager(id, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil approve!'),
          backgroundColor: Colors.green,
        ),
      );
      _fetchDirectPurchases();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal approve: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        color: isActive ? Colors.pink.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.pink.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.pink : Colors.grey,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: isActive ? Colors.pink : Colors.grey,
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
  }) {
    final isMenuExpanded = _expandedMenuIndex == menuIndex;
    bool isAnySubMenuActive = false;
    if (menuIndex == PURCHASING_MENU) {
      isAnySubMenuActive = [11, 12].contains(_selectedIndex);
    } else if (menuIndex == STOCK_MANAGEMENT_MENU) {
      isAnySubMenuActive = [21, 22, 23, 24, 25].contains(_selectedIndex);
    }
    final bool highlightParent = isExpanded && !isAnySubMenuActive;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: highlightParent ? Colors.pink.shade50 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: highlightParent
                    ? Colors.pink.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: highlightParent ? Colors.pink : Colors.grey,
                size: 20,
              ),
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                color: highlightParent ? Colors.pink : Colors.grey,
                fontWeight: highlightParent
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            trailing: Icon(
              isMenuExpanded ? Icons.expand_less : Icons.expand_more,
              color: highlightParent ? Colors.pink : Colors.grey,
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
          color: isActive ? Colors.pink.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.pink.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getSubMenuIcon(index),
              color: isActive ? Colors.pink : Colors.grey,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isActive ? Colors.pink : Colors.black87,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selected: isActive,
          onTap: () {
            if (_selectedIndex != index) {
              setState(() {
                _selectedIndex = index;
                if ([11, 12].contains(index)) {
                  _expandedMenuIndex = PURCHASING_MENU;
                } else if ([21, 22, 23, 24, 25].contains(index)) {
                  _expandedMenuIndex = STOCK_MANAGEMENT_MENU;
                }
              });
              _navigateToPage(index);
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

  void _navigateToPage(int index) {
    Navigator.pushReplacement(context, _getPageRouteByIndex(index));
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
      case 3:
        // Replace with your Inventory Report page if available
        return MaterialPageRoute(
          builder: (context) => DashboardPage(selectedIndex: 0),
        );
      case 4:
        // Replace with your Account & Settings page if available
        return MaterialPageRoute(builder: (context) => UserprofilePage());
      case 5:
        return MaterialPageRoute(builder: (context) => HelpPage());
      default:
        return MaterialPageRoute(
          builder: (context) => DashboardPage(selectedIndex: 0),
        );
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

  String getNoDirect(dynamic item) {
    return item['no_direct'] ??
        item['no_direct_purchase'] ??
        item['noDirect'] ??
        item['noDirectPurchase'] ??
        item['direct_number'] ??
        '-';
  }

  String getDate(dynamic item) {
    String? rawDate =
        item['directPurchaseDate'] ??
        item['date'] ??
        item['tanggal'] ??
        item['purchase_date'] ??
        item['created_at'] ??
        item['createdAt'];
    if (rawDate == null) return '-';
    try {
      DateTime dt = DateTime.parse(rawDate);
      return DateFormat('dd/MM/yyyy').format(dt);
    } catch (e) {
      return rawDate;
    }
  }

  Widget _modernHeaderIcon({
    required IconData icon,
    required VoidCallback onTap,
    bool badge = false,
    bool isMobile = false,
    Color? color,
    bool glass = false,
    double? iconSize,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(isMobile ? 8 : 12),
          decoration: BoxDecoration(
            color: glass
                ? Colors.white.withOpacity(0.35)
                : (color?.withOpacity(0.13) ?? Colors.white.withOpacity(0.13)),
            borderRadius: BorderRadius.circular(16),
            border: glass
                ? Border.all(color: Colors.white.withOpacity(0.32), width: 1.1)
                : Border.all(color: (color ?? Colors.white).withOpacity(0.22)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: iconSize ?? (isMobile ? 24 : 28),
              ),
              if (badge)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color ?? Colors.pinkAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modernHeaderIconBarNoSearch(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.22), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            key: _notificationIconKey,
            child: _modernHeaderIcon(
              icon: Icons.notifications_none_outlined,
              onTap: _toggleNotificationOverlay,
              badge: notifications.isNotEmpty,
              isMobile: isMobile,
              glass: true,
              iconSize: isMobile ? 24 : 28,
              color: Colors.white,
            ),
          ),
          SizedBox(width: isMobile ? 8 : 14),
          SizedBox(
            key: _emailIconKey,
            child: _modernHeaderIcon(
              icon: Icons.mail_outline_rounded,
              onTap: _toggleEmailOverlay,
              badge: emails.isNotEmpty,
              isMobile: isMobile,
              glass: true,
              iconSize: isMobile ? 24 : 28,
              color: Colors.white,
            ),
          ),
          SizedBox(width: isMobile ? 10 : 18),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserprofilePage(),
                ),
              );
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(isMobile ? 8 : 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.35),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.32),
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
              child: ClipOval(
                child: Image.asset(
                  'assets/images/avatar.jpg',
                  fit: BoxFit.cover,
                  width: isMobile ? 24 : 28,
                  height: isMobile ? 24 : 28,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.person,
                    color: Colors.grey[500],
                    size: isMobile ? 24 : 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Notification Overlay Logic ---
  void _toggleNotificationOverlay() {
    if (!mounted) return;
    if (_notificationAnimationController.isAnimating) return;
    if (_notificationOverlayEntry == null) {
      _showNotificationBubble();
    } else {
      _removeNotificationOverlay();
    }
  }

  void _removeNotificationOverlay() {
    if (!mounted) return;
    if (_notificationOverlayEntry != null) {
      _notificationAnimationController.reverse().then((_) {
        if (_notificationOverlayEntry != null &&
            _notificationOverlayEntry!.mounted) {
          _notificationOverlayEntry!.remove();
          _notificationOverlayEntry = null;
        }
      });
    }
  }

  void _showNotificationBubble() {
    if (!mounted) return;
    if (_notificationOverlayEntry != null) return;
    final RenderBox renderBox =
        _notificationIconKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    _notificationOverlayEntry = OverlayEntry(
      builder: (context) => _buildNotificationTooltipAnimated(position, size),
    );
    Overlay.of(context).insert(_notificationOverlayEntry!);
    _notificationAnimationController.forward();
  }

  Widget _buildNotificationTooltipAnimated(Offset position, Size size) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    final double popupWidth = isMobile ? screenWidth * 0.85 : 260;
    double left = position.dx + size.width / 2 - popupWidth / 2;
    if (left < 8) left = 8;
    if (left + popupWidth > screenWidth - 8)
      left = screenWidth - popupWidth - 8;
    double arrowWidth = 22;
    double arrowOffset =
        (position.dx + size.width / 2) - left - (arrowWidth / 2) - 125;
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _removeNotificationOverlay,
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned(
          top: position.dy + size.height + 10,
          left: left,
          child: AnimatedBuilder(
            animation: _notificationAnimationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _notificationAnimationController,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _notificationAnimationController,
                      curve: Curves.easeOutBack,
                    ),
                  ),
                  alignment: Alignment.topCenter,
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(width: arrowOffset),
                    CustomPaint(
                      size: Size(arrowWidth, 10),
                      painter: _NotifTooltipArrowPainter(
                        color: Colors.white,
                        borderColor: Colors.grey.withOpacity(0.13),
                      ),
                    ),
                  ],
                ),
                _buildNotificationTooltipContent(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationTooltipContent() {
    final List<Map<String, dynamic>> previewNotifs = notifications
        .take(4)
        .toList();
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    return Material(
      type: MaterialType.transparency,
      elevation: 0,
      child: Container(
        width: isMobile ? screenWidth * 0.85 : 260,
        constraints: BoxConstraints(maxHeight: isMobile ? 220 : 180),
        padding: const EdgeInsets.only(top: 10, bottom: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(255, 3, 1, 1).withOpacity(0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
              child: Text(
                'Notifikasi',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 2),
            if (previewNotifs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                child: Text(
                  'Belum ada notifikasi.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  itemCount: previewNotifs.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade100),
                  itemBuilder: (context, i) =>
                      _buildNotificationBubbleItem(previewNotifs[i]),
                ),
              ),
            const SizedBox(height: 2),
            InkWell(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              onTap: () {
                _removeNotificationOverlay();
                Future.delayed(const Duration(milliseconds: 100), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_active_rounded,
                      color: deepPink,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Lihat Semua Notifikasi',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: deepPink,
                        fontSize: 13,
                      ),
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

  Widget _buildNotificationBubbleItem(Map<String, dynamic> notif) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: (notif['color'] as Color).withOpacity(0.13),
            child: Icon(notif['icon'], color: notif['color'], size: 16),
            radius: 13,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif['title'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: notif['color'],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  notif['message'],
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  notif['time'],
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Email Overlay Logic ---
  void _toggleEmailOverlay() {
    if (!mounted) return;
    if (_emailAnimationController.isAnimating) return;
    if (_emailOverlayEntry == null) {
      _showEmailBubble();
    } else {
      _removeEmailOverlay();
    }
  }

  void _removeEmailOverlay() {
    if (!mounted) return;
    if (_emailOverlayEntry != null) {
      _emailAnimationController.reverse().then((_) {
        if (_emailOverlayEntry != null && _emailOverlayEntry!.mounted) {
          _emailOverlayEntry!.remove();
          _emailOverlayEntry = null;
        }
        _emailAnimationController.reset(); // reset controller setelah reverse
      });
    }
  }

  void _showEmailBubble() {
    if (!mounted) return;
    if (_emailOverlayEntry != null) return; // cegah overlay ganda
    final RenderBox renderBox =
        _emailIconKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    _emailOverlayEntry = OverlayEntry(
      builder: (context) => _buildEmailTooltipAnimated(position, size),
    );

    Overlay.of(context).insert(_emailOverlayEntry!);
    _emailAnimationController.forward();
  }

  Widget _buildEmailTooltipAnimated(Offset position, Size size) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    final double popupWidth = isMobile ? screenWidth * 0.85 : 260;
    double left = position.dx + size.width / 2 - popupWidth / 2;
    if (left < 8) left = 8;
    if (left + popupWidth > screenWidth - 8)
      left = screenWidth - popupWidth - 8;
    double arrowWidth = 22;
    double arrowOffset =
        (position.dx + size.width / 2) - left - (arrowWidth / 2) - 75;
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _removeEmailOverlay,
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned(
          top: position.dy + size.height + 10,
          left: left,
          child: AnimatedBuilder(
            animation: _emailAnimationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _emailAnimationController,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _emailAnimationController,
                      curve: Curves.easeOutBack,
                    ),
                  ),
                  alignment: Alignment.topCenter,
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(width: arrowOffset),
                    CustomPaint(
                      size: Size(arrowWidth, 10),
                      painter: _NotifTooltipArrowPainter(
                        color: Colors.white,
                        borderColor: Colors.grey.withOpacity(0.13),
                      ),
                    ),
                  ],
                ),
                _buildEmailTooltipContent(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailTooltipContent() {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    final List<Map<String, dynamic>> previewEmails = emails.take(3).toList();
    return Material(
      type: MaterialType.transparency,
      elevation: 0,
      child: Container(
        width: isMobile ? screenWidth * 0.85 : 260,
        constraints: BoxConstraints(maxHeight: isMobile ? 220 : 180),
        padding: const EdgeInsets.only(top: 10, bottom: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
              child: Text(
                'Email',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 2),
            if (previewEmails.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                child: Text(
                  'Tidak ada email baru.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  itemCount: previewEmails.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade100),
                  itemBuilder: (context, i) =>
                      _buildEmailBubbleItem(previewEmails[i]),
                ),
              ),
            const SizedBox(height: 2),
            InkWell(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              onTap: () {
                _removeEmailOverlay();
                Future.delayed(const Duration(milliseconds: 100), () {
                  // Navigasi ke halaman email jika ada
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.mail_outline_rounded, color: deepPink, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Lihat Semua Email',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: deepPink,
                        fontSize: 13,
                      ),
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

  Widget _buildEmailBubbleItem(Map<String, dynamic> email) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: deepPink.withOpacity(0.13),
            child: Icon(Icons.mail_outline_rounded, color: deepPink, size: 16),
            radius: 13,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email['subject'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: deepPink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  email['snippet'],
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  email['time'],
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Move this class to top-level (outside of any class)
class _NotifTooltipArrowPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  _NotifTooltipArrowPainter({required this.color, required this.borderColor});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(_NotifTooltipArrowPainter oldDelegate) => false;
}

/// Add Direct Purchase Form Content Widget
class _AddDirectPurchaseFormContent extends StatefulWidget {
  final VoidCallback onSuccess;
  const _AddDirectPurchaseFormContent({Key? key, required this.onSuccess})
    : super(key: key);

  @override
  State<_AddDirectPurchaseFormContent> createState() =>
      _AddDirectPurchaseFormContentState();
}

class _AddDirectPurchaseFormContentState
    extends State<_AddDirectPurchaseFormContent> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _purchaseDate;
  String? _expenseType = 'Inventory';
  final List<Map<String, dynamic>> _items = [];
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  List<File> _files = [];
  bool _isSubmitting = false;

  final Color deepPink = const Color.fromARGB(255, 233, 30, 99);
  final AuthService _authService = AuthService();
  final DirectService _directService = DirectService();

  @override
  void initState() {
    super.initState();
    _addItem();
  }

  void _addItem() {
    setState(() {
      _items.add({
        'name': TextEditingController(),
        'description': TextEditingController(),
        'qty': TextEditingController(text: '1'),
        'unit': 'PCS',
        'price': TextEditingController(),
      });
    });
  }

  void _removeItem(int index) {
    if (_items.length > 1) {
      final item = _items.removeAt(index);
      item['name'].dispose();
      item['description'].dispose();
      item['qty'].dispose();
      item['price'].dispose();
      setState(() {});
    }
  }

  @override
  void dispose() {
    for (var item in _items) {
      item['name'].dispose();
      item['description'].dispose();
      item['qty'].dispose();
      item['price'].dispose();
    }
    _supplierController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'svg'],
      );
      if (result != null) {
        setState(() {
          _files = result.paths.map((path) => File(path!)).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking files: ${e.toString()}')),
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_purchaseDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tanggal pembelian wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_supplierController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Supplier wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_items.any((item) => item['name'].text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nama item wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      double totalAmount = 0.0;
      for (var item in _items) {
        final qty = int.tryParse(item['qty'].text.trim()) ?? 0;
        final price = double.tryParse(item['price'].text.trim()) ?? 0.0;
        totalAmount += qty * price;
      }

      final items = _items
          .map(
            (item) => {
              'item_name': item['name'].text.trim(),
              'item_description': item['description'].text.trim(),
              'quantity': int.tryParse(item['qty'].text.trim()) ?? 1,
              'price': double.tryParse(item['price'].text.trim()) ?? 0.0,
              'unit': item['unit'],
            },
          )
          .toList();
      final dateStr =
          '${_purchaseDate!.year}-${_purchaseDate!.month.toString().padLeft(2, '0')}-${_purchaseDate!.day.toString().padLeft(2, '0')}';
      await _directService.createDirectPurchase(
        date: dateStr,
        supplier: _supplierController.text.trim(),
        expenseType: _expenseType ?? 'Inventory',
        items: items,
        totalAmount: totalAmount,
        note: _notesController.text.trim(),
        purchaseProofs: _files.isNotEmpty ? _files : null,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil menambah direct purchase'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambah: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                'Add Direct Purchase',
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      title: "Purchase Information",
                      icon: Icons.info_outline,
                      children: [
                        _buildTopSection(),
                        const SizedBox(height: 16),
                        _buildExpenseTypeDropdown(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildItemsSection(),
                    const SizedBox(height: 24),
                    _buildSection(
                      title: 'Attachments & Notes',
                      icon: Icons.description_outlined,
                      children: [
                        _buildFileUploadSection(),
                        const SizedBox(height: 16),
                        _buildNotesSection(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildInfoBanner(),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildModernTextField(
            label: 'Purchase Date',
            hint: 'Select Date',
            readOnly: true,
            controller: TextEditingController(
              text: _purchaseDate == null
                  ? ''
                  : "${_purchaseDate!.day}/${_purchaseDate!.month}/${_purchaseDate!.year}",
            ),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() {
                  _purchaseDate = date;
                });
              }
            },
            prefixIcon: Icons.calendar_today,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildModernTextField(
            label: 'Supplier/Store',
            controller: _supplierController,
            prefixIcon: Icons.store,
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseTypeDropdown() {
    return _buildModernDropdown(
      label: 'Expense Type',
      value: _expenseType,
      items: ['Inventory', 'Non Inventory'],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _expenseType = value;
          });
        }
      },
      prefixIcon: Icons.category_outlined,
    );
  }

  Widget _buildItemsSection() {
    return _buildSection(
      title: 'Items',
      icon: Icons.inventory_2_outlined,
      children: [
        ..._items.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;
          return _buildItemCard(index, item);
        }).toList(),
        const SizedBox(height: 16),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: _items.length > 1
                  ? () => _removeItem(_items.length - 1)
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
              onPressed: _addItem,
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
    );
  }

  Widget _buildItemCard(int index, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildModernTextField(
                  label: 'Item Name',
                  controller: item['name'],
                  hint: 'Enter item name',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildModernTextField(
                  label: 'Description',
                  controller: item['description'],
                  hint: 'Enter description',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildModernTextField(
                  label: 'Qty',
                  controller: item['qty'],
                  hint: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: _buildModernDropdown(
                  label: "Unit",
                  value: item['unit'],
                  items: ['PCS', 'BOX', 'KG', 'L'],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        item['unit'] = val;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 4,
                child: _buildModernTextField(
                  label: 'Price',
                  controller: item['price'],
                  hint: '0.00',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.attach_money,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upload Purchase Proof',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
            if (_files.isNotEmpty)
              TextButton(
                onPressed: () => setState(() => _files.clear()),
                child: Text(
                  'Clear',
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickFiles,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.upload_file, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Text(
                  _files.isEmpty
                      ? 'Choose File to Upload'
                      : '${_files.length} file(s) selected',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_files.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _files
                  .map(
                    (file) => Chip(
                      label: Text(
                        file.path.split(Platform.pathSeparator).last,
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                      onDeleted: () {
                        setState(() {
                          _files.remove(file);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        const SizedBox(height: 4),
        Text(
          'Supported formats: JPG, PNG, GIF, SVG (Max. 5MB)',
          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return _buildModernTextField(
      label: 'Notes',
      hint: 'Masukkan catatan / remarks',
      maxLines: 3,
      controller: _notesController,
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 97, 110, 255),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color.fromARGB(255, 43, 42, 66)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Purchases will require approval from the Area Manager and Head Office before being processed.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
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
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
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
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Add'),
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

  Widget _buildModernTextField({
    required String label,
    String? hint,
    TextEditingController? controller,
    IconData? prefixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
    TextInputType? keyboardType,
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
          onTap: onTap,
          maxLines: maxLines,
          keyboardType: keyboardType,
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
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildModernDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    IconData? prefixIcon,
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
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: GoogleFonts.poppins(fontSize: 13)),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: Colors.grey[600])
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
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
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800]),
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
}

class _StatusBadgeHorizontal extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color textColor;
  const _StatusBadgeHorizontal({
    required this.icon,
    required this.text,
    required this.color,
    required this.textColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 110),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.13),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 15),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: textColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernTooltip extends StatelessWidget {
  final String description;
  final VoidCallback onClose;
  const _ModernTooltip({
    required this.description,
    required this.onClose,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline, color: Color(0xFFE91E63), size: 18),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClose,
                child: Icon(Icons.close, size: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
        Positioned(
          top: -10,
          left: 24,
          child: CustomPaint(
            size: Size(18, 10),
            painter: _TooltipArrowPainter(),
          ),
        ),
      ],
    );
  }
}

class _TooltipArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawShadow(path, Colors.black.withOpacity(0.10), 3, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InfoRowIcon extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String label;
  final String value;
  const _InfoRowIcon({
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          label + ':',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _InfoRowIconModern extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String label;
  final String value;
  const _InfoRowIconModern({
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: iconBg.withOpacity(0.18), blurRadius: 6),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 16),
        Text(
          label + ':',
          style: GoogleFonts.orbitron(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.orbitron(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _InfoValueRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String value;
  const _InfoValueRow({
    required this.icon,
    required this.iconBg,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: iconBg.withOpacity(0.13), blurRadius: 3),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 15),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.orbitron(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.05,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MobileFloatingNavBarGlass extends StatelessWidget {
  const _MobileFloatingNavBarGlass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double navBarHeight = 62;
    final double fabSize = 54;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.94,
          height: navBarHeight,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _NavBarIcon(
                icon: Icons.home_rounded,
                label: 'Home',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardPage(selectedIndex: 0),
                    ),
                  );
                },
              ),
              // Tombol Add di tengah, lebih besar
              GestureDetector(
                onTap: () async {
                  final state = context
                      .findAncestorStateOfType<_DirectPurchasePageState>();
                  state?._showAddDirectPurchaseForm();
                },
                child: Container(
                  width: fabSize,
                  height: fabSize,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE040FB), Color(0xFF7B1FA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFE040FB).withOpacity(0.18),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Icon(Icons.add, color: Colors.white, size: 32),
                  ),
                ),
              ),
              _NavBarIcon(
                icon: Icons.person_rounded,
                label: 'Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserprofilePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//icon for navigation bar
class _NavBarIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _NavBarIcon({
    required this.icon,
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Color(0xFF7B1FA2), size: 25),
              SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF7B1FA2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
