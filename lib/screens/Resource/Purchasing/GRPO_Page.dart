import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Email_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/LoginPage.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Notification_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/DirectPurchase_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialCalculate_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/StockOpname_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/TransferStock_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialRequest_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/UserProfile_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Help_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/Waste_Page.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:miniproject_flutter/services/GrpoService.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Email_Page.dart';
import 'package:miniproject_flutter/screens/DashboardPage.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Notification_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/LoginPage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class GRPO_Page extends StatefulWidget {
  final int selectedIndex;
  const GRPO_Page({this.selectedIndex = 12, Key? key}) : super(key: key);

  @override
  GrpoPageState createState() => GrpoPageState();
}

class GrpoPageState extends State<GRPO_Page> {
  bool isOutstandingSelected = true;
  bool _isSidebarExpanded = true;
  bool _isProfileMenuOpen = false;
  bool _isStoreMenuOpen = false;
  int? _expandedMenuIndex;
  int? _hoveredIndex;
  int get _selectedIndex => widget.selectedIndex;

  // Tambahan untuk integrasi API
  final GrpoService _grpoService = GrpoService();
  List<dynamic> _shippingPOs = [];
  List<dynamic> _receivedGrpos = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  final Color primaryColor = const Color(0xFFF8BBD0);
  final Color deepPink = const Color.fromARGB(255, 233, 30, 99);
  final Color lightPink = const Color(0xFFFCE4EC);

  static const int PURCHASING_MENU = 1;
  static const int STOCK_MANAGEMENT_MENU = 2;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    if (_selectedIndex == 11 || _selectedIndex == 12) {
      _expandedMenuIndex = PURCHASING_MENU;
    }
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      print(
        'Fetching data for tab: ${isOutstandingSelected ? "Shipping" : "Received"}',
      );
      if (isOutstandingSelected) {
        // Tab Shipping: ambil dari endpoint shipping
        final shippingData = await _grpoService.fetchShippingPOs();
        setState(() {
          _shippingPOs = shippingData;
          _isLoading = false;
        });
        print('Shipping data count: ${shippingData.length}');
      } else {
        // Tab Received: ambil dari endpoint received
        final receivedData = await _grpoService.fetchReceivedGrpo();
        setState(() {
          _receivedGrpos = receivedData;
          _isLoading = false;
        });
        print('Received data count: ${receivedData.length}');
      }
    } catch (e) {
      print('Error fetching data: ${e}');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data: ${e.toString()}';
      });
    }
  }

  Future<void> _fetchAllData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      print('Fetching all GRPO data...');

      // Fetch semua data GRPO
      final allData = await _grpoService.fetchAllGrpo();
      print('All GRPO data received: ${allData.length} items');

      // Filter data untuk kedua tab
      final shippingData = allData.where((item) {
        final status = item['status']?.toString().toLowerCase() ?? '';
        return status.contains('shipping') ||
            status.contains('pending') ||
            status == '' ||
            status == 'null';
      }).toList();

      final receivedData = allData.where((item) {
        final status = item['status']?.toString().toLowerCase() ?? '';
        return status.contains('received') ||
            status.contains('completed') ||
            status.contains('approved');
      }).toList();

      print(
        'Filtered data - Shipping: ${shippingData.length}, Received: ${receivedData.length}',
      );

      setState(() {
        _shippingPOs = shippingData;
        _receivedGrpos = receivedData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching all data: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data: ${e.toString()}';
      });
    }
  }

  Future<void> _searchData() async {
    if (_searchQuery.trim().isEmpty) {
      _fetchData();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await _grpoService.searchGrpo(keyword: _searchQuery);
      print('Search result: ${data.length} items');

      setState(() {
        if (isOutstandingSelected) {
          // Filter search result untuk tab shipping
          _shippingPOs = data.where((item) {
            final status = item['status']?.toString().toLowerCase() ?? '';
            return status.contains('shipping') ||
                status.contains('pending') ||
                status == '' ||
                status == 'null';
          }).toList();
        } else {
          // Filter search result untuk tab received
          _receivedGrpos = data.where((item) {
            final status = item['status']?.toString().toLowerCase() ?? '';
            return status.contains('received') ||
                status.contains('completed') ||
                status.contains('approved');
          }).toList();
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal mencari data: ${e.toString()}';
      });
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    _searchData();
  }

  void _onTabChanged(bool outstanding) {
    setState(() {
      isOutstandingSelected = outstanding;
    });
    _fetchData();
  }

  void _showAddGRPOForm() async {
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: _AddGRPOFormContent(
            onSuccess: () {
              Navigator.pop(context, true);
            },
          ),
        );
      },
    );
    if (result == true) {
      print('GRPO added successfully, refreshing data...');
      // Refresh data seperti di DirectPurchase Page
      _fetchData();
    }
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color(0xFFE91E63),
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'GRPO',
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
      backgroundColor: Color(0xFFF8F9FA),
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
                          hintText: 'Cari GRPO',
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
                      onPressed: _fetchData,
                    ),
                  ),
                ],
              ),
            ),
            // Taskbar Outstanding/Received
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _onTabChanged(true),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: isOutstandingSelected
                              ? LinearGradient(
                                  colors: [
                                    Color(0xFFE91E63),
                                    Color(0xFFF8BBD0),
                                  ],
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
                        child: Center(
                          child: Text(
                            'Shipping',
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
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _onTabChanged(false),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: !isOutstandingSelected
                              ? LinearGradient(
                                  colors: [
                                    Color(0xFFE91E63),
                                    Color(0xFFF8BBD0),
                                  ],
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
                        child: Center(
                          child: Text(
                            'Received',
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
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Card List
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(child: Text(_errorMessage!))
                  : isOutstandingSelected
                  ? (_shippingPOs.isEmpty
                        ? Center(child: Text('Tidak ada data shipping'))
                        : RefreshIndicator(
                            onRefresh: _fetchData,
                            child: ListView.builder(
                              itemCount: _shippingPOs.length,
                              itemBuilder: (context, index) {
                                final item = _shippingPOs[index];
                                return _buildShippingCardFromApi(item);
                              },
                            ),
                          ))
                  : (_receivedGrpos.isEmpty
                        ? Center(child: Text('Tidak ada data received'))
                        : RefreshIndicator(
                            onRefresh: _fetchData,
                            child: ListView.builder(
                              itemCount: _receivedGrpos.length,
                              itemBuilder: (context, index) {
                                final item = _receivedGrpos[index];
                                return _buildReceivedCardFromApi(item);
                              },
                            ),
                          )),
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
              color: Color(0xFFE91E63).withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _showAddGRPOForm,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add, size: 24),
        ),
      ),
    );
  }

  Widget _buildShippingCardFromApi(dynamic item) {
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'No. Purchase Order: ',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFFE91E63),
                        ),
                      ),
                      TextSpan(
                        text: item['purchaseOrderNumber'] ?? '-',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.store, color: Color(0xFFE91E63), size: 16),
                    SizedBox(width: 6),
                    Expanded(
                      child: RichText(
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
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Color(0xFFE91E63),
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Purchase Order Date: ',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey[900],
                              ),
                            ),
                            TextSpan(
                              text: item['purchaseOrderDate'] ?? '-',
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
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: OutlinedButton.icon(
                    onPressed: () => _showDetailGrpo(item),
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
          // Status badge di pojok kanan atas
          Positioned(
            top: 14,
            right: 18,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 120),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9C4),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFF9C4).withOpacity(0.18),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_shipping_rounded,
                    color: const Color(0xFFFBC02D),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Shipping',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: const Color(0xFFFBC02D),
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

  Widget _buildReceivedCardFromApi(dynamic item) {
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'No. GRPO: ',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFFE91E63),
                        ),
                      ),
                      TextSpan(
                        text: item['noGRPO'] ?? '-',
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
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'No. Purchase Order: ',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                      TextSpan(
                        text: item['noPO'] ?? '-',
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
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.store, color: Color(0xFFE91E63), size: 16),
                    SizedBox(width: 6),
                    Expanded(
                      child: RichText(
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
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Color(0xFFE91E63),
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Receive Date: ',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey[900],
                              ),
                            ),
                            TextSpan(
                              text: item['receiveDate'] ?? '-',
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
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: OutlinedButton.icon(
                    onPressed: () => _showDetailGrpo(item),
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
          // Status badge di pojok kanan atas
          Positioned(
            top: 14,
            right: 18,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 120),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF90CAF9),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF90CAF9).withOpacity(0.18),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    color: const Color(0xFF1565C0),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Received',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: const Color(0xFF1565C0),
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

  // Detail modal mirip DirectPurchasePage
  void _showDetailGrpo(dynamic item) async {
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
                      'Detail GRPO',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildDetailRow('No GRPO', item['noGRPO'] ?? '-'),
                    _buildDetailRow('No PO', item['noPO'] ?? '-'),
                    _buildDetailRow('Receive Date', item['receiveDate'] ?? '-'),
                    _buildDetailRow('Supplier', item['supplier'] ?? '-'),
                    _buildDetailRow('Shipper', item['shipperName'] ?? '-'),
                    _buildDetailRow('Expense Type', item['expenseType'] ?? '-'),
                    _buildDetailRow('Notes', item['notes'] ?? '-'),
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
                                  '- ${itm['itemName'] ?? '-'} | Qty: ${itm['quantity']} | Unit: ${itm['unit']}',
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                              ),
                            )
                            .toList() ??
                        []),
                    SizedBox(height: 12),
                    if (item['packingSlip'] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Packing Slip:',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item['packingSlip'].toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    // CTA Received
                    if ((item['status'] ?? '').toString().toLowerCase() !=
                        'received')
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.check, color: Colors.white),
                            label: Text('Mark as Received'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF388E3C),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              try {
                                Navigator.of(context).pop();
                                await GrpoService().markAsReceived(
                                  item['noGRPO'],
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'GRPO berhasil di-mark as Received',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                _fetchData();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Gagal update status: ' + e.toString(),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                  ],
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

  bool _isMainMenuActive(int index) {
    return _selectedIndex == index;
  }

  bool _isSubMenuActive(int index) {
    return _selectedIndex == index || _hoveredIndex == index;
  }
}

class _AddGRPOFormContent extends StatefulWidget {
  final VoidCallback onSuccess;
  const _AddGRPOFormContent({Key? key, required this.onSuccess})
    : super(key: key);

  @override
  State<_AddGRPOFormContent> createState() => _AddGRPOFormContentState();
}

class _AddGRPOFormContentState extends State<_AddGRPOFormContent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _poController = TextEditingController();
  final TextEditingController _grpoController = TextEditingController();
  DateTime? _receiveDate;
  String? _expenseType = 'Inventory';
  final TextEditingController _shipperController = TextEditingController();
  String? _receiveBy = 'John Doe';
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final List<Map<String, dynamic>> _items = [];
  List<File> _files = [];
  bool _isSubmitting = false;

  final GrpoService _grpoService = GrpoService();

  @override
  void initState() {
    super.initState();
    _addItem();
    _supplierController.text = 'MTP';
  }

  void _addItem() {
    setState(() {
      _items.add({
        'code': TextEditingController(text: 'M-1300'),
        'name': TextEditingController(text: 'Bubuk Thai Tea'),
        'qty': TextEditingController(text: '50'),
        'unit': 'PCS',
      });
    });
  }

  void _removeItem(int index) {
    if (_items.length > 1) {
      final item = _items.removeAt(index);
      item['code'].dispose();
      item['name'].dispose();
      item['qty'].dispose();
      setState(() {});
    }
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

  @override
  void dispose() {
    for (var item in _items) {
      item['code'].dispose();
      item['name'].dispose();
      item['qty'].dispose();
    }
    _poController.dispose();
    _grpoController.dispose();
    _shipperController.dispose();
    _supplierController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validasi field wajib
    if (_poController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No. PO wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_receiveDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tanggal receive wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_shipperController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Shipper wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_items.any(
      (item) =>
          item['code'].text.trim().isEmpty || item['name'].text.trim().isEmpty,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item code dan name wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      // Test koneksi terlebih dahulu
      final isConnected = await _grpoService.testConnection();
      if (!isConnected) {
        throw Exception(
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
        );
      }

      // Format items sesuai backend
      final items = _items
          .map(
            (item) => {
              'item_code': item['code'].text.trim(),
              'item_name': item['name'].text.trim(),
              'quantity': int.tryParse(item['qty'].text.trim()) ?? 1,
              'unit': item['unit'] ?? 'PCS',
            },
          )
          .toList();

      // Format date sesuai backend (YYYY-MM-DD)
      final dateStr =
          '${_receiveDate!.year}-${_receiveDate!.month.toString().padLeft(2, '0')}-${_receiveDate!.day.toString().padLeft(2, '0')}';

      print('Submitting GRPO with data:');
      print('no_po: ${_poController.text.trim()}');
      print('receive_date: $dateStr');
      print('expense_type: ${_expenseType ?? 'Inventory'}');
      print('shipper_name: ${_shipperController.text.trim()}');
      print('notes: ${_notesController.text.trim()}');
      print('items: $items');
      print('files count: ${_files.length}');

      await _grpoService.createGrpo(
        noPo: _poController.text.trim(),
        receiveDate: dateStr,
        expenseType: _expenseType ?? 'Inventory',
        shipperName: _shipperController.text.trim(),
        packingSlipFiles: _files,
        notes: _notesController.text.trim(),
        items: items,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil menambah GRPO'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSuccess();
      }
    } catch (e) {
      print('Error in _submit: $e');
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
                'Add GRPO',
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
                      title: "Basic Information",
                      icon: Icons.info_outline,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildModernTextField(
                                label: 'NO. PO',
                                controller: _poController,
                                hint: 'PO-123',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildModernTextField(
                                label: 'NO. GRPO',
                                controller: _grpoController,
                                hint: 'GR-123',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildModernTextField(
                                label: 'Receive Date',
                                readOnly: true,
                                controller: TextEditingController(
                                  text: _receiveDate == null
                                      ? ''
                                      : "${_receiveDate!.day.toString().padLeft(2, '0')}/${_receiveDate!.month.toString().padLeft(2, '0')}/${_receiveDate!.year}",
                                ),
                                hint: '24/04/2025',
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      _receiveDate = date;
                                    });
                                  }
                                },
                                prefixIcon: Icons.calendar_today,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildModernDropdown(
                                label: 'Expense Type',
                                value: _expenseType,
                                items: ['Inventory', 'Non Inventory'],
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _expenseType = val;
                                    });
                                  }
                                },
                                prefixIcon: Icons.category_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildModernTextField(
                                label: 'Shipper by',
                                controller: _shipperController,
                                hint: 'Harries',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildModernDropdown(
                                label: 'Receive by',
                                value: _receiveBy,
                                items: ['John Doe', 'Jane Smith'],
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _receiveBy = val;
                                    });
                                  }
                                },
                                prefixIcon: Icons.person,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildModernTextField(
                          label: 'Supplier',
                          controller: _supplierController,
                          hint: 'MTP',
                          readOnly: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      title: 'Item',
                      icon: Icons.inventory_2_outlined,
                      children: [_buildItemTable()],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      title: 'Upload Packing Slip',
                      icon: Icons.upload_file,
                      children: [_buildFileUploadSection()],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      title: 'Notes',
                      icon: Icons.note_alt_outlined,
                      children: [
                        _buildModernTextField(
                          label: 'Notes',
                          controller: _notesController,
                          hint: 'Masukan catatan / remarks',
                          maxLines: 3,
                        ),
                      ],
                    ),
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

  Widget _buildItemTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._items.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildModernTextField(
                        label: 'Item Code',
                        controller: item['code'],
                        hint: 'Kode',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildModernTextField(
                        label: 'Item Name',
                        controller: item['name'],
                        hint: 'Nama Item',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildModernTextField(
                        label: 'Qty',
                        controller: item['qty'],
                        hint: 'Qty',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: _buildModernDropdown(
                        label: 'Unit',
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
                  ],
                ),
              ],
            ),
          );
        }).toList(),
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
              onPressed: _isSubmitting ? null : _submit,
              icon: const Icon(Icons.add),
              label: const Text('Add'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 233, 30, 99),
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

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upload Packing Slip',
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
        if (label.isNotEmpty)
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
        if (label.isNotEmpty) const SizedBox(height: 8),
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
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 233, 30, 99),
              ),
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
        if (label.isNotEmpty)
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
        if (label.isNotEmpty) const SizedBox(height: 8),
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
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 233, 30, 99),
              ),
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
              Icon(
                icon,
                color: const Color.fromARGB(255, 233, 30, 99),
                size: 20,
              ),
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
                backgroundColor: const Color.fromARGB(255, 233, 30, 99),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                shadowColor: const Color.fromARGB(
                  255,
                  233,
                  30,
                  99,
                ).withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
