import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StockOpnamePage extends StatefulWidget {
  const StockOpnamePage({super.key});

  @override
  _StockOpnamePageState createState() => _StockOpnamePageState();
}

class _StockOpnamePageState extends State<StockOpnamePage> {
  bool isOutstandingSelected =
      true; // Track selected tab (Outstanding or Approved)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE91E63), Color(0xFFFF4081)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFE91E63).withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Stock Opname',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: Icon(Icons.filter_alt, color: Colors.white, size: 20),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar Section
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.06),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  style: GoogleFonts.poppins(fontSize: 13),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Color(0xFFE91E63), size: 20),
                    hintText: 'Search by DocNum, Date, Outlet, or Status',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
            ),
            // Taskbar for Outstanding and Approved
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.06),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isOutstandingSelected = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isOutstandingSelected
                              ? Color(0xFFE91E63)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Ongoing',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: isOutstandingSelected
                                ? Colors.white
                                : Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isOutstandingSelected = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !isOutstandingSelected
                              ? Color(0xFFE91E63)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Completed',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: !isOutstandingSelected
                                ? Colors.white
                                : Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Display content based on the selected tab (Outstanding or Approved)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: isOutstandingSelected
                      ? [
                          _buildStockOpnameCard(
                            docNum: 'SO-2023-1',
                            date: '2023-06-01',
                            outlet: 'Outlet A',
                            qty: '10',
                            status: 'Pending',
                          ),
                          _buildStockOpnameCard(
                            docNum: 'SO-2023-2',
                            date: '2023-06-02',
                            outlet: 'Outlet B',
                            qty: '8',
                            status: 'Pending',
                          ),
                          _buildStockOpnameCard(
                            docNum: 'SO-2023-3',
                            date: '2023-06-03',
                            outlet: 'Outlet C',
                            qty: '5',
                            status: 'Pending',
                          ),
                        ]
                      : [
                          _buildStockOpnameCard(
                            docNum: 'SO-2023-4',
                            date: '2023-05-28',
                            outlet: 'Outlet D',
                            qty: '12',
                            status: 'Completed',
                          ),
                          _buildStockOpnameCard(
                            docNum: 'SO-2023-5',
                            date: '2023-05-30',
                            outlet: 'Outlet E',
                            qty: '7',
                            status: 'Completed',
                          ),
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE91E63), Color(0xFFFF4081)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFE91E63).withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => _StockOpnameModal(),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add, size: 24),
        ),
      ),
    );
  }

  // Helper function to build the card layout for each direct purchase item
  Widget _buildStockOpnameCard({
    required String docNum,
    required String date,
    required String outlet,
    required String qty,
    required String status,
  }) {
    Color statusColor = status == "Completed"
        ? Colors.green[600]!
        : status == "Pending"
            ? Colors.orange[600]!
            : Color(0xFFE91E63);

    Color statusBg = status == "Completed"
        ? Colors.green[50]!
        : status == "Pending"
            ? Colors.orange[50]!
            : Color(0xFFE91E63).withOpacity(0.08);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: Color(0xFFE91E63), size: 20),
                const SizedBox(width: 8),
                Text(
                  docNum,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFFE91E63),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[600], size: 16),
                const SizedBox(width: 8),
                Text(
                  "Date: ",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.store, color: Colors.grey[600], size: 16),
                const SizedBox(width: 8),
                Text(
                  "Outlet: ",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                Text(
                  outlet,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.confirmation_number, color: Colors.grey[600], size: 16),
                const SizedBox(width: 8),
                Text(
                  "Qty: ",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                Text(
                  qty,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        status == "Completed"
                            ? Icons.check_circle
                            : status == "Pending"
                                ? Icons.pending
                                : Icons.info,
                        color: statusColor,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        status,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFFE91E63),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  icon: Icon(Icons.info_outline, size: 16),
                  label: Text(
                    'Detail',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StockOpnameModal extends StatefulWidget {
  @override
  State<_StockOpnameModal> createState() => _StockOpnameModalState();
}

class _StockOpnameModalState extends State<_StockOpnameModal> {
  String? _noStockOpname = '';
  DateTime? _stockOpnameDate = DateTime.now();
  DateTime? _inputStockOpnameDate = DateTime.now();
  String? _countedBy = '';
  String? _preparedBy = 'John Doe';
  String? _outlet = 'Haus Jakarta';
  List<Map<String, dynamic>> _items = [
    {'code': 'BV-001', 'name': 'Boba', 'qty': 100, 'uom': 'gram'},
  ];

  final List<String> _itemCodes = ['BV-001', 'BV-002', 'BV-003'];
  final List<String> _itemNames = ['Boba', 'Cincau', 'Susu'];
  final List<String> _uoms = ['gram', 'pcs', 'ml'];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add New Stock Opname',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'No. Stock Opname',
                        hint: 'SO - 1234',
                        onChanged: (v) => setState(() => _noStockOpname = v),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'Stock Opname Date',
                        hint: _stockOpnameDate != null
                            ? _stockOpnameDate!.toString().substring(0, 10)
                            : 'Select Date',
                        readOnly: true,
                        suffixIcon: Icons.calendar_today,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _stockOpnameDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => _stockOpnameDate = picked);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Input Stock Opname Date',
                        hint: _inputStockOpnameDate != null
                            ? _inputStockOpnameDate!.toString().substring(0, 10)
                            : 'Select Date',
                        readOnly: true,
                        suffixIcon: Icons.calendar_today,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _inputStockOpnameDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => _inputStockOpnameDate = picked);
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'Counted By',
                        hint: 'Emy',
                        onChanged: (v) => setState(() => _countedBy = v),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Prepared by',
                        hint: _preparedBy,
                        readOnly: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'Outlet/Store',
                        hint: _outlet,
                        readOnly: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Text('Item', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ..._items.asMap().entries.map((entry) {
                        int idx = entry.key;
                        var item = entry.value;
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            bool isMobile = constraints.maxWidth < 500;
                            if (isMobile) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: _modernLabeledDropdown(
                                            label: 'Item Code',
                                            hint: 'Pilih kode barang',
                                            value: item['code'],
                                            items: _itemCodes,
                                            onChanged: (v) => setState(() => _items[idx]['code'] = v),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          flex: 2,
                                          child: _modernLabeledDropdown(
                                            label: 'Item Name',
                                            hint: 'Pilih nama barang',
                                            value: item['name'],
                                            items: _itemNames,
                                            onChanged: (v) => setState(() => _items[idx]['name'] = v),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: _modernLabeledInput(
                                            label: 'Qty',
                                            hint: 'Jumlah',
                                            value: item['qty'].toString(),
                                            keyboardType: TextInputType.number,
                                            onChanged: (v) => setState(() => _items[idx]['qty'] = int.tryParse(v) ?? 1),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          flex: 1,
                                          child: _modernLabeledInput(
                                            label: 'UoM',
                                            hint: 'Satuan',
                                            value: item['uom'],
                                            readOnly: true,
                                            fillColor: Colors.grey[200],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: _modernLabeledDropdown(
                                        label: 'Item Code',
                                        hint: 'Pilih kode barang',
                                        value: item['code'],
                                        items: _itemCodes,
                                        onChanged: (v) => setState(() => _items[idx]['code'] = v),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      flex: 2,
                                      child: _modernLabeledDropdown(
                                        label: 'Item Name',
                                        hint: 'Pilih nama barang',
                                        value: item['name'],
                                        items: _itemNames,
                                        onChanged: (v) => setState(() => _items[idx]['name'] = v),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      flex: 1,
                                      child: _modernLabeledInput(
                                        label: 'Qty',
                                        hint: 'Jumlah',
                                        value: item['qty'].toString(),
                                        keyboardType: TextInputType.number,
                                        onChanged: (v) => setState(() => _items[idx]['qty'] = int.tryParse(v) ?? 1),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      flex: 1,
                                      child: _modernLabeledInput(
                                        label: 'UoM',
                                        hint: 'Satuan',
                                        value: item['uom'],
                                        readOnly: true,
                                        fillColor: Colors.grey[200],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      }).toList(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            bool isMobile = constraints.maxWidth < 500;
                            if (isMobile) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      if (_items.isNotEmpty) {
                                        setState(() => _items.removeLast());
                                      }
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    label: Text('Delete item', style: GoogleFonts.poppins(color: Colors.red)),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.red),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _items.add({'code': _itemCodes.first, 'name': _itemNames.first, 'qty': 1, 'uom': _uoms.first});
                                      });
                                    },
                                    icon: Icon(Icons.add, color: Color(0xFFE91E63)),
                                    label: Text('Add item', style: GoogleFonts.poppins(color: Color(0xFFE91E63))),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Color(0xFFE91E63)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        if (_items.isNotEmpty) {
                                          setState(() => _items.removeLast());
                                        }
                                      },
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      label: Text('Delete item', style: GoogleFonts.poppins(color: Colors.red)),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.red),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _items.add({'code': _itemCodes.first, 'name': _itemNames.first, 'qty': 1, 'uom': _uoms.first});
                                        });
                                      },
                                      icon: Icon(Icons.add, color: Color(0xFFE91E63)),
                                      label: Text('Add item', style: GoogleFonts.poppins(color: Color(0xFFE91E63))),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Color(0xFFE91E63)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel', style: GoogleFonts.poppins(color: Color(0xFFE91E63), fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE91E63),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      ),
                      child: Text('Add', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    String? hint,
    bool readOnly = false,
    Color? fillColor,
    IconData? suffixIcon,
    void Function()? onTap,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
        SizedBox(height: 6),
        TextField(
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 18) : null,
            filled: fillColor != null,
            fillColor: fillColor,
          ),
        ),
      ],
    );
  }

  Widget _modernLabeledInput({
    required String label,
    String? hint,
    String? value,
    TextInputType? keyboardType,
    bool readOnly = false,
    Color? fillColor,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF6B7280))),
        SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          keyboardType: keyboardType,
          readOnly: readOnly,
          style: GoogleFonts.poppins(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            filled: fillColor != null,
            fillColor: fillColor,
          ),
        ),
      ],
    );
  }

  Widget _modernLabeledDropdown({
    required String label,
    String? hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF6B7280))),
        SizedBox(height: 4),
        Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              filled: true,
              fillColor: Colors.grey[100],
              hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400]),
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
            icon: Icon(Icons.arrow_drop_down, size: 18),
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              filled: true,
              fillColor: Colors.grey[100],
              hintText: hint,
              hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400]),
              constraints: BoxConstraints(minHeight: 44),
            ),
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
            dropdownColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
