// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'dart:ui';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:miniproject_flutter/screens/Resource/Auth/Email_Page.dart';
// import 'package:miniproject_flutter/screens/Resource/Auth/Notification_Page.dart';
// import 'package:miniproject_flutter/screens/Resource/Purchasing/GRPO_Page.dart';
// import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialCalculate_Page.dart';
// import 'package:miniproject_flutter/screens/Resource/Stock_Management/StockOpname_Page.dart';
// import 'package:miniproject_flutter/screens/Resource/Stock_Management/TransferStock_Page.dart';
// import 'package:miniproject_flutter/screens/Resource/Stock_Management/MaterialRequest_Page.dart';
// import 'package:miniproject_flutter/screens/Resource/Auth/UserProfile_Page.dart';
// import 'package:miniproject_flutter/screens/Resource/Auth/Help_Page.dart';
// import 'package:miniproject_flutter/screens/Resource/Stock_Management/Waste_Page.dart';
// import 'package:miniproject_flutter/screens/DashboardPage.dart';
// import 'package:miniproject_flutter/services/DirectService.dart';
// import 'package:miniproject_flutter/screens/Resource/Auth/LoginPage.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:miniproject_flutter/services/authService.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/rendering.dart';
// import 'package:miniproject_flutter/widgets/Dashboard/AnimatedSidebar.dart';
// import 'package:miniproject_flutter/widgets/DirectPurchase/AppBarTitle.dart';
// import 'dart:convert';

// class DirectPurchasePage extends StatefulWidget {
//   final int selectedIndex;
//   const DirectPurchasePage({this.selectedIndex = 11, Key? key})
//     : super(key: key);

//   @override
//   _DirectPurchasePageState createState() => _DirectPurchasePageState();
// }

// class _DirectPurchasePageState extends State<DirectPurchasePage>
//     with TickerProviderStateMixin {
//   bool isOutstandingSelected =
//       true; // Track selected tab (Outstanding or Approved)
//   bool _isSidebarExpanded = true;
//   bool _isProfileMenuOpen = false;
//   bool _isStoreMenuOpen = false;
//   int? _expandedMenuIndex;
//   late int _selectedIndex;
//   int? _hoveredIndex;

//   // Tambahan untuk integrasi API
//   final DirectService _directService = DirectService();
//   List<dynamic> _directPurchases = [];
//   bool _isLoading = false;
//   String? _errorMessage;
//   String _searchQuery = '';
//   final AuthService _authService = AuthService();

//   late AnimationController _sidebarController;
//   late Animation<double> _sidebarWidth;
//   late Animation<double> _sidebarOpacity;
//   late Animation<Offset> _sidebarOffset;
//   late Animation<double> _sidebarScale;
//   late Animation<double> _sidebarSpringAnim;

//   // Tambahkan variabel dan fungsi yang diperlukan untuk header AppBar modern
//   late AnimationController _headerAnimationController;

//   // Dummy data notifikasi dan email
//   final List<Map<String, dynamic>> notifications = [
//     {
//       'icon': Icons.shopping_cart,
//       'title': 'Purchase Approved',
//       'message': 'Your direct purchase request has been approved.',
//       'time': '2 min ago',
//       'color': Color(0xFFE91E63),
//     },
//     {
//       'icon': Icons.assignment_turned_in,
//       'title': 'GRPO Received',
//       'message': 'Goods receipt has been completed for PO-2023-12.',
//       'time': '10 min ago',
//       'color': Color(0xFFE91E63),
//     },
//     {
//       'icon': Icons.warning_amber_rounded,
//       'title': 'Stock Low',
//       'message': 'Stock for Item ABC is below minimum level.',
//       'time': '1 hour ago',
//       'color': Color(0xFFE91E63),
//     },
//   ];
//   final List<Map<String, dynamic>> emails = [
//     {
//       'subject': 'Welcome to haus! Inventory',
//       'from': 'admin@haus.com',
//       'snippet': 'Thank you for registering your account.',
//       'time': '1 min ago',
//     },
//     {
//       'subject': 'PO-2024-0125 Approved',
//       'from': 'system@haus.com',
//       'snippet': 'Your PO-2024-0125 has been approved.',
//       'time': '10 min ago',
//     },
//     {
//       'subject': 'Monthly Report',
//       'from': 'report@haus.com',
//       'snippet': 'Your monthly inventory report is ready.',
//       'time': '1 hour ago',
//     },
//   ];
//   late AnimationController _emailAnimationController;
//   OverlayEntry? _emailOverlayEntry;
//   final GlobalKey _emailIconKey = GlobalKey();

//   // Tambahkan variabel state untuk tab Rejected
//   int _tabIndex = 0; // 0: Outstanding, 1: Approved, 2: Rejected

//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.selectedIndex;
//     // Set expanded menu otomatis sesuai submenu yang sedang selected
//     if ([11, 12].contains(_selectedIndex)) {
//       _expandedMenuIndex = PURCHASING_MENU;
//     } else if ([21, 22, 23, 24, 25].contains(_selectedIndex)) {
//       _expandedMenuIndex = STOCK_MANAGEMENT_MENU;
//     }
//     _fetchDirectPurchases();
//     // Tambahkan dummy data jika kosong (untuk testing UI)
//     Future.delayed(Duration(milliseconds: 500), () {
//       if (mounted && _directPurchases.isEmpty) {
//         setState(() {
//           _directPurchases = [
//             {
//               'no_direct': 'DP-2024-0001',
//               'supplier': 'PT. Sumber Makmur',
//               'directPurchaseDate': DateTime.now().toIso8601String(),
//               'status': 'Pending Area Manager',
//               'items': [
//                 {
//                   'itemName': 'Gula',
//                   'quantity': 10,
//                   'price': 15000,
//                   'totalPrice': 150000,
//                 },
//                 {
//                   'itemName': 'Kopi',
//                   'quantity': 5,
//                   'price': 30000,
//                   'totalPrice': 150000,
//                 },
//               ],
//               'totalAmount': 300000,
//               'expenseType': 'Inventory',
//               'note': 'Pembelian bahan baku',
//               'purchase_proof': '-',
//             },
//             {
//               'no_direct': 'DP-2024-0002',
//               'supplier': 'CV. Aneka Jaya',
//               'directPurchaseDate': DateTime.now()
//                   .subtract(Duration(days: 2))
//                   .toIso8601String(),
//               'status': 'Approved',
//               'items': [
//                 {
//                   'itemName': 'Susu',
//                   'quantity': 20,
//                   'price': 12000,
//                   'totalPrice': 240000,
//                 },
//               ],
//               'totalAmount': 240000,
//               'expenseType': 'Non Inventory',
//               'note': 'Pembelian susu',
//               'purchase_proof': '-',
//             },
//           ];
//         });
//       }
//     });
//     _headerAnimationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _emailAnimationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );
//   }

//   @override
//   void dispose() {
//     // Hapus overlay SEBELUM dispose controller
//     if (_emailOverlayEntry != null) {
//       _emailOverlayEntry!.remove();
//       _emailOverlayEntry = null;
//     }
//     _headerAnimationController.dispose();
//     _emailAnimationController.dispose();
//     super.dispose();
//   }

//   // color palate
//   final Color pastelPink = const Color(0xFFF8BBD0);
//   final Color deepPink = const Color.fromARGB(255, 255, 0, 85);
//   final Color lightPink = const Color(0xFFFCE4EC);
//   final Color accentPurple = const Color(0xFF7B1FA2);

//   //define menu indexes
//   static const int PURCHASING_MENU = 1;
//   static const int STOCK_MANAGEMENT_MENU = 2;
  
//   late bool isMobile;

//   bool _isMainMenuActive(int index) {
//     // Aktif jika salah satu submenu dari menu utama sedang selected
//     if (index == PURCHASING_MENU) {
//       return [11, 12].contains(_selectedIndex);
//     } else if (index == STOCK_MANAGEMENT_MENU) {
//       return [21, 22, 23, 24, 25].contains(_selectedIndex);
//     }
//     return _selectedIndex == index;
//   }

//   bool _isSubMenuActive(int index) {
//     // Submenu aktif hanya jika selected
//     return _selectedIndex == index;
//   }

//   bool _isMenuExpanded(int menuIndex, List<int> submenuIndexes) {
//     return _expandedMenuIndex == menuIndex ||
//         submenuIndexes.contains(_selectedIndex) ||
//         submenuIndexes.contains(_hoveredIndex);
//   }

//   Future<void> _fetchDirectPurchases() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//     try {
//       String? status;
//       if (_tabIndex == 1) {
//         status = 'Approved';
//       } else if (_tabIndex == 2) {
//         status = 'Rejected';
//       }
//       final data = await _directService.getDirectPurchases(
//         search: _searchQuery.isNotEmpty ? _searchQuery : null,
//         status: status, // Akan mengirim null untuk tab outstanding
//       );
//       List<dynamic> allPurchases = data['data'] ?? [];
//       setState(() {
//         if (_tabIndex == 0) {
//           _directPurchases = allPurchases.where((item) {
//             final itemStatus = item['status'] as String?;
//             return itemStatus != null &&
//                 itemStatus != 'Approved' &&
//                 itemStatus != 'Rejected';
//           }).toList();
//         } else {
//           _directPurchases = allPurchases;
//         }
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Gagal memuat data: ${e.toString()}';
//       });
//     }
//   }

//   void _onSearchChanged(String value) {
//     setState(() {
//       _searchQuery = value;
//     });
//     _fetchDirectPurchases();
//   }

//   void _onTabChanged(int index) {
//     setState(() {
//       _tabIndex = index;
//       isOutstandingSelected = (index == 0);
//     });
//     _fetchDirectPurchases();
//   }

//   /// Membuka dialog pop-up form tambah Direct Purchase (aman, tidak error)
//   void _showAddDirectPurchaseForm() async {
//     final result = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//           backgroundColor: Colors.white,
//           child: Container(
//             constraints: BoxConstraints(
//               maxWidth: 520,
//               maxHeight: MediaQuery.of(context).size.height * 0.95,
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Tambah Direct Purchase',
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: deepPink,
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.close, color: Colors.grey[600]),
//                         onPressed: () => Navigator.of(context).pop(),
//                         tooltip: 'Tutup',
//                       ),
//                     ],
//                   ),
//                   Divider(),
//                   //todo: from add
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//     if (result == true) {
//       _fetchDirectPurchases();
//     }
//   }

//   @override
//   //===================================================================================================================== //
//   //Todo:Rangkaian fungsi dan styling untuk header dan item lain
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     final bool isMobile = width < 700;
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(238, 255, 255, 255),
//       extendBody: true, // penting agar Stack bisa sampai ke bawah
//       drawer: Drawer(
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.75),
//             borderRadius: BorderRadius.only(
//               topRight: Radius.circular(32),
//               bottomRight: Radius.circular(32),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.07),
//                 blurRadius: 24,
//                 offset: Offset(4, 0),
//               ),
//             ],
//             border: Border.all(color: Color(0xFFE0E0E0), width: 1),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.only(
//               topRight: Radius.circular(32),
//               bottomRight: Radius.circular(32),
//             ),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//               child: Column(
//                 children: [
//                   // Logo dan nama aplikasi
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.7),
//                       borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(32),
//                         bottomLeft: Radius.circular(20),
//                         bottomRight: Radius.circular(20),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.04),
//                           blurRadius: 8,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             color: deepPink.withOpacity(0.11),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           padding: EdgeInsets.all(6),
//                           child: Image.asset(
//                             'assets/images/icons-haus.png',
//                             height: 32,
//                             width: 32,
//                           ),
//                         ),
//                         if (_isSidebarExpanded) const SizedBox(width: 14),
//                         if (_isSidebarExpanded)
//                           Text(
//                             'haus! Inventory',
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 19,
//                               color: deepPink,
//                               letterSpacing: 0.2,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                   if (_isSidebarExpanded) _buildStoreDropdown(),
//                   // Menu Items dengan Expanded
//                   Expanded(
//                     child: SingleChildScrollView(
//                       physics: const BouncingScrollPhysics(),
//                       child: Column(
//                         children: [
//                           if (_isSidebarExpanded)
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     'GENERAL',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 12,
//                                       color: Colors.black54,
//                                       letterSpacing: 1,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   const Spacer(),
//                                   Container(
//                                     height: 1,
//                                     width: 80,
//                                     color: Colors.grey.withOpacity(0.13),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           _buildMenuItem(
//                             icon: Icons.dashboard_outlined,
//                             title: 'Dashboard',
//                             index: 0,
//                             onTap: () {
//                               if (_selectedIndex != 0) {
//                                 _navigateToPage(0);
//                               }
//                             },
//                           ),
//                           _buildExpandableMenu(
//                             icon: Icons.shopping_cart_outlined,
//                             title: 'Purchasing',
//                             isExpanded: _isMenuExpanded(PURCHASING_MENU, [
//                               11,
//                               12,
//                             ]),
//                             menuIndex: PURCHASING_MENU,
//                             children: [
//                               _buildSubMenuItem('Direct Purchase', 11),
//                               _buildSubMenuItem('GRPO', 12),
//                             ],
//                             onTap: () {
//                               if (_selectedIndex != PURCHASING_MENU) {
//                                 _navigateToPage(PURCHASING_MENU);
//                               }
//                             },
//                           ),
//                           _buildExpandableMenu(
//                             icon: Icons.inventory_2_outlined,
//                             title: 'Stock Management',
//                             isExpanded: _isMenuExpanded(STOCK_MANAGEMENT_MENU, [
//                               21,
//                               22,
//                               23,
//                               24,
//                               25,
//                             ]),
//                             menuIndex: STOCK_MANAGEMENT_MENU,
//                             children: [
//                               _buildSubMenuItem('Material Request', 21),
//                               _buildSubMenuItem('Material Calculate', 25),
//                               _buildSubMenuItem('Stock Opname', 22),
//                               _buildSubMenuItem('Transfer Stock', 23),
//                               _buildSubMenuItem('Waste', 24),
//                             ],
//                             onTap: () {
//                               if (_selectedIndex != STOCK_MANAGEMENT_MENU) {
//                                 _navigateToPage(STOCK_MANAGEMENT_MENU);
//                               }
//                             },
//                           ),
//                           _buildMenuItem(
//                             icon: Icons.assessment_outlined,
//                             title: 'Inventory Report',
//                             index: 3,
//                             onTap: () {
//                               if (_selectedIndex != 3) {
//                                 _navigateToPage(3);
//                               }
//                             },
//                           ),
//                           if (_isSidebarExpanded)
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     'TOOLS',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 12,
//                                       color: Colors.black54,
//                                       letterSpacing: 1,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   const Spacer(),
//                                   Container(
//                                     height: 1,
//                                     width: 80,
//                                     color: Colors.grey.withOpacity(0.13),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           _buildMenuItem(
//                             icon: Icons.settings_outlined,
//                             title: 'Account & Settings',
//                             index: 4,
//                             onTap: () {
//                               if (_selectedIndex != 4) {
//                                 _navigateToPage(4);
//                               }
//                             },
//                           ),
//                           _buildMenuItem(
//                             icon: Icons.help_outline,
//                             title: 'Help',
//                             index: 5,
//                             onTap: () {
//                               if (_selectedIndex != 5) {
//                                 _navigateToPage(5);
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   if (_isSidebarExpanded)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 18,
//                       ),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.7),
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.04),
//                               blurRadius: 8,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: _buildProfileDropdown(),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           SafeArea(
//             child: SingleChildScrollView(
//               child: Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: isMobile ? 16 : 32,
//                   vertical: isMobile ? 16 : 24,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // AppBar custom: search + icon kanan
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 18.0),
//                       child: Material(
//                         color: Colors.white,
//                         elevation: 3,
//                         borderRadius: BorderRadius.circular(22),
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: isMobile ? 8 : 18,
//                             vertical: isMobile ? 8 : 14,
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(22),
//                             border: Border.all(
//                               color: Colors.grey.withOpacity(0.08),
//                             ),
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               // Logo kecil (jika ada)
//                               if (!isMobile)
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 8.0),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: Image.asset(
//                                       'assets/images/icons-haus.png',
//                                       width: 32,
//                                       height: 32,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                               // Icon menu/sidebar di kiri
//                               Material(
//                                 color: Colors.transparent,
//                                 child: InkWell(
//                                   borderRadius: BorderRadius.circular(22),
//                                   onTap: () {
//                                     Scaffold.of(context).openDrawer();
//                                   },
//                                   child: Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       color: deepPink.withOpacity(0.11),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Icon(
//                                       Icons.menu,
//                                       color: deepPink,
//                                       size: 24,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 12),
//                               // Search bar
//                               Expanded(
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[50],
//                                     borderRadius: BorderRadius.circular(18),
//                                     border: Border.all(
//                                       color: Colors.grey[200]!,
//                                     ),
//                                   ),
//                                   child: FocusScope(
//                                     child: Focus(
//                                       onFocusChange: (hasFocus) {},
//                                       child: TextField(
//                                         onChanged: _onSearchChanged,
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 16,
//                                           color: Colors.grey[800],
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                         decoration: InputDecoration(
//                                           prefixIcon: Icon(
//                                             Icons.search,
//                                             color: Colors.grey[500],
//                                             size: 22,
//                                           ),
//                                           hintText: 'Cari direct purchase...',
//                                           hintStyle: GoogleFonts.poppins(
//                                             color: Colors.grey[400],
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w400,
//                                           ),
//                                           border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               18,
//                                             ),
//                                             borderSide: BorderSide.none,
//                                           ),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               18,
//                                             ),
//                                             borderSide: BorderSide(
//                                               color: Colors.grey[200]!,
//                                             ),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               18,
//                                             ),
//                                             borderSide: BorderSide(
//                                               color: Colors.pink.shade200,
//                                             ),
//                                           ),
//                                           contentPadding: EdgeInsets.symmetric(
//                                             horizontal: 18,
//                                             vertical: 14,
//                                           ),
//                                           filled: true,
//                                           fillColor: Colors.grey[50],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: isMobile ? 6 : 16),
//                               // Icon notifikasi
//                               Material(
//                                 color: Colors.transparent,
//                                 child: InkWell(
//                                   borderRadius: BorderRadius.circular(22),
//                                   onTap: _toggleEmailOverlay,
//                                   child: Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[100],
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Stack(
//                                       children: [
//                                         Center(
//                                           child: Icon(
//                                             Icons.mail_outline_rounded,
//                                             color: Colors.pink,
//                                             size: 22,
//                                           ),
//                                         ),
//                                         if (emails.isNotEmpty)
//                                           Positioned(
//                                             right: 8,
//                                             top: 8,
//                                             child: Container(
//                                               width: 8,
//                                               height: 8,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.pink,
//                                                 shape: BoxShape.circle,
//                                               ),
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: isMobile ? 4 : 10),
//                               // Icon email
//                               Material(
//                                 color: Colors.transparent,
//                                 child: InkWell(
//                                   borderRadius: BorderRadius.circular(22),
//                                   onTap: _toggleEmailOverlay,
//                                   child: Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[100],
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Stack(
//                                       children: [
//                                         Center(
//                                           child: Icon(
//                                             Icons.mail_outline_rounded,
//                                             color: Colors.pink,
//                                             size: 22,
//                                           ),
//                                         ),
//                                         if (emails.isNotEmpty)
//                                           Positioned(
//                                             right: 8,
//                                             top: 8,
//                                             child: Container(
//                                               width: 8,
//                                               height: 8,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.pink,
//                                                 shape: BoxShape.circle,
//                                               ),
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: isMobile ? 4 : 10),
//                               // Icon profil/avatar
//                               Material(
//                                 color: Colors.transparent,
//                                 child: InkWell(
//                                   borderRadius: BorderRadius.circular(22),
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             const UserprofilePage(),
//                                       ),
//                                     );
//                                   },
//                                   child: Container(
//                                     width: 40,
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       color: deepPink.withOpacity(0.11),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         'J', // Inisial, bisa diganti dinamis
//                                         style: GoogleFonts.poppins(
//                                           color: Colors.pink,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     // Section judul & icon di bawah app bar (badge status filter di dalam card judul)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 18.0),
//                       child: Material(
//                         color: Colors.white,
//                         elevation: 1,
//                         borderRadius: BorderRadius.circular(18),
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: isMobile ? 16 : 23,
//                             vertical: isMobile ? 16: 22,
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(18),
//                           ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(14),
//                                     decoration: BoxDecoration(
//                                       color: deepPink.withOpacity(0.09),
//                                       borderRadius: BorderRadius.circular(14),
//                                     ),
//                                     child: Icon(
//                                       Icons.shopping_cart_checkout_rounded,
//                                       color: deepPink,
//                                       size: 28,
//                                     ),
//                                   ),
//                                   SizedBox(width: 18),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Direct Purchase',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: isMobile ? 18 : 22,
//                                             fontWeight: FontWeight.bold,
//                                             color: deepPink,
//                                             letterSpacing: 0.5,
//                                           ),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         SizedBox(height: 4),
//                                         Text(
//                                           'Kelola dan pantau pembelian langsung untuk kebutuhan operasional toko Anda.',
//                                           style: GoogleFonts.poppins(
//                                             fontSize: isMobile ? 12 : 14,
//                                             color: Colors.grey[700],
//                                             fontWeight: FontWeight.w400,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 8),
//                               Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: SizedBox(
//                                   height: 40,
//                                   child: SingleChildScrollView(
//                                     scrollDirection: Axis.horizontal,
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () {
//                                             setState(() {
//                                               _tabIndex = 0;
//                                             });
//                                           },
//                                           child: _buildStatusBadge(
//                                             icon: Icons.timelapse,
//                                             label: 'Outstanding',
//                                             count: _directPurchases
//                                                 .where(
//                                                   (e) => (e['status'] ?? '')
//                                                       .toLowerCase()
//                                                       .contains('pending'),
//                                                 )
//                                                 .length,
//                                             color: _tabIndex == 0 ? Colors.orange : Colors.orange.withOpacity(0.5),
//                                           ),
//                                         ),
//                                         SizedBox(width: 8),
//                                         GestureDetector(
//                                           onTap: () {
//                                             setState(() {
//                                               _tabIndex = 1;
//                                             });
//                                           },
//                                           child: _buildStatusBadge(
//                                             icon: Icons.verified,
//                                             label: 'Approved',
//                                             count: _directPurchases
//                                                 .where(
//                                                   (e) => (e['status'] ?? '')
//                                                       .toLowerCase()
//                                                       .contains('approved'),
//                                                 )
//                                                 .length,
//                                             color: _tabIndex == 1 ? Colors.green : Colors.green.withOpacity(0.5),
//                                           ),
//                                         ),
//                                         SizedBox(width: 8),
//                                         GestureDetector(
//                                           onTap: () {
//                                             setState(() {
//                                               _tabIndex = 2;
//                                             });
//                                           },
//                                           child: _buildStatusBadge(
//                                             icon: Icons.close,
//                                             label: 'Rejected',
//                                             count: _directPurchases
//                                                 .where(
//                                                   (e) => (e['status'] ?? '')
//                                                       .toLowerCase()
//                                                       .contains('rejected'),
//                                                 )
//                                                 .length,
//                                             color: _tabIndex == 2 ? Colors.red : Colors.red.withOpacity(0.5),
//                                           ),
//                                         ),
//                                         SizedBox(width: 12),
//                                         // Tombol add bulat di ujung kanan badge status
//                                         ElevatedButton.icon(
//                                           onPressed: _showAddDirectPurchaseForm,
//                                           icon: Icon(Icons.add, color: Colors.white, size: 20),
//                                           label: Text('Tambah', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: deepPink,
//                                             elevation: 3,
//                                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                           SizedBox(height: 16),
//                     // Data langsung tanpa card pembungkus
//                           _isLoading
//                               ? _buildHolographicLoading()
//                               : _errorMessage != null
//                               ? _buildErrorDisplay()
//                         : _filteredPurchases().isEmpty
//                               ? _buildHolographicEmptyState()
//                         : _buildHolographicDataGrid(_filteredPurchases()),
//                         ],
//                       ),
//                     ),
//             ),
//             ),
//         ],
//       ),
//     );
//   }

//   // AI-Powered Header Section
//   Widget _buildAIHeaderSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: deepPink,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Icon(
//                   Icons.shopping_cart_checkout_rounded,
//                   color: deepPink,
//                   size: 32,
//                 ),
//               ),
//               SizedBox(width: 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: Text(
//                         'Haus Inventory',
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: GoogleFonts.poppins(
//                           fontSize: 26,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'Inventory Management System',
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.poppins(
//                         fontSize: 15,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w400,
//                         letterSpacing: 0.1,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 18),
//         // Search bar di bawah header
//         Row(
//           children: [
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[50],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey[300]!),
//                 ),
//                 child: TextField(
//                   onChanged: _onSearchChanged,
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     color: Colors.grey[800],
//                     fontWeight: FontWeight.w500,
//                   ),
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(
//                       Icons.search,
//                       color: Colors.grey[600],
//                       size: 22,
//                     ),
//                     hintText: 'Search for direct purchases...',
//                     hintStyle: GoogleFonts.poppins(
//                       color: Colors.grey[500],
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide.none,
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(color: Colors.grey[300]!),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(color: Colors.grey[400]!),
//                     ),
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 18,
//                       vertical: 14,
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey[50],
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: 16),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey[300]!),
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   borderRadius: BorderRadius.circular(8),
//                   onTap: _fetchDirectPurchases,
//                   child: Padding(
//                     padding: EdgeInsets.all(12),
//                     child: Icon(Icons.tune, color: deepPink, size: 22),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   // Quantum Tab Navigation
//   Widget _buildQuantumTabNavigation() {
//     final tabData = [
//       {'label': 'Outstanding', 'icon': Icons.timelapse},
//       {'label': 'Approved', 'icon': Icons.verified},
//       {'label': 'Rejected', 'icon': Icons.close},
//     ];
//     final List<GlobalKey> tabKeys = List.generate(
//       tabData.length,
//       (_) => GlobalKey(),
//     );
//     return StatefulBuilder(
//       builder: (context, setTabState) {
//         double indicatorLeft = 0;
//         double indicatorWidth = 60;
//         void updateIndicator() {
//           final keyContext = tabKeys[_tabIndex].currentContext;
//           if (keyContext != null) {
//             final box = keyContext.findRenderObject() as RenderBox;
//             final offset = box.localToGlobal(
//               Offset.zero,
//               ancestor: context.findRenderObject(),
//             );
//             final parentOffset = (context.findRenderObject() as RenderBox)
//                 .localToGlobal(Offset.zero);
//             final newLeft = offset.dx - parentOffset.dx;
//             final newWidth = box.size.width;
//             if (indicatorLeft != newLeft || indicatorWidth != newWidth) {
//               setTabState(() {
//                 indicatorLeft = newLeft;
//                 indicatorWidth = newWidth;
//               });
//             }
//           } else {
//             setTabState(() {
//               indicatorLeft = 0;
//               indicatorWidth = 60;
//             });
//           }
//         }

//         WidgetsBinding.instance.addPostFrameCallback((_) => updateIndicator());
//         return Container(
//           padding: EdgeInsets.symmetric(vertical: 4),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 8,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: SizedBox(
//             height: 48,
//             child: NotificationListener<ScrollNotification>(
//               onNotification: (notif) {
//                 WidgetsBinding.instance.addPostFrameCallback(
//                   (_) => updateIndicator(),
//                 );
//                 return false;
//               },
//               child: Stack(
//                 children: [
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: List.generate(tabData.length, (i) {
//                         final isSelected = _tabIndex == i;
//                         return Container(
//                           key: tabKeys[i],
//                           margin: EdgeInsets.symmetric(horizontal: 4),
//                           child: GestureDetector(
//                             onTap: () {
//                               _onTabChanged(i);
//                               setTabState(() {});
//                             },
//                             child: AnimatedContainer(
//                               duration: Duration(milliseconds: 250),
//                               curve: Curves.ease,
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 18,
//                                 vertical: 12,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.transparent,
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     tabData[i]['icon'] as IconData,
//                                     color: isSelected
//                                         ? deepPink
//                                         : Colors.grey[500],
//                                     size: 20,
//                                   ),
//                                   SizedBox(width: 8),
//                                   AnimatedSwitcher(
//                                     duration: Duration(milliseconds: 250),
//                                     child: Text(
//                                       tabData[i]['label'] as String,
//                                       key: ValueKey(isSelected),
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         color: isSelected
//                                             ? deepPink
//                                             : Colors.grey[700],
//                                         fontSize: 15,
//                                         letterSpacing: 0.2,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                   AnimatedPositioned(
//                     duration: Duration(milliseconds: 350),
//                     curve: Curves.easeInOutCubic,
//                     left: indicatorLeft,
//                     bottom: 0,
//                     width: indicatorWidth,
//                     height: 3,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(2),
//                         gradient: LinearGradient(
//                           colors: [deepPink, Color(0xFF7B1FA2)],
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildQuantumTabButton({
//     required String label,
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//       margin: EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         gradient: isSelected
//             ? LinearGradient(
//                 colors: [deepPink, Color(0xFF7B1FA2)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               )
//             : null,
//         color: isSelected ? null : Colors.grey[50],
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: isSelected
//             ? [
//                 BoxShadow(
//                   color: deepPink.withOpacity(0.3),
//                   blurRadius: 8,
//                   offset: Offset(0, 2),
//                 ),
//               ]
//             : null,
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: onTap,
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   icon,
//                   color: isSelected ? Colors.white : Colors.grey[600],
//                   size: 20,
//                 ),
//                 SizedBox(width: 8),
//                 Flexible(
//                   child: FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: Text(
//                       label,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.orbitron(
//                         fontWeight: FontWeight.bold,
//                         color: isSelected ? Colors.white : Colors.grey[600],
//                         fontSize: 14,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Holographic Data Grid
//   Widget _buildHolographicDataGrid(List<dynamic> data) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.only(bottom: 20),
//       itemCount: data.length,
//       itemBuilder: (context, index) {
//         return _buildHolographicCard(data[index]);
//       },
//     );
//   }

//   Widget _buildHolographicCard(dynamic item) {
//     String status = item['status'] ?? '';
//     Color statusColor = _getStatusColor(status);

//     return AnimatedContainer(
//       duration: Duration(milliseconds: 350),
//       curve: Curves.easeInOut,
//       margin: const EdgeInsets.only(bottom: 20),
//       child: Material(
//         color: Color.fromRGBO(255, 255, 255, 0.85),
//         elevation: 3,
//         borderRadius: BorderRadius.circular(24),
//       child: Container(
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height * 0.5,
//         ),
//         child: SingleChildScrollView(
//           padding: EdgeInsets.fromLTRB(28, 28, 28, 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header with status
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       color: deepPink,
//                       borderRadius: BorderRadius.circular(14),
//                       boxShadow: [
//                         BoxShadow(
//                           color: deepPink.withOpacity(0.18),
//                           blurRadius: 10,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       Icons.shopping_cart,
//                       color: Color.fromRGBO(255, 255, 255, 1),
//                       size: 28,
//                     ),
//                   ),
//                   SizedBox(width: 22),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           getNoDirect(item),
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w800,
//                             fontSize: 22,
//                             color: deepPink,
//                             letterSpacing: 0.5,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: 6),
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 14,
//                             vertical: 7,
//                           ),
//                           decoration: BoxDecoration(
//                             color: statusColor.withOpacity(0.13),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: statusColor.withOpacity(0.4),
//                               width: 1,
//                             ),
//                           ),
//                           child: Text(
//                             status,
//                             style: GoogleFonts.poppins(
//                               fontSize: 13,
//                               fontWeight: FontWeight.bold,
//                               color: statusColor,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 24),
//               _buildDataRow(
//                 icon: Icons.store,
//                 label: 'Supplier',
//                 value: item['supplier'] ?? '-',
//                 iconColor: deepPink,
//               ),
//               SizedBox(height: 14),
//               _buildDataRow(
//                 icon: Icons.calendar_today,
//                 label: 'Date',
//                 value: getDate(item),
//                 iconColor: Color(0xFF4CAF50),
//               ),
//               SizedBox(height: 14),
//               _buildDataRow(
//                 icon: Icons.inventory_2,
//                 label: 'Items',
//                 value: '${item['items']?.length ?? 0} items',
//                 iconColor: Color(0xFFFF9800),
//               ),
//               SizedBox(height: 14),
//               if (item['totalAmount'] != null)
//                 _buildDataRow(
//                   icon: Icons.attach_money,
//                   label: 'Total',
//                   value: item['totalAmount'].toString(),
//                   iconColor: Color(0xFF4CAF50),
//                 ),
//               SizedBox(height: 22),
//               Container(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: () => _showDetailDialog(item),
//                   icon: Icon(Icons.visibility, size: 22, color: Colors.white),
//                   label: Text(
//                     'View Details',
//                     style: GoogleFonts.poppins(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                       letterSpacing: 0.5,
//                       color: Colors.white,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color.fromRGBO(255, 0, 85, 1),
//                     foregroundColor: Colors.white,
//                     elevation: 0,
//                     padding: EdgeInsets.symmetric(vertical: 18),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDataRow({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color iconColor,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: iconColor.withOpacity(0.18),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, color: iconColor, size: 18),
//         ),
//         SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: GoogleFonts.poppins(
//                   fontSize: 11,
//                   color: Colors.grey[500],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 value,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: GoogleFonts.poppins(
//                   fontSize: 15,
//                   color: Colors.black87,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 0.3,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'Pending Area Manager':
//         return Color(0xFFFF9800);
//       case 'Approved Area Manager':
//         return Color.fromARGB(255, 53, 39, 176);
//       case 'Approved':
//         return Color(0xFF4CAF50);
//       default:
//         return Colors.grey;
//     }
//   }

//   // Holographic Loading
//   Widget _buildHolographicLoading() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [deepPink, Color(0xFF7B1FA2)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: deepPink.withOpacity(0.3),
//                   blurRadius: 20,
//                   offset: Offset(0, 8),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: SizedBox(
//                 width: 40,
//                 height: 40,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 3,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 24),
//           Text(
//             'Loading Neural Data...',
//             style: GoogleFonts.orbitron(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: deepPink,
//               letterSpacing: 1,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Error Display
//   Widget _buildErrorDisplay() {
//     return Center(
//       child: Container(
//         padding: EdgeInsets.all(32),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: Color(0xFFFF5722).withOpacity(0.3),
//             width: 1,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 20,
//               offset: Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.error_outline, size: 64, color: Color(0xFFFF5722)),
//             SizedBox(height: 16),
//             Text(
//               'Neural Error',
//               style: GoogleFonts.orbitron(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFFFF5722),
//                 letterSpacing: 1,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               _errorMessage!,
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Holographic Empty State
//   Widget _buildHolographicEmptyState() {
//     // Warna dan teks sesuai status tab
//     Color statusColor;
//     String statusText;
//     String descText;
//     IconData iconData;
//     if (_tabIndex == 1) {
//       statusColor = Colors.green;
//       statusText = 'Tidak Ada Approved';
//       descText = 'Tidak ada data direct purchase yang sudah disetujui.';
//       iconData = Icons.verified;
//     } else if (_tabIndex == 2) {
//       statusColor = Colors.red;
//       statusText = 'Tidak Ada Rejected';
//       descText = 'Tidak ada data direct purchase yang ditolak.';
//       iconData = Icons.close;
//     } else {
//       statusColor = Colors.orange;
//       statusText = 'Tidak Ada Outstanding';
//       descText = 'Tidak ada data direct purchase outstanding.';
//       iconData = Icons.timelapse;
//     }
//     return Center(
//       child: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(40),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: statusColor.withOpacity(0.3),
//               width: 1,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: statusColor.withOpacity(0.10),
//                 blurRadius: 20,
//                 offset: Offset(0, 8),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.13),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: statusColor.withOpacity(0.13),
//                       blurRadius: 20,
//                       offset: Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: Icon(iconData, size: 48, color: statusColor),
//               ),
//               SizedBox(height: 24),
//               Text(
//                 statusText,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: GoogleFonts.orbitron(
//                   fontSize: 17,
//                   fontWeight: FontWeight.bold,
//                   color: statusColor,
//                   letterSpacing: 1.1,
//                 ),
//               ),
//               SizedBox(height: 12),
//               Text(
//                 descText,
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   color: statusColor.withOpacity(0.8),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Dialog pop-up modern untuk detail data
//   void _showDetailDialog(dynamic item) {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//           backgroundColor: Colors.white,
//           child: Container(
//             constraints: BoxConstraints(maxWidth: 420),
//             padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Detail Direct Purchase',
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: deepPink,
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.close, color: Colors.grey[600]),
//                         onPressed: () => Navigator.of(context).pop(),
//                         tooltip: 'Tutup',
//                       ),
//                     ],
//                   ),
//                   Divider(),
//                   SizedBox(height: 8),
//                   _buildDetailRow('No Direct', getNoDirect(item)),
//                   _buildDetailRow('Supplier', item['supplier'] ?? '-'),
//                   _buildDetailRow('Date', getDate(item)),
//                   _buildDetailRow('Expense Type', item['expenseType'] ?? '-'),
//                   _buildDetailRow('Status', item['status'] ?? '-'),
//                   _buildDetailRow('Note', item['note'] ?? '-'),
//                   // --- Gambar purchase_proof (array atau string) ---
//                   ...(() {
//                     dynamic proof = item['purchase_proof'];
//                     if (proof is String) {
//                       try {
//                         proof = jsonDecode(proof);
//                       } catch (_) {}
//                     }
//                     List<String> images = [];
//                     if (proof is List) {
//                       images = proof.cast<String>();
//                     } else if (proof is String && proof.isNotEmpty && proof != '-') {
//                       images = [proof];
//                     }
//                     if (images.isNotEmpty) {
//                       return [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Image:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
//                               SizedBox(height: 8),
//                               ...images.map((img) {
//                                 String url = img.startsWith('http')
//                                     ? img
//                                     : 'http://192.168.1.10:8000/storage/' + img;
//                                 return Padding(
//                                   padding: const EdgeInsets.only(bottom: 8.0),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: Image.network(
//                                       url,
//                                       height: 160,
//                                       width: double.infinity,
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (c, e, s) => Container(
//                                         color: Colors.grey[200],
//                                         height: 160,
//                                         child: Center(child: Icon(Icons.broken_image, color: Colors.grey)),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                             ],
//                           ),
//                         ),
//                       ];
//                     } else {
//                       return [];
//                     }
//                   })(),
//                   SizedBox(height: 12),
//                   Text('Items:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
//                   ...((item['items'] as List?)?.map((itm) => Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 4.0),
//                         child: Text(
//                           '- 	${itm['itemName'] ?? itm['item_name'] ?? '-'} | Qty: ${itm['quantity']} | Price: ${itm['price']} | Total: ${itm['totalPrice'] ?? itm['total_price']} ',
//                           style: GoogleFonts.poppins(fontSize: 13),
//                         ),
//                       )).toList() ?? []),
//                   SizedBox(height: 18),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.of(context).pop(),
//                       child: Text('Tutup', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: deepPink,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               '$label:',
//               style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
//             ),
//           ),
//           Expanded(child: Text(value, style: GoogleFonts.poppins())),
//         ],
//       ),
//     );
//   }



// /*************  ✨ Windsurf Command 🌟  *************/
// // ... existing code ...

//   Widget _buildMenuItem({
//     required IconData icon,
//     required String title,
//     required int index,
//     required VoidCallback onTap,
//   }) {
//     final isActive = _isMainMenuActive(index);
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: isActive ? deepPink: Colors.transparent,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListTile(
//         leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: isActive
//                 ? deepPink.withOpacity(0.1)
//                 : Colors.grey.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(
//             icon,
//             color: isActive ? deepPink : Colors.grey,
//             size: 20,
//           ),
//         ),
//         title: Text(
//           title,
//           style: GoogleFonts.poppins(
//             color: isActive ? deepPink : Colors.grey,
//             fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//             fontSize: 14,
//           ),
//         ),
//         selected: isActive,
//         onTap: onTap,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         dense: true,
//       ),
//     );
//   }

//   Widget _buildExpandableMenu({
//     required IconData icon,
//     required String title,
//     required bool isExpanded,
//     required List<Widget> children,
//     required VoidCallback onTap,
//     required int menuIndex,
//   }) {
//     final isMenuExpanded = _expandedMenuIndex == menuIndex;
//     bool isAnySubMenuActive = false;
//     if (menuIndex == PURCHASING_MENU) {
//       isAnySubMenuActive = [11, 12].contains(_selectedIndex);
//     } else if (menuIndex == STOCK_MANAGEMENT_MENU) {
//       isAnySubMenuActive = [21, 22, 23, 24, 25].contains(_selectedIndex);
//     }
//     final bool highlightParent = isExpanded && !isAnySubMenuActive;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           decoration: BoxDecoration(
//             color: highlightParent ? deepPink : Colors.transparent,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: ListTile(
//             leading: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: highlightParent
//                     ? deepPink.withOpacity(0.1)
//                     : Colors.grey.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 icon,
//                 color: highlightParent ? deepPink : Colors.grey,
//                 size: 20,
//               ),
//             ),
//             title: Text(
//               title,
//               style: GoogleFonts.poppins(
//                 color: highlightParent ? deepPink : Colors.grey,
//                 fontWeight: highlightParent
//                     ? FontWeight.bold
//                     : FontWeight.normal,
//                 fontSize: 14,
//               ),
//             ),
//             trailing: Icon(
//               isMenuExpanded ? Icons.expand_less : Icons.expand_more,
//               color: highlightParent ? deepPink : Colors.grey,
//             ),
//             onTap: () {
//               setState(() {
//                 if (_expandedMenuIndex == menuIndex) {
//                   _expandedMenuIndex = null;
//                 } else {
//                   _expandedMenuIndex = menuIndex;
//                 }
//               });
//             },
//             dense: true,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 8,
//             ),
//           ),
//         ),
//         if (isMenuExpanded)
//           Container(
//             margin: const EdgeInsets.only(left: 16),
//             decoration: BoxDecoration(
//               border: Border(
//                 left: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: children,
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildSubMenuItem(
//     String title,
//     int index, {
//     bool isMobile = false,
//     VoidCallback? closeDrawer,
//   }) {
//     final isActive = _isSubMenuActive(index);
//     return MouseRegion(
//       onEnter: (_) {
//         if (!isActive) {
//           setState(() => _hoveredIndex = index);
//         }
//       },
//       onExit: (_) {
//         if (!isActive) {
//           setState(() => _hoveredIndex = null);
//         }
//       },
//       child: Container(
//         margin: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
//         decoration: BoxDecoration(
//           color: isActive ? deepPink : Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: ListTile(
//           leading: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: isActive
//                   ? deepPink.withOpacity(0.1)
//                   : Colors.grey.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               _getSubMenuIcon(index),
//               color: isActive ? deepPink : Colors.grey,
//               size: 20,
//             ),
//           ),
//           title: Text(
//             title,
//             style: GoogleFonts.poppins(
//               fontSize: 13,
//               color: isActive ? deepPink : Colors.black87,
//               fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//           selected: isActive,
//           onTap: () {
//             if (_selectedIndex != index) {
//               setState(() {
//                 _selectedIndex = index;
//                 if ([11, 12].contains(index)) {
//                   _expandedMenuIndex = PURCHASING_MENU;
//                 } else if ([21, 22, 23, 24, 25].contains(index)) {
//                   _expandedMenuIndex = STOCK_MANAGEMENT_MENU;
//                 }
//               });
//               _navigateToPage(index);
//               if (isMobile && closeDrawer != null) closeDrawer();
//             }
//           },
//           dense: true,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 4,
//           ),
//         ),
//       ),
//     );
//   }

//   IconData _getSubMenuIcon(int index) {
//     switch (index) {
//       case 11:
//         return Icons.shopping_cart_outlined;
//       case 12:
//         return Icons.receipt_long_outlined;
//       case 21:
//         return Icons.inventory_2_outlined;
//       case 22:
//         return Icons.checklist_rtl_outlined;
//       case 23:
//         return Icons.swap_horiz_outlined;
//       case 24:
//         return Icons.delete_outline;
//       case 25:
//         return Icons.inventory_2_outlined;
//       default:
//         return Icons.circle_outlined;
//     }
//   }

//   void _navigateToPage(int index) {
//     Navigator.pushReplacement(context, _getPageRouteByIndex(index));
//   }

//   Route _getPageRouteByIndex(int index) {
//     switch (index) {
//       case 0:
//         return MaterialPageRoute(
//           builder: (context) => DashboardPage(selectedIndex: 0),
//         );
//       case 11:
//         return MaterialPageRoute(
//           builder: (context) => DirectPurchasePage(selectedIndex: 11),
//         );
//       case 12:
//         return MaterialPageRoute(
//           builder: (context) => GRPO_Page(selectedIndex: 12),
//         );
//       case 21:
//         return MaterialPageRoute(
//           builder: (context) => MaterialRequestPage(selectedIndex: 21),
//         );
//       case 22:
//         return MaterialPageRoute(
//           builder: (context) => StockOpnamePage(selectedIndex: 22),
//         );
//       case 23:
//         return MaterialPageRoute(
//           builder: (context) => TransferStockPage(selectedIndex: 23),
//         );
//       case 24:
//         return MaterialPageRoute(
//           builder: (context) => WastePage(selectedIndex: 24),
//         );
//       case 25:
//         return MaterialPageRoute(
//           builder: (context) => MaterialCalculatePage(selectedIndex: 25),
//         );
//       case 3:
//         // Replace with your Inventory Report page if available
//         return MaterialPageRoute(
//           builder: (context) => DashboardPage(selectedIndex: 0),
//         );
//       case 4:
//         // Replace with your Account & Settings page if available
//         return MaterialPageRoute(builder: (context) => UserprofilePage());
//       case 5:
//         return MaterialPageRoute(builder: (context) => HelpPage());
//       default:
//         return MaterialPageRoute(
//           builder: (context) => DashboardPage(selectedIndex: 0),
//         );
//     }
//   }

//   Widget _buildStoreDropdown() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: lightPink,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: deepPink.withOpacity(0.1), width: 1),
//       ),
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 _isStoreMenuOpen = !_isStoreMenuOpen;
//                 _isProfileMenuOpen = false;
//               });
//             },
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: deepPink.withOpacity(0.1),
//                   child: Icon(Icons.store, color: deepPink),
//                   radius: 18,
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Toko',
//                         style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           color: Colors.black54,
//                         ),
//                       ),
//                       Text(
//                         'HAUS Jakarta',
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   _isStoreMenuOpen ? Icons.expand_less : Icons.expand_more,
//                   color: deepPink,
//                 ),
//               ],
//             ),
//           ),
//           if (_isStoreMenuOpen)
//             Container(
//               margin: const EdgeInsets.only(top: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.withOpacity(0.2)),
//               ),
//               child: Column(
//                 children: [
//                   _buildStoreMenuItem('HAUS Jakarta', true),
//                   _buildStoreMenuItem('HAUS Bandung', false),
//                   _buildStoreMenuItem('HAUS Surabaya', false),
//                   _buildStoreMenuItem('HAUS Medan', false),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStoreMenuItem(String storeName, bool isSelected) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isSelected ? lightPink.withOpacity(0.3) : Colors.transparent,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListTile(
//         dense: true,
//         title: Text(
//           storeName,
//           style: GoogleFonts.poppins(
//             fontSize: 13,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             color: isSelected ? deepPink : Colors.black87,
//           ),
//         ),
//         trailing: isSelected
//             ? Icon(Icons.check_circle, color: deepPink, size: 18)
//             : null,
//         onTap: () {
//           setState(() {
//             _isStoreMenuOpen = false;
//           });
//         },
//       ),
//     );
//   }

//   Widget _buildProfileDropdown() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: lightPink,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: deepPink.withOpacity(0.1), width: 1),
//       ),
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 _isProfileMenuOpen = !_isProfileMenuOpen;
//                 _isStoreMenuOpen = false;
//               });
//             },
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: deepPink,
//                   child: Text('J', style: TextStyle(color: Colors.white)),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'John Doe',
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                       Text(
//                         'Admin',
//                         style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   _isProfileMenuOpen ? Icons.expand_less : Icons.expand_more,
//                   color: deepPink,
//                 ),
//               ],
//             ),
//           ),
//           if (_isProfileMenuOpen)
//             Container(
//               margin: const EdgeInsets.only(top: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.withOpacity(0.2)),
//               ),
//               child: Column(
//                 children: [
//                   _buildProfileMenuItem(
//                     Icons.person_outline,
//                     'Profile',
//                     onTap: () {
//                       setState(() => _isProfileMenuOpen = false);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const UserprofilePage(),
//                         ),
//                       );
//                     },
//                   ),
//                   _buildProfileMenuItem(
//                     Icons.settings_outlined,
//                     'Settings',
//                     onTap: () {
//                       setState(() => _isProfileMenuOpen = false);
//                     },
//                   ),
//                   _buildProfileMenuItem(
//                     Icons.help_outline,
//                     'Help & Support',
//                     onTap: () {
//                       setState(() => _isProfileMenuOpen = false);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => HelpPage()),
//                       );
//                     },
//                   ),
//                   _buildProfileMenuItem(
//                     Icons.logout,
//                     'Logout',
//                     isLogout: true,
//                     onTap: () async {
//                       setState(() => _isProfileMenuOpen = false);
//                       await _handleLogout();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileMenuItem(
//     IconData icon,
//     String title, {
//     bool isLogout = false,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListTile(
//         dense: true,
//         leading: Icon(
//           icon,
//           size: 20,
//           color: isLogout ? Colors.red : Colors.black87,
//         ),
//         title: Text(
//           title,
//           style: GoogleFonts.poppins(
//             fontSize: 13,
//             color: isLogout ? Colors.red : Colors.black87,
//           ),
//         ),
//         onTap: onTap,
//       ),
//     );
//   }

//   Future<void> _handleLogout() async {
//     try {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return const Center(child: CircularProgressIndicator());
//         },
//       );

//       await _authService.logout();

//       if (mounted) {
//         Navigator.of(context).pop();
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Berhasil logout'),
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }

//       if (mounted) {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginPage()),
//           (route) => false,
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         Navigator.of(context).pop();

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Gagal logout: ${e.toString()}'),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 2),
//           ),
//         );

//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginPage()),
//           (route) => false,
//         );
//       }
//     }
//   }

//   String getNoDirect(dynamic item) {
//     return item['no_direct'] ??
//         item['no_direct_purchase'] ??
//         item['noDirect'] ??
//         item['noDirectPurchase'] ??
//         item['direct_number'] ??
//         '-';
//   }

//   String getDate(dynamic item) {
//     String? rawDate =
//         item['directPurchaseDate'] ??
//         item['date'] ??
//         item['tanggal'] ??
//         item['purchase_date'] ??
//         item['created_at'] ??
//         item['createdAt'];
//     if (rawDate == null) return '-';
//     try {
//       DateTime dt = DateTime.parse(rawDate);
//       return DateFormat('dd/MM/yyyy').format(dt);
//     } catch (e) {
//       return rawDate;
//     }
//   }

//   Widget _modernHeaderIcon({
//     required IconData icon,
//     required VoidCallback onTap,
//     bool badge = false,
//     bool isMobile = false,
//     Color? color,
//     bool glass = false,
//     double? iconSize,
//   }) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: Duration(milliseconds: 180),
//           curve: Curves.easeInOut,
//           padding: EdgeInsets.all(isMobile ? 8 : 12),
//           decoration: BoxDecoration(
//             color: glass
//                 ? Colors.white.withOpacity(0.35)
//                 : (color?.withOpacity(0.13) ?? Colors.white.withOpacity(0.13)),
//             borderRadius: BorderRadius.circular(16),
//             border: glass
//                 ? Border.all(color: Colors.white.withOpacity(0.32), width: 1.1)
//                 : Border.all(color: (color ?? Colors.white).withOpacity(0.22)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.08),
//                 blurRadius: 8,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Stack(
//             clipBehavior: Clip.none,
//             children: [
//               Icon(
//                 icon,
//                 color: Colors.white,
//                 size: iconSize ?? (isMobile ? 24 : 28),
//               ),
//               if (badge)
//                 Positioned(
//                   right: -2,
//                   top: -2,
//                   child: Container(
//                     width: 12,
//                     height: 12,
//                     decoration: BoxDecoration(
//                       color: color ?? Colors.pinkAccent,
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 1),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _modernHeaderIconBarNoSearch(bool isMobile) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(32),
//         border: Border.all(color: Colors.white.withOpacity(0.22), width: 1),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(
//             key: _emailIconKey,
//             child: _modernHeaderIcon(
//               icon: Icons.mail_outline_rounded,
//               onTap: _toggleEmailOverlay,
//               badge: emails.isNotEmpty,
//               isMobile: isMobile,
//               glass: true,
//               iconSize: isMobile ? 24 : 28,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(width: isMobile ? 8 : 14),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const UserprofilePage(),
//                 ),
//               );
//             },
//             child: AnimatedContainer(
//               duration: Duration(milliseconds: 180),
//               curve: Curves.easeInOut,
//               padding: EdgeInsets.all(isMobile ? 8 : 12),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.35),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: Colors.white.withOpacity(0.32),
//                   width: 1.1,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.08),
//                     blurRadius: 8,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: ClipOval(
//                 child: Image.asset(
//                   'assets/images/avatar.jpg',
//                   fit: BoxFit.cover,
//                   width: isMobile ? 24 : 28,
//                   height: isMobile ? 24 : 28,
//                   errorBuilder: (context, error, stackTrace) => Icon(
//                     Icons.person,
//                     color: Colors.grey[500],
//                     size: isMobile ? 24 : 28,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- Email Overlay Logic ---
//   void _toggleEmailOverlay() {
//     if (!mounted) return;
//     if (_emailAnimationController.isAnimating) return;
//     if (_emailOverlayEntry == null) {
//       _showEmailBubble();
//     } else {
//       _removeEmailOverlay();
//     }
//   }

//   void _removeEmailOverlay() {
//     if (!mounted) return;
//     if (_emailOverlayEntry != null) {
//       _emailAnimationController.reverse().then((_) {
//         if (_emailOverlayEntry != null && _emailOverlayEntry!.mounted) {
//           _emailOverlayEntry!.remove();
//           _emailOverlayEntry = null;
//         }
//         _emailAnimationController.reset(); // reset controller setelah reverse
//       });
//     }
//   }

//   void _showEmailBubble() {
//     if (!mounted) return;
//     if (_emailOverlayEntry != null) return; // cegah overlay ganda
//     final RenderBox renderBox =
//         _emailIconKey.currentContext!.findRenderObject() as RenderBox;
//     final size = renderBox.size;
//     final position = renderBox.localToGlobal(Offset.zero);

//     _emailOverlayEntry = OverlayEntry(
//       builder: (context) => _buildEmailTooltipAnimated(position, size),
//     );

//     Overlay.of(context).insert(_emailOverlayEntry!);
//     _emailAnimationController.forward();
//   }

//   Widget _buildEmailTooltipAnimated(Offset position, Size size) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     bool isMobile = screenWidth < 600;
//     final double popupWidth = isMobile ? screenWidth * 0.85 : 260;
//     double left = position.dx + size.width / 2 - popupWidth / 2;
//     if (left < 8) left = 8;
//     if (left + popupWidth > screenWidth - 8)
//       left = screenWidth - popupWidth - 8;
//     double arrowWidth = 22;
//     double arrowOffset =
//         (position.dx + size.width / 2) - left - (arrowWidth / 2) - 75;
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: GestureDetector(
//             onTap: _removeEmailOverlay,
//             behavior: HitTestBehavior.opaque,
//             child: Container(color: Colors.transparent),
//           ),
//         ),
//         Positioned(
//           top: position.dy + size.height + 10,
//           left: left,
//           child: AnimatedBuilder(
//             animation: _emailAnimationController,
//             builder: (context, child) {
//               return FadeTransition(
//                 opacity: _emailAnimationController,
//                 child: ScaleTransition(
//                   scale: Tween<double>(begin: 0.92, end: 1.0).animate(
//                     CurvedAnimation(
//                       parent: _emailAnimationController,
//                       curve: Curves.easeOutBack,
//                     ),
//                   ),
//                   alignment: Alignment.topCenter,
//                   child: child,
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmailTooltipContent() {
//     double screenWidth = MediaQuery.of(context).size.width;
//     bool isMobile = screenWidth < 600;
//     final List<Map<String, dynamic>> previewEmails = emails.take(3).toList();
//     return Material(
//       type: MaterialType.transparency,
//       elevation: 0,
//       child: Container(
//         width: isMobile ? screenWidth * 0.85 : 260,
//         constraints: BoxConstraints(maxHeight: isMobile ? 220 : 180),
//         padding: const EdgeInsets.only(top: 10, bottom: 6),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
//               child: Text(
//                 'Email',
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 2),
//             if (previewEmails.isEmpty)
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 18,
//                   vertical: 16,
//                 ),
//                 child: Text(
//                   'Tidak ada email baru.',
//                   style: GoogleFonts.poppins(
//                     fontSize: 13,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               )
//             else
//               Flexible(
//                 child: ListView.separated(
//                   shrinkWrap: true,
//                   padding: const EdgeInsets.symmetric(vertical: 2),
//                   itemCount: previewEmails.length,
//                   separatorBuilder: (_, __) =>
//                       Divider(height: 1, color: Colors.grey.shade100),
//                   itemBuilder: (context, i) =>
//                       _buildEmailBubbleItem(previewEmails[i]),
//                 ),
//               ),
//             const SizedBox(height: 2),
//             InkWell(
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//               onTap: () {
//                 _removeEmailOverlay();
//                 Future.delayed(const Duration(milliseconds: 100), () {
//                   // Navigasi ke halaman email jika ada
//                 });
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 alignment: Alignment.center,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.mail_outline_rounded, color: deepPink, size: 18),
//                     SizedBox(width: 8),
//                     Text(
//                       'Lihat Semua Email',
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.bold,
//                         color: deepPink,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmailBubbleItem(Map<String, dynamic> email) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(
//             backgroundColor: deepPink.withOpacity(0.13),
//             child: Icon(Icons.mail_outline_rounded, color: deepPink, size: 16),
//             radius: 13,
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   email['subject'],
//                   style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 13,
//                     color: deepPink,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 1),
//                 Text(
//                   email['snippet'],
//                   style: GoogleFonts.poppins(
//                     fontSize: 11.5,
//                     color: Colors.grey[800],
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   email['time'],
//                   style: GoogleFonts.poppins(
//                     fontSize: 10,
//                     color: Colors.grey[400],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Tambahkan widget badge status di dalam State agar bisa akses context/state
//   Widget _buildStatusBadge({
//     required IconData icon,
//     required String label,
//     required int count,
//     required Color color,
//   }) {
//     final bool isActive =
//         (color == Colors.orange && _tabIndex == 0) ||
//         (color == Colors.green && _tabIndex == 1) ||
//         (color == Colors.red && _tabIndex == 2);
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 220),
//       curve: Curves.easeInOut,
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: isActive ? color.withOpacity(0.18) : color.withOpacity(0.10),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: isActive ? color : color.withOpacity(0.18),
//           width: isActive ? 2.2 : 1.2,
//         ),
//         boxShadow: isActive
//             ? [
//                 BoxShadow(
//                   color: color.withOpacity(0.18),
//                   blurRadius: 8,
//                   offset: Offset(0, 2),
//                 ),
//               ]
//             : [],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: color, size: isActive ? 20 : 16),
//           SizedBox(width: 7),
//           Text(
//             '$count $label',
//             style: GoogleFonts.poppins(
//               fontSize: isActive ? 15 : 13,
//               color: color,
//               fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
//               letterSpacing: 0.2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Filter data sesuai tab
//   List<dynamic> _filteredPurchases() {
//     if (_tabIndex == 1) {
//       return _directPurchases.where((item) => (item['status'] ?? '').toLowerCase().contains('approved')).toList();
//     } else if (_tabIndex == 2) {
//       return _directPurchases.where((item) => (item['status'] ?? '').toLowerCase().contains('rejected')).toList();
//     } else {
//       // Outstanding
//       return _directPurchases.where((item) {
//         final status = (item['status'] ?? '').toLowerCase();
//         return !status.contains('approved') && !status.contains('rejected');
//       }).toList();
//     }
//   }
// }







// class _InfoRowIcon extends StatelessWidget {
//   final IconData icon;
//   final Color iconBg;
//   final String label;
//   final String value;
//   const _InfoRowIcon({
//     required this.icon,
//     required this.iconBg,
//     required this.label,
//     required this.value,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(6),
//           decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
//           child: Icon(icon, color: Colors.white, size: 16),
//         ),
//         const SizedBox(width: 10),
//         Text(
//           label + ':',
//           style: GoogleFonts.poppins(
//             fontSize: 12,
//             color: Colors.black87,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(width: 6),
//         Flexible(
//           child: Text(
//             value,
//             style: GoogleFonts.poppins(
//               fontSize: 13,
//               color: Colors.black87,
//               fontWeight: FontWeight.w600,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _InfoRowIconModern extends StatelessWidget {
//   final IconData icon;
//   final Color iconBg;
//   final String label;
//   final String value;
//   const _InfoRowIconModern({
//     required this.icon,
//     required this.iconBg,
//     required this.label,
//     required this.value,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: iconBg,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(color: iconBg.withOpacity(0.18), blurRadius: 6),
//             ],
//           ),
//           child: Icon(icon, color: Colors.white, size: 20),
//         ),
//         const SizedBox(width: 16),
//         Text(
//           label + ':',
//           style: GoogleFonts.orbitron(
//             fontSize: 13,
//             color: Colors.black87,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 1.1,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Flexible(
//           child: Text(
//             value,
//             style: GoogleFonts.orbitron(
//               fontSize: 15,
//               color: Colors.black87,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 1.1,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _InfoValueRow extends StatelessWidget {
//   final IconData icon;
//   final Color iconBg;
//   final String value;
//   const _InfoValueRow({
//     required this.icon,
//     required this.iconBg,
//     required this.value,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(6),
//           decoration: BoxDecoration(
//             color: iconBg,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(color: iconBg.withOpacity(0.13), blurRadius: 3),
//             ],
//           ),
//           child: Icon(icon, color: Colors.white, size: 15),
//         ),
//         const SizedBox(width: 10),
//         Flexible(
//           child: Text(
//             value,
//             style: GoogleFonts.orbitron(
//               fontSize: 13,
//               color: Colors.black87,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 1.05,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
// }
