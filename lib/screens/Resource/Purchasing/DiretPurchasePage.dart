import "dart:ui";
import "package:flutter/material.dart";
import 'package:miniproject_flutter/screens/Resource/Auth/Help_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/UserProfile_Page.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/HeaderFloatingCard.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/TitleCardDirectPurchase.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/PurchaseSimpleCard.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/SearchAndFilterBar.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/AddDirectPurchaseForm.dart';
import 'package:miniproject_flutter/services/DirectService.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/SidebarDrawer.dart';


class DirectPurchasePage extends StatefulWidget {
  final int selectedIndex;
  DirectPurchasePage({this.selectedIndex = 11, Key? key})
    : super(key: key);

  @override
  _DirectPurchasePageState createState() => _DirectPurchasePageState();
}

class _DirectPurchasePageState extends State<DirectPurchasePage>
    with TickerProviderStateMixin {
  // Tambahkan controller untuk search
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _directPurchases = [];
  bool _isLoading = false;
  String? _errorMessage;
  int? _expandedMenuIndex;
  int? _hoveredIndex;
  bool _isSidebarExpanded = true;
  int _selectedIndex = 11;

  // Tambahkan variabel state untuk store dan user
  List<String> _storeList = ['HAUS Jakarta', 'HAUS Bandung', 'HAUS Surabaya', 'HAUS Medan'];
  String _selectedStore = 'HAUS Jakarta';
  String _userName = 'John Doe';
  String _userRole = 'Admin';

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _fetchDirectPurchases();
  }

  Future<void> _fetchDirectPurchases() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await DirectService().getDirectPurchases();
      setState(() {
        _directPurchases = data['data'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data: \\${e.toString()}';
      });
    }
  }

  void _showSearchDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Search',
      barrierColor: Colors.transparent,
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 90),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cari Transaksi',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color.fromARGB(255, 255, 0, 85),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.grey[600]),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        SearchAndFilterBar(
                          controller: _searchController,
                          onChanged: (val) {},
                          onFilterTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Icon petunjuk di bawah pop-up, sejajar dengan tombol search
            Positioned(
              left: 0,
              right: 0,
              bottom: 40, // sedikit di atas navigation bar
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 60), // sesuaikan agar sejajar dengan tombol search
                    child: Icon(
                    
                      Icons.arrow_drop_down_rounded , // panah ke atas
                      size: 80,
                      color: Color.fromARGB(255, 29, 21, 116),
                    ),
                    
                  ),
                ],
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(
            begin: Offset(0, 1),
            end: Offset(0, 0),
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 350),
    );
  }

  void _showAddDirectPurchaseDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add',
      barrierColor: Colors.transparent,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 90),
            child: AddDirectPurchaseForm(
              onSuccess: () {
                Navigator.of(context).pop();
                _fetchDirectPurchases(); // refresh data setelah tambah
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(
            begin: Offset(0, 1),
            end: Offset(0, 0),
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 350),
    );
  }

  // Tambahkan helper untuk menutup semua dropdown
  void _closeAllDropdowns() {
    setState(() {
      _expandedMenuIndex = null;
    });
  }

  void _showSidebarDrawer() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Sidebar',
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.centerLeft,
          child: SidebarDrawer(
            selectedIndex: _selectedIndex,
            onNavigate: (int idx) {
              Navigator.of(context).pop();
              _navigateToPage(idx);
              _closeAllDropdowns();
            },
            isSidebarExpanded: _isSidebarExpanded,
            onClose: () => Navigator.of(context).pop(),
            storeList: _storeList,
            selectedStore: _selectedStore,
            onSelectStore: (String store) {
              setState(() {
                _selectedStore = store;
              });
            },
            userName: _userName,
            userRole: _userRole,
            onProfile: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserprofilePage(),
                ),
              );
            },
            onSettings: () {},
            onHelp: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              );
            },
            onLogout: () async {
              // await _handleLogout();
            },
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final offset = Tween<Offset>(
          begin: Offset(-1, 0),
          end: Offset(0, 0),
        ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutBack));
        return SlideTransition(
          position: offset,
          child: child,
        );
      },
    );
  }

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;
    final Color primary =Color.fromARGB(255,255,0,85);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: HeaderFloatingCard(
                    isMobile: isMobile,
                    onMenuTap: _showSidebarDrawer,
                    onEmailTap: () {},
                    onNotifTap: () {},
                    onAvatarTap: () {},
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
                  child: TitleCardDirectPurchase(isMobile: isMobile),
                ),
                // Konten utama
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _errorMessage != null
                          ? Center(child: Text(_errorMessage!))
                          : ListView(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 8,
                                bottom: 90,
                              ),
                              children: _directPurchases.map<Widget>((item) => PurchaseSimpleCard(
                                noDirect: item['no_direct'] ?? item['noDirect'] ?? item['no_direct_purchase'] ?? item['noDirectPurchase'] ?? item['direct_number'] ?? '-',
                                status: item['status'] ?? '-',
                                date: item['directPurchaseDate'] ?? item['date'] ?? '-',
                                supplier: item['supplier'] ?? '-',
                                items: '${item['items']?.length ?? 0} items',
                                total: item['totalAmount']?.toString() ?? '-',
                                data: item,
                              )).toList(),
                            ),
                ),
              ],
            ),
            // Navigation bar floating di bawah layar
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  color: Colors.white,
                  child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.shopping_cart, color: primary, size: 28),
                        onPressed: () {},
                        tooltip: 'Keranjang',
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white, size: 28),
                          onPressed: _showAddDirectPurchaseDialog,
                          tooltip: 'Add',
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search, color: primary, size: 28),
                        onPressed: _showSearchDialog,
                        tooltip: 'Search',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
