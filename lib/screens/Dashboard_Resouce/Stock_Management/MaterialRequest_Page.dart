import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaterialRequestPage extends StatefulWidget {
  const MaterialRequestPage({super.key});

  @override
  _MaterialRequest_PageState createState() => _MaterialRequest_PageState();
}

class _MaterialRequest_PageState extends State<MaterialRequestPage> {
  bool isOutstandingSelected = true;

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
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Material Request',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: Icon(Icons.filter_alt, color: Colors.white),
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
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFFE91E63),
                      size: 20,
                    ),
                    hintText: 'Search by NO. Tanggal, Outlet/Store, Qty, etc',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey[400],
                      fontSize: 13,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
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
                          gradient: isOutstandingSelected
                              ? LinearGradient(
                                  colors: [Color(0xFFE91E63), Color(0xFFFF4081)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                      color: isOutstandingSelected
                              ? null
                          : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                    child: Text(
                      'Pending',
                      style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                        color: isOutstandingSelected
                            ? Colors.white
                                  : Colors.grey[600],
                            ),
                          ),
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
                          gradient: !isOutstandingSelected
                              ? LinearGradient(
                                  colors: [Color(0xFFE91E63), Color(0xFFFF4081)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                      color: !isOutstandingSelected
                              ? null
                          : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                    child: Text(
                      'Approved',
                      style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                        color: !isOutstandingSelected
                            ? Colors.white
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: isOutstandingSelected
                        ? [
                          _buildModernCard(
                              requestNo: 'MR-2023-1',
                              date: '2023-06-01',
                              outlet: 'Outlet A',
                              qty: '10',
                              dueDate: '2023-06-10',
                            status: 'Pending',
                            statusIcon: Icons.pending_actions,
                            ),
                          _buildModernCard(
                              requestNo: 'MR-2023-2',
                              date: '2023-06-02',
                              outlet: 'Outlet B',
                              qty: '5',
                              dueDate: '2023-06-12',
                            status: 'Pending',
                            statusIcon: Icons.pending_actions,
                            ),
                          _buildModernCard(
                              requestNo: 'MR-2023-3',
                              date: '2023-06-03',
                              outlet: 'Outlet C',
                              qty: '8',
                              dueDate: '2023-06-15',
                            status: 'Pending',
                            statusIcon: Icons.pending_actions,
                            ),
                          ]
                        : [
                          _buildModernCard(
                              requestNo: 'MR-2023-4',
                              date: '2023-05-28',
                              outlet: 'Outlet D',
                              qty: '12',
                              dueDate: '2023-06-05',
                            status: 'Approved',
                            statusIcon: Icons.check_circle,
                            ),
                          _buildModernCard(
                              requestNo: 'MR-2023-5',
                              date: '2023-05-30',
                              outlet: 'Outlet E',
                              qty: '7',
                              dueDate: '2023-06-08',
                            status: 'Approved',
                            statusIcon: Icons.check_circle,
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
              color: Color(0xFFE91E63).withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => _MaterialRequestModal(),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add, size: 24),
        ),
      ),
    );
  }

  Widget _buildModernCard({
    required String requestNo,
    required String date,
    required String outlet,
    required String qty,
    required String dueDate,
    required String status,
    required IconData statusIcon,
  }) {
    Color statusColor = status == "Approved"
        ? Colors.green
        : status == "Rejected"
        ? Colors.red
        : Color(0xFFE91E63);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
      child: Padding(
              padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
            Text(
              requestNo,
              style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                color: Color(0xFFE91E63),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
              children: [
                            Icon(
                              statusIcon,
                              size: 14,
                              color: statusColor,
                            ),
                            SizedBox(width: 4),
                            Text(
                              status,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: statusColor,
                  ),
                ),
              ],
            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
            Row(
              children: [
                      Icon(Icons.store, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 6),
                Text(
                        outlet,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 6),
                Text(
                        'Date: $date',
                  style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
                  SizedBox(height: 6),
            Row(
              children: [
                      Icon(Icons.event_available, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 6),
                Text(
                        'Due: $dueDate',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.confirmation_number, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 6),
                Text(
                        'Qty: $qty',
                  style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Color(0xFFE91E63),
                      ),
                      label: Text(
                        'View Details',
                        style: GoogleFonts.poppins(
                          color: Color(0xFFE91E63),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        backgroundColor: Color(0xFFE91E63).withOpacity(0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
    );
  }
}

class _MaterialRequestModal extends StatefulWidget {
  @override
  State<_MaterialRequestModal> createState() => _MaterialRequestModalState();
}

class _MaterialRequestModalState extends State<_MaterialRequestModal> {
  DateTime? _requestDate = DateTime.now();
  DateTime? _dueDate = DateTime.now().add(Duration(days: 1));
  List<Map<String, dynamic>> _items = [
    {'code': 'B-V002', 'name': 'Bubuk Coklat', 'qty': 1, 'unit': 'PCS'},
  ];
  String? _reason = '';

  final List<String> _itemCodes = ['B-V002', 'B-V003', 'B-V004'];
  final List<String> _itemNames = ['Bubuk Coklat', 'Gula', 'Susu'];
  final List<String> _units = ['PCS', 'BOX', 'KG', 'L'];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
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
                      'Add New Material Request',
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
                        label: 'Request Date',
                        hint: _requestDate != null
                            ? _requestDate!.toString().substring(0, 10)
                            : 'Select Date',
                        readOnly: true,
                        suffixIcon: Icons.calendar_today,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _requestDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => _requestDate = picked);
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: 'Due Date',
                        hint: _dueDate != null
                            ? _dueDate!.toString().substring(0, 10)
                            : 'Select Date',
                        readOnly: true,
                        suffixIcon: Icons.calendar_today,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _dueDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => _dueDate = picked);
                        },
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
                                          child: _modernLabeledDropdown(
                                            label: 'Unit',
                                            hint: 'Pilih satuan',
                                            value: item['unit'],
                                            items: _units,
                                            onChanged: (v) => setState(() => _items[idx]['unit'] = v),
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
                                      child: _modernLabeledDropdown(
                                        label: 'Unit',
                                        hint: 'Pilih satuan',
                                        value: item['unit'],
                                        items: _units,
                                        onChanged: (v) => setState(() => _items[idx]['unit'] = v),
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
                                        _items.add({'code': _itemCodes.first, 'name': _itemNames.first, 'qty': 1, 'unit': _units.first});
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
                                          _items.add({'code': _itemCodes.first, 'name': _itemNames.first, 'qty': 1, 'unit': _units.first});
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
                SizedBox(height: 18),
                Text('Request Reason', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
                SizedBox(height: 8),
                TextField(
                  minLines: 3,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter reason / remarks',
                    hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400]),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  onChanged: (v) => setState(() => _reason = v),
                ),
                SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFE1D8F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFF8B5CF6), size: 18),
                      SizedBox(width: 8),
                      Expanded(
                  child: Text(
                          'Request will require approval from the Area Manager and Supply Chain before being processed.',
                          style: GoogleFonts.poppins(fontSize: 12, color: Color(0xFF6D28D9)),
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
                      child: Text('Close', style: GoogleFonts.poppins(color: Color(0xFFE91E63), fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                  onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE91E63),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      ),
                      child: Text('Create', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
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
          style: GoogleFonts.poppins(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            filled: true,
            fillColor: Colors.grey[100],
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
