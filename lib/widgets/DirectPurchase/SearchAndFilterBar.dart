import 'dart:async';
import 'package:flutter/material.dart';

class SearchAndFilterBar extends StatefulWidget {
  static const Color primary = Color.fromARGB(255, 255, 0, 85);
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;
  final String hintText;

  const SearchAndFilterBar({
    Key? key,
    required this.onChanged,
    this.onFilterTap,
    this.hintText = 'Cari transaksi…',
  }) : super(key: key);

  @override
  _SearchAndFilterBarState createState() => _SearchAndFilterBarState();
}

class _SearchAndFilterBarState extends State<SearchAndFilterBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        widget.onChanged(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Material(
          elevation: 1,
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: IconButton(
            icon: const Icon(Icons.filter_list, color: SearchAndFilterBar.primary),
            onPressed: widget.onFilterTap,
          ),
        ),
      ],
    );
  }
} 