import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GRPO_Page extends StatefulWidget {
  const GRPO_Page({super.key});

  @override
  _GrpoPageState createState() => _GrpoPageState();
}

class _GrpoPageState extends State<GRPO_Page> {
  bool isOutstandingSelected =
      true; // Track selected tab (Outstanding or Approved)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ), // Ubah warna icon back ke putih
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'GRPO',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: const Color(0xFF880E4F),
          elevation: 4,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(Icons.filter_alt, color: Colors.white),
                onPressed: () {
                  // Filter action here
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF3F4F6),
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
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    hintText: 'Search by No. GRPO, Supplier, or Total',
                    hintStyle: TextStyle(color: Colors.grey[600]),
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
            // Taskbar for Outstanding and Approved
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Outstanding Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isOutstandingSelected = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    width: 170,
                    decoration: BoxDecoration(
                      color: isOutstandingSelected
                          ? Color(0xFF880E4F)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isOutstandingSelected
                            ? Colors.transparent
                            : Colors.grey[400]!,
                      ),
                    ),
                    child: Text(
                      'Shipping',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: isOutstandingSelected
                            ? Colors.white
                            : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Approved Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isOutstandingSelected = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    width: 170,
                    decoration: BoxDecoration(
                      color: !isOutstandingSelected
                          ? Color(0xFF880E4F)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: !isOutstandingSelected
                            ? Colors.transparent
                            : Colors.grey[400]!,
                      ),
                    ),
                    child: Text(
                      'Riceived',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: !isOutstandingSelected
                            ? Colors.white
                            : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Display content based on the selected tab (Outstanding or Approved)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: isOutstandingSelected
                      ? [
                          _buildDirectPurchaseCard(
                            'DP-2023-1',
                            'Supplier 1',
                            'Rp 1.000.000',
                            'Pending',
                          ),
                          _buildDirectPurchaseCard(
                            'DP-2023-2',
                            'Supplier 2',
                            'Rp 1.000.000',
                            'Pending',
                          ),
                          _buildDirectPurchaseCard(
                            'DP-2023-3',
                            'Supplier 3',
                            'Rp 1.000.000',
                            'Pending',
                          ),
                        ]
                      : [
                          _buildDirectPurchaseCard(
                            'DP-2023-4',
                            'Supplier 4',
                            'Rp 2.000.000',
                            'Received',
                          ),
                          _buildDirectPurchaseCard(
                            'DP-2023-5',
                            'Supplier 5',
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
      floatingActionButton: Tooltip(
        message: "Add New GRPO",
        child: FloatingActionButton(
          onPressed: () {
            // Action to add a new direct purchase
          },
          backgroundColor: const Color(0xFF880E4F),
          child: Icon(Icons.add, size: 30), // + icon
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Helper function to build the card layout for each direct purchase item
  Widget _buildDirectPurchaseCard(
    String id,
    String supplier,
    String total,
    String status,
  ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16), // Space between cards
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No. $id',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF880E4F), // Accent color for item number
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Supplier: $supplier',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              total,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: status == 'Pending'
                    ? Colors.orange[200]
                    : Colors.green[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: status == 'Pending'
                      ? Colors.orange[700]
                      : Colors.green[700],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF880E4F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text('Detail'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
