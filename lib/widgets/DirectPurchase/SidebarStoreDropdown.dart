import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SidebarStoreDropdown extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onTap;
  final List<String> storeList;
  final String selectedStore;
  final ValueChanged<String> onSelectStore;

  const SidebarStoreDropdown({
    Key? key,
    required this.isOpen,
    required this.onTap,
    required this.storeList,
    required this.selectedStore,
    required this.onSelectStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color deepPink = const Color.fromARGB(255, 255, 0, 85);
    final Color lightPink = const Color(0xFFFCE4EC);
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
          Row(
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
                      selectedStore,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: deepPink,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Icon(
                  isOpen ? Icons.expand_less : Icons.expand_more,
                  color: deepPink,
                ),
              ),
            ],
          ),
          AnimatedCrossFade(
            firstChild: SizedBox.shrink(),
            secondChild: Container(
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                children: storeList.map((store) => _buildStoreMenuItem(store, store == selectedStore, context)).toList(),
              ),
            ),
            crossFadeState: isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 220),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }

  Widget _buildStoreMenuItem(String storeName, bool isSelected, BuildContext context) {
    final Color deepPink = const Color.fromARGB(255, 255, 0, 85);
    final Color lightPink = const Color(0xFFFCE4EC);
    return Material(
      color: Colors.transparent,
      child: Container(
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
          onTap: () => onSelectStore(storeName),
        ),
      ),
    );
  }
} 