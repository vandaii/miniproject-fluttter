import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransferOutModal extends StatefulWidget {
  const TransferOutModal({Key? key}) : super(key: key);

  @override
  State<TransferOutModal> createState() => _TransferOutModalState();
}

class _TransferOutModalState extends State<TransferOutModal> {
  String? _selectedTransferOut;
  String? _selectedSourceLocation;
  String? _selectedDestinationLocation;
  final List<Map<String, dynamic>> _items = [
    {
      'itemName': 'Bubuk Vanilla',
      'qty': '100',
      'unit': 'PCS',
    }
  ];

  final List<String> _transferOutList = ['TO-2024-0125', 'TO-2024-0126', 'TO-2024-0127'];
  final List<String> _sourceLocations = ['HAUS Jakarta', 'HAUS Bandung', 'HAUS Surabaya'];
  final List<String> _destinationLocations = ['HAUS Tanggerang', 'HAUS Tangerang Selatan', 'HAUS Bekasi'];
  final List<String> _itemNames = ['Bubuk Vanilla', 'Bubuk Coklat', 'Bubuk Strawberry'];
  final List<String> _units = ['PCS', 'BOX', 'KG'];

  @override
  Widget build(BuildContext context) {
    const deepPink = Color.fromARGB(255, 255, 0, 85);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: deepPink,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.upload_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Transfer Out',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Buat transfer out baru',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transfer Details Section
                  _buildTransferDetailsSection(),
                  const SizedBox(height: 24),
                  
                  // Item Details Section
                  _buildItemDetailsSection(),
                  const SizedBox(height: 24),
                  
                  // Upload File Section
                  _buildUploadFileSection(),
                  const SizedBox(height: 24),
                  
                  // Notes Section
                  _buildNotesSection(),
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferDetailsSection() {
    const deepPink = Color.fromARGB(255, 255, 0, 85);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transfer Details',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        
        // Row 1: No. Transfer Out & Transfer Date
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                label: 'No. Transfer Out',
                value: _selectedTransferOut ?? 'TO-2024-0125',
                items: _transferOutList,
                onChanged: (value) {
                  setState(() {
                    _selectedTransferOut = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFormField(
                label: 'Transfer Date',
                value: '15/03/2024',
                readOnly: true,
                icon: Icons.calendar_today,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Row 2: Source Location & Destination Location
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                label: 'Source Location',
                value: _selectedSourceLocation ?? 'HAUS Jakarta',
                items: _sourceLocations,
                onChanged: (value) {
                  setState(() {
                    _selectedSourceLocation = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdownField(
                label: 'Destination Location',
                value: _selectedDestinationLocation ?? 'HAUS Tanggerang',
                items: _destinationLocations,
                onChanged: (value) {
                  setState(() {
                    _selectedDestinationLocation = value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemDetailsSection() {
    const deepPink = Color.fromARGB(255, 255, 0, 85);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item Details',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        
        // Items List
        ..._items.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> item = entry.value;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Name
                _buildDropdownField(
                  label: 'Item Name',
                  value: item['itemName'],
                  items: _itemNames,
                  onChanged: (value) {
                    setState(() {
                      _items[index]['itemName'] = value ?? 'Bubuk Vanilla';
                    });
                  },
                ),
                const SizedBox(height: 12),
                
                // Qty & Unit Row
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField(
                        label: 'Qty',
                        value: item['qty'],
                        isNumber: true,
                        onChanged: (value) {
                          setState(() {
                            _items[index]['qty'] = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Unit',
                        value: item['unit'],
                        items: _units,
                        onChanged: (value) {
                          setState(() {
                            _items[index]['unit'] = value ?? 'PCS';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Delete Button
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _items.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
        
        // Add Item Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _items.add({
                  'itemName': 'Bubuk Vanilla',
                  'qty': '100',
                  'unit': 'PCS',
                });
              });
            },
            icon: const Icon(Icons.add, size: 18),
            label: Text('Add Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: deepPink,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadFileSection() {
    const deepPink = Color.fromARGB(255, 255, 0, 85);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload File',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        
        // File Upload Area
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Icon(Icons.folder_open, color: Colors.grey[600], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Choose File...',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Supported formats: JPG, PNG, PDF (Max. 5MB)',
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey[500],
          ),
        ),
        const SizedBox(height: 12),
        
        // File Preview
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.insert_drive_file, color: deepPink, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DN-24015.PNG',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          'DELIVERY NOTE',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NO. DN-24015',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'FROM HAUS TANGERANG SELATAN',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'DATE 24/04/2024',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    const deepPink = Color.fromARGB(255, 255, 0, 85);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter notes / remarks',
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[400],
              fontSize: 13,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: deepPink),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    const deepPink = Color.fromARGB(255, 255, 0, 85);
    
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: deepPink),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                color: deepPink,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Create functionality
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: deepPink,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Create',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required String value,
    bool readOnly = false,
    IconData? icon,
    bool isNumber = false,
    ValueChanged<String>? onChanged,
  }) {
    const deepPink = Color.fromARGB(255, 255, 0, 85);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          readOnly: readOnly,
          keyboardType: isNumber ? TextInputType.number : null,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[400],
              fontSize: 13,
            ),
            prefixIcon: icon != null
                ? Icon(icon, size: 18, color: Colors.grey[600])
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: deepPink),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool readOnly = false,
  }) {
    const deepPink = Color.fromARGB(255, 255, 0, 85);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
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
          onChanged: readOnly ? null : onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: deepPink),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800]),
        ),
      ],
    );
  }
} 