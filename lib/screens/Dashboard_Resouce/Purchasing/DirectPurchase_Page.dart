import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Auth/Email_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Auth/Notification_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Purchasing/GRPO_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/MaterialCalculate_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/StockOpname_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/TransferStock_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/MaterialRequest_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Auth/UserProfile_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Auth/Help_Page.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/Waste_Page.dart';
import 'package:miniproject_flutter/screens/DashboardPage.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:miniproject_flutter/screens/Dashboard_Resouce/Auth/LoginPage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

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

  // Tambahan untuk integrasi API
  final AuthService _authService = AuthService();
  List<dynamic> _directPurchases = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

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
  }

  final Color primaryColor = const Color(0xFFF8BBD0);
  final Color deepPink = const Color.fromARGB(255, 233, 30, 99);
  final Color lightPink = const Color(0xFFFCE4EC);

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
      // Untuk tab "Approved", kita filter di backend dengan status 'Approved'.
      // Untuk tab "Outstanding", kita ambil semua data dan filter di sisi klien.
      // CATATAN: Ini bukan solusi ideal karena paginasi. Jika satu halaman data
      // dari server isinya item yang sudah 'Approved' semua, maka daftar 'Outstanding'
      // bisa terlihat kosong sesaat. Solusi terbaik adalah mengubah backend
      // agar mendukung filter beberapa status sekaligus.
      final status = isOutstandingSelected ? null : 'Approved';

      final data = await _authService.getDirectPurchases(
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
        status: status, // Akan mengirim null untuk tab outstanding
      );

      List<dynamic> allPurchases = data['data'] ?? [];

      setState(() {
        // Jika di tab Outstanding, kita filter secara manual di sini
        if (isOutstandingSelected) {
          _directPurchases = allPurchases.where((item) {
            final itemStatus = item['status'] as String?;
            // Item dianggap outstanding jika statusnya BUKAN 'Approved'.
            return itemStatus != null && itemStatus != 'Approved';
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

  void _onTabChanged(bool outstanding) {
    setState(() {
      isOutstandingSelected = outstanding;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color(0xFFE91E63),
          elevation: 4,
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          title: Text(
            'Direct Purchase',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          actions: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EmailPage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.mail_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      setState(() {
                        _isProfileMenuOpen = !_isProfileMenuOpen;
                        _isStoreMenuOpen = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
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
                ),
                const SizedBox(width: 12),
              ],
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
                        isExpanded: _isMenuExpanded(PURCHASING_MENU, [11, 12]),
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
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFFE91E63),
                            size: 22,
                          ),
                          hintText: 'Cari direct purchase',
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
                      onPressed: _fetchDirectPurchases,
                    ),
                  ),
                ],
              ),
            ),
            // Taskbar for Outstanding and Approved
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Outstanding Button
                GestureDetector(
                  onTap: () => _onTabChanged(true),
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
                      'Outstanding',
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
                // Approved Button
                GestureDetector(
                  onTap: () => _onTabChanged(false),
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
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(child: Text(_errorMessage!))
                  : _directPurchases.isEmpty
                  ? Center(child: Text('Tidak ada data'))
                  : RefreshIndicator(
                      onRefresh: _fetchDirectPurchases,
                      child: ListView.builder(
                        itemCount: _directPurchases.length,
                        itemBuilder: (context, index) {
                          final item = _directPurchases[index];
                          return _buildDirectPurchaseCardFromApi(item);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Tooltip(
        message: "Add New Direct Purchase",
        child: FloatingActionButton(
          onPressed: _showAddDirectPurchaseForm,
          backgroundColor: const Color(0xFFE91E63),
          child: const Icon(Icons.add, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildDirectPurchaseCardFromApi(dynamic item) {
    print(item); // Debug: cek field yang tersedia
    // Mapping status dan badge
    String status = item['status'] ?? '';
    Color badgeColor;
    Color badgeTextColor;
    IconData badgeIcon;
    String badgeText;
    if (status == 'pending_area_manager') {
      badgeColor = const Color(0xFFFFF9C4);
      badgeTextColor = const Color(0xFFFBC02D);
      badgeIcon = Icons.hourglass_top_rounded;
      badgeText = 'Pending Area Manager';
    } else if (status == 'approved_area_manager') {
      badgeColor = const Color(0xFF90CAF9);
      badgeTextColor = const Color(0xFF1565C0);
      badgeIcon = Icons.verified_user_rounded;
      badgeText = 'Approved Area Manager';
    } else if (status == 'approved_accounting') {
      badgeColor = const Color(0xFFC8E6C9);
      badgeTextColor = const Color(0xFF388E3C);
      badgeIcon = Icons.verified_rounded;
      badgeText = 'Approved Accounting';
    } else {
      badgeColor = const Color(0xFFF8BBD0);
      badgeTextColor = const Color(0xFFE91E63);
      badgeIcon = Icons.info_outline_rounded;
      badgeText = status;
    }
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'No Direct: ',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFFE91E63),
                        ),
                      ),
                      TextSpan(
                        text: getNoDirect(item),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          color: Color(0xFFE91E63),
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.store, color: Color(0xFFE91E63), size: 16),
                    SizedBox(width: 6),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Supplier: ',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                          TextSpan(
                            text: item['supplier'] ?? '-',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Color(0xFFE91E63),
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Date: ',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey[900],
                            ),
                          ),
                          TextSpan(
                            text: getDate(item),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.grey[900],
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      elevation: 0,
                      minimumSize: Size(120, 44),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 14,
            right: 18,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 120),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: badgeColor.withOpacity(0.18),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(badgeIcon, color: badgeTextColor, size: 16),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      badgeText,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
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
  }) {
    final isMenuExpanded = _expandedMenuIndex == menuIndex;
    // Cek jika ada submenu yang sedang aktif pada menu ini
    bool isAnySubMenuActive = false;
    if (menuIndex == PURCHASING_MENU) {
      isAnySubMenuActive = [11, 12].contains(_selectedIndex);
    } else if (menuIndex == STOCK_MANAGEMENT_MENU) {
      isAnySubMenuActive = [21, 22, 23, 24, 25].contains(_selectedIndex);
    }

    // Jika ada submenu aktif, nonaktifkan hover/active background pada parent
    final bool highlightParent = isExpanded && !isAnySubMenuActive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: highlightParent
                ? lightPink.withOpacity(0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: highlightParent
                    ? deepPink.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: highlightParent ? deepPink : Colors.grey,
                size: 20,
              ),
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                color: highlightParent ? deepPink : Colors.grey,
                fontWeight: highlightParent
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            trailing: Icon(
              isMenuExpanded ? Icons.expand_less : Icons.expand_more,
              color: highlightParent ? deepPink : Colors.grey,
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
                _selectedIndex = index;
                // Pastikan parent menu tetap expanded
                if ([11, 12].contains(index)) {
                  _expandedMenuIndex = PURCHASING_MENU;
                } else if ([21, 22, 23, 24, 25].contains(index)) {
                  _expandedMenuIndex = STOCK_MANAGEMENT_MENU;
                }
              });
              // Navigator.pushReplacement(context, _getPageRouteByIndex(index));
              // if (isMobile && closeDrawer != null) closeDrawer();
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

  // Route _getPageRouteByIndex(int index) {
  //   switch (index) {
  //     case 0:
  //       return MaterialPageRoute(
  //         builder: (context) => DashboardPage(selectedIndex: 0),
  //       );
  //     case 11:
  //       return MaterialPageRoute(
  //         builder: (context) => DirectPurchasePage(selectedIndex: 11),
  //       );
  //     case 12:
  //       return MaterialPageRoute(
  //         builder: (context) => GRPO_Page(selectedIndex: 12),
  //       );
  //     case 21:
  //       return MaterialPageRoute(
  //         builder: (context) => MaterialRequestPage(selectedIndex: 21),
  //       );
  //     case 22:
  //       return MaterialPageRoute(
  //         builder: (context) => StockOpnamePage(selectedIndex: 22),
  //       );
  //     case 23:
  //       return MaterialPageRoute(
  //         builder: (context) => TransferStockPage(selectedIndex: 23),
  //       );
  //     case 24:
  //       return MaterialPageRoute(
  //         builder: (context) => WastePage(selectedIndex: 24),
  //       );
  //     case 25:
  //       return MaterialPageRoute(
  //         builder: (context) => MaterialCalculatePage(selectedIndex: 25),
  //       );
  //     default:
  //       return MaterialPageRoute(
  //         builder: (context) => DirectPurchasePage(selectedIndex: 11),
  //       );
  //   }
  // }

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
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage()),
        );
        break;
      case 5:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HelpPage()),
        );
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
        item['tanggal'] ??
        item['purchase_date'] ??
        item['date'] ??
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
}

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
      await _authService.createDirectPurchase(
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
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
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
              color: Colors.grey[50],
              border: Border.all(color: Colors.grey[300]!),
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
        color: const Color.fromARGB(255, 237, 243, 255),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: const Color.fromARGB(255, 25, 118, 210),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Purchases will require approval from the Area Manager and Head Office before being processed.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color.fromARGB(255, 23, 100, 177),
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
