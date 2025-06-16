import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserprofilePage extends StatefulWidget {
  const UserprofilePage({super.key});

  @override
  State<UserprofilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserprofilePage> {
  final TextEditingController _nameController = TextEditingController(
    text: "John Doe",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "john.doe@email.com",
  );
  final TextEditingController _storeController = TextEditingController(
    text: "Jakarta",
  );
  final TextEditingController _employeeIdController = TextEditingController(
    text: "EMP123456",
  );
  final TextEditingController _phoneController = TextEditingController(
    text: "08123456789",
  );
  final TextEditingController _positionController = TextEditingController(
    text: "Manager",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account & Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF880E4F),
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              // Avatar & Change Button
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: Color(0xFF880E4F).withOpacity(0.1),
                      backgroundImage: AssetImage(
                        'assets/avatar_placeholder.png',
                      ), // Ganti sesuai asset Anda
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          // Action to change picture
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF880E4F),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Profile Card
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 22,
                  ),
                  child: Column(
                    children: [
                      _buildProfileField(
                        label: "Full Name",
                        hint: "Enter your full name",
                        icon: Icons.person,
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),
                      _buildProfileField(
                        label: "Email",
                        hint: "Enter your email",
                        icon: Icons.email,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 16),
                      _buildProfileField(
                        label: "Store Location",
                        hint: "Enter store location",
                        icon: Icons.store,
                        controller: _storeController,
                      ),
                      const SizedBox(height: 16),
                      _buildProfileField(
                        label: "Employee ID",
                        icon: Icons.badge,
                        controller: _employeeIdController,
                        readOnly: true,
                        textColor: Colors.grey, // <-- Tambahkan ini
                      ),
                      const SizedBox(height: 16),
                      _buildProfileField(
                        label: "Phone Number",
                        hint: "Enter phone number",
                        icon: Icons.phone,
                        controller: _phoneController,
                      ),
                      const SizedBox(height: 16),
                      _buildProfileField(
                        label: "Position",
                        icon: Icons.work,
                        controller: _positionController,
                        readOnly: true,
                        textColor: Colors.grey, // <-- Tambahkan ini
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Save profile action
                  },
                  icon: Icon(Icons.save, color: Colors.white),
                  label: Text(
                    "Save Profile",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF880E4F),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    String? hint,
    required IconData icon,
    required TextEditingController controller,
    bool readOnly = false,
    Color? textColor, // Tambahkan parameter ini
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF880E4F),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: textColor ?? Colors.black, // Gunakan warna jika ada
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Color(0xFF880E4F)),
            hintText: hint,
            filled: true,
            fillColor: readOnly ? Colors.grey[100] : Colors.grey[50],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFF880E4F)),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          ),
        ),
      ],
    );
  }
}
