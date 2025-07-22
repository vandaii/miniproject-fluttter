import "dart:ui";
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Help_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/UserProfile_Page.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/HeaderAppbar.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/TitleCardDirectPurchase.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/PurchaseCard.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/SearchAndFilterBar.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/AddDirectPurchaseForm.dart';
import 'package:miniproject_flutter/services/DirectService.dart';


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
  // Tambahkan variabel state untuk expandable menu
  int? _expandedMenuIndex;
  int? _hoveredIndex;
  bool _isSidebarExpanded = true;
  int _selectedIndex = 11;
  TabController? _tabController;

  // Tambahkan variabel state untuk store dan user
  List<String> _storeList = ['HAUS Jakarta', 'HAUS Bandung', 'HAUS Surabaya', 'HAUS Medan'];
  String _selectedStore = 'HAUS Jakarta';
  String _userName = 'John Doe';
  String _userRole = 'Admin';

  final Color primary = Color.fromARGB(255,255,0,85);
  final double navBarHeight = 104.0; // Tinggi navigation bar + margin bawah

  // Tambahkan GlobalKey untuk mengakses TabController
  final GlobalKey<_DirectPurchasePageState> _pageKey = GlobalKey<_DirectPurchasePageState>();

  // Mapping tab ke status database
  final List<String> tabStatus = [
    'Pending Area Manager',
    'Approved',
    'Rejected',
    'Revision',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _tabController = TabController(length: 4, vsync: this);
    _tabController?.addListener(() {
      if (_tabController!.indexIsChanging || _tabController!.index != _tabController!.previousIndex) {
        _fetchDirectPurchases();
      }
    });
    _fetchDirectPurchases();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
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
        // DEBUG PRINT DATA
        print('DEBUG _directPurchases: ' + _directPurchases.toString());
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
                    padding: const EdgeInsets.only(right: 40), // sesuaikan agar sejajar dengan tombol search
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
          child: _buildSidebarContent(
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

  // Sidebar content builder for sidebar drawer
  Widget _buildSidebarContent({
    required int selectedIndex,
    required Function(int) onNavigate,
    required bool isSidebarExpanded,
    required VoidCallback onClose,
    required List<String> storeList,
    required String selectedStore,
    required Function(String) onSelectStore,
    required String userName,
    required String userRole,
    required VoidCallback onProfile,
    required VoidCallback onSettings,
    required VoidCallback onHelp,
    required Future<void> Function() onLogout,
  }) {
    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        children: [
          // Logo and app name
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
                const SizedBox(width: 12),
                Text(
                  'haus! Inventory',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: primary,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          // Menu Items
          Expanded(
            child: ListView(
              children: [
                _buildSectionLabel('GENERAL'),
                _buildExpandableMenu(
                  icon: Icons.shopping_cart_outlined,
                  title: 'Purchasing',
                  menuIndex: 1,
                  isExpanded: _expandedMenuIndex == 1,
                  onTap: () {
                    setState(() {
                      _expandedMenuIndex = _expandedMenuIndex == 1 ? null : 1;
                    });
                  },
                  children: [
                    _buildSubMenuItem('Direct Purchase', 11),
                    _buildSubMenuItem('GRPO', 12),
                  ],
                ),
                _buildExpandableMenu(
                  icon: Icons.inventory_2_outlined,
                  title: 'Stock Management',
                  menuIndex: 2,
                  isExpanded: _expandedMenuIndex == 2,
                  onTap: () {
                    setState(() {
                      _expandedMenuIndex = _expandedMenuIndex == 2 ? null : 2;
                    });
                  },
                  children: [
                    _buildSubMenuItem('Material Request', 21),
                    _buildSubMenuItem('Material Calculate', 25),
                    _buildSubMenuItem('Stock Opname', 22),
                    _buildSubMenuItem('Transfer Stock', 23),
                    _buildSubMenuItem('Waste', 24),
                  ],
                ),
                _buildSectionLabel('TOOLS'),
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
                _buildProfileDropdown(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tambahkan fungsi _buildExpandableMenu dan _buildSubMenuItem
  Widget _buildExpandableMenu({
    required IconData icon,
    required String title,
    required int menuIndex,
    required List<Widget> children,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.grey[700]),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
          onTap: onTap,
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Column(children: children),
          ),
      ],
    );
  }

  Widget _buildSubMenuItem(String title, int index) {
    final bool isActive = _selectedIndex == index;
    return ListTile(
      title: Text(title, style: TextStyle(color: isActive ? primary : Colors.black87, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      selected: isActive,
      onTap: () {
        if (_selectedIndex != index) {
          _navigateToPage(index);
        }
      },
    );
  }

  // Tambahkan widget section label
  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
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
    );
  }

  // Tambahkan profile dropdown sederhana di bawah
  Widget _buildProfileDropdown() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.pink[100],
            child: Text('J', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Admin', style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Icon(Icons.expand_more, color: Colors.grey),
        ],
      ),
    );
  }

  // Tambahkan fungsi _buildMenuItem
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required int index,
    required VoidCallback onTap,
  }) {
    final bool isActive = _selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isActive ? primary : Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? primary : Colors.black87,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isActive,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;
    if (_tabController == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
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
                    const SizedBox(width: 12),
                    Text(
                      'haus! Inventory',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
              // Menu Items
              Expanded(
                child: ListView(
                  children: [
                    _buildSectionLabel('GENERAL'),
                    _buildExpandableMenu(
                      icon: Icons.shopping_cart_outlined,
                      title: 'Purchasing',
                      menuIndex: 1,
                      isExpanded: _expandedMenuIndex == 1,
                      onTap: () {
                        setState(() {
                          _expandedMenuIndex = _expandedMenuIndex == 1 ? null : 1;
                        });
                      },
                      children: [
                        _buildSubMenuItem('Direct Purchase', 11),
                        _buildSubMenuItem('GRPO', 12),
                      ],
                    ),
                    _buildExpandableMenu(
                      icon: Icons.inventory_2_outlined,
                      title: 'Stock Management',
                      menuIndex: 2,
                      isExpanded: _expandedMenuIndex == 2,
                      onTap: () {
                        setState(() {
                          _expandedMenuIndex = _expandedMenuIndex == 2 ? null : 2;
                        });
                      },
                      children: [
                        _buildSubMenuItem('Material Request', 21),
                        _buildSubMenuItem('Material Calculate', 25),
                        _buildSubMenuItem('Stock Opname', 22),
                        _buildSubMenuItem('Transfer Stock', 23),
                        _buildSubMenuItem('Waste', 24),
                      ],
                    ),
                    _buildSectionLabel('TOOLS'),
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
                    _buildProfileDropdown(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: HeaderFloatingCard(
                    isMobile: isMobile,
                    onMenuTap: () {
                      if (isMobile) {
                        Scaffold.of(context).openDrawer();
                      }
                    },
                    onEmailTap: () {},
                    onNotifTap: () {},
                    onAvatarTap: () {},
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 6),
                  child: TitleCardDirectPurchase(isMobile: isMobile, tabController: _tabController!),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController!,
                    children: List.generate(4, (i) => _buildPurchaseList(tabStatus[i])),
                  ),
                ),
              ],
            ),
            // Floating navigation bar (hanya mobile)
            if (isMobile)
              Positioned(
                left: 0,
                right: 0,
                bottom: 24, // jarak dari bawah layar
                child: Center(
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.transparent,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.92,
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.shopping_cart_outlined, color: Color.fromARGB(255, 255, 0, 85), size: 28),
                            onPressed: () {
                              // Aksi ke halaman keranjang atau list purchase
                            },
                            tooltip: 'Daftar Pembelian',
                          ),
                          Container(
                            decoration: BoxDecoration(
                               gradient: LinearGradient(
                                 colors: [Color.fromARGB(255, 255, 0, 85), Color.fromARGB(255, 255, 0, 85)],
                                 begin: Alignment.topLeft,
                                 end: Alignment.bottomRight,
                               ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: IconButton(
                               icon: Icon(Icons.add, color: Colors.white, size: 28),
                              onPressed: () async {
                                await _showAddDirectPurchaseDialogWithTabSwitch(context);
                              },
                                tooltip: 'Tambah Pembelian',
                              ),
                            ),
                            IconButton(
                             icon: Icon(Icons.search, color: Color.fromARGB(255, 255, 0, 85), size: 28),
                              onPressed: _showSearchDialog,
                              tooltip: 'Cari',
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

  // Fungsi untuk menampilkan dialog tambah dan pindah ke tab Outstanding setelah sukses
  Future<void> _showAddDirectPurchaseDialogWithTabSwitch(BuildContext context) async {
    await showGeneralDialog(
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
                // Pindah ke tab Outstanding
                final TabController? tabController = DefaultTabController.of(context);
                if (tabController != null) {
                  tabController.animateTo(0);
                }
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

  Widget _buildPurchaseList(String status) {
    final filtered = _directPurchases.where((e) => (e['status'] ?? '').toString().toLowerCase() == status.toLowerCase()).toList();

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color.fromARGB(255, 255, 0, 85),
              strokeWidth: 4,
            ),
            const SizedBox(height: 18),
            Text(
              'Memuat data...',
              style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[700], fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: Color.fromARGB(255, 255, 0, 85),
      onRefresh: _fetchDirectPurchases,
      child: filtered.isEmpty
          ? _EmptyStatusWidget(status: status)
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
              children: filtered.map((item) => PurchaseSimpleCard(
                noDirect: item['noDirectPurchase'] ?? item['no_direct'] ?? '-',
                status: item['status'] ?? '-',
                date: item['date'] ?? item['directPurchaseDate'] ?? '-',
                supplier: item['supplier'] ?? '-',
                items: item['items'] ?? [],
                total: item['total_amount']?.toString() ?? item['totalAmount']?.toString() ?? '-',
                data: item,
              )).toList(),
            ),
    );
  }
}

class _EmptyStatusWidget extends StatelessWidget {
  final String status;
  const _EmptyStatusWidget({required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String msg;
    switch (status.toLowerCase()) {
      case 'approved':
        icon = Icons.verified_rounded;
        color = Colors.green;
        msg = 'Belum ada data yang disetujui.';
        break;
      case 'rejected':
        icon = Icons.cancel_rounded;
        color = Colors.red;
        msg = 'Tidak ada data yang ditolak.';
        break;
      case 'revision':
        icon = Icons.edit_rounded;
        color = Colors.orange;
        msg = 'Tidak ada data revisi.';
        break;
      default:
        icon = Icons.hourglass_empty_rounded;
        color = Colors.blueGrey;
        msg = 'Belum ada data outstanding.';
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 64),
          const SizedBox(height: 18),
          Text(
            msg,
            style: GoogleFonts.poppins(fontSize: 16, color: color, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
