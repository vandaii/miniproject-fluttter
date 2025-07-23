import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Email_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Help_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Notification_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/UserProfile_Page.dart';
import 'package:miniproject_flutter/screens/DashboardPage.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/LoginPage.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/DirectPurchasePage.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/GRPO_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialRequest_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/StockOpname_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/TransferStock_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/Waste_Page.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/HeaderAppBar.dart';
import 'package:miniproject_flutter/widgets/Sidebar.dart';
import 'dart:ui';

class MaterialCalculatePage extends StatefulWidget {
  final int selectedIndex;
  const MaterialCalculatePage({this.selectedIndex = 25, Key? key})
    : super(key: key);

  @override
  State<MaterialCalculatePage> createState() => _MaterialCalculatePageState();
}

class _MaterialCalculatePageState extends State<MaterialCalculatePage> {
  // Scaffold and sidebar states
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? _expandedMenuIndex;
  int get _selectedIndex => widget.selectedIndex;

  final Color primaryColor = const Color(0xFFF8BBD0);
  final Color deepPink = const Color.fromARGB(255, 233, 30, 99);
  final Color lightPink = const Color(0xFFFCE4EC);

  // Constants for menu index
  static const int PURCHASING_MENU = 1;
  static const int STOCK_MANAGEMENT_MENU = 2;

  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

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
            content: Text('Gagal logout:  [${e.toString()}'),
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

  // Dummy data untuk dropdown dan tabel
  final List<Map<String, String>> itemList = [
    {'code': 'BV-001', 'name': 'Boba'},
    {'code': 'BV-002', 'name': 'Jelly'},
    {'code': 'BV-003', 'name': 'Pudding'},
  ];
  final List<String> uomList = ['gram', 'ml', 'pcs'];

  String? selectedCode;
  String? selectedName;
  String? selectedUom;
  int qty = 100;

  // Dummy breakdown
  List<Map<String, dynamic>> breakdown = [
    {'code': 'T-4', 'name': 'Tepung Tapioka', 'qty': 20, 'uom': 'gram'},
    {'code': 'A-1', 'name': 'Air Mineral', 'qty': 250, 'uom': 'ml'},
    {'code': 'B-2', 'name': 'Perisa Brown Sugar', 'qty': 100, 'uom': 'gram'},
  ];

  int currentPage = 1;
  int totalPages = 13;

  @override
  void initState() {
    super.initState();
    selectedCode = itemList[0]['code'];
    selectedName = itemList[0]['name'];
    selectedUom = uomList[0];
    qty = 100;
    // Set expanded menu otomatis sesuai submenu yang sedang selected
    if ([11, 12].contains(_selectedIndex)) {
      _expandedMenuIndex = PURCHASING_MENU;
    } else if ([21, 22, 23, 24, 25].contains(_selectedIndex)) {
      _expandedMenuIndex = STOCK_MANAGEMENT_MENU;
    }
  }

  void _calculateItem() {
    setState(() {});
  }

  void _refresh() {
    setState(() {});
  }

  void _showAddMaterialRequestModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
        );
      },
    );
  }
  
  // Navigation helper method
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          color: deepPink,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 16, bottom: 8),
          child: HeaderFloatingCard(
            isMobile: true,
            onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
            onEmailTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EmailPage())),
            onNotifTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage())),
            onAvatarTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserprofilePage())),
            searchController: _searchController,
            searchFocusNode: _searchFocusNode,
            onSearchChanged: (value) {
              // Handle search
            },
            avatarInitial: 'J',
          ),
        ),
      ),
      backgroundColor: Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Item',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            Container(
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
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: selectedCode,
                          decoration: InputDecoration(
                            labelText: 'Item Code',
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFFE91E63)),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          items: itemList
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item['code'],
                                  child: Text(
                                    item['code']!,
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedCode = val;
                              selectedName = itemList.firstWhere(
                                (e) => e['code'] == val,
                              )['name'];
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<String>(
                          value: selectedName,
                          decoration: InputDecoration(
                            labelText: 'Item Name',
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFFE91E63)),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          items: itemList
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item['name'],
                                  child: Text(
                                    item['name']!,
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedName = val;
                              selectedCode = itemList.firstWhere(
                                (e) => e['name'] == val,
                              )['code'];
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          initialValue: qty.toString(),
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.poppins(fontSize: 13),
                          decoration: InputDecoration(
                            labelText: 'Qty',
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFFE91E63)),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              qty = int.tryParse(val) ?? 1;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: selectedUom,
                          decoration: InputDecoration(
                            labelText: 'UoM',
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFFE91E63)),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          items: uomList
                              .map(
                                (uom) => DropdownMenuItem(
                                  value: uom,
                                  child: Text(
                                    uom,
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedUom = val;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red[400]!, Colors.red[600]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.2),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _calculateItem,
                    icon: Icon(Icons.calculate, size: 18),
                    label: Text(
                      'Calculate',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE91E63),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Raw Material Breakdown',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            Container(
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
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Item Code',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Item Name',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Qty',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'UoM',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...breakdown.map(
                    (row) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              row['code'],
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey[800],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              row['name'],
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey[800],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              row['qty'].toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey[800],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              row['uom'],
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey[800],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1 - 10 of 13 Pages',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Page ',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      DropdownButton<int>(
                        value: currentPage,
                        underline: SizedBox(),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Color(0xFFE91E63),
                          fontWeight: FontWeight.w500,
                        ),
                        items: List.generate(totalPages, (i) => i + 1)
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.toString()),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            currentPage = val!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _refresh,
                child: Text(
                  'Refresh',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF43A047),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      extendBody: true,
      extendBodyBehindAppBar: false,
    );
  }

  // Sidebar implementation has been replaced with SidebarWidget
  }

  // Menu item implementation has been replaced with SidebarWidget

  // Expandable menu implementation has been replaced with SidebarWidget

  // Sub menu item implementation has been replaced with SidebarWidget

 

  // Sub menu icon implementation has been replaced with SidebarWidget

  // Store dropdown and menu item implementations have been replaced with SidebarWidget

  // Profile dropdown and menu item implementations have been replaced with SidebarWidget
