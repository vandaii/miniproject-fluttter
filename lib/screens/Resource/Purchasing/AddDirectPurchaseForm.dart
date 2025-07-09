import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:miniproject_flutter/services/DirectService.dart';

class AddDirectPurchaseForm extends StatefulWidget {
  final VoidCallback? onSuccess;
  const AddDirectPurchaseForm({Key? key, this.onSuccess}) : super(key: key);

  @override
  State<AddDirectPurchaseForm> createState() => _AddDirectPurchaseFormState();
}

class _AddDirectPurchaseFormState extends State<AddDirectPurchaseForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _expenseTypeController = TextEditingController();
  List<Map<String, dynamic>> _items = [];
  List<File> _files = [];
  bool _isSubmitting = false;
  double _totalAmount = 0.0;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final List<String> _expenseTypes = ['Inventory', 'Non Inventory'];

  @override
  void initState() {
    super.initState();
    _addItem();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _slideAnim = Tween<Offset>(begin: Offset(0, 0.15), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );
    _animController.forward();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _supplierController.dispose();
    _noteController.dispose();
    _expenseTypeController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _addItem() {
    setState(() {
      _items.add({
        'name': TextEditingController(),
        'desc': TextEditingController(),
        'qty': TextEditingController(),
        'price': TextEditingController(),
        'unit': 'PCS',
      });
    });
  }

  void _removeItem(int idx) {
    setState(() {
      _items.removeAt(idx);
    });
    _recalculateTotal();
  }

  void _recalculateTotal() {
    double total = 0.0;
    for (var item in _items) {
      final qty = double.tryParse(item['qty'].text) ?? 0.0;
      final price = double.tryParse(item['price'].text) ?? 0.0;
      total += qty * price;
    }
    setState(() => _totalAmount = total);
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null) {
      setState(() {
        _files = result.paths.map((e) => File(e!)).toList();
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tanggal wajib diisi'), backgroundColor: Colors.red),
      );
      return;
    }
    if (_supplierController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Supplier wajib diisi'), backgroundColor: Colors.red),
      );
      return;
    }
    if (_items.isEmpty || _items.any((item) => item['name'].text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Minimal 1 item barang dengan nama!'), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final items = _items
          .map(
            (item) => {
              'item_name': item['name'].text.trim(),
              'item_description': item['desc'].text.trim(),
              'quantity': int.tryParse(item['qty'].text) ?? 0,
              'price': double.tryParse(item['price'].text) ?? 0.0,
              'unit': item['unit'],
            },
          )
          .toList();
      await DirectService().createDirectPurchase(
        date: _dateController.text,
        supplier: _supplierController.text,
        expenseType: _expenseTypeController.text,
        items: items,
        totalAmount: _totalAmount,
        note: _noteController.text,
        purchaseProofs: _files,
      );
      if (widget.onSuccess != null) widget.onSuccess!();
      // Reset form setelah sukses
      setState(() {
        _dateController.clear();
        _supplierController.clear();
        _noteController.clear();
        _expenseTypeController.clear();
        _items = [];
        _addItem();
        _files = [];
        _totalAmount = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berhasil tambah direct purchase'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal tambah direct purchase: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 520,
              minWidth: 320,
              maxHeight: MediaQuery.of(context).size.height * 0.92,
            ),
            margin: EdgeInsets.only(top: 24, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.purple.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 32,
                  offset: Offset(0, 12),
                ),
              ],
              backgroundBlendMode: BlendMode.luminosity,
            ),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 60,
                            height: 6,
                            margin: EdgeInsets.only(bottom: 18),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        Text(
                          'Tambah Direct Purchase',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[700],
                          ),
                        ),
                        SizedBox(height: 18),
                        // Tanggal
                        _ModernField(
                          label: 'Tanggal',
                          controller: _dateController,
                          hint: 'Pilih tanggal',
                          readOnly: true,
                          prefixIcon: Icons.calendar_today_rounded,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              _dateController.text = DateFormat(
                                'yyyy-MM-dd',
                              ).format(picked);
                            }
                          },
                          validator: (v) => v == null || v.isEmpty
                              ? 'Tanggal wajib diisi'
                              : null,
                        ),
                        SizedBox(height: 12),
                        // Supplier
                        _ModernField(
                          label: 'Supplier',
                          controller: _supplierController,
                          hint: 'Nama supplier',
                          prefixIcon: Icons.store,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Supplier wajib diisi'
                              : null,
                        ),
                        SizedBox(height: 12),
                        // Expense Type
                        _ModernDropdown(
                          label: 'Expense Type',
                          value: _expenseTypeController.text.isEmpty
                              ? null
                              : _expenseTypeController.text,
                          items: _expenseTypes,
                          onChanged: (val) {
                            _expenseTypeController.text = val ?? '';
                          },
                          prefixIcon: Icons.category_outlined,
                        ),
                        SizedBox(height: 18),
                        // Items
                        Text(
                          'Item Barang',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.purple[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        ..._items.asMap().entries.map((entry) {
                          int idx = entry.key;
                          var item = entry.value;
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 250),
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.purple[50]?.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.purple.withOpacity(0.10),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _ModernField(
                                        label: 'Nama',
                                        controller: item['name'],
                                        hint: 'Nama barang',
                                        validator: (v) => v == null || v.isEmpty
                                            ? 'Wajib'
                                            : null,
                                        onChanged: (_) => _recalculateTotal(),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: _ModernField(
                                        label: 'Deskripsi',
                                        controller: item['desc'],
                                        hint: 'Deskripsi',
                                        onChanged: (_) => _recalculateTotal(),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _ModernField(
                                        label: 'Qty',
                                        controller: item['qty'],
                                        hint: '0',
                                        keyboardType: TextInputType.number,
                                        validator: (v) {
                                          if (v == null || v.isEmpty)
                                            return 'Wajib';
                                          final val = int.tryParse(v);
                                          if (val == null || val <= 0)
                                            return 'Harus angka > 0';
                                          return null;
                                        },
                                        onChanged: (_) => _recalculateTotal(),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: _ModernField(
                                        label: 'Harga',
                                        controller: item['price'],
                                        hint: '0',
                                        keyboardType: TextInputType.number,
                                        validator: (v) => v == null || v.isEmpty
                                            ? 'Wajib'
                                            : null,
                                        onChanged: (_) => _recalculateTotal(),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: _ModernDropdown(
                                        label: 'Unit',
                                        value: item['unit'],
                                        items: ['PCS', 'BOX', 'KG', 'L'],
                                        onChanged: (val) {
                                          setState(() {
                                            item['unit'] = val;
                                          });
                                        },
                                      ),
                                    ),
                                    if (_items.length > 1)
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => _removeItem(idx),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _addItem,
                              icon: Icon(Icons.add, size: 18),
                              label: Text('Tambah Item'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple[100],
                                foregroundColor: Colors.purple[700],
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Total: ' +
                                  NumberFormat.currency(
                                    locale: 'id',
                                    symbol: 'Rp ',
                                    decimalDigits: 0,
                                  ).format(_totalAmount),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple[700],
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18),
                        // Note
                        _ModernField(
                          label: 'Catatan',
                          controller: _noteController,
                          hint: 'Catatan tambahan',
                          maxLines: 2,
                        ),
                        SizedBox(height: 14),
                        // Upload file
                        Text(
                          'Lampiran (Bukti Pembelian)',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.purple[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickFiles,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple[50]?.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.purple.withOpacity(0.10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload_file,
                                  color: Colors.purple[300],
                                ),
                                SizedBox(width: 10),
                                Text(
                                  _files.isEmpty
                                      ? 'Pilih file untuk upload'
                                      : '${_files.length} file terpilih',
                                  style: GoogleFonts.poppins(
                                    color: Colors.purple[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_files.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: _files
                                  .map(
                                    (file) => Chip(
                                      label: Text(
                                        file.path
                                            .split(Platform.pathSeparator)
                                            .last,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                        ),
                                      ),
                                      onDeleted: () {
                                        setState(() {
                                          _files.remove(file);
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        SizedBox(height: 18),
                        // Tombol submit
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isSubmitting ? null : _submit,
                            icon: _isSubmitting
                                ? SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Icon(Icons.save_rounded),
                            label: Text(
                              _isSubmitting ? 'Menyimpan...' : 'Simpan',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple[700],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              textStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Batal',
                              style: GoogleFonts.poppins(
                                color: Colors.purple[300],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool readOnly;
  final IconData? prefixIcon;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  const _ModernField({
    required this.label,
    required this.controller,
    this.hint,
    this.readOnly = false,
    this.prefixIcon,
    this.onTap,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.purple[700],
            ),
          ),
        if (label.isNotEmpty) SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: GoogleFonts.poppins(fontSize: 13.5, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.purple[200],
              fontSize: 13,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: Colors.purple[300])
                : null,
            filled: true,
            fillColor: Colors.white.withOpacity(0.85),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.purple.withOpacity(0.10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.purple.withOpacity(0.10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.purple[700]!, width: 1.3),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}

class _ModernDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final IconData? prefixIcon;
  const _ModernDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.purple[700],
            ),
          ),
        if (label.isNotEmpty) SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: GoogleFonts.poppins(fontSize: 13)),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.85),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: Colors.purple[300])
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.purple.withOpacity(0.10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.purple.withOpacity(0.10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.purple[700]!, width: 1.3),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
}
