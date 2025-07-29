import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/DirectPurchasePage.dart';
import 'package:miniproject_flutter/screens/Resource/Purchasing/GRPO_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialCalculate_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/StockOpname_Page.dart';
import 'package:miniproject_flutter/screens/Resource/Stock_Management/Waste_Page.dart';
import 'Resource/Stock_Management/TransferStock_Page.dart';
import 'Resource/Stock_Management/MaterialRequest_Page.dart';
import 'Resource/Auth/UserProfile_Page.dart';
import 'Resource/Auth/Help_Page.dart';
import 'Resource/Auth/Notification_Page.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/LoginPage.dart';
import 'dart:ui';
import 'package:miniproject_flutter/widgets/Dashboard/TaskCard.dart';
import 'package:miniproject_flutter/screens/TaskDetailPage.dart';
import 'package:flutter/physics.dart';
import 'package:miniproject_flutter/widgets/Dashboard/AnimatedSidebar.dart';
import 'package:miniproject_flutter/component/Sidebar.dart';

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
  final Color softPink = Color(0xFFF8BBD0).withOpacity(0.65);

  // Konstanta untuk menu index
  static const int PURCHASING_MENU = 1;
  static const int STOCK_MANAGEMENT_MENU = 2;

  final AuthService _authService = AuthService();
  late AnimationController _searchAnimationController;
  late AnimationController _notificationAnimationController;
  late AnimationController _emailAnimationController;

  OverlayEntry? _notificationOverlayEntry;
  final GlobalKey _notificationIconKey = GlobalKey();
  OverlayEntry? _emailOverlayEntry;
  final GlobalKey _emailIconKey = GlobalKey();

  final ScrollController _taskScrollController = ScrollController();

  AnimationController? _sidebarController;
  late Animation<double> _sidebarWidth;
  late Animation<double> _sidebarOpacity;
  late Animation<Offset> _sidebarOffset;
  late Animation<double> _sidebarScale;
  late Animation<double> _sidebarSpringAnim; // animasi manual spring

  static const _macOSSmoothCurve = Cubic(0.77, 0, 0.175, 1);

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

  // Dummy data email
  final List<Map<String, dynamic>> emails = [
    {
      'subject': 'Welcome to haus! Inventory',
      'from': 'admin@haus.com',
      'snippet': 'Thank you for registering your account.',
      'time': '1 min ago',
    },
    {
      'subject': 'PO-2024-0125 Approved',
      'from': 'system@haus.com',
      'snippet': 'Your PO-2024-0125 has been approved.',
      'time': '10 min ago',
    },
    {
      'subject': 'Monthly Report',
      'from': 'report@haus.com',
      'snippet': 'Your monthly inventory report is ready.',
      'time': '1 hour ago',
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

  // Todo : Tambahkan state untuk hover
  int? _hoveredIndex;

  //todo : Fungsi reusable untuk menentukan apakah menu sedang di-hover atau selected
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
    _emailAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _taskScrollController.addListener(() {
      AnimatedTooltipBadge.removeAllTooltips();
      _removeTaskTooltip();
    });
    _sidebarController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: const Duration(milliseconds: 800),
    );
    _sidebarSpringAnim = _sidebarController!;
    if (_isSidebarExpanded) {
      _sidebarController?.value = 1.0;
    } else {
      _sidebarController?.value = 0.0;
    }
  }

  @override
  void didUpdateWidget(covariant DashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = widget.selectedIndex;
      });
    }
  }

  void _toggleSidebar() {
    if (_sidebarController?.isAnimating ?? true) return;
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
      final spring = SpringDescription(
        mass: 1.0,
        stiffness: 90.0,
        damping: 12.0,
      );
      final sim = SpringSimulation(
        spring,
        _sidebarController!.value,
        _isSidebarExpanded ? 1.0 : 0.0,
        0.0,
      );
      _sidebarController!.animateWith(sim);
    });
  }

  @override
  void dispose() {
    _searchAnimationController.dispose();
    _notificationAnimationController.dispose();
    _emailAnimationController.dispose();
    _taskScrollController.dispose();
    _sidebarController?.dispose();
    // Pastikan overlay dihapus saat widget di-dispose
    if (_notificationOverlayEntry != null) {
      _notificationOverlayEntry!.remove();
      _notificationOverlayEntry = null;
    }
    if (_emailOverlayEntry != null) {
      _emailOverlayEntry!.remove();
      _emailOverlayEntry = null;
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
      builder: (context) => _buildNotificationTooltipAnimated(position, size),
    );

    Overlay.of(context).insert(_notificationOverlayEntry!);
    _notificationAnimationController.forward();
  }

  Widget _buildNotificationTooltipAnimated(Offset position, Size size) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    final double popupWidth = isMobile ? screenWidth * 0.85 : 260;
    // Posisi left agar arrow tepat di bawah icon notif dan popup tidak keluar layar
    double left = position.dx + size.width / 2 - popupWidth / 2;
    if (left < 8) left = 8;
    if (left + popupWidth > screenWidth - 8)
      left = screenWidth - popupWidth - 8;
    // Arrow offset dari kiri popup
    double arrowWidth = 22;
    double arrowOffset =
        (position.dx + size.width / 2) - left - (arrowWidth / 2) - 125;
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
          left: left,
          child: AnimatedBuilder(
            animation: _notificationAnimationController,
            builder: (context, child) {
              final animValue = _notificationAnimationController.value;
              return FadeTransition(
                opacity: _notificationAnimationController,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _notificationAnimationController,
                      curve: Curves.easeOutBack,
                    ),
                  ),
                  alignment: Alignment.topCenter,
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Arrow atas tepat di bawah icon notif
                Row(
                  children: [
                    SizedBox(width: arrowOffset),
                    CustomPaint(
                      size: Size(arrowWidth, 10),
                      painter: _NotifTooltipArrowPainter(
                        color: Colors.white,
                        borderColor: Colors.grey.withOpacity(0.13),
                      ),
                    ),
                  ],
                ),
                _buildNotificationTooltipContent(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationTooltipContent() {
    final List<Map<String, dynamic>> previewNotifs = notifications
        .take(4)
        .toList();
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    return Material(
      type: MaterialType.transparency,
      elevation: 0,
      child: Container(
        width: isMobile ? screenWidth * 0.85 : 260,
        constraints: BoxConstraints(maxHeight: isMobile ? 220 : 180),
        padding: const EdgeInsets.only(top: 10, bottom: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(255, 3, 1, 1).withOpacity(0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  shrinkWrap: true,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_active_rounded,
                      color: deepPink,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Lihat Semua Notifikasi',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: deepPink,
                        fontSize: 13,
                      ),
                    ),
                  ],
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

  void _onSidebarMenuTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Future.microtask(() {
      _navigateToPageSimple(index);
    });
  }

  void _navigateToPageSimple(int index) {
    switch (index) {
      case 11:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DirectPurchasePage()),
        );
        break;
      case 12:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GRPO_Page()),
        );
        break;
      case 21:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MaterialRequestPage()),
        );
        break;
      case 22:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StockOpnamePage()),
        );
        break;
      case 23:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TransferStockPage()),
        );
        break;
      case 24:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WastePage()),
        );
        break;
      case 25:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MaterialCalculatePage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserprofilePage()),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HelpPage()),
        );
        break;
      default:
        // Dashboard, Inventory Report, dll: tidak navigasi
        break;
    }
  }

  void _onSidebarToggleMenu(int menuIndex) {
    setState(() {
      if (_expandedMenuIndex == menuIndex) {
        _expandedMenuIndex = null;
      } else {
        _expandedMenuIndex = menuIndex;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    final double headerHeight = isMobile ? 68 : 80;

    return Scaffold(
      backgroundColor: const Color.fromARGB(238, 255, 255, 255),
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 72 : 84),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 255, 30, 105),
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
                    )
                  else
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      child: _modernHeaderIcon(
                        icon: Icons.grid_view_rounded,
                        onTap: _toggleSidebar,
                        isMobile: false,
                        glass: true,
                        iconSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  if (isMobile) const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Dashboard',
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
                  _modernHeaderIconBarNoSearch(isMobile),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: isMobile
          ? Drawer(
              child: SidebarWidget(
                selectedIndex: _selectedIndex,
                onMenuTap: _onSidebarMenuTap,
                isSidebarExpanded: true,
                expandedMenuIndex: _expandedMenuIndex,
                onToggleMenu: _onSidebarToggleMenu,
                deepPink: deepPink,
                lightPink: lightPink,
                isMobile: true,
                closeDrawer: () => Navigator.pop(context),
                onLogout: _handleLogout,
              ),
            )
          : null,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          AnimatedTooltipBadge.removeAllTooltips();
          _removeTaskTooltip();
        },
        child: SafeArea(
          child: Stack(
            children: [
              // Sidebar (desktop/tablet)
              if (!isMobile)
                AnimatedSidebar(
                  controller: _sidebarController!,
                  isSidebarExpanded: _isSidebarExpanded,
                  child: SidebarWidget(
                    selectedIndex: _selectedIndex,
                    onMenuTap: _onSidebarMenuTap,
                    isSidebarExpanded: _isSidebarExpanded,
                    expandedMenuIndex: _expandedMenuIndex,
                    onToggleMenu: _onSidebarToggleMenu,
                    deepPink: deepPink,
                    lightPink: lightPink,
                    onLogout: _handleLogout,
                  ),
                ),
              // Main Content Area
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: isMobile
                    ? EdgeInsets.zero
                    : EdgeInsets.only(left: _isSidebarExpanded ? 250 : 70),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 8,
                    left: isMobile ? 12 : 32,
                    right: isMobile ? 12 : 32,
                  ),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      FocusScope.of(context).unfocus();
                      return false;
                    },
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 18,
                          ), // Jarak rapi antara header dan search bar
                          // Search bar modern lebih menarik
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            child: StatefulBuilder(
                              builder: (context, setState) {
                                bool isFocused = false;
                                return FocusScope(
                                  child: Focus(
                                    onFocusChange: (focus) =>
                                        setState(() => isFocused = focus),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 220,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.82),
                                        borderRadius: BorderRadius.circular(22),
                                        border: Border.all(
                                          width: 1.5,
                                          color: isFocused
                                              ? const Color(0xFFF48FB1)
                                              : Colors.purple.withOpacity(0.10),
                                        ),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.82),
                                            Color(0xFFF8BBD0).withOpacity(0.13),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.purple.withOpacity(
                                              0.06,
                                            ),
                                            blurRadius: 16,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Icon(
                                              Icons.search,
                                              color: const Color(
                                                0xFFF06292,
                                              ), // pink pastel
                                              size: 26,
                                            ),
                                          ),
                                          Expanded(
                                            child: TextField(
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.black87,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: 'seacrh... ',
                                                hintStyle: GoogleFonts.poppins(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                                border: InputBorder.none,
                                              ),
                                              cursorColor: const Color(
                                                0xFFF06292,
                                              ),
                                              onTap: () => setState(
                                                () => isFocused = true,
                                              ),
                                              onEditingComplete: () => setState(
                                                () => isFocused = false,
                                              ),
                                            ),
                                          ),
                                          MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 180,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: isFocused
                                                      ? Color(
                                                          0xFFF8BBD0,
                                                        ).withOpacity(0.18)
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Icon(
                                                  Icons.tune,
                                                  color: isFocused
                                                      ? const Color(0xFFF06292)
                                                      : Colors.grey.shade400,
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 18),
                          _buildTaskSection(),
                          SizedBox(height: 22),
                          _buildOutstandingCards(),
                          SizedBox(height: 22),
                          _buildOpenItemList(),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modernHeaderIconBarNoSearch(bool isMobile) {
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
          SizedBox(width: isMobile ? 8 : 14),
          // Pastikan icon email selalu muncul
          SizedBox(
            key: _emailIconKey,
            child: _modernHeaderIcon(
              icon: Icons.mail_outline_rounded,
              onTap: _toggleEmailOverlay,
              badge: emails.isNotEmpty,
              isMobile: isMobile,
              glass: true,
              iconSize: isMobile ? 24 : 28,
              color: Colors.white,
            ),
          ),
          SizedBox(width: isMobile ? 10 : 18),
          _modernHeaderAvatar(isMobile: isMobile, glass: true),
        ],
      ),
    );
  }

  Widget _buildTaskSection() {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(
              255,
              255,
              213,
              244,
            ).withOpacity(0.96), // abu-abu sangat muda
            const Color.fromARGB(
              255,
              255,
              241,
              247,
            ).withOpacity(0.92), // abu-abu kebiruan
            Colors.white.withOpacity(0.90),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFF8BBD0), // pink pastel
          width: 1.3,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.task_alt_rounded,
                      color: Color(0xFFE91E63),
                      size: 26,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Tasks",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 16 : 20,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_outward_rounded,
                    size: 18,
                    color: Color(0xFFE91E63),
                  ),
                  label: Text(
                    "Lihat Semua",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Color(0xFFE91E63),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFFE91E63),
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: isMobile ? 210 : 200,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  _removeTaskTooltip();
                  AnimatedTooltipBadge.removeAllTooltips();
                  return false;
                },
                child: ListView(
                  controller: _taskScrollController,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(left: 4),
                  children: [
                    TaskCard(
                      taskTitle: "Stock Opname belum dilakukan",
                      date: "12/03/2025 09:42",
                      priority: "High Priority",
                      status: "Needs Attention",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailPage(),
                          ),
                        );
                      },
                      onStatusTap: (tapContext, tapPosition) {
                        _showTaskTooltip(
                          tapContext,
                          "Status: Needs Attention",
                          tapPosition,
                        );
                      },
                      onPriorityTap: (tapContext, tapPosition) {
                        _showTaskTooltip(
                          tapContext,
                          "Priority: High Priority",
                          tapPosition,
                        );
                      },
                    ),
                    TaskCard(
                      taskTitle: "PO-2024-0125 menunggu acceptance dari PTK",
                      date: "12/03/2025 09:42",
                      priority: "Medium Priority",
                      status: "Waiting for Action",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailPage(),
                          ),
                        );
                      },
                      onStatusTap: (tapContext, tapPosition) {
                        _showTaskTooltip(
                          tapContext,
                          "Status: Waiting for Action",
                          tapPosition,
                        );
                      },
                      onPriorityTap: (tapContext, tapPosition) {
                        _showTaskTooltip(
                          tapContext,
                          "Priority: Medium Priority",
                          tapPosition,
                        );
                      },
                    ),
                    TaskCard(
                      taskTitle: "PO-2025-0222 menunggu acceptance dari PTK",
                      date: "12/03/2025 09:42",
                      priority: "High Priority",
                      status: "Needs Attention",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailPage(),
                          ),
                        );
                      },
                      onStatusTap: (tapContext, tapPosition) {
                        _showTaskTooltip(
                          tapContext,
                          "Status: Needs Attention",
                          tapPosition,
                        );
                      },
                      onPriorityTap: (tapContext, tapPosition) {
                        _showTaskTooltip(
                          tapContext,
                          "Priority: High Priority",
                          tapPosition,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.swipe, size: 18, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  'Geser untuk melihat lebih banyak',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutstandingCards() {
    final List<Map<String, dynamic>> items = [
      {
        'title': 'Outstanding PO',
        'count': '3',
        'icon': Icons.assignment_turned_in,
        'color': Color(0xFF42A5F5), // vivid blue
        'gradient': [Color(0xFF90CAF9), Color(0xFF42A5F5)],
      },
      {
        'title': 'Outstanding Direct Purchase',
        'count': '5',
        'icon': Icons.shopping_bag_rounded,
        'color': Color(0xFFF06292), // vivid pink
        'gradient': [Color(0xFFF8BBD0), Color(0xFFF06292)],
      },
      {
        'title': 'Outstanding Transfer Out',
        'count': '8',
        'icon': Icons.swap_horiz_rounded,
        'color': Color(0xFFFFD600), // vivid yellow
        'gradient': [Color(0xFFFFF59D), Color(0xFFFFD600)],
      },
    ];

    return Column(
      children: items.map((item) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isPressed = false;
            return GestureDetector(
              onTapDown: (_) => setState(() => isPressed = true),
              onTapUp: (_) => setState(() => isPressed = false),
              onTapCancel: () => setState(() => isPressed = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 18,
                ),
                transform: isPressed
                    ? (Matrix4.identity()..scale(0.97))
                    : Matrix4.identity(),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border(
                    left: BorderSide(color: (item['color'] as Color), width: 5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon dengan background soft
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: (item['color'] as Color).withOpacity(0.13),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: (item['color'] as Color),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['count'],
                            style: GoogleFonts.robotoMono(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: (item['color'] as Color),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['title'],
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildOpenItemList() {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;

    // Soft pastel gradient
    final List<Color> softGradient = [
      Color(0xFFF8BBD0).withOpacity(0.65), // pink pastel
      Color(0xFFCE93D8).withOpacity(0.55), // ungu pastel
    ];

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.92, end: 1),
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final safeValue = value.clamp(0.0, 1.0);
        return Opacity(
          opacity: safeValue,
          child: Transform.scale(scale: safeValue, child: child),
        );
      },
      child: Stack(
        children: [
          // Card utama
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: isMobile ? 14 : 24,
                    horizontal: isMobile ? 12 : 18,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.90),
                        Color(0xFFF8BBD0).withOpacity(0.10),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: softPink, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.list_alt_rounded,
                                color: deepPink,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Open Item List",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isMobile ? 18 : screenWidth * 0.045,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: [
                                Icon(
                                  Icons.filter_list,
                                  size: 16,
                                  color: Colors.black54,
                                ),
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
                      const SizedBox(height: 6),
                      Divider(
                        color: softGradient[0].withOpacity(0.18),
                        thickness: 1.1,
                        height: 1,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 2.0,
                        ),
                        child: _buildTaskBar(),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Material(
                          color: Colors.transparent,
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              AnimatedTooltipBadge.removeAllTooltips();
                              _removeTaskTooltip();
                              return false;
                            },
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: screenWidth - (isMobile ? 8 : 32),
                                ),
                                child: _buildModernDataTable(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.swipe_left_rounded,
                              size: 18,
                              color: Colors.grey[500],
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Geser untuk melihat data lain',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Page on',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
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
                                        color: softGradient[0],
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DataTable dengan efek hover pada baris (khusus desktop)
  Widget _buildModernDataTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        // Header style
        final headerBg = Color(0xFFFDE4EC).withOpacity(0.85); // soft pink
        final headerTextStyle = GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: isMobile ? 13.5 : 15,
          letterSpacing: 1.1,
        );
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(0.06),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DataTable(
            headingRowHeight: isMobile ? 54 : 60,
            dataRowMinHeight: isMobile ? 44 : 54,
            dataRowMaxHeight: isMobile ? 60 : 72,
            columnSpacing: isMobile ? 10 : 22,
            horizontalMargin: isMobile ? 8 : 16,
            headingRowColor: MaterialStateProperty.all(headerBg),
            columns: [
              DataColumn(
                label: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    'PO NUMBER',
                    style: headerTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'DATE',
                    style: headerTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'SUPPLIER',
                    style: headerTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 2 : 3),
                  child: Text(
                    'STATUS',
                    style: headerTextStyle.copyWith(
                      fontSize: isMobile ? 12.5 : 13.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'ACTION',
                    style: headerTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
            rows: List.generate(_openItemRows[_selectedOpenItemTab].length, (
              i,
            ) {
              final row = _openItemRows[_selectedOpenItemTab][i];
              return DataRow(
                color: MaterialStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(MaterialState.hovered)) {
                    return deepPink.withOpacity(0.07);
                  }
                  return i % 2 == 0
                      ? Colors.white
                      : Color(0xFFFCE4EC).withOpacity(0.5);
                }),
                cells: List.generate(row.cells.length, (j) {
                  final cell = row.cells[j];
                  // PO Number
                  if (j == 0) {
                    return DataCell(
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 8 : 12,
                          horizontal: isMobile ? 8 : 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.13),
                              width: 1,
                            ),
                          ),
                        ),
                        child: DefaultTextStyle(
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? 13 : 14,
                            color: Colors.black87,
                          ),
                          child: cell.child,
                        ),
                      ),
                    );
                  }
                  // Status badge
                  if (j == 3) {
                    return DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 4 : 6,
                          horizontal: isMobile ? 4 : 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              cell.child is Text &&
                                  (cell.child as Text).data!
                                      .toLowerCase()
                                      .contains('open')
                              ? Color(0xFFB2FFB2).withOpacity(0.7)
                              : Color(0xFFFFF9C4).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.13),
                          ),
                        ),
                        child: DefaultTextStyle(
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color:
                                cell.child is Text &&
                                    (cell.child as Text).data!
                                        .toLowerCase()
                                        .contains('open')
                                ? Colors.green[700]
                                : Colors.orange[800],
                            fontSize: isMobile ? 12 : 13.5,
                          ),
                          child: cell.child is Text
                              ? Text(
                                  (cell.child as Text).data ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        cell.child is Text &&
                                            (cell.child as Text).data!
                                                .toLowerCase()
                                                .contains('open')
                                        ? Colors.green[700]
                                        : Colors.orange[800],
                                    fontSize: isMobile ? 12 : 13.5,
                                  ),
                                )
                              : cell.child,
                        ),
                      ),
                    );
                  }
                  // Default cell
                  return DataCell(
                    Container(
                      alignment: j == 1
                          ? Alignment.center
                          : Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                        vertical: isMobile ? 8 : 12,
                        horizontal: isMobile ? 6 : 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.13),
                            width: 1,
                          ),
                        ),
                      ),
                      child: DefaultTextStyle(
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 13 : 14,
                          color: Colors.black87,
                        ),
                        child: cell.child,
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        );
      },
    );
  }

  // Todo : build taksbar menu di open item list
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

  // Modern Header Icon
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
                color: Colors.white,
                size: iconSize ?? (isMobile ? 24 : 28),
              ),
              if (badge)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color ?? Colors.pinkAccent,
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

  // Modern Header Avatar
  Widget _modernHeaderAvatar({bool isMobile = false, bool glass = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserprofilePage()),
          );
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(isMobile ? 8 : 12),
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
          child: ClipOval(
            child: Image.asset(
              'assets/images/avatar.jpg',
              fit: BoxFit.cover,
              width: isMobile ? 24 : 28,
              height: isMobile ? 24 : 28,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.person,
                color: Colors.grey[500],
                size: isMobile ? 24 : 28,
              ),
            ),
          ),
        ),
      ),
    );
  }


  // Expandable Menu (Sidebar)
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
                    ? Colors.white.withOpacity(0.35)
                    : Colors.white.withOpacity(0.13),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isExpanded
                      ? Colors.white.withOpacity(0.32)
                      : Colors.white.withOpacity(0.22),
                  width: 1.1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
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
                color: isExpanded ? deepPink : Colors.black87,
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

  // Sub Menu Item (Sidebar)
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
                ? Colors.white.withOpacity(0.35)
                : Colors.white.withOpacity(0.13),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _selectedIndex == index
                  ? Colors.white.withOpacity(0.32)
                  : Colors.white.withOpacity(0.22),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
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

  // Icon untuk sub menu sidebar
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
      case 25: // Material Calculate
        return Icons.inventory_rounded;
      default:
        return Icons.circle_outlined;
    }
  }

  // Navigasi ke halaman lain
  void _navigateToPage(int index) {
    // Dihapus pengecekan agar setiap klik menu selalu navigasi
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(selectedIndex: 0),
          ),
        );
        break;
      case 11:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DirectPurchasePage(selectedIndex: 11),
          ),
        );
        break;
      case 12:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GRPO_Page(selectedIndex: 12),
          ),
        );
        break;
      case 21:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MaterialRequestPage(selectedIndex: 21),
          ),
        );
        break;
      case 22:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StockOpnamePage(selectedIndex: 22),
          ),
        );
        break;
      case 23:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransferStockPage(selectedIndex: 23),
          ),
        );
        break;
      case 24:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WastePage(selectedIndex: 24),
          ),
        );
        break;
      case 25:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MaterialCalculatePage(selectedIndex: 25),
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserprofilePage()),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HelpPage()),
        );
        break;
    }
  }

  // --- Email Overlay Logic ---
  void _toggleEmailOverlay() {
    if (!mounted) return;
    if (_emailAnimationController.isAnimating) return;
    if (_emailOverlayEntry == null) {
      _showEmailBubble();
    } else {
      _removeEmailOverlay();
    }
  }

  void _removeEmailOverlay() {
    if (!mounted) return;
    if (_emailOverlayEntry != null) {
      _emailAnimationController.reverse().then((_) {
        if (_emailOverlayEntry != null && _emailOverlayEntry!.mounted) {
          _emailOverlayEntry!.remove();
          _emailOverlayEntry = null;
        }
        _emailAnimationController.reset(); // reset controller setelah reverse
      });
    }
  }

  void _showEmailBubble() {
    if (!mounted) return;
    if (_emailOverlayEntry != null) return; // cegah overlay ganda
    final RenderBox renderBox =
        _emailIconKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    _emailOverlayEntry = OverlayEntry(
      builder: (context) => _buildEmailTooltipAnimated(position, size),
    );

    Overlay.of(context).insert(_emailOverlayEntry!);
    _emailAnimationController.forward();
  }

  Widget _buildEmailTooltipAnimated(Offset position, Size size) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    final double popupWidth = isMobile ? screenWidth * 0.85 : 260;
    double left = position.dx + size.width / 2 - popupWidth / 2;
    if (left < 8) left = 8;
    if (left + popupWidth > screenWidth - 8)
      left = screenWidth - popupWidth - 8;
    double arrowWidth = 22;
    double arrowOffset =
        (position.dx + size.width / 2) - left - (arrowWidth / 2) - 75;
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _removeEmailOverlay,
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned(
          top: position.dy + size.height + 10,
          left: left,
          child: AnimatedBuilder(
            animation: _emailAnimationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _emailAnimationController,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _emailAnimationController,
                      curve: Curves.easeOutBack,
                    ),
                  ),
                  alignment: Alignment.topCenter,
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(width: arrowOffset),
                    CustomPaint(
                      size: Size(arrowWidth, 10),
                      painter: _NotifTooltipArrowPainter(
                        color: Colors.white,
                        borderColor: Colors.grey.withOpacity(0.13),
                      ),
                    ),
                  ],
                ),
                _buildEmailTooltipContent(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailTooltipContent() {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    final List<Map<String, dynamic>> previewEmails = emails.take(3).toList();
    return Material(
      type: MaterialType.transparency,
      elevation: 0,
      child: Container(
        width: isMobile ? screenWidth * 0.85 : 260,
        constraints: BoxConstraints(maxHeight: isMobile ? 220 : 180),
        padding: const EdgeInsets.only(top: 10, bottom: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
              child: Text(
                'Email',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 2),
            if (previewEmails.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                child: Text(
                  'Tidak ada email baru.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  itemCount: previewEmails.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade100),
                  itemBuilder: (context, i) =>
                      _buildEmailBubbleItem(previewEmails[i]),
                ),
              ),
            const SizedBox(height: 2),
            InkWell(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              onTap: () {
                _removeEmailOverlay();
                Future.delayed(const Duration(milliseconds: 100), () {
                  // Navigasi ke halaman email jika ada
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.mail_outline_rounded, color: deepPink, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Lihat Semua Email',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: deepPink,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailBubbleItem(Map<String, dynamic> email) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: deepPink.withOpacity(0.13),
            child: Icon(Icons.mail_outline_rounded, color: deepPink, size: 16),
            radius: 13,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email['subject'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: deepPink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  email['snippet'],
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  email['time'],
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

  // Tambahkan state untuk overlay tooltip task
  OverlayEntry? _taskTooltipOverlayEntry;

  void _showTaskTooltip(BuildContext context, String text, Offset position) {
    _removeTaskTooltip();
    _taskTooltipOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_taskTooltipOverlayEntry!);
  }

  void _removeTaskTooltip() {
    if (_taskTooltipOverlayEntry != null) {
      _taskTooltipOverlayEntry!.remove();
      _taskTooltipOverlayEntry = null;
    }
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

class _NotifTooltipArrowPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  _NotifTooltipArrowPainter({required this.color, required this.borderColor});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(_NotifTooltipArrowPainter oldDelegate) => false;
}
