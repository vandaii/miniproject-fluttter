import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaterialRequestPage extends StatefulWidget {
  const MaterialRequestPage({super.key});

  @override
  _MaterialRequest_PageState createState() => _MaterialRequest_PageState();
}

class _MaterialRequest_PageState extends State<MaterialRequestPage> {
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
              'Material Request',
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
                    hintText:
                        ' Search by NO. Tanggal , Outlet/Store, Oty , etc',
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
                      'Pending',
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
                      'Approved',
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
                  children: [
                    // HAPUS HEADER TABEL DI SINI
                    ...(isOutstandingSelected
                        ? [
                            _buildMaterialRequestCard(
                              requestNo: 'MR-2023-1',
                              date: '2023-06-01',
                              outlet: 'Outlet A',
                              qty: '10',
                              dueDate: '2023-06-10',
                            ),
                            _buildMaterialRequestCard(
                              requestNo: 'MR-2023-2',
                              date: '2023-06-02',
                              outlet: 'Outlet B',
                              qty: '5',
                              dueDate: '2023-06-12',
                            ),
                            _buildMaterialRequestCard(
                              requestNo: 'MR-2023-3',
                              date: '2023-06-03',
                              outlet: 'Outlet C',
                              qty: '8',
                              dueDate: '2023-06-15',
                            ),
                          ]
                        : [
                            _buildMaterialRequestCard(
                              requestNo: 'MR-2023-4',
                              date: '2023-05-28',
                              outlet: 'Outlet D',
                              qty: '12',
                              dueDate: '2023-06-05',
                              status: 'Approved Accounting',
                            ),
                            _buildMaterialRequestCard(
                              requestNo: 'MR-2023-5',
                              date: '2023-05-30',
                              outlet: 'Outlet E',
                              qty: '7',
                              dueDate: '2023-06-08',
                              status: 'Approved Accounting',
                            ),
                          ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Tooltip(
        message: "Add New Material Request",
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
  Widget _buildMaterialRequestCard({
    required String requestNo,
    required String date,
    required String outlet,
    required String qty,
    required String dueDate,
    String status = "Pending",
  }) {
    Color statusColor = status == "Approved Accounting"
        ? Colors.green
        : status == "Rejected"
        ? Colors.red
        : Color(0xFF880E4F);

    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.07),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Request Number
            Text(
              requestNo,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF880E4F),
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            // Outlet
            Row(
              children: [
                Icon(Icons.store, color: Colors.grey[600], size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    outlet,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Date & Due Date
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[600], size: 18),
                const SizedBox(width: 8),
                Text(
                  "Date: ",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.event_available, color: Colors.grey[600], size: 18),
                const SizedBox(width: 8),
                Text(
                  "Due: ",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),
                Text(
                  dueDate,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Qty
            Row(
              children: [
                Icon(
                  Icons.confirmation_number,
                  color: Colors.grey[600],
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  "Qty: ",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),
                Text(
                  qty,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Status & Detail Button at the bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                      fontSize: 13,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF880E4F),
                    side: BorderSide(color: Color(0xFF880E4F)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onPressed: () {},
                  icon: Icon(Icons.info_outline, size: 18),
                  label: Text(
                    'Detail',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
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
