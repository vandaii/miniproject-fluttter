import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransferOutPage extends StatelessWidget {
  const TransferOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transfer Out',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF880E4F),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'List Transfer Out',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF880E4F),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(const Color(0xFFF8BBD0)),
                    columns: [
                      DataColumn(label: Text('TO Number', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Date', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Supplier', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Status', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Action', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text('TO-2024-0002')),
                          DataCell(Text('17/03/2024')),
                          DataCell(Text('PT Transfer Jaya')),
                          DataCell(Text('Open', style: TextStyle(color: Colors.green))),
                          DataCell(
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF880E4F),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: const Text('Detail'),
                            ),
                          ),
                        ],
                      ),
                      // Tambahkan DataRow lain jika perlu
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}