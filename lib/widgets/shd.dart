// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:miniproject_flutter/screens/Dashboard_Resouce/Purchasing/GRPO_Page.dart';
// import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/MaterialCalculate_Page.dart';
// import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/StockOpname_Page.dart';
// import 'Dashboard_Resouce/Purchasing/DirectPurchase_Page.dart';
// import 'Dashboard_Resouce/Stock_Management/TransferStock_Page.dart';
// import 'Dashboard_Resouce/Stock_Management/MaterialRequest_Page.dart';
// import 'Dashboard_Resouce/Auth/UserProfile_Page.dart';
// import 'Dashboard_Resouce/Stock_Management/Waste_Page.dart';
// import 'Dashboard_Resouce/Auth/Help_Page.dart';
// import 'Dashboard_Resouce/Auth/Notification_Page.dart';
// import 'Dashboard_Resouce/Auth/Email_Page.dart';
// import 'package:miniproject_flutter/services/authService.dart';
// import 'package:miniproject_flutter/screens/Dashboard_Resouce/Auth/LoginPage.dart';

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({super.key});

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage>
//     with SingleTickerProviderStateMixin {
//   int _selectedIndex = 0;
//   bool _isSidebarExpanded = true;
//   bool _isProfileMenuOpen = false;
//   bool _isStoreMenuOpen = false;
//   int? _expandedMenuIndex; // Untuk menyimpan index menu yang sedang terbuka

//   int _selectedOpenItemTab = 0; // 0: PO, 1: Direct Purchase, 2: Transfer Out

//   final Color primaryColor = const Color(0xFFF8BBD0);
//   // final Color accentColor = const Color.fromARGB(255, 233, 30, 99);
//   final Color deepPink = const Color.fromARGB(255, 233, 30, 99);
//   final Color lightPink = const Color(0xFFFCE4EC);

//   // Konstanta untuk menu index
//   static const int PURCHASING_MENU = 1;
//   static const int STOCK_MANAGEMENT_MENU = 2;

//   final AuthService _authService = AuthService();

//   // Dummy data untuk masing-masing tab
//   final List<List<DataRow>> _openItemRows = [
//     // PO
//     [
//       DataRow(
//         cells: [
//           DataCell(Text('PO-2024-0125')),
//           DataCell(Text('15/03/2024')),
//           DataCell(Text('PT Kurnia Alam')),
//           DataCell(Text('Open', style: TextStyle(color: Colors.green))),
//           DataCell(
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color.fromARGB(255, 233, 30, 99),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 elevation: 0,
//               ),
//               child: Text('Detail'),
//             ),
//           ),
//         ],
//       ),
//     ],
//     // Direct Purchase
//     [
//       DataRow(
//         cells: [
//           DataCell(Text('DP-2024-0001')),
//           DataCell(Text('16/03/2024')),
//           DataCell(Text('PT Direct Sukses')),
//           DataCell(Text('Open', style: TextStyle(color: Colors.green))),
//           DataCell(
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color.fromARGB(255, 233, 30, 99),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 elevation: 0,
//               ),
//               child: Text('Detail'),
//             ),
//           ),
//         ],
//       ),
//     ],
//     // Transfer Out
//     [
//       DataRow(
//         cells: [
//           DataCell(Text('TO-2024-0002')),
//           DataCell(Text('17/03/2024')),
//           DataCell(Text('PT Transfer Jaya')),
//           DataCell(Text('Open', style: TextStyle(color: Colors.green))),
//           DataCell(
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color.fromARGB(255, 233, 30, 99),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 elevation: 0,
//               ),
//               child: Text('Detail'),
//             ),
//           ),
//         ],
//       ),
//     ],
//   ];

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   void _toggleMenu(int menuIndex) {
//     setState(() {
//       if (_expandedMenuIndex == menuIndex) {
//         // Jika menu yang sama diklik, tutup menu
//         _expandedMenuIndex = null;
//       } else {
//         // Buka menu yang baru diklik
//         _expandedMenuIndex = menuIndex;
//       }
//     });
//   }

//   Future<void> _handleLogout() async {
//     try {
//       // Tampilkan loading dialog
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return const Center(child: CircularProgressIndicator());
//         },
//       );

//       // Panggil API logout
//       await _authService.logout();

//       // Tutup loading dialog
//       if (mounted) {
//         Navigator.of(context).pop();
//       }

//       // Tampilkan snackbar sukses
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Berhasil logout'),
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }

//       // Navigate ke halaman login dan hapus semua route sebelumnya
//       if (mounted) {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginPage()),
//           (route) => false,
//         );
//       }
//     } catch (e) {
//       // Handle error
//       if (mounted) {
//         // Tutup loading dialog jika masih terbuka
//         Navigator.of(context).pop();

//         // Tampilkan pesan error
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Gagal logout: ${e.toString()}'),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 2),
//           ),
//         );

//         // Tetap arahkan ke halaman login meskipun terjadi error
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginPage()),
//           (route) => false,
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     bool isMobile = screenWidth < 600;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6),
//       drawer: isMobile
//           ? Drawer(
//               child: _buildSidebarContent(
//                 isMobile: true,
//                 closeDrawer: () => Navigator.pop(context),
//               ),
//             )
//           : null,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // Main Content
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: isMobile
//                   ? EdgeInsets.zero
//                   : EdgeInsets.only(left: _isSidebarExpanded ? 250 : 70),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     _buildHeader(screenWidth, isMobile),
//                     const SizedBox(height: 10),
//                     Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Divider(
//                         color: Colors.grey.withOpacity(0.13),
//                         thickness: 1.2,
//                         height: 0,
//                       ),
//                     ),
//                     const SizedBox(height: 18),
//                     // Search bar di luar header
//                     Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 20),
//                       child: _buildSearchBar(),
//                     ),
//                     const SizedBox(height: 24),
//                     _buildTaskSection(),
//                     const SizedBox(height: 16),
//                     _buildOutstandingCards(),
//                     const SizedBox(height: 16),
//                     _buildOpenItemList(),
//                     const SizedBox(height: 12),
//                   ],
//                 ),
//               ),
//             ),
//             // Sidebar (hanya tampil di desktop/tablet)
//             if (!isMobile)
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 width: _isSidebarExpanded ? 250 : 70,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: const Offset(0, 0),
//                     ),
//                   ],
//                 ),
//                 child: _buildSidebarContent(isMobile: false),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSidebarContent({
//     bool isMobile = false,
//     VoidCallback? closeDrawer,
//   }) {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           // Logo dan nama aplikasi
//           Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: isMobile ? 16 : 20,
//               vertical: 24,
//             ),
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   color: Colors.grey.withOpacity(0.1),
//                   width: 1,
//                 ),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Image.asset(
//                   'assets/images/icons-haus.png',
//                   height: 36,
//                   width: 36,
//                 ),
//                 if (_isSidebarExpanded || isMobile) const SizedBox(width: 12),
//                 if (_isSidebarExpanded || isMobile)
//                   Text(
//                     'haus! Inventory',
//                     style: GoogleFonts.poppins(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: deepPink,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           // Info toko dengan dropdown
//           if (_isSidebarExpanded || isMobile) _buildStoreDropdown(),

//           // Menu Items dengan Expanded
//           Expanded(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   // Section GENERAL
//                   if (_isSidebarExpanded || isMobile)
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
//                       child: Row(
//                         children: [
//                           Text(
//                             'GENERAL',
//                             style: GoogleFonts.poppins(
//                               fontSize: 12,
//                               color: Colors.black54,
//                               letterSpacing: 1,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const Spacer(),
//                           Container(
//                             height: 1,
//                             width: 100,
//                             color: Colors.grey.withOpacity(0.2),
//                           ),
//                         ],
//                       ),
//                     ),
//                   _buildMenuItem(
//                     icon: Icons.dashboard_outlined,
//                     title: 'Dashboard',
//                     isSelected: _selectedIndex == 0,
//                     onTap: () {
//                       setState(() => _selectedIndex = 0);
//                       if (isMobile && closeDrawer != null) closeDrawer();
//                     },
//                   ),
//                   _buildExpandableMenu(
//                     icon: Icons.shopping_cart_outlined,
//                     title: 'Purchasing',
//                     isExpanded: _selectedIndex == PURCHASING_MENU,
//                     menuIndex: PURCHASING_MENU,
//                     children: [
//                       _buildSubMenuItem('Direct Purchase', 11),
//                       _buildSubMenuItem('GRPO', 12),
//                     ],
//                     onTap: () {
//                       setState(() => _selectedIndex = PURCHASING_MENU);
//                     },
//                     isMobile: isMobile,
//                   ),
//                   _buildExpandableMenu(
//                     icon: Icons.inventory_2_outlined,
//                     title: 'Stock Management',
//                     isExpanded: _selectedIndex == STOCK_MANAGEMENT_MENU,
//                     menuIndex: STOCK_MANAGEMENT_MENU,
//                     children: [
//                       _buildSubMenuItem('Material Request', 21),
//                       _buildSubMenuItem('Material Calculate', 25),
//                       _buildSubMenuItem('Stock Opname', 22),
//                       _buildSubMenuItem('Transfer Stock', 23),
//                       _buildSubMenuItem('Waste', 24),
//                     ],
//                     onTap: () {
//                       setState(() => _selectedIndex = STOCK_MANAGEMENT_MENU);
//                     },
//                     isMobile: isMobile,
//                   ),
//                   _buildMenuItem(
//                     icon: Icons.assessment_outlined,
//                     title: 'Inventory Report',
//                     isSelected: _selectedIndex == 3,
//                     onTap: () {
//                       setState(() => _selectedIndex = 3);
//                       if (isMobile && closeDrawer != null) closeDrawer();
//                     },
//                   ),
//                   // Section TOOLS
//                   if (_isSidebarExpanded || isMobile)
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
//                       child: Row(
//                         children: [
//                           Text(
//                             'TOOLS',
//                             style: GoogleFonts.poppins(
//                               fontSize: 12,
//                               color: Colors.black54,
//                               letterSpacing: 1,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const Spacer(),
//                           Container(
//                             height: 1,
//                             width: 100,
//                             color: Colors.grey.withOpacity(0.2),
//                           ),
//                         ],
//                       ),
//                     ),
//                   _buildMenuItem(
//                     icon: Icons.settings_outlined,
//                     title: 'Account & Settings',
//                     isSelected: _selectedIndex == 4,
//                     onTap: () {
//                       setState(() => _selectedIndex = 4);
//                       if (isMobile && closeDrawer != null) closeDrawer();
//                     },
//                   ),
//                   _buildMenuItem(
//                     icon: Icons.help_outline,
//                     title: 'Help',
//                     isSelected: _selectedIndex == 5,
//                     onTap: () {
//                       setState(() => _selectedIndex = 5);
//                       if (isMobile && closeDrawer != null) closeDrawer();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // User profile dengan dropdown (selalu di bawah)
//           if (_isSidebarExpanded || isMobile) _buildProfileDropdown(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuItem({
//     required IconData icon,
//     required String title,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: isSelected ? lightPink.withOpacity(0.3) : Colors.transparent,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListTile(
//         leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: isSelected
//                 ? deepPink.withOpacity(0.1)
//                 : Colors.grey.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(
//             icon,
//             color: isSelected ? deepPink : Colors.grey,
//             size: 20,
//           ),
//         ),
//         title: Text(
//           title,
//           style: GoogleFonts.poppins(
//             color: isSelected ? deepPink : Colors.grey,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             fontSize: 14,
//           ),
//         ),
//         selected: isSelected,
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
//     bool isMobile = false,
//   }) {
//     final isMenuExpanded = _expandedMenuIndex == menuIndex;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           decoration: BoxDecoration(
//             color: isExpanded ? lightPink.withOpacity(0.3) : Colors.transparent,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: ListTile(
//             leading: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isExpanded
//                     ? deepPink.withOpacity(0.1)
//                     : Colors.grey.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 icon,
//                 color: isExpanded ? deepPink : Colors.grey,
//                 size: 20,
//               ),
//             ),
//             title: Text(
//               title,
//               style: GoogleFonts.poppins(
//                 color: isExpanded ? deepPink : Colors.grey,
//                 fontWeight: isExpanded ? FontWeight.bold : FontWeight.normal,
//                 fontSize: 14,
//               ),
//             ),
//             trailing: Icon(
//               isMenuExpanded ? Icons.expand_less : Icons.expand_more,
//               color: isExpanded ? deepPink : Colors.grey,
//             ),
//             onTap: () {
//               _toggleMenu(menuIndex);
//               onTap();
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
//         if (isMenuExpanded && (_isSidebarExpanded || isMobile))
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

//   Widget _buildSubMenuItem(String title, int index) {
//     return Container(
//       margin: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
//       decoration: BoxDecoration(
//         color: _selectedIndex == index
//             ? lightPink.withOpacity(0.3)
//             : Colors.transparent,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListTile(
//         leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: _selectedIndex == index
//                 ? deepPink.withOpacity(0.1)
//                 : Colors.grey.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(
//             _getSubMenuIcon(index),
//             color: _selectedIndex == index ? deepPink : Colors.grey,
//             size: 20,
//           ),
//         ),
//         title: Text(
//           title,
//           style: GoogleFonts.poppins(
//             fontSize: 13,
//             color: _selectedIndex == index ? deepPink : Colors.black87,
//             fontWeight: _selectedIndex == index
//                 ? FontWeight.bold
//                 : FontWeight.normal,
//           ),
//         ),
//         selected: _selectedIndex == index,
//         onTap: () {
//           setState(() => _selectedIndex = index);
//           _navigateToPage(index);
//         },
//         dense: true,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       ),
//     );
//   }

//   void _navigateToPage(int index) {
//     switch (index) {
//       case 11: // Direct Purchase
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => DirectPurchasePage()),
//         );
//         break;
//       case 12: // GRPO
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => GRPO_Page()),
//         );
//         break;
//       case 21: // Material Request
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => MaterialRequestPage()),
//         );
//         break;
//       case 22: // Stock Opname
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => StockOpnamePage()),
//         );
//         break;
//       case 23: // Transfer Stock
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => TransferStockPage()),
//         );
//         break;
//       case 24: // Waste
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => WastePage()),
//         );
//         break;
//       case 25: // Material Calculate
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => MaterialCalculatePage()),
//         );
//     }
//   }

//   IconData _getSubMenuIcon(int index) {
//     switch (index) {
//       case 11: // Direct Purchase
//         return Icons.shopping_cart_outlined;
//       case 12: // GRPO
//         return Icons.receipt_long_outlined;
//       case 21: // Material Request
//         return Icons.inventory_2_outlined;
//       case 22: // Stock Opname
//         return Icons.checklist_rtl_outlined;
//       case 23: // Transfer Stock
//         return Icons.swap_horiz_outlined;
//       case 24: // Waste
//         return Icons.delete_outline;
//       case 25: //material calculate
//         return Icons.inventory_2_outlined;
//       default:
//         return Icons.circle_outlined;
//     }
//   }

//   Widget _buildHeader(double screenWidth, [bool isMobile = false]) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(
//         10,
//         isMobile ? 5 : 10,
//         20,
//         isMobile ? 5 : 10,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 16,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           const SizedBox(height: 4),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   if (isMobile)
//                     Builder(
//                       builder: (context) => IconButton(
//                         icon: Icon(Icons.menu, color: Colors.black),
//                         onPressed: () {
//                           Scaffold.of(context).openDrawer();
//                         },
//                       ),
//                     ),
//                   Text(
//                     'Dashboard',
//                     style: GoogleFonts.poppins(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 22,
//                       color: deepPink,
//                     ),
//                   ),
//                 ],
//               ),
//               _buildProfileIcons(),
//             ],
//           ),
//           const SizedBox(height: 4),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileIcons() {
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => NotificationPage()),
//             );
//           },
//           child: const Icon(Icons.notifications, color: Colors.black),
//         ),
//         const SizedBox(width: 12),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => EmailPage()),
//             );
//           },
//           child: const Icon(Icons.mail_outline, color: Colors.black),
//         ),
//         const SizedBox(width: 12),
//         GestureDetector(
//           onTap: () {
//             _showProfileMenu(context);
//           },
//           child: const CircleAvatar(
//             backgroundImage: AssetImage('assets/images/avatar.jpg'),
//             radius: 15,
//           ),
//         ),
//       ],
//     );
//   }

//   void _showProfileMenu(BuildContext context) {
//     final RenderBox button = context.findRenderObject() as RenderBox;
//     final RenderBox overlay =
//         Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
//     final RelativeRect position = RelativeRect.fromRect(
//       Rect.fromPoints(
//         button.localToGlobal(Offset.zero, ancestor: overlay),
//         button.localToGlobal(
//           button.size.bottomRight(Offset.zero),
//           ancestor: overlay,
//         ),
//       ),
//       Offset.zero & overlay.size,
//     );

//     showMenu(
//       context: context,
//       position: position,
//       color: Colors.white,
//       elevation: 8,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       items: [
//         PopupMenuItem(
//           height: 40,
//           child: _buildProfileMenuItem(
//             Icons.person_outline,
//             'Profile',
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const UserprofilePage(),
//                 ),
//               );
//             },
//           ),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const UserprofilePage()),
//             );
//           },
//         ),
//         PopupMenuItem(
//           height: 40,
//           child: _buildProfileMenuItem(
//             Icons.settings_outlined,
//             'Settings',
//             onTap: () {
//               // Handle settings
//             },
//           ),
//           onTap: () {
//             // Handle settings
//           },
//         ),
//         PopupMenuItem(
//           height: 40,
//           child: _buildProfileMenuItem(
//             Icons.help_outline,
//             'Help & Support',
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => HelpPage()),
//               );
//             },
//           ),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => HelpPage()),
//             );
//           },
//         ),
//         PopupMenuItem(
//           height: 40,
//           child: _buildProfileMenuItem(
//             Icons.logout,
//             'Logout',
//             isLogout: true,
//             onTap: () async {
//               await _handleLogout();
//             },
//           ),
//           onTap: () async {
//             await _handleLogout();
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildSearchBar() {
//     return Material(
//       elevation: 2,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.07),
//               blurRadius: 16,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: TextField(
//           style: GoogleFonts.poppins(fontSize: 16),
//           decoration: InputDecoration(
//             contentPadding: const EdgeInsets.symmetric(
//               vertical: 18,
//               horizontal: 0,
//             ),
//             prefixIcon: Icon(Icons.search, color: deepPink, size: 26),
//             hintText: 'Search transactions',
//             hintStyle: GoogleFonts.poppins(
//               fontSize: 16,
//               color: Colors.black38,
//               fontWeight: FontWeight.w500,
//             ),
//             filled: true,
//             fillColor: Colors.white,
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: BorderSide(color: deepPink, width: 2.2),
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _actionButton(IconData icon, String label) {
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: primaryColor,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           padding: const EdgeInsets.all(12),
//           child: Icon(icon, color: deepPink, size: 28),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
//         ),
//       ],
//     );
//   }

//   Widget _buildTaskSection() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 12,
//             offset: Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Tasks",
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                   color: Colors.black87,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   // Handle "Show All" press
//                 },
//                 child: Row(
//                   children: [
//                     Text(
//                       "Show All",
//                       style: GoogleFonts.poppins(
//                         fontSize: 12,
//                         color: Colors.black54,
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     Icon(
//                       Icons.arrow_outward_rounded,
//                       size: 14,
//                       color: const Color.fromARGB(246, 0, 0, 0),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           _buildTaskCard(
//             "Stock Opname has not been performed",
//             "12/03/2025 09:42",
//             "High Priority",
//             "Needs Attention",
//           ),
//           const SizedBox(height: 8),
//           _buildTaskCard(
//             "PO-2024-0125 awaiting acceptance from PTK",
//             "12/03/2025 09:42",
//             "Medium Priority",
//             "Waiting for Action",
//           ),
//           const SizedBox(height: 8),
//           _buildTaskCard(
//             "PO-2025-0222 awaiting acceptance from PTK",
//             "12/03/2025 09:42",
//             "High Priority",
//             "Needs Attention",
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTaskCard(
//     String taskTitle,
//     String date,
//     String priority,
//     String status,
//   ) {
//     Color priorityColor;
//     IconData priorityIcon;
//     Color statusColor;
//     String statusText;

//     if (priority == "High Priority") {
//       priorityColor = Colors.red;
//       priorityIcon = Icons.error;
//     } else if (priority == "Medium Priority") {
//       priorityColor = Colors.orange;
//       priorityIcon = Icons.warning;
//     } else {
//       priorityColor = Colors.green;
//       priorityIcon = Icons.check_circle;
//     }

//     if (status == "Needs Attention") {
//       statusColor = Colors.red;
//       statusText = "Needs Attention";
//     } else if (status == "Waiting for Action") {
//       statusColor = Colors.orange;
//       statusText = "Waiting for Action";
//     } else {
//       statusColor = Colors.green;
//       statusText = "Resolved";
//     }

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 0),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 8,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Icon(priorityIcon, color: priorityColor, size: 30),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         taskTitle,
//                         style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         date,
//                         style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: statusColor.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         statusText,
//                         style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: statusColor,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     IconButton(
//                       icon: Icon(Icons.chevron_right, color: Colors.grey),
//                       onPressed: () {
//                         // Handle task click (navigate or show details)
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 6),
//             Divider(color: Colors.grey.withOpacity(0.18), thickness: 1),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOutstandingCards() {
//     final List<Map<String, dynamic>> items = [
//       {'title': 'Outstanding PO', 'count': '3'},
//       {'title': 'Outstanding Direct Purchase', 'count': '5'},
//       {'title': 'Outstanding Transfer Out', 'count': '8'},
//     ];

//     double screenWidth = MediaQuery.of(context).size.width;
//     bool isMobile = screenWidth < 600;

//     if (isMobile) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         child: Column(
//           children: items.map((item) {
//             return Container(
//               margin: const EdgeInsets.only(bottom: 10),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 8,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 24,
//                   horizontal: 16,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       item['count'],
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 32,
//                         color: deepPink,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       item['title'],
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       );
//     } else {
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: items.map((item) {
//             return Expanded(
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 10),
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 28,
//                   horizontal: 16,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 8,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       item['count'],
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 32,
//                         color: deepPink,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       item['title'],
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15,
//                         color: Colors.black87,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       );
//     }
//   }

//   Widget _buildOpenItemList() {
//     double screenWidth = MediaQuery.of(context).size.width;
//     bool isMobile = screenWidth < 600;

//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: EdgeInsets.symmetric(
//         vertical: isMobile ? 14 : 24,
//         horizontal: 20,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 12,
//             offset: Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Open Item List",
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.bold,
//                   fontSize: isMobile ? 18 : screenWidth * 0.045,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {},
//                 child: Row(
//                   children: [
//                     Icon(Icons.filter_list, size: 16, color: Colors.black54),
//                     const SizedBox(width: 4),
//                     Text(
//                       "Filter",
//                       style: GoogleFonts.poppins(
//                         fontSize: 12,
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
//             child: _buildTaskBar(),
//           ),
//           const SizedBox(height: 10),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minWidth: screenWidth - (isMobile ? 24 : 64),
//               ),
//               child: DataTable(
//                 headingRowHeight: 50,
//                 columns: [
//                   DataColumn(
//                     label: SizedBox(
//                       width: 100,
//                       child: Text(
//                         'PO Number',
//                         style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: SizedBox(
//                       width: 80,
//                       child: Text(
//                         'Date',
//                         style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: SizedBox(
//                       width: 120,
//                       child: Text(
//                         'Supplier',
//                         style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: SizedBox(
//                       width: 70,
//                       child: Text(
//                         'Status',
//                         style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: SizedBox(
//                       width: 70,
//                       child: Text(
//                         'Action',
//                         style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                 ],
//                 rows: _openItemRows[_selectedOpenItemTab],
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Page on',
//                 style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.chevron_left),
//                     splashRadius: 20,
//                     onPressed: () {},
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.black12),
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.06),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Text(
//                           '1',
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.bold,
//                             color: deepPink,
//                             fontSize: 14,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           '2',
//                           style: GoogleFonts.poppins(
//                             color: Colors.black54,
//                             fontSize: 14,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           '3',
//                           style: GoogleFonts.poppins(
//                             color: Colors.black54,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.chevron_right),
//                     splashRadius: 20,
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTaskBar() {
//     final tabLabels = ['PO', 'Direct Purchase', 'Transfer Out'];
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(tabLabels.length, (i) {
//           return Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _selectedOpenItemTab = i;
//                 });
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 8,
//                   horizontal: 16,
//                 ),
//                 decoration: BoxDecoration(
//                   color: _selectedOpenItemTab == i
//                       ? deepPink
//                       : Colors.transparent,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                     color: _selectedOpenItemTab == i
//                         ? deepPink
//                         : Colors.black12,
//                   ),
//                 ),
//                 child: Text(
//                   tabLabels[i],
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: _selectedOpenItemTab == i
//                         ? Colors.white
//                         : Colors.black54,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
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
//                       // Handle settings
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
// }
