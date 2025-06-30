import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/GRPO_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialCalculate_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/StockOpname_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/Waste_Page.dart';
import 'Resource/Purchasing/DirectPurchase_Page.dart';
import 'Resource/Stock_Management/TransferStock_Page.dart';
import 'Resource/Stock_Management/MaterialRequest_Page.dart';
import 'Resource/Auth/UserProfile_Page.dart';
import 'Resource/Auth/Help_Page.dart';
import 'Resource/Auth/Notification_Page.dart';
import 'Resource/Auth/Email_Page.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/LoginPage.dart';
import 'dart:ui';

class DashboardPage extends StatefulWidget {
  final int selectedIndex;
  const DashboardPage({super.key, required this.selectedIndex});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  late int _selectedIndex;
  bool _isSidebarExpanded = true;
  bool _isProfileMenuOpen = false;
  bool _isStoreMenuOpen = false;
  int? _expandedMenuIndex;
  bool _isSearchActive = false;

  int _selectedOpenItemTab = 0; // 0: PO, 1: Direct Purchase, 2: Transfer Out

  final Color primaryColor = const Color(0xFFF8BBD0);
  // final Color accentColor = const Color.fromARGB(255, 233, 30, 99);
  final Color deepPink = const Color.fromARGB(255, 233, 30, 99);
  final Color lightPink = const Color(0xFFFCE4EC);

  // Konstanta untuk menu index
  static const int PURCHASING_MENU = 1;
  static const int STOCK_MANAGEMENT_MENU = 2;

  final AuthService _authService = AuthService();
  late AnimationController _searchAnimationController;
  late AnimationController _notificationAnimationController;

  OverlayEntry? _notificationOverlayEntry;
  final GlobalKey _notificationIconKey = GlobalKey();

  // Data notifikasi (diambil dari Notification_Page.dart)
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

  // Dummy data untuk masing-masing tab
  final List<List<DataRow>> _openItemRows = [
    // PO
    [
      DataRow(
        cells: [
          DataCell(Text('PO-2024-0125')),
          DataCell(Text('15/03/2024')),
          DataCell(Text('PT Kurnia Alam')),
          DataCell(Text('Open', style: TextStyle(color: Colors.green))),
          DataCell(
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 233, 30, 99),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text('Detail'),
            ),
          ),
        ],
      ),
    ],
    // Direct Purchase
    [
      DataRow(
        cells: [
          DataCell(Text('DP-2024-0001')),
          DataCell(Text('16/03/2024')),
          DataCell(Text('PT Direct Sukses')),
          DataCell(Text('Open', style: TextStyle(color: Colors.green))),
          DataCell(
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 233, 30, 99),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text('Detail'),
            ),
          ),
        ],
      ),
    ],
    // Transfer Out
    [
      DataRow(
        cells: [
          DataCell(Text('TO-2024-0002')),
          DataCell(Text('17/03/2024')),
          DataCell(Text('PT Transfer Jaya')),
          DataCell(Text('Open', style: TextStyle(color: Colors.green))),
          DataCell(
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 233, 30, 99),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text('Detail'),
            ),
          ),
        ],
      ),
    ],
  ];

  // Tambahkan state untuk hover
  int? _hoveredIndex;

  // Fungsi reusable untuk menentukan apakah menu sedang di-hover atau selected
  bool _isMenuActive(int index) {
    return _selectedIndex == index || _hoveredIndex == index;
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _searchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _notificationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _searchAnimationController.dispose();
    _notificationAnimationController.dispose();
    // Pastikan overlay dihapus saat widget di-dispose
    if (_notificationOverlayEntry != null) {
      _notificationOverlayEntry!.remove();
      _notificationOverlayEntry = null;
    }
    super.dispose();
  }

  void _toggleSearch() {
    if (_searchAnimationController.isAnimating) return;

    setState(() {
      _isSearchActive = !_isSearchActive;
      if (_isSearchActive) {
        _searchAnimationController.forward();
      } else {
        _searchAnimationController.reverse();
      }
    });
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
              final animValue = _notificationAnimationController.value;
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
    final List<Map<String, dynamic>> previewNotifs = notifications
        .take(4)
        .toList();
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    return Material(
      color: Colors.white.withOpacity(0.98),
      elevation: 16,
      shadowColor: Colors.black.withOpacity(0.10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: isMobile ? screenWidth * 0.85 : 250,
        constraints: BoxConstraints(maxHeight: isMobile ? 220 : 180),
        padding: const EdgeInsets.only(top: 10, bottom: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Triangle
            Container(
              margin: const EdgeInsets.only(right: 16, bottom: 2),
              child: ClipPath(
                clipper: TriangleClipper(),
                child: Container(color: Colors.white, height: 10, width: 18),
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

  Widget _buildAnimatedSearchBar() {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: _searchAnimationController,
        curve: Curves.easeInOutCubic,
      ),
      axisAlignment: -1.0,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: 12,
        ),
        child: _buildModernSearchBar(),
      ),
    );
  }

  Widget _buildModernSearchBar() {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24.0),
      elevation: 12.0,
      shadowColor: deepPink.withOpacity(0.10),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10 : 20,
          vertical: isMobile ? 8 : 12,
        ),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _searchAnimationController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
          ),
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.0, 0.5), // Slide from bottom
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _searchAnimationController,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: deepPink.withOpacity(0.8),
                  size: isMobile ? 20 : 24,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: TextField(
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 14 : 16,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Search anything...',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: deepPink,
                  splashRadius: 20,
                  onPressed: _toggleSearch,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleMenu(int menuIndex) {
    setState(() {
      if (_expandedMenuIndex == menuIndex) {
        // Jika menu yang sama diklik, tutup menu
        _expandedMenuIndex = null;
      } else {
        // Buka menu yang baru diklik
        _expandedMenuIndex = menuIndex;
      }
    });
  }

  Future<void> _handleLogout() async {
    try {
      // Tampilkan loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Panggil API logout
      await _authService.logout();

      // Tutup loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Tampilkan snackbar sukses
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil logout'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Navigate ke halaman login dan hapus semua route sebelumnya
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        // Tutup loading dialog jika masih terbuka
        Navigator.of(context).pop();

        // Tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal logout: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );

        // Tetap arahkan ke halaman login meskipun terjadi error
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  //content season

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    final double headerHeight = isMobile ? 68 : 80;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      drawer: isMobile
          ? Drawer(
              child: _buildSidebarContent(
                isMobile: true,
                closeDrawer: () => Navigator.pop(context),
              ),
            )
          : null,
      body: Stack(
        children: [
          // HEADER PINK MODERN STICKY
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: headerHeight + MediaQuery.of(context).padding.top,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB6D5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.08),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: isMobile ? 8 : 24,
                right: isMobile ? 8 : 24,
                bottom: 8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isMobile)
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.grid_view_rounded, color: Colors.white),
                        iconSize: isMobile ? 28 : 32,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: isMobile ? 2 : 8),
                      child: Text(
                        'Dashboard',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 24 : 28,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  // ICON BAR TANPA SEARCH, PADDING LEBIH RAPI
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 2 : 10,
                      vertical: isMobile ? 0 : 2,
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
                            iconSize: isMobile ? 30 : 32,
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
                          iconSize: isMobile ? 30 : 32,
                        ),
                        SizedBox(width: isMobile ? 10 : 18),
                        _modernHeaderAvatar(isMobile: isMobile, glass: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // BODY PUTIH, KONTEN DI BAWAH HEADER, BISA DI-SCROLL
          Padding(
            padding: EdgeInsets.only(top: headerHeight + MediaQuery.of(context).padding.top - 8),
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                FocusScope.of(context).unfocus();
                return false;
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildAnimatedSearchBar(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(
                              color: Colors.grey.withOpacity(0.13),
                              thickness: 1.2,
                              height: 0,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTaskSection(),
                          const SizedBox(height: 16),
                          _buildOutstandingCards(),
                          const SizedBox(height: 16),
                          _buildOpenItemList(),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Sidebar (hanya tampil di desktop/tablet)
          if (!isMobile)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isSidebarExpanded ? 250 : 70,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: _buildSidebarContent(isMobile: false),
            ),
        ],
      ),
    );
  }

  // content widgets
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
          // Info toko dengan dropdown
          if (_isSidebarExpanded || isMobile) _buildStoreDropdown(),

          // Menu Items dengan Expanded
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
                        setState(() => _selectedIndex = 0);
                        _navigateToPage(0);
                        if (isMobile && closeDrawer != null) closeDrawer();
                      }
                    },
                  ),
                  _buildExpandableMenu(
                    icon: Icons.shopping_bag_rounded,
                    title: 'Purchasing',
                    isExpanded: _selectedIndex == PURCHASING_MENU,
                    menuIndex: PURCHASING_MENU,
                    children: [
                      _buildSubMenuItem('Direct Purchase', 11),
                      _buildSubMenuItem('GRPO', 12),
                    ],
                    onTap: () {
                      setState(() => _selectedIndex = PURCHASING_MENU);
                    },
                    isMobile: isMobile,
                  ),
                  _buildExpandableMenu(
                    icon: Icons.inventory_rounded,
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
                      setState(() => _selectedIndex = STOCK_MANAGEMENT_MENU);
                    },
                    isMobile: isMobile,
                  ),
                  _buildMenuItem(
                    icon: Icons.bar_chart_rounded,
                    title: 'Inventory Report',
                    index: 3,
                    onTap: () {
                      setState(() => _selectedIndex = 3);
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
                      setState(() => _selectedIndex = 4);
                      _navigateToPage(4);
                      if (isMobile && closeDrawer != null) closeDrawer();
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.help_center_rounded,
                    title: 'Help',
                    index: 5,
                    onTap: () {
                      setState(() => _selectedIndex = 5);
                      _navigateToPage(5);
                      if (isMobile && closeDrawer != null) closeDrawer();
                    },
                  ),
                ],
              ),
            ),
          ),
          // User profile dengan dropdown (selalu di bawah)
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
    final isActive = _isMenuActive(index);
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? lightPink.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          horizontalTitleGap: 12,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive
                  ? deepPink.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isActive ? deepPink : Colors.grey,
              size: 20,
            ),
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
          onTap: () {
            if (_selectedIndex != index) {
              setState(() => _selectedIndex = index);
              _navigateToPage(index);
            }
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          dense: true,
        ),
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
    bool isMobile = false,
  }) {
    final isMenuExpanded = _expandedMenuIndex == menuIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isExpanded ? lightPink.withOpacity(0.3) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            horizontalTitleGap: 12,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isExpanded
                    ? deepPink.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isExpanded ? deepPink : Colors.grey,
                size: 20,
              ),
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                color: isExpanded ? deepPink : Colors.grey,
                fontWeight: isExpanded ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            trailing: AnimatedRotation(
              turns: isMenuExpanded ? 0.5 : 0.0,
              duration: Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.expand_more,
                color: isExpanded ? deepPink : Colors.grey,
              ),
            ),
            onTap: () {
              _toggleMenu(menuIndex);
              onTap();
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
        if (isMenuExpanded && (_isSidebarExpanded || isMobile))
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

  Widget _buildSubMenuItem(String title, int index) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
      decoration: BoxDecoration(
        color: _selectedIndex == index
            ? lightPink.withOpacity(0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        horizontalTitleGap: 12,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _selectedIndex == index
                ? deepPink.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getSubMenuIcon(index),
            color: _selectedIndex == index ? deepPink : Colors.grey,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: _selectedIndex == index ? deepPink : Colors.black87,
            fontWeight: _selectedIndex == index
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        selected: _selectedIndex == index,
        onTap: () {
          setState(() => _selectedIndex = index);
          _navigateToPage(index);
        },
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 11: // Direct Purchase
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DirectPurchasePage()),
        );
        break;
      case 12: // GRPO
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GRPO_Page()),
        );
        break;
      case 21: // Material Request
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MaterialRequestPage()),
        );
        break;
      case 22: // Stock Opname
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StockOpnamePage()),
        );
        break;
      case 23: // Transfer Stock
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TransferStockPage()),
        );
        break;
      case 24: // Waste
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WastePage()),
        );
        break;
      case 25: // Material Calculate
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MaterialCalculatePage()),
        );
        break;
      case 4: // Account & Settings
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserprofilePage()),
        );
        break;
      case 5: // Help
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HelpPage()),
        );
        break;
    }
  }

  IconData _getSubMenuIcon(int index) {
    switch (index) {
      case 11: // Direct Purchase
        return Icons.shopping_bag_rounded;
      case 12: // GRPO
        return Icons.receipt_long_outlined;
      case 21: // Material Request
        return Icons.inventory_rounded;
      case 22: // Stock Opname
        return Icons.checklist_rtl_outlined;
      case 23: // Transfer Stock
        return Icons.swap_horiz_outlined;
      case 24: // Waste
        return Icons.delete_outline;
      case 25: //material calculate
        return Icons.inventory_rounded;
      default:
        return Icons.circle_outlined;
    }
  }

  Widget _buildTaskSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tasks",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Handle "Show All" press
                },
                child: Row(
                  children: [
                    Text(
                      "Show All",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_outward_rounded,
                      size: 14,
                      color: const Color.fromARGB(246, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildTaskCard(
            "Stock Opname has not been performed",
            "12/03/2025 09:42",
            "High Priority",
            "Needs Attention",
          ),
          const SizedBox(height: 8),
          _buildTaskCard(
            "PO-2024-0125 awaiting acceptance from PTK",
            "12/03/2025 09:42",
            "Medium Priority",
            "Waiting for Action",
          ),
          const SizedBox(height: 8),
          _buildTaskCard(
            "PO-2025-0222 awaiting acceptance from PTK",
            "12/03/2025 09:42",
            "High Priority",
            "Needs Attention",
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(
    String taskTitle,
    String date,
    String priority,
    String status,
  ) {
    Color priorityColor;
    IconData priorityIcon;
    Color statusColor;
    String statusText;

    if (priority == "High Priority") {
      priorityColor = Colors.red;
      priorityIcon = Icons.error;
    } else if (priority == "Medium Priority") {
      priorityColor = Colors.orange;
      priorityIcon = Icons.warning;
    } else {
      priorityColor = Colors.green;
      priorityIcon = Icons.check_circle;
    }

    if (status == "Needs Attention") {
      statusColor = Colors.red;
      statusText = "Needs Attention";
    } else if (status == "Waiting for Action") {
      statusColor = Colors.orange;
      statusText = "Waiting for Action";
    } else {
      statusColor = Colors.green;
      statusText = "Resolved";
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(priorityIcon, color: priorityColor, size: 30),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        taskTitle,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    IconButton(
                      icon: Icon(Icons.chevron_right, color: Colors.grey),
                      onPressed: () {
                        // Handle task click (navigate or show details)
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Divider(color: Colors.grey.withOpacity(0.18), thickness: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildOutstandingCards() {
    final List<Map<String, dynamic>> items = [
      {'title': 'Outstanding PO', 'count': '3'},
      {'title': 'Outstanding Direct Purchase', 'count': '5'},
      {'title': 'Outstanding Transfer Out', 'count': '8'},
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;

    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: items.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['count'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: deepPink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['title'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.map((item) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(
                  vertical: 28,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['count'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: deepPink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['title'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    }
  }

  Widget _buildOpenItemList() {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 14 : 24,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Open Item List",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 18 : screenWidth * 0.045,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.filter_list, size: 16, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      "Filter",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
            child: _buildTaskBar(),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: screenWidth - (isMobile ? 24 : 64),
              ),
              child: DataTable(
                headingRowHeight: 50,
                columns: [
                  DataColumn(
                    label: SizedBox(
                      width: 100,
                      child: Text(
                        'PO Number',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 80,
                      child: Text(
                        'Date',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 120,
                      child: Text(
                        'Supplier',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 70,
                      child: Text(
                        'Status',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 70,
                      child: Text(
                        'Action',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                rows: _openItemRows[_selectedOpenItemTab],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Page on',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    splashRadius: 20,
                    onPressed: () {},
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          '1',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: deepPink,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '2',
                          style: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '3',
                          style: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    splashRadius: 20,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskBar() {
    final tabLabels = ['PO', 'Direct Purchase', 'Transfer Out'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabLabels.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedOpenItemTab = i;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: _selectedOpenItemTab == i
                      ? deepPink
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedOpenItemTab == i
                        ? deepPink
                        : Colors.black12,
                  ),
                ),
                child: Text(
                  tabLabels[i],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _selectedOpenItemTab == i
                        ? Colors.white
                        : Colors.black54,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
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
                      // Handle settings
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

  void _showProfileMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
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
      items: [
        PopupMenuItem(
          height: 40,
          child: _buildProfileMenuItem(
            Icons.person_outline,
            'Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserprofilePage(),
                ),
              );
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserprofilePage()),
            );
          },
        ),
        PopupMenuItem(
          height: 40,
          child: _buildProfileMenuItem(
            Icons.settings_outlined,
            'Settings',
            onTap: () {
              // Handle settings
            },
          ),
          onTap: () {
            // Handle settings
          },
        ),
        PopupMenuItem(
          height: 40,
          child: _buildProfileMenuItem(
            Icons.help_outline,
            'Help & Support',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              );
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpPage()),
            );
          },
        ),
        PopupMenuItem(
          height: 40,
          child: _buildProfileMenuItem(
            Icons.logout,
            'Logout',
            isLogout: true,
            onTap: () async {
              await _handleLogout();
            },
          ),
          onTap: () async {
            await _handleLogout();
          },
        ),
      ],
    );
  }

  // --- MODERN HEADER ICON & AVATAR (GLASS EFFECT, BORDER HALUS, TANPA SHADOW) ---

  // Icon bulat transparan (glass effect) dengan border halus, tanpa shadow
  Widget _modernHeaderIcon({
    required IconData icon,
    required VoidCallback onTap,
    bool badge = false,
    bool isMobile = false,
    bool glass = true,
    double iconSize = 22,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: Container(
        width: isMobile ? 36 : 40,
        height: isMobile ? 36 : 40,
        decoration: BoxDecoration(
          color: glass ? Colors.white.withOpacity(0.32) : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Colors.white.withOpacity(0.22),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(icon, color: Colors.white, size: iconSize),
            ),
            if (badge)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Avatar bulat transparan (glass effect)
  Widget _modernHeaderAvatar({bool isMobile = false, bool glass = true}) {
    return Container(
      width: isMobile ? 36 : 40,
      height: isMobile ? 36 : 40,
      decoration: BoxDecoration(
        color: glass ? Colors.white.withOpacity(0.32) : Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withOpacity(0.22),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Image.asset(
          'assets/images/icons-logoDekoration.png', // Ganti dengan path avatar kamu jika perlu
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
