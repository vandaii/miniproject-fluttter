import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GRPO_Page extends StatefulWidget {
  const GRPO_Page({super.key});

  @override
  _GrpoPageState createState() => _GrpoPageState();
}

class _GrpoPageState extends State<GRPO_Page> {
  bool isOutstandingSelected =
      true; // Track selected tab (Outstanding or Approved)

  void _showAddGRPOForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: _AddGRPOFormContent(),
        );
      },
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

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
              'GRPO',
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
                    hintText: 'Search by No. GRPO, Supplier, or Total',
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
                                  colors: [
                                    Color(0xFFE91E63),
                                    Color(0xFFFF4081),
                                  ],
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
                      'Shipping',
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
                                  colors: [
                                    Color(0xFFE91E63),
                                    Color(0xFFFF4081),
                                  ],
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
                            'Received',
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
                            'DP-2023-1',
                            'Supplier 1',
                            'Rp 1.000.000',
                            'Pending',
                            Icons.local_shipping,
                          ),
                          _buildModernCard(
                            'DP-2023-2',
                            'Supplier 2',
                            'Rp 1.000.000',
                            'Pending',
                            Icons.local_shipping,
                          ),
                          _buildModernCard(
                            'DP-2023-3',
                            'Supplier 3',
                            'Rp 1.000.000',
                            'Pending',
                            Icons.local_shipping,
                          ),
                        ]
                      : [
                          _buildModernCard(
                            'DP-2023-4',
                            'Supplier 4',
                            'Rp 2.000.000',
                            'Received',
                            Icons.check_circle,
                          ),
                          _buildModernCard(
                            'DP-2023-5',
                            'Supplier 5',
                            'Rp 2.500.000',
                            'Received',
                            Icons.check_circle,
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
          onPressed: _showAddGRPOForm,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add, size: 24),
        ),
      ),
    );
  }

  Widget _buildModernCard(
    String id,
    String supplier,
    String total,
    String status,
    IconData statusIcon,
  ) {
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
              'No. $id',
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
                          color: status == 'Pending'
                              ? Colors.orange.withOpacity(0.08)
                              : Colors.green.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              statusIcon,
                              size: 14,
                              color: status == 'Pending'
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                            SizedBox(width: 4),
            Text(
                              status,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: status == 'Pending'
                                    ? Colors.orange
                                    : Colors.green,
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
                      Icon(Icons.business, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 6),
                      Text(
                        supplier,
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
                      Icon(
                        Icons.attach_money,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 6),
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

class _AddGRPOFormContent extends StatelessWidget {
  const _AddGRPOFormContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Handle bar
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add GRPO',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE91E63),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        // Form Content
        Expanded(
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information
                _buildSection(
                  title: 'Basic Information',
                  icon: Icons.info_outline,
                  color: Color(0xFFE91E63),
                  children: [
              _buildModernTextField(
                label: 'NO. GRPO',
                hint: 'Enter GRPO number',
                prefixIcon: Icons.numbers,
                      iconColor: Color(0xFFE91E63),
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                label: 'Supplier',
                hint: 'Select supplier',
                prefixIcon: Icons.business,
                suffixIcon: Icons.arrow_drop_down,
                      iconColor: Color(0xFFE91E63),
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                label: 'Receive Date',
                hint: 'Select date',
                prefixIcon: Icons.calendar_today,
                suffixIcon: Icons.arrow_drop_down,
                      iconColor: Color(0xFFE91E63),
                    ),
                  ],
              ),
              const SizedBox(height: 24),
              // Item Details
                _buildSection(
                  title: 'Item Details',
                  icon: Icons.inventory_2_outlined,
                  color: Color(0xFF2196F3),
                  children: [
              _buildModernTextField(
                label: 'Item Name',
                hint: 'Enter item name',
                prefixIcon: Icons.inventory_2,
                      iconColor: Color(0xFF2196F3),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildModernTextField(
                      label: 'Quantity',
                      hint: 'Enter quantity',
                      prefixIcon: Icons.format_list_numbered,
                            iconColor: Color(0xFF2196F3),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildModernTextField(
                      label: 'Unit',
                      hint: 'Select unit',
                      prefixIcon: Icons.straighten,
                      suffixIcon: Icons.arrow_drop_down,
                            iconColor: Color(0xFF2196F3),
                    ),
                        ),
                      ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Notes
                _buildSection(
                  title: 'Additional Notes',
                  icon: Icons.note_alt_outlined,
                  color: Color(0xFF4CAF50),
                  children: [
              _buildModernTextField(
                label: 'Notes',
                hint: 'Add any additional notes here...',
                prefixIcon: Icons.note,
                maxLines: 3,
                      iconColor: Color(0xFF4CAF50),
                    ),
                  ],
              ),
              const SizedBox(height: 32),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Color(0xFFE91E63)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          color: Color(0xFFE91E63),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE91E63),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required String label,
    required String hint,
    required IconData prefixIcon,
    IconData? suffixIcon,
    int maxLines = 1,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[400],
              fontSize: 13,
            ),
            prefixIcon: Icon(prefixIcon, color: iconColor, size: 18),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: iconColor, size: 18)
                : null,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: iconColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
