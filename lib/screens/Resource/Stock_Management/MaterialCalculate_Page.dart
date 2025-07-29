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
import 'package:miniproject_flutter/component/HeaderAppBar.dart';
import 'package:miniproject_flutter/component/Sidebar.dart';
import 'package:miniproject_flutter/widgets/MaterialCalculate/TitleCardMaterialCalculate.dart';
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
  final Color deepPink = const Color.fromARGB(255, 255, 0, 85);
  final Color lightPink = const Color(0xFFFCE4EC);

  // Constants for menu index
  static const int PURCHASING_MENU = 1;
  static const int STOCK_MANAGEMENT_MENU = 2;

  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  // TabController untuk title card
  TabController? _tabController;

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
    {'code': 'T-4', 'name': 'Tepung Tapioka', 'qty': 20, 'uom': 'gram', 'icon': Icons.grain},
    {'code': 'A-1', 'name': 'Air Mineral', 'qty': 250, 'uom': 'ml', 'icon': Icons.water_drop},
    {'code': 'B-2', 'name': 'Perisa Brown Sugar', 'qty': 100, 'uom': 'gram', 'icon': Icons.cake},
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

  @override
  void dispose() {
    super.dispose();
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
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    
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
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Builder(
                builder: (context) => HeaderFloatingCard(
                  isMobile: MediaQuery.of(context).size.width < 700,
                  onMenuTap: () {
                    if (isMobile) {
                      Scaffold.of(context).openDrawer();
                    } else {
                      // Handle desktop sidebar toggle if needed
                    }
                  },
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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleCardMaterialCalculate(
                      isMobile: isMobile,
                    ),
                    SizedBox(height: 18),
                    _buildCalculateContent(),
                  ],
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

  // Content method
  Widget _buildCalculateContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Item Section
          Container(
            margin: EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: deepPink,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Add Item',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item Code & Item Name Row
                        Row(
                          children: [
                            Expanded(
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
                                    borderSide: BorderSide(color: deepPink),
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
                                    borderSide: BorderSide(color: deepPink),
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
                        SizedBox(height: 16),
                        
                        // Qty, UoM & Delete Button Row
                        Row(
                          children: [
                            Expanded(
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
                                    borderSide: BorderSide(color: deepPink),
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
                                    borderSide: BorderSide(color: deepPink),
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
                                color: Colors.red[400],
                                borderRadius: BorderRadius.circular(12),
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
                ),
                
                // Calculate Button - Full Width
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _calculateItem,
                    icon: Icon(Icons.calculate, size: 18, color: Colors.white),
                    label: Text(
                      'Calculate',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: deepPink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Raw Material Breakdown Section
          Container(
            margin: EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: deepPink,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Raw Material Breakdown',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                
                // Individual Cards for each item
                ...breakdown.map((row) => Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with delete button and code
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: deepPink,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  onPressed: () {},
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                row['code'],
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          
                          // Inner container with item details
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  row['icon'],
                                  size: 16,
                                  color: deepPink,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    row['name'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 12),
                                
                                // Quantity badge
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: deepPink.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '# ${row['qty']}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: deepPink,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                
                                // Unit badge with ruler icon
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.straighten,
                                        size: 12,
                                        color: deepPink,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        row['uom'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              ],
            ),
          ),
          
          // Pagination Section - No Card Wrapper
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Text(
                      '1 - 3 of 3 items',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Page ',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: deepPink.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: deepPink.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButton<int>(
                          value: currentPage,
                          underline: SizedBox(),
                          icon: Icon(Icons.keyboard_arrow_down, color: deepPink, size: 16),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: deepPink,
                            fontWeight: FontWeight.w600,
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
                      ),
                      Text(
                        ' of 13',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [deepPink, deepPink.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: deepPink.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _refresh,
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      label: Text(
                        'Refresh',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
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
  // Sidebar implementation has been replaced with SidebarWidget

  // Menu item implementation has been replaced with SidebarWidget

  // Expandable menu implementation has been replaced with SidebarWidget

  // Sub menu item implementation has been replaced with SidebarWidget

 

  // Sub menu icon implementation has been replaced with SidebarWidget

  // Store dropdown and menu item implementations have been replaced with SidebarWidget

  // Profile dropdown and menu item implementations have been replaced with SidebarWidget
