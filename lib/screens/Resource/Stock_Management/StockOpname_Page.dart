import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Email_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Help_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Notification_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/DirectPurchasePage.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/GRPO_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialCalculate_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialRequest_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/TransferStock_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/Waste_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/UserProfile_Page.dart';
import 'package:miniproject_flutter/screens/DashboardPage.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/LoginPage.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/HeaderAppBar.dart';
import 'package:miniproject_flutter/widgets/Sidebar.dart';
import 'package:miniproject_flutter/widgets/StockOpname/TitleCardStockOpname.dart';
import 'package:miniproject_flutter/widgets/StockOpname/StockOpnameCard.dart';

class StockOpnamePage extends StatefulWidget {
  final int selectedIndex;
  const StockOpnamePage({this.selectedIndex = 22, Key? key}) : super(key: key);

  @override
  _StockOpnamePageState createState() => _StockOpnamePageState();
}

class _StockOpnamePageState extends State<StockOpnamePage> with TickerProviderStateMixin {
  // Sidebar states & variables
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? _expandedMenuIndex;
  int get _selectedIndex => widget.selectedIndex;

  final Color primaryColor = const Color(0xFFF8BBD0);
  final Color deepPink = const Color.fromARGB(255, 233, 30, 99);
  final Color lightPink = const Color(0xFFFCE4EC);

  // Konstanta untuk menu index
  static const int PURCHASING_MENU = 1;
  static const int STOCK_MANAGEMENT_MENU = 2;

  final AuthService _authService = AuthService();
  
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
                    // Title Card
                    if (_tabController != null)
                      TitleCardStockOpname(
                        isMobile: MediaQuery.of(context).size.width < 700,
                        tabController: _tabController!,
                      ),
                    SizedBox(height: 18),
                    // TabBarView
                    if (_tabController != null)
                      Expanded(
                        child: TabBarView(
                          controller: _tabController!,
                          children: [
                                                        // Ongoing Tab
                            SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 90),
                              child: Column(
                                children: [
                          StockOpnameCard(
                            docNum: 'SO-2024-0125',
                            outlet: 'HAUS Jakarta',
                            qty: '2000',
                            status: 'Running',
                            date: '15/03/2024',
                            inputDate: '15/03/2024',
                          ),
                          StockOpnameCard(
                            docNum: 'SO-2024-0125',
                            outlet: 'HAUS Jakarta',
                            qty: '1500',
                            status: 'Running',
                            date: '15/03/2024',
                            inputDate: '15/03/2024',
                          ),
                          StockOpnameCard(
                            docNum: 'SO-2024-0125',
                            outlet: 'HAUS Jakarta',
                            qty: '1500',
                            status: 'Running',
                            date: '15/03/2024',
                            inputDate: '15/03/2024',
                          ),
                                ],
                              ),
                            ),
                            // Completed Tab
                            SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 90),
                              child: Column(
                                children: [
                          StockOpnameCard(
                            docNum: 'SO-2023-4',
                            outlet: 'Outlet D',
                            qty: '12',
                            status: 'Completed',
                            date: '15/03/2024',
                            inputDate: '15/03/2024',
                          ),
                          StockOpnameCard(
                            docNum: 'SO-2023-5',
                            outlet: 'Outlet E',
                            qty: '7',
                            status: 'Completed',
                            date: '15/03/2024',
                            inputDate: '15/03/2024',
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
          ],
        ),
      ),
      floatingActionButton: Tooltip(
        message: "Add New Stock Opname",
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => Container(
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
                child: _StockOpnameModal(),
              ),
            );
          },
          backgroundColor: const Color(0xFFE91E63),
          child: Icon(Icons.add, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }



  




}

class _StockOpnameModal extends StatefulWidget {
  @override
  State<_StockOpnameModal> createState() => _StockOpnameModalState();
}

class _StockOpnameModalState extends State<_StockOpnameModal> {
  String? _noStockOpname = '';
  DateTime? _stockOpnameDate = DateTime.now();
  DateTime? _inputStockOpnameDate = DateTime.now();
  String? _countedBy = '';
  String? _preparedBy = 'John Doe';
  String? _outlet = 'Haus Jakarta';
  List<Map<String, dynamic>> _items = [
    {'code': 'BV-001', 'name': 'Boba', 'qty': 100, 'uom': 'gram'},
  ];

  final List<String> _itemCodes = ['BV-001', 'BV-002', 'BV-003'];
  final List<String> _itemNames = ['Boba', 'Cincau', 'Susu'];
  final List<String> _uoms = ['gram', 'pcs', 'ml'];

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
                      'Add New Stock Opname',
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
                    title: 'Stock Opname Information',
                    icon: Icons.info_outline,
                    children: [
                Row(
                  children: [
                    Expanded(
                            child: _buildModernTextField(
                        label: 'No. Stock Opname',
                        hint: 'SO - 1234',
                              initialValue: _noStockOpname,
                        onChanged: (v) => setState(() => _noStockOpname = v),
                      ),
                    ),
                          const SizedBox(width: 16),
                    Expanded(
                            child: _buildModernTextField(
                        label: 'Stock Opname Date',
                              hint: _stockOpnameDate != null ? _stockOpnameDate!.toString().substring(0, 10) : 'Select Date',
                        readOnly: true,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _stockOpnameDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                                if (picked != null) setState(() => _stockOpnameDate = picked);
                        },
                              prefixIcon: Icons.calendar_today,
                      ),
                    ),
                  ],
                ),
                      const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                            child: _buildModernTextField(
                        label: 'Input Stock Opname Date',
                              hint: _inputStockOpnameDate != null ? _inputStockOpnameDate!.toString().substring(0, 10) : 'Select Date',
                        readOnly: true,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                                  initialDate: _inputStockOpnameDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                                if (picked != null) setState(() => _inputStockOpnameDate = picked);
                        },
                              prefixIcon: Icons.calendar_today,
                      ),
                    ),
                          const SizedBox(width: 16),
                    Expanded(
                            child: _buildModernTextField(
                        label: 'Counted By',
                        hint: 'Emy',
                              initialValue: _countedBy,
                        onChanged: (v) => setState(() => _countedBy = v),
                      ),
                    ),
                  ],
                ),
                      const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                            child: _buildModernTextField(
                        label: 'Prepared by',
                        hint: _preparedBy,
                        readOnly: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                          const SizedBox(width: 16),
                    Expanded(
                            child: _buildModernTextField(
                        label: 'Outlet/Store',
                        hint: _outlet,
                        readOnly: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ],
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
                            onPressed: _items.length > 1 ? () => setState(() => _items.removeLast()) : null,
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
                            'Stock Opname will require approval from the Area Manager and Supply Chain before being processed.',
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
                                      child: _modernLabeledDropdown(
                                        label: 'Item Code',
                                        hint: 'Pilih kode barang',
                                        value: item['code'],
                                        items: _itemCodes,
                  onChanged: (v) => setState(() => item['code'] = v),
                                        ),
                                      ),
              const SizedBox(width: 16),
                                    Expanded(
                                      child: _modernLabeledDropdown(
                                        label: 'Item Name',
                                        hint: 'Pilih nama barang',
                                        value: item['name'],
                                        items: _itemNames,
                  onChanged: (v) => setState(() => item['name'] = v),
                                        ),
                                      ),
            ],
                                    ),
          const SizedBox(height: 12),
          Row(
            children: [
                                    Expanded(
                                      child: _modernLabeledInput(
                                        label: 'Qty',
                                        hint: 'Jumlah',
                                        value: item['qty'].toString(),
                                        keyboardType: TextInputType.number,
                  onChanged: (v) => setState(() => item['qty'] = int.tryParse(v) ?? 1),
                                        ),
                                      ),
              const SizedBox(width: 16),
                                    Expanded(
                                      child: _modernLabeledInput(
                                        label: 'UoM',
                                        hint: 'Satuan',
                                        value: item['uom'],
                                        readOnly: true,
                                        fillColor: Colors.grey[200],
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
    String? hint,
    String? initialValue,
    bool readOnly = false,
    IconData? prefixIcon,
    Color? fillColor,
    void Function()? onTap,
    void Function(String)? onChanged,
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
          initialValue: initialValue,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
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
            fillColor: fillColor ?? Colors.white,
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

  Widget _modernLabeledInput({
    required String label,
    String? hint,
    String? value,
    TextInputType? keyboardType,
    bool readOnly = false,
    Color? fillColor,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
        SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          keyboardType: keyboardType,
          readOnly: readOnly,
          style: GoogleFonts.poppins(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[400],
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            filled: fillColor != null,
            fillColor: fillColor,
          ),
        ),
      ],
    );
  }

  Widget _modernLabeledDropdown({
    required String label,
    String? hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
        SizedBox(height: 4),
        DropdownButtonFormField<String>(
            value: value,
          isExpanded: true,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              filled: true,
            fillColor: Colors.white,
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[400],
              ),
              constraints: BoxConstraints(minHeight: 44),
            ),
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
            dropdownColor: Colors.white,
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
