// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:miniproject_flutter/screens/Dashboard_Resouce/Purchasing/GRPO_Page.dart';
// import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/MaterialCalculate_Page.dart';
// import 'package:miniproject_flutter/screens/Dashboard_Resouce/Stock_Management/StockOpname_Page.dart';
// import 'Dashboard_Resouce/Purchasing/DirectPurchase_Page.dart';
// import 'Dashboard_Resouce/Stock_Management/TransferStock_Page.dart';
// import 'Dashboard_Resouce/Stock_Management/MaterialRequest_Page.dart';
// import 'Dashboard_Resouce/Auth/UserProfile_Page.dart';
// import 'Dashboard_Resouce/Auth/Help_Page.dart';
// import 'package:miniproject_flutter/services/authService.dart';
// import 'package:miniproject_flutter/screens/Dashboard_Resouce/Auth/LoginPage.dart';

// class Sidebar extends StatefulWidget {
//   final bool isMobile;
//   final VoidCallback? closeDrawer;
//   final bool isSidebarExpanded;

//   const Sidebar({
//     Key? key,
//     this.isMobile = false,
//     this.closeDrawer,
//     this.isSidebarExpanded = true,
//   }) : super(key: key);

//   @override
//   State<Sidebar> createState() => _SidebarState();
// }

// class _SidebarState extends State<Sidebar> {
//   bool _isProfileMenuOpen = false;
//   bool _isStoreMenuOpen = false;
//   int? _expandedMenuIndex;
//   int _selectedIndex = 0;

//   final Color primaryColor = const Color(0xFFF8BBD0);
//   final Color deepPink = const Color.fromARGB(255, 233, 30, 99);
//   final Color lightPink = const Color(0xFFFCE4EC);

//   // Konstanta untuk menu index
//   static const int PURCHASING_MENU = 1;
//   static const int STOCK_MANAGEMENT_MENU = 2;

//   final AuthService _authService = AuthService();

//   void _toggleMenu(int menuIndex) {
//     setState(() {
//       if (_expandedMenuIndex == menuIndex) {
//         _expandedMenuIndex = null;
//       } else {
//         _expandedMenuIndex = menuIndex;
//       }
//     });
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

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: widget.isMobile ? 16 : 20,
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
//                 if (widget.isSidebarExpanded || widget.isMobile) const SizedBox(width: 12),
//                 if (widget.isSidebarExpanded || widget.isMobile)
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
//           if (widget.isSidebarExpanded || widget.isMobile) _buildStoreDropdown(),

//           Expanded(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   if (widget.isSidebarExpanded || widget.isMobile)
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
//                       if (widget.isMobile && widget.closeDrawer != null) widget.closeDrawer!();
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
//                     isMobile: widget.isMobile,
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
//                     isMobile: widget.isMobile,
//                   ),
//                   _buildMenuItem(
//                     icon: Icons.assessment_outlined,
//                     title: 'Inventory Report',
//                     isSelected: _selectedIndex == 3,
//                     onTap: () {
//                       setState(() => _selectedIndex = 3);
//                       if (widget.isMobile && widget.closeDrawer != null) widget.closeDrawer!();
//                     },
//                   ),
//                   if (widget.isSidebarExpanded || widget.isMobile)
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
//                       if (widget.isMobile && widget.closeDrawer != null) widget.closeDrawer!();
//                     },
//                   ),
//                   _buildMenuItem(
//                     icon: Icons.help_outline,
//                     title: 'Help',
//                     isSelected: _selectedIndex == 5,
//                     onTap: () {
//                       setState(() => _selectedIndex = 5);
//                       if (widget.isMobile && widget.closeDrawer != null) widget.closeDrawer!();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (widget.isSidebarExpanded || widget.isMobile) _buildProfileDropdown(),
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
//         if (isMenuExpanded && (widget.isSidebarExpanded || isMobile))
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
