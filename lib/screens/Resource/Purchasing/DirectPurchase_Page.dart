import 'package:flutter/material.dart';
import 'dart:io';
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
import 'dart:ui';

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
  late AnimationController _notificationAnimationController;
  OverlayEntry? _notificationOverlayEntry;
  final GlobalKey _notificationIconKey = GlobalKey();

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

  // Tambahan untuk integrasi API
  final DirectService _directService = DirectService();
  List<dynamic> _directPurchases = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  final AuthService _authService = AuthService();

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
    _notificationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _notificationAnimationController.dispose();
    if (_notificationOverlayEntry != null) {
      _notificationOverlayEntry!.remove();
      _notificationOverlayEntry = null;
    }
    super.dispose();
  }

  final Color primaryColor = const Color(0xFFF8BBD0);
  final Color deepPink = const Color.fromARGB(255, 233, 30, 99);
  final Color lightPink = const Color(0xFFFCE4EC);

  static const int PURCHASING_MENU = 1;
  static const int STOCK_MANAGEMENT_MENU = 2;

  bool? get isMobile => null;

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
      final status = isOutstandingSelected ? null : 'Approved';

      final data = await _directService.getDirectPurchases(
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
          // Jika di tab Approved, filter yang statusnya 'Approved'
          _directPurchases = allPurchases
              .where((item) => (item['status'] as String?) == 'Approved')
              .toList();
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
  //===================================================================================================================== //
  //Todo:Rangkaian fungsi dan styling untuk header dan item lain
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 72 : 84),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 233, 30, 99),
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
                    ),
                  if (isMobile) const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Direct Purchase',
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
                  _modernHeaderIconBar(isMobile),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: _buildSidebarContent(
          isMobile: true,
          closeDrawer: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: Column(
        children: [
          // Search Bar & Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Row(
              children: [
                Expanded(child: _buildModernSearchBar()),
                const SizedBox(width: 14),
                _modernHeaderIcon(
                  icon: Icons.filter_alt_outlined,
                  onTap: () {
                    // TODO: Implement filter logic
                  },
                  isMobile: isMobile,
                  color: deepPink,
                ),
              ],
            ),
          ),
          // Status Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
            child: _buildStatusTabs(),
          ),
          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(child: Text(_errorMessage!))
                    : _directPurchases.isEmpty
                        ? Center(
                            child: Text(
                              'Tidak ada data',
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchDirectPurchases,
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
      floatingActionButton: Tooltip(
        message: "Add New Direct Purchase",
        child: FloatingActionButton(
          onPressed: _showAddDirectPurchaseForm,
          backgroundColor: deepPink,
          child: const Icon(Icons.add, size: 30, color: Colors.white),
          shape: const CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildModernSearchBar() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.0),
      elevation: 4.0,
      shadowColor: Colors.black.withOpacity(0.05),
      child: TextField(
        onChanged: _onSearchChanged,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 22),
          hintText: 'Search by No Direct, Supplier, etc.',
          hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          _buildTabItem('Outstanding', true),
          _buildTabItem('Approved', false),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, bool isOutstandingTab) {
    final isSelected = isOutstandingSelected == isOutstandingTab;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabChanged(isOutstandingTab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? deepPink : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey[600],
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDirectPurchaseCardFromApi(dynamic item) {
    // Mapping status dan badge
    String status = item['status'] ?? 'Unknown';
    Color badgeColor, badgeTextColor;
    IconData badgeIcon;

    switch (status) {
      case 'Pending Area Manager':
        badgeColor = const Color(0xFFFFF9C4); // Light Yellow
        badgeTextColor = const Color(0xFFFBC02D); // Amber
        badgeIcon = Icons.hourglass_top_rounded;
        break;
      case 'Approved Area Manager':
        badgeColor = const Color(0xFFD1C4E9); // Light Purple
        badgeTextColor = const Color(0xFF5E35B1); // Deep Purple
        badgeIcon = Icons.verified_user_rounded;
        break;
      case 'Approved':
        badgeColor = const Color(0xFFC8E6C9); // Light Green
        badgeTextColor = const Color(0xFF388E3C); // Green
        badgeIcon = Icons.check_circle_rounded;
        break;
      default:
        badgeColor = Colors.grey.shade200;
        badgeTextColor = Colors.grey.shade800;
        badgeIcon = Icons.info_outline_rounded;
    }

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: No Direct & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NO. DIRECT PURCHASE',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              getNoDirect(item),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: deepPink,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: Icon(
                              Icons.copy,
                              size: 18,
                              color: Colors.grey[400],
                            ),
                            tooltip: 'Copy No Direct',
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: getNoDirect(item)),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No Direct berhasil disalin!'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(badgeIcon, color: badgeTextColor, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: badgeTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            // Details: Supplier and Date
            _buildInfoRow(
              icon: Icons.store_mall_directory_outlined,
              label: 'Supplier',
              value: item['supplier'] ?? '-',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              value: getDate(item),
            ),
            const SizedBox(height: 20),
            // Action Button
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: () => _showDetailPopup(item),
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.white,
                ),
                label: Text(
                  'View Details',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: deepPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[500], size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ],
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

  Widget _buildSidebarContent({
    bool isMobile = false,
    VoidCallback? closeDrawer,
  }) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Logo dan nama aplikasi
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 20,
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
                if (_isSidebarExpanded || isMobile) const SizedBox(width: 12),
                if (_isSidebarExpanded || isMobile)
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
          if (_isSidebarExpanded || isMobile) _buildStoreDropdown(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Section GENERAL
                  if (_isSidebarExpanded || isMobile)
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
                    onTap: () {
                      if (_selectedIndex != 0) {
                        _navigateToPage(0);
                      }
                      if (isMobile && closeDrawer != null) closeDrawer();
                    },
                  ),
                  _buildExpandableMenu(
                    icon: Icons.shopping_bag_rounded,
                    title: 'Purchasing',
                    isExpanded: _isMenuExpanded(PURCHASING_MENU, [11, 12]),
                    menuIndex: PURCHASING_MENU,
                    children: [
                      _buildSubMenuItem(
                        'Direct Purchase',
                        11,
                        isMobile: isMobile,
                        closeDrawer: closeDrawer,
                      ),
                      _buildSubMenuItem(
                        'GRPO',
                        12,
                        isMobile: isMobile,
                        closeDrawer: closeDrawer,
                      ),
                    ],
                    onTap: () {
                      // This onTap is for the main expandable menu header
                    },
                  ),
                  _buildExpandableMenu(
                    icon: Icons.inventory_rounded,
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
                      _buildSubMenuItem(
                        'Material Request',
                        21,
                        isMobile: isMobile,
                        closeDrawer: closeDrawer,
                      ),
                      _buildSubMenuItem(
                        'Material Calculate',
                        25,
                        isMobile: isMobile,
                        closeDrawer: closeDrawer,
                      ),
                      _buildSubMenuItem(
                        'Stock Opname',
                        22,
                        isMobile: isMobile,
                        closeDrawer: closeDrawer,
                      ),
                      _buildSubMenuItem(
                        'Transfer Stock',
                        23,
                        isMobile: isMobile,
                        closeDrawer: closeDrawer,
                      ),
                      _buildSubMenuItem(
                        'Waste',
                        24,
                        isMobile: isMobile,
                        closeDrawer: closeDrawer,
                      ),
                    ],
                    onTap: () {
                      // This onTap is for the main expandable menu header
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.bar_chart_rounded,
                    title: 'Inventory Report',
                    index: 3,
                    onTap: () {
                      if (_selectedIndex != 3) _navigateToPage(3);
                      if (isMobile && closeDrawer != null) closeDrawer();
                    },
                  ),
                  // Section TOOLS
                  if (_isSidebarExpanded || isMobile)
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
                    onTap: () {
                      if (_selectedIndex != 4) _navigateToPage(4);
                      if (isMobile && closeDrawer != null) closeDrawer();
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.help_center_rounded,
                    title: 'Help',
                    index: 5,
                    onTap: () {
                      if (_selectedIndex != 5) _navigateToPage(5);
                      if (isMobile && closeDrawer != null) closeDrawer();
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_isSidebarExpanded || isMobile) _buildProfileDropdown(),
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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? deepPink.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? deepPink : Colors.grey[600],
          size: 22,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: isActive ? deepPink : Colors.grey[800],
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
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
    final bool highlightParent = isAnySubMenuActive || isMenuExpanded;
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: highlightParent && !isAnySubMenuActive
                ? deepPink.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              icon,
              color: highlightParent ? deepPink : Colors.grey[600],
              size: 22,
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                color: highlightParent ? deepPink : Colors.grey[800],
                fontWeight:
                    highlightParent ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
            trailing: AnimatedRotation(
              turns: isMenuExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.expand_more,
                color: highlightParent ? deepPink : Colors.grey,
              ),
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
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 2,
            ),
          ),
        ),
        if (isMenuExpanded && (_isSidebarExpanded || isMobile))
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(left: 32, top: 4, bottom: 4),
            padding: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.grey.withOpacity(0.3),
                  width: 1.5,
                ),
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
        margin: const EdgeInsets.only(left: 0, right: 8, top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: isActive ? deepPink.withOpacity(0.1) : Colors.transparent,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: ListTile(
          leading: Icon(
            _getSubMenuIcon(index),
            color: isActive ? deepPink : Colors.grey[600],
            size: 20,
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isActive ? deepPink : Colors.black87,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
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
              _navigateToPage(index);
              if (isMobile && closeDrawer != null) closeDrawer();
            }
          },
          dense: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
        ),
      ),
    );
  }

  //Todo : Routing navigation page for each menu
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

  // Todo :Routing navigation page for each dropdown page
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

  //Todo : Icons
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
        color: const Color(0xFFFFF1F5),
        borderRadius: BorderRadius.circular(16),
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
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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

  Widget _modernHeaderIconBar(bool isMobile) {
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
          SizedBox(width: isMobile ? 10 : 18),
          _modernHeaderIcon(
            icon: Icons.mail_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmailPage()),
              );
            },
            isMobile: isMobile,
            glass: true,
            iconSize: isMobile ? 24 : 28,
            color: Colors.white,
          ),
          SizedBox(width: isMobile ? 10 : 18),
          _modernHeaderAvatar(isMobile: isMobile, glass: true),
        ],
      ),
    );
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
                color: color != null && !glass ? deepPink : Colors.white,
                size: iconSize ?? (isMobile ? 22 : 26),
              ),
              if (badge)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
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

  Widget _modernHeaderAvatar({bool isMobile = false, bool glass = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _showProfileMenu(context);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(isMobile ? 4 : 6),
          decoration: BoxDecoration(
            color: glass
                ? Colors.white.withOpacity(0.35)
                : Colors.white.withOpacity(0.13),
            borderRadius: BorderRadius.circular(16),
            border: glass
                ? Border.all(color: Colors.white.withOpacity(0.32), width: 1.1)
                : Border.all(color: Colors.white.withOpacity(0.22)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: isMobile ? 15 : 17,
            child: Text(
              'J',
              style: TextStyle(
                color: deepPink,
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(const Offset(0, 0), ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: Builder(
            builder: (context) => _buildProfileMenuItem(
              Icons.person_outline,
              'Profile',
              onTap: () {
                Navigator.pop(context); // Close the menu first
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserprofilePage(),
                  ),
                );
              },
            ),
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Builder(
            builder: (context) => _buildProfileMenuItem(
              Icons.settings_outlined,
              'Settings',
              onTap: () {
                Navigator.pop(context);
                // Handle settings
              },
            ),
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Builder(
            builder: (context) => _buildProfileMenuItem(
              Icons.help_outline,
              'Help & Support',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpPage()),
                );
              },
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 3,
          child: Builder(
            builder: (context) => _buildProfileMenuItem(
              Icons.logout,
              'Logout',
              isLogout: true,
              onTap: () async {
                Navigator.pop(context);
                await _handleLogout();
              },
            ),
          ),
        ),
      ],
    );
  }

  // --- Notification Overlay Logic ---
  void _toggleNotificationOverlay() {
    if (_notificationAnimationController.isAnimating) return;

    if (_notificationOverlayEntry == null) {
      _showNotificationBubble();
    } else {
      _removeNotificationOverlay();
    }
  }

  void _removeNotificationOverlay() {
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
    final RenderBox renderBox =
        _notificationIconKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    _notificationOverlayEntry = OverlayEntry(
      builder: (context) => _buildNotificationBubbleAnimated(position, size),
    );

    Overlay.of(context).insert(_notificationOverlayEntry!);
    _notificationAnimationController.forward();
  }

  Widget _buildNotificationBubbleAnimated(Offset position, Size size) {
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
          right: 16,
          child: AnimatedBuilder(
            animation: _notificationAnimationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _notificationAnimationController,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.85, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _notificationAnimationController,
                      curve: Curves.easeOutBack,
                    ),
                  ),
                  alignment: Alignment.topRight,
                  child: child,
                ),
              );
            },
            child: _buildNotificationBubbleContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationBubbleContent() {
    final List<Map<String, dynamic>> previewNotifs =
        notifications.take(4).toList();
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    return Material(
      color: Colors.white.withOpacity(0.98),
      elevation: 16,
      shadowColor: Colors.black.withOpacity(0.10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: isMobile ? screenWidth * 0.85 : 340,
        constraints: BoxConstraints(maxHeight: isMobile ? 380 : 420),
        padding: const EdgeInsets.only(top: 10, bottom: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Triangle
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(right: 16, bottom: 2),
                child: ClipPath(
                  clipper: TriangleClipper(),
                  child: Container(
                      color: Colors.white.withOpacity(0.98),
                      height: 10,
                      width: 18),
                ),
              ),
            ),
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
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  itemCount: previewNotifs.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                child: Text(
                  'Lihat Semua Notifikasi',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: deepPink,
                    fontSize: 13,
                  ),
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
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - (size.width / 2), 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}

// Todo : ini souce line untuk menambahkan data baru di database
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

  // Todo : styling souce line untuk item konten

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
