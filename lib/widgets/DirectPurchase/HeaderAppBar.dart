import 'package:flutter/material.dart';

class HeaderFloatingCard extends StatelessWidget {
  final bool isMobile;
  final VoidCallback? onMenuTap;
  final VoidCallback? onEmailTap;
  final VoidCallback? onNotifTap;
  final VoidCallback? onAvatarTap;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final String? avatarInitial;
  final FocusNode? searchFocusNode;

  const HeaderFloatingCard({
    Key? key,
    this.isMobile = false,
    this.onMenuTap,
    this.onEmailTap,
    this.onNotifTap,
    this.onAvatarTap,
    this.searchController,
    this.onSearchChanged,
    this.avatarInitial = 'J',
    this.searchFocusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8 : 18,
          vertical: isMobile ? 8 : 14,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.grey.withOpacity(0.08),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon menu/sidebar di kiri
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: onMenuTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.pink.withOpacity(0.11),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu,
                    color: Colors.pink,
                    size: 24,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            // Search bar
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.grey[200]!,
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  focusNode: searchFocusNode,
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[500],
                      size: 22,
                    ),
                    hintText: 'Cari direct purchase...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: Colors.grey[200]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: Colors.pink.shade200,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
              ),
            ),
            SizedBox(width: isMobile ? 6 : 16),
            // Icon email
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: onEmailTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.email_outlined,
                    color: Colors.pink,
                    size: 22,
                  ),
                ),
              ),
            ),
            SizedBox(width: isMobile ? 4 : 10),
            // Icon notif
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: onNotifTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_none,
                    color: Colors.pink,
                    size: 22,
                  ),
                ),
              ),
            ),
            SizedBox(width: isMobile ? 4 : 10),
            // Avatar/profile
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: onAvatarTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.pink.withOpacity(0.11),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      avatarInitial ?? 'J',
                      style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
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