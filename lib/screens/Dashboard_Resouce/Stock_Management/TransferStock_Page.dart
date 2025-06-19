import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransferStockPage extends StatefulWidget {
  const TransferStockPage({super.key});

  @override
  _TransferStockPageState createState() => _TransferStockPageState();
}

class _TransferStockPageState extends State<TransferStockPage> {
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
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Transfer Stock',
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
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFFE91E63),
                      size: 20,
                    ),
                    hintText: 'Search by No. Transfer, date, destination, etc.',
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
                          'Transfer Out',
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
                          'Transfer In',
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: isOutstandingSelected
                      ? [
                          _buildTransferCard(
                            'TO-2023-1',
                            'Outlet A',
                            'Rp 1.000.000',
                            'Shipping',
                          ),
                          _buildTransferCard(
                            'TO-2023-2',
                            'Outlet B',
                            'Rp 1.000.000',
                            'Pending',
                          ),
                          _buildTransferCard(
                            'TO-2023-3',
                            'Outlet C',
                            'Rp 1.000.000',
                            'Completed',
                          ),
                        ]
                      : [
                          _buildTransferCard(
                            'TI-2023-4',
                            'Outlet D',
                            'Rp 2.000.000',
                            'Pending',
                          ),
                          _buildTransferCard(
                            'TI-2023-5',
                            'Outlet E',
                            'Rp 2.500.000',
                            'Received',
                          ),
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _SimpleFabMenu(),
    );
  }

  Widget _buildTransferCard(
    String id,
    String destination,
    String total,
    String status,
  ) {
    Color statusColor = status == "Completed"
        ? Colors.green[600]!
        : status == "Shipping"
        ? Colors.blue[600]!
        : status == "Pending"
        ? Colors.orange[600]!
        : Colors.green[600]!;

    Color statusBg = status == "Completed"
        ? Colors.green[50]!
        : status == "Shipping"
        ? Colors.blue[50]!
        : status == "Pending"
        ? Colors.orange[50]!
        : Colors.green[50]!;

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
                  id,
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
                Icon(Icons.store, color: Colors.grey[600], size: 16),
                const SizedBox(width: 8),
                Text(
                  "Destination: ",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                Text(
                  destination,
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
                Icon(Icons.attach_money, color: Colors.grey[600], size: 16),
                const SizedBox(width: 8),
                Text(
                  "Total: ",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                Text(
                  total,
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
                            : status == "Shipping"
                            ? Icons.local_shipping
                            : status == "Pending"
                            ? Icons.pending
                            : Icons.check_circle,
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

class _ListTransferOutModal extends StatefulWidget {
  @override
  State<_ListTransferOutModal> createState() => _ListTransferOutModalState();
}

class _ListTransferOutModalState extends State<_ListTransferOutModal> {
  final List<Map<String, String>> _data = [
    {'no': 'TO-2024-0125', 'date': '15/03/2024', 'outlet': 'HAUS Jakarta'},
    {
      'no': 'TO-2024-0125',
      'date': '15/03/2024',
      'outlet': 'HAUS Tangerang Selatan',
    },
    {'no': 'TO-2024-0125', 'date': '15/03/2024', 'outlet': 'HAUS Tangerang'},
  ];
  int _page = 1;
  int _totalPages = 2;

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
                Text(
                  'List Transfer Out',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFFE91E63),
                          ),
                          hintText: 'Search',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[400],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.filter_alt, color: Color(0xFFE91E63)),
                      label: Text(
                        'Filter',
                        style: GoogleFonts.poppins(color: Color(0xFFE91E63)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFFE91E63)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Color(0xFFE5E7EB)),
                  ),
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      Color(0xFFF3F4F6),
                    ),
                    columnSpacing: 16,
                    columns: [
                      DataColumn(
                        label: Text(
                          'No. Transfer',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Transfer Date',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Outlet/Store',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Action',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                    rows: _data.map((row) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              row['no']!,
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ),
                          DataCell(
                            Text(
                              row['date']!,
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ),
                          DataCell(
                            Text(
                              row['outlet']!,
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ),
                          DataCell(
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFE91E63),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                              ),
                              child: Text(
                                'Choose',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  children: [
                    Text(
                      '1 - 10 of 13 Pages',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    Spacer(),
                    Text('Page on', style: GoogleFonts.poppins(fontSize: 13)),
                    SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _page,
                      items: List.generate(
                        _totalPages,
                        (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text('${i + 1}'),
                        ),
                      ),
                      onChanged: (v) => setState(() => _page = v ?? 1),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: _page > 1
                          ? () => setState(() => _page--)
                          : null,
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: _page < _totalPages
                          ? () => setState(() => _page++)
                          : null,
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Close',
                        style: GoogleFonts.poppins(
                          color: Color(0xFFE91E63),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
}

class _ListTransferInModal extends StatefulWidget {
  @override
  State<_ListTransferInModal> createState() => _ListTransferInModalState();
}

class _ListTransferInModalState extends State<_ListTransferInModal> {
  final List<Map<String, String>> _data = [
    {'no': 'TI-2024-0126', 'date': '16/03/2024', 'outlet': 'HAUS Bandung'},
    {'no': 'TI-2024-0127', 'date': '16/03/2024', 'outlet': 'HAUS Surabaya'},
    {'no': 'TI-2024-0128', 'date': '16/03/2024', 'outlet': 'HAUS Medan'},
  ];
  int _page = 1;
  int _totalPages = 1;

  void _showAddTransferInForm(BuildContext context, Map<String, String> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddTransferInFormModal(data: data),
    );
  }

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
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'List Transfer In',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFFE91E63),
                          ),
                          hintText: 'Search',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[400],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.filter_alt, color: Color(0xFFE91E63)),
                      label: Text(
                        'Filter',
                        style: GoogleFonts.poppins(color: Color(0xFFE91E63)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFFE91E63)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _data.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final row = _data[i];
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xFFE5E7EB)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.04),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _LabelValue(label: 'No. Transfer', value: row['no']!),
                                  SizedBox(height: 4),
                                  _LabelValue(label: 'Transfer Date', value: row['date']!),
                                  SizedBox(height: 4),
                                  _LabelValue(label: 'Outlet/Store', value: row['outlet']!),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () => _showAddTransferInForm(context, row),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFE91E63),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Choose',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 18),
                Row(
                  children: [
                    Text(
                      '1 - 10 of 13 Pages',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    Spacer(),
                    Text('Page on', style: GoogleFonts.poppins(fontSize: 13)),
                    SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _page,
                      items: List.generate(
                        _totalPages,
                        (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text('${i + 1}'),
                        ),
                      ),
                      onChanged: (v) => setState(() => _page = v ?? 1),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: _page > 1
                          ? () => setState(() => _page--)
                          : null,
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: _page < _totalPages
                          ? () => setState(() => _page++)
                          : null,
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Close',
                        style: GoogleFonts.poppins(
                          color: Color(0xFFE91E63),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
}

class _AddTransferInFormModal extends StatelessWidget {
  final Map<String, String> data;
  const _AddTransferInFormModal({required this.data});

  @override
  Widget build(BuildContext context) {
    final TextEditingController notesController = TextEditingController();
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.7,
      maxChildSize: 0.98,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Transfer In',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _FormFieldBox(
                        label: 'No. Transfer In',
                        child: TextFormField(
                          initialValue: data['no'] ?? '',
                          decoration: InputDecoration(border: InputBorder.none),
                          readOnly: true,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _FormFieldBox(
                        label: 'Receipt Date',
                        child: TextFormField(
                          initialValue: data['date'] ?? '',
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: Icon(Icons.calendar_today, size: 18),
                          ),
                          readOnly: true,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _FormFieldBox(
                        label: 'No. Transfer Out',
                        child: TextFormField(
                          initialValue: 'TO-2024-0125',
                          decoration: InputDecoration(border: InputBorder.none),
                          readOnly: true,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _FormFieldBox(
                        label: 'Transfer Date',
                        child: TextFormField(
                          initialValue: '15/03/2024',
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: Icon(Icons.calendar_today, size: 18),
                          ),
                          readOnly: true,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _FormFieldBox(
                        label: 'Source Location',
                        child: TextFormField(
                          initialValue: 'HAUS Jakarta',
                          decoration: InputDecoration(border: InputBorder.none),
                          readOnly: true,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _FormFieldBox(
                        label: 'Destination Source',
                        child: TextFormField(
                          initialValue: 'HAUS Tangerang',
                          decoration: InputDecoration(border: InputBorder.none),
                          readOnly: true,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _FormFieldBox(
                        label: 'Received by',
                        child: DropdownButtonFormField<String>(
                          value: 'John Doe',
                          items: [
                            DropdownMenuItem(value: 'John Doe', child: Text('John Doe')),
                            DropdownMenuItem(value: 'Jane Smith', child: Text('Jane Smith')),
                          ],
                          onChanged: (v) {},
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Text('Item', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: 'Bubuk Vanilla',
                          items: [
                            DropdownMenuItem(value: 'Bubuk Vanilla', child: Text('Bubuk Vanilla')),
                            DropdownMenuItem(value: 'Bubuk Coklat', child: Text('Bubuk Coklat')),
                          ],
                          onChanged: (v) {},
                          decoration: InputDecoration(border: InputBorder.none, labelText: 'Item Name'),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: '100',
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Transfer Qty',
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: '100',
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Received Qty',
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: 'PCS',
                          items: [
                            DropdownMenuItem(value: 'PCS', child: Text('PCS')),
                            DropdownMenuItem(value: 'BOX', child: Text('BOX')),
                          ],
                          onChanged: (v) {},
                          decoration: InputDecoration(border: InputBorder.none, labelText: 'Unit'),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18),
                Text('Upload File', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.upload_file, color: Color(0xFFE91E63)),
                      SizedBox(width: 8),
                      Expanded(child: Text('Choose File...', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]))),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  width: 180,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text('Preview File', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]))),
                ),
                SizedBox(height: 18),
                Text('Notes', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                TextFormField(
                  controller: notesController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Pengiriman Stock Bubuk Vanilla ke Haus Tangerang',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      ),
                      child: Text('Create', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
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
}

class _FormFieldBox extends StatelessWidget {
  final String label;
  final Widget child;
  const _FormFieldBox({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 2, bottom: 2),
            child: Text(
              label,
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  const _LabelValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey[900],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SimpleFabMenu extends StatefulWidget {
  @override
  State<_SimpleFabMenu> createState() => _SimpleFabMenuState();
}

class _SimpleFabMenuState extends State<_SimpleFabMenu> {
  bool _isOpen = false;

  void _toggle() => setState(() => _isOpen = !_isOpen);

  void _showTransferOut(BuildContext context) {
    setState(() => _isOpen = false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ListTransferOutModal(),
    );
  }

  void _showTransferIn(BuildContext context) {
    setState(() => _isOpen = false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ListTransferInModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (_isOpen) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 130, right: 8),
            child: _FabMenuItem(
              label: 'Transfer Out',
              icon: Icons.upload,
              onTap: () => _showTransferOut(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 80, right: 8),
            child: _FabMenuItem(
              label: 'Transfer In',
              icon: Icons.download,
              onTap: () => _showTransferIn(context),
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 16),
          child: FloatingActionButton(
            backgroundColor: Color(0xFFE91E63),
            onPressed: _toggle,
            child: Icon(_isOpen ? Icons.close : Icons.add),
          ),
        ),
      ],
    );
  }
}

class _FabMenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _FabMenuItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Row(
                children: [
                  Icon(icon, color: Color(0xFFE91E63), size: 20),
                  SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: Color(0xFFE91E63),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
