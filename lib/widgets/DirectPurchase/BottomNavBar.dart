import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  static const Color primary = Color.fromARGB(255, 255, 0, 85);
  final int selectedIndex;
  final Function(int) onTap;
  final VoidCallback onAdd;
  const BottomNavBar({Key? key, required this.selectedIndex, required this.onTap, required this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double navBarHeight = 76;
    final double fabSize = 56;
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom:0 ),
      height: navBarHeight,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: Icons.home,
                label: 'Home',
                isActive: selectedIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavBarItem(
                icon: Icons.local_shipping,
                label: 'My Pickup',
                isActive: selectedIndex == 1,
                onTap: () => onTap(1),
              ),
              SizedBox(width: fabSize), // Space for FAB
              _NavBarItem(
                icon: Icons.search,
                label: 'Search',
                isActive: selectedIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavBarItem(
                icon: Icons.person,
                label: 'Profile',
                isActive: selectedIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
          // FAB di tengah, benar-benar setengah di dalam bar
          Align(
            alignment: Alignment.topCenter,
            child: Transform.translate(
              offset: Offset(0, -fabSize / 2),
              child: Container(
                width: fabSize,
                height: fabSize,
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.18),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 32),
                  onPressed: onAdd,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  static const Color primary = BottomNavBar.primary;
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _NavBarItem({Key? key, required this.icon, required this.label, required this.isActive, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? primary : Colors.white,
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? primary : Colors.white,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///
/// Contoh penggunaan di halaman utama:
///
/// Stack(
///   children: [
///     SingleChildScrollView(
///       child: ... // konten utama
///     ),
///     Positioned(
///       left: 0,
///       right: 0,
///       bottom: 0,
///       child: BottomNavBar(
///         selectedIndex: _selectedNavIndex,
///         onTap: (idx) {
///           setState(() {
///             _selectedNavIndex = idx;
///           });
///         },
///       ),
///     ),
///   ],
/// ) 