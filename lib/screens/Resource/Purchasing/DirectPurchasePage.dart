import "dart:ui";
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject_flutter/screens/DashboardPage.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/Help_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/UserProfile_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/GRPO_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialCalculate_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialRequest_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/StockOpname_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/TransferStock_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/Waste_Page.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/TitleCardDirectPurchase.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/PurchaseCard.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/SearchAndFilterBar.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/AddDirectPurchaseForm.dart';
import 'package:miniproject_flutter/services/DirectService.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/FilterBottomSheet.dart';
import 'package:intl/intl.dart';
import 'package:miniproject_flutter/widgets/DirectPurchase/CartDialog.dart';
import 'package:miniproject_flutter/component/Sidebar.dart';
import 'package:miniproject_flutter/component/HeaderAppBar.dart';


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
  String _searchQuery = '';
  String? _selectedStatus;
  DateTime? _startDate;
  DateTime? _endDate;

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

  final FocusNode _searchFocusNode = FocusNode();

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
    _searchFocusNode.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _fetchDirectPurchases({String? search, bool resetSearch = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      if (resetSearch) {
        _searchQuery = '';
        _selectedStatus = null;
        _startDate = null;
        _endDate = null;
      }
      final data = await DirectService().getDirectPurchases(
        search: resetSearch ? null : (search ?? _searchQuery),
        status: _selectedStatus,
        startDate: _startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : null,
        endDate: _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : null,
      );
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
        return _SearchDialogContent(
          onSearch: (keyword) {
            setState(() {
              _searchQuery = keyword;
            });
            _fetchDirectPurchases(search: keyword);
          },
          onFilterApplied: (status, startDate, endDate) {
            final statusTabIndex = {
              'Pending Area Manager': 0,
              'Approved': 1,
              'Rejected': 2,
              'Revision': 3,
            };
            setState(() {
              _selectedStatus = status;
              _startDate = startDate;
              _endDate = endDate;
            });
            if (status != null && statusTabIndex.containsKey(status)) {
              _tabController?.animateTo(statusTabIndex[status]!);
            }
            _fetchDirectPurchases();
          },
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
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

  // Tambahkan fungsi untuk handle menu tap dari SidebarWidget
  void _handleSidebarMenuTap(int index) {
    // Routing langsung ke halaman sesuai index
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardPage(selectedIndex: 0)));
        break;
      case 11:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DirectPurchasePage(selectedIndex: 11)));
        break;
      case 12:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => GRPO_Page(selectedIndex: 12)));
        break;
      case 21:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MaterialRequestPage(selectedIndex: 21)));
        break;
      case 22:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => StockOpnamePage(selectedIndex: 22)));
        break;
      case 23:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TransferStockPage(selectedIndex: 23)));
        break;
      case 24:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => WastePage(selectedIndex: 24)));
        break;
      case 25:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MaterialCalculatePage(selectedIndex: 25)));
        break;
      case 4:
        // Account & Settings
        break;
      case 5:
        // Help
        break;
    }
  }

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bool keyboardVisible = keyboardHeight > 0;
    final double dialogLeftRightPadding = keyboardVisible ? 0 : 16;
    final bool isMobile = MediaQuery.of(context).size.width < 700;
    // Unfocus search bar jika keyboard ditutup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        _searchFocusNode.unfocus();
      }
    });
    if (_tabController == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      drawer: Drawer(
        child: SidebarWidget(
          selectedIndex: _selectedIndex,
          onMenuTap: _handleSidebarMenuTap,
          isSidebarExpanded: true,
          expandedMenuIndex: _expandedMenuIndex,
          onToggleMenu: (idx) => setState(() => _expandedMenuIndex = idx),
          deepPink: primary,
          lightPink: Colors.pink.shade50,
          isMobile: MediaQuery.of(context).size.width < 700,
          closeDrawer: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Builder(
                    builder: (context) => HeaderFloatingCard(
                      isMobile: MediaQuery.of(context).size.width < 700,
                    onMenuTap: () {
                        Scaffold.of(context).openDrawer();
                    },
                    onEmailTap: () {},
                    onNotifTap: () {},
                    onAvatarTap: () {},
                    ),
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
                            onPressed: _showCartDialog,
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
    var filtered = _directPurchases.where((e) => (e['status'] ?? '').toString().toLowerCase() == status.toLowerCase()).toList();

    // Tambahkan filter tanggal di sisi frontend sebagai pengaman
    if (_startDate != null && _endDate != null) {
      filtered = filtered.where((item) {
        final itemDateStr = item['date'] ?? item['directPurchaseDate'];
        if (itemDateStr == null || itemDateStr.toString().isEmpty) return false;

        try {
          final itemDate = DateTime.parse(itemDateStr.toString().split(' ').first);
          final inclusiveEndDate = _endDate!.add(const Duration(days: 1));
          return (itemDate.isAtSameMomentAs(_startDate!) || itemDate.isAfter(_startDate!)) &&
                 itemDate.isBefore(inclusiveEndDate);
        } catch (e) {
          return false;
        }
      }).toList();
    }

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
      onRefresh: () => _fetchDirectPurchases(resetSearch: true),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (filtered.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: _EmptyStatusWidget(status: status),
              ),
            );
          }
          return ListView(
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
          );
        },
      ),
    );
  }

  void _showCartDialog() {
    // Ambil semua item barang dari draft pembelian (status 'pending'), dan tambahkan field supplier ke setiap item
    final cartItems = _directPurchases
      .where((e) => (e['status'] ?? '').toString().toLowerCase().contains('pending'))
      .expand((purchase) {
        final supplier = purchase['supplier'] ?? '-';
        final items = purchase['items'] ?? [];
        return (items as List).map((item) => {
          ...item,
          'supplier': supplier,
        });
      // ignore: unnecessary_cast
      }).map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item as Map)).toList();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cart',
      barrierColor: Colors.black.withOpacity(0.15),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 24),
            child: CartDialog(
              cartItems: cartItems,
              onClose: () => Navigator.of(context).pop(),
              onReview: () {
                Navigator.of(context).pop();
                // Tampilkan dialog/halaman review
              },
              onSubmit: () {
                Navigator.of(context).pop();
                // Tampilkan notifikasi sukses
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
          child: child,
        );
      },
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

// Tambahkan widget baru untuk konten dialog search
class _SearchDialogContent extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final Function(String?, DateTime?, DateTime?) onFilterApplied;
  const _SearchDialogContent({Key? key, required this.onSearch, required this.onFilterApplied}) : super(key: key);
  @override
  State<_SearchDialogContent> createState() => _SearchDialogContentState();
}

class _SearchDialogContentState extends State<_SearchDialogContent> {
  String _keyword = '';

  void _doSearch() {
    if (_keyword.trim().isNotEmpty) {
      widget.onSearch(_keyword.trim());
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bsContext) {
        return FilterBottomSheet(
          onFilterApplied: (status, startDate, endDate) {
            widget.onFilterApplied(status, startDate, endDate);
            Navigator.of(bsContext).pop(); // Tutup hanya bottom sheet
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bool keyboardVisible = keyboardHeight > 0;
    final double dialogLeftRightPadding = keyboardVisible ? 0 : 16;
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              left: dialogLeftRightPadding,
              right: dialogLeftRightPadding,
              bottom: keyboardVisible ? keyboardHeight : 90,
            ),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(22),
                    topRight: const Radius.circular(22),
                    bottomLeft: keyboardVisible ? Radius.zero : const Radius.circular(22),
                    bottomRight: keyboardVisible ? Radius.zero : const Radius.circular(22),
                  ),
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
                          'Cari & Filter Transaksi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 0, 85),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.grey[600]),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    SearchAndFilterBar(
                      onChanged: (val) {
                        setState(() {
                          _keyword = val;
                        });
                      },
                      onSearchPressed: _doSearch,
                      onFilterTap: _showFilterSheet,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
