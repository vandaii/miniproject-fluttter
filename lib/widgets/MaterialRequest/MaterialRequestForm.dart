import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MaterialRequestForm extends StatefulWidget {
  final Function? onClose;
  final Function? onSuccess;

  const MaterialRequestForm({Key? key, this.onClose, this.onSuccess}) : super(key: key);

  @override
  _MaterialRequestFormState createState() => _MaterialRequestFormState();
}

class _MaterialRequestFormState extends State<MaterialRequestForm> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final Color deepPink = const Color(0xFFE91E63);
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;

  // Form fields
  final TextEditingController _requestDateController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  
  // Item fields
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Initialize with current date
    _requestDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    
    // Add initial item
    _addItem();
    
    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _requestDateController.dispose();
    _dueDateController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _addItem() {
    setState(() {
      _items.add({
        'itemCode': null,
        'itemName': null,
        'qty': '',
        'unit': 'PCS',
      });
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(controller.text)
          : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: deepPink,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: deepPink,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Show success dialog
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 70,
              ),
              const SizedBox(height: 16),
              Text(
                'Success!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Material request has been created successfully',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (widget.onSuccess != null) {
                  widget.onSuccess!();
                }
                Navigator.of(context).pop(); // Close the form modal
              },
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  color: deepPink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    children: [
                      Text(
                        'Add New Material Request',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey[600]),
                        onPressed: () {
                          if (widget.onClose != null) {
                            widget.onClose!();
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                
                // Form content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Request Information Section
                        _buildSection(
                          title: 'Request Information',
                          icon: Icons.info_outline,
                          children: [
                            Row(
                              children: [
                                // Request Date
                                Expanded(
                                  child: _ModernField(
                                    label: 'Request Date',
                                    controller: _requestDateController,
                                    prefixIcon: Icons.calendar_today,
                                    readOnly: true,
                                    onTap: () => _selectDate(context, _requestDateController),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter request date';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Due Date
                                Expanded(
                                  child: _ModernField(
                                    label: 'Due Date',
                                    controller: _dueDateController,
                                    prefixIcon: Icons.event,
                                    readOnly: true,
                                    onTap: () => _selectDate(context, _dueDateController),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter due date';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Item Section
                        _buildSection(
                          title: 'Item',
                          icon: Icons.shopping_cart_outlined,
                          children: [
                            ..._items.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, dynamic> item = entry.value;
                              
                              return Column(
                                children: [
                                  if (index > 0) const Divider(height: 32),
                                  Row(
                                    children: [
                                      // Item Code
                                      Expanded(
                                        child: _ModernDropdown(
                                          label: 'Item Code',
                                          value: item['itemCode'],
                                          items: const [
                                            DropdownMenuItem(value: 'B-V001', child: Text('B-V001')),
                                            DropdownMenuItem(value: 'B-V002', child: Text('B-V002')),
                                            DropdownMenuItem(value: 'B-V003', child: Text('B-V003')),
                                          ],
                                          prefixIcon: Icons.qr_code,
                                          onChanged: (value) {
                                            setState(() {
                                              item['itemCode'] = value;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select item code';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Item Name
                                      Expanded(
                                        child: _ModernDropdown(
                                          label: 'Item Name',
                                          value: item['itemName'],
                                          items: const [
                                            DropdownMenuItem(value: 'Bubuk Coklat', child: Text('Bubuk Coklat')),
                                            DropdownMenuItem(value: 'Bubuk Matcha', child: Text('Bubuk Matcha')),
                                            DropdownMenuItem(value: 'Gula Aren', child: Text('Gula Aren')),
                                          ],
                                          prefixIcon: Icons.inventory_2_outlined,
                                          onChanged: (value) {
                                            setState(() {
                                              item['itemName'] = value;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select item name';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      // Quantity
                                      Expanded(
                                        child: _ModernField(
                                          label: 'Qty',
                                          initialValue: item['qty'],
                                          prefixIcon: Icons.format_list_numbered,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            setState(() {
                                              item['qty'] = value;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter quantity';
                                            }
                                            if (int.tryParse(value) == null) {
                                              return 'Please enter a valid number';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Unit
                                      Expanded(
                                        child: _ModernDropdown(
                                          label: 'Unit',
                                          value: item['unit'],
                                          items: const [
                                            DropdownMenuItem(value: 'PCS', child: Text('PCS')),
                                            DropdownMenuItem(value: 'BOX', child: Text('BOX')),
                                            DropdownMenuItem(value: 'KG', child: Text('KG')),
                                            DropdownMenuItem(value: 'L', child: Text('L')),
                                          ],
                                          prefixIcon: Icons.straighten,
                                          onChanged: (value) {
                                            setState(() {
                                              item['unit'] = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (_items.length > 1)
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                        onPressed: () => _removeItem(index),
                                        icon: Icon(Icons.delete_outline, color: Colors.red[400], size: 20),
                                        label: Text(
                                          'Remove Item',
                                          style: GoogleFonts.poppins(
                                            color: Colors.red[400],
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }).toList(),
                            
                            const SizedBox(height: 16),
                            
                            // Add Item Button
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: _addItem,
                                icon: const Icon(Icons.add, size: 20),
                                label: Text(
                                  'Add Item',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: deepPink,
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  side: BorderSide(color: deepPink),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Request Reason Section
                        _buildSection(
                          title: 'Request Reason',
                          icon: Icons.description_outlined,
                          children: [
                            _ModernField(
                              label: 'Reason',
                              controller: _reasonController,
                              prefixIcon: Icons.notes,
                              maxLines: 3,
                              hintText: 'Enter reason / remarks',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter request reason';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Info message
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.purple[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.purple[100]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.purple[400], size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Request will require approval from the Area Manager and Supply Chain before being processed.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.purple[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Bottom buttons
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            if (widget.onClose != null) {
                              widget.onClose!();
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Close',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                            side: BorderSide(color: Colors.grey[300]!),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Create',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: deepPink,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                            shadowColor: deepPink.withOpacity(0.3),
                          ),
                        ),
                      ),
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

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: deepPink, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }
}

class _ModernField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final IconData? prefixIcon;
  final bool readOnly;
  final int maxLines;
  final TextInputType keyboardType;
  final Function()? onTap;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const _ModernField({
    Key? key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hintText,
    this.prefixIcon,
    this.readOnly = false,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[400],
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: Colors.grey[600])
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFFE91E63), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[800],
          ),
          readOnly: readOnly,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}

class _ModernDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final IconData? prefixIcon;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const _ModernDropdown({
    Key? key,
    required this.label,
    this.value,
    this.items,
    this.prefixIcon,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: Colors.grey[600])
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFFE91E63), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[800],
          ),
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
          dropdownColor: Colors.white,
          isExpanded: true,
        ),
      ],
    );
  }
}