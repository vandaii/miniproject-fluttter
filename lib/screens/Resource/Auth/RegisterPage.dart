import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:miniproject_flutter/widgets/Register/HeaderforRegisterPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/loginPage.dart';
import 'package:miniproject_flutter/widgets/Register/FormRegister.dart';
import 'package:miniproject_flutter/utils/responsive_page.dart';
import 'package:miniproject_flutter/config/APi.dart';

// Custom painter untuk background pattern
class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    // Draw grid pattern
    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += 50) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }

    // Draw circles
    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      80,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      120,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _employeeIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  static const primaryColor = Color.fromARGB(255, 255, 0, 85);

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;
  int _currentStep = 1;

  @override
  void initState() {
    super.initState();
    _employeeIdController.addListener(_onStep1FieldChanged);
    _nameController.addListener(_onStep1FieldChanged);
    _emailController.addListener(_onStep1FieldChanged);
    _phoneController.addListener(_onStep1FieldChanged);
    _passwordController.addListener(_onStep2FieldChanged);
    _confirmPasswordController.addListener(_onStep2FieldChanged);
  }

  void _onStep1FieldChanged() {
    setState(() {});
  }

  void _onStep2FieldChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _employeeIdController.removeListener(_onStep1FieldChanged);
    _nameController.removeListener(_onStep1FieldChanged);
    _emailController.removeListener(_onStep1FieldChanged);
    _phoneController.removeListener(_onStep1FieldChanged);
    _passwordController.removeListener(_onStep2FieldChanged);
    _confirmPasswordController.removeListener(_onStep2FieldChanged);
    super.dispose();
  }

  void showSweetAlert(
    BuildContext context,
    String title,
    String desc,
    DialogType type, {
    VoidCallback? onOk,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.rightSlide,
      title: title,
      desc: desc,
      btnOkOnPress: () {
        FocusScope.of(context).unfocus();
        if (onOk != null) onOk();
      },
    ).show();
  }

  bool get isStep1Valid =>
      _employeeIdController.text.isNotEmpty &&
      _nameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _phoneController.text.isNotEmpty;

  bool get isStep2Valid =>
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  Future<void> _handleSignUp() async {
    final employeeId = _employeeIdController.text.trim();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validasi input
    if (employeeId.isEmpty || name.isEmpty || email.isEmpty || phone.isEmpty) {
      showSweetAlert(
        context,
        "Data Tidak Lengkap",
        "Silakan lengkapi semua data pada step 1.",
        DialogType.error,
      );
      return;
    }

    if (password.isEmpty || confirmPassword.isEmpty) {
      showSweetAlert(
        context,
        "Password Kosong",
        "Silakan isi password dan konfirmasi password.",
        DialogType.error,
      );
      return;
    }

    if (password != confirmPassword) {
      showSweetAlert(
        context,
        "Password Tidak Cocok",
        "Password dan konfirmasi password harus sama.",
        DialogType.error,
      );
      return;
    }

    if (password.length < 6) {
      showSweetAlert(
        context,
        "Password Terlalu Pendek",
        "Password minimal 6 karakter.",
        DialogType.error,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Cek koneksi terlebih dahulu
      final isConnected = await ApiConfig.checkConnection();
      if (!isConnected) {
        showSweetAlert(
          context,
          "Gagal Terhubung",
          "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.",
          DialogType.warning,
        );
        return;
      }

      bool isRegistered = await AuthService().register(
        employeeId: employeeId,
        name: name,
        email: email,
        phone: phone,
        password: password,
        confirmedPassword: confirmPassword,
        storeLocation: '1',
      );

      if (isRegistered) {
        if (mounted) {
          showSweetAlert(
            context,
            "Registrasi Berhasil",
            "Akun Anda berhasil dibuat. Silakan login.",
            DialogType.success,
            onOk: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            },
          );
        }
      } else {
        showSweetAlert(
          context,
          "Registrasi Gagal",
          "ID, email, atau nomor telepon sudah terdaftar.",
          DialogType.error,
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = "Terjadi kesalahan yang tidak diketahui.";
        
        if (e.toString().toLowerCase().contains("failed host lookup") ||
            e.toString().toLowerCase().contains("socketexception")) {
          errorMessage = "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.";
        } else if (e.toString().toLowerCase().contains("unsupported operation")) {
          errorMessage = "Terjadi masalah dengan platform. Silakan coba lagi.";
        } else if (e.toString().toLowerCase().contains("timeout")) {
          errorMessage = "Koneksi timeout. Silakan coba lagi.";
        } else if (e.toString().toLowerCase().contains("certificate")) {
          errorMessage = "Masalah sertifikat SSL. Silakan coba lagi.";
        }
        
        showSweetAlert(
          context,
          "Error",
          errorMessage,
          DialogType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Widget untuk tampilan mobile
  Widget _buildMobileLayout() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  HeaderWithLogo(
                    logoSize: _currentStep == 1 ? 80 : 90,
                    fontSize: _currentStep == 1 ? 20 : 20,
                    subtitleSize: _currentStep == 1 ? 14 : 16,
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (_currentStep == 1)
                            Step1Form(
                              employeeIdController: _employeeIdController,
                              nameController: _nameController,
                              emailController: _emailController,
                              phoneController: _phoneController,
                              isValid: isStep1Valid,
                              onNext: isStep1Valid
                                  ? () {
                                      setState(() {
                                        _currentStep = 2;
                                      });
                                    }
                                  : null,
                              buttonColor: primaryColor,
                              onFieldChanged: () => setState(() {}),
                            ),
                          if (_currentStep == 2)
                            Step2Form(
                              passwordController: _passwordController,
                              confirmPasswordController: _confirmPasswordController,
                              showPassword: _showPassword,
                              showConfirmPassword: _showConfirmPassword,
                              onTogglePassword: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              onToggleConfirmPassword: () {
                                setState(() {
                                  _showConfirmPassword = !_showConfirmPassword;
                                });
                              },
                              isValid: isStep2Valid,
                              onSignUp: isStep2Valid ? _handleSignUp : null,
                            ),
                          if (_currentStep == 2)
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _currentStep = 1;
                                      });
                                    },
                                    child: const Text(
                                      'back',
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Already have an account?'),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LoginPage(autoFocusId: false),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (_currentStep == 1)
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Already have an account?'),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LoginPage(autoFocusId: false),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FooterImage(),
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  // Widget untuk tampilan desktop/web
  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Row(
            children: [
              // Left side - Background dengan gradient dan logo
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color.fromARGB(255, 255, 0, 85),
                        const Color.fromARGB(255, 233, 30, 99),
                        Colors.pink.shade400,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background pattern
                      Positioned.fill(
                        child: CustomPaint(
                          painter: BackgroundPatternPainter(),
                        ),
                      ),
                      // Content
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo dan branding
                            Container(
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/icons-haus.png',
                                    height: 120,
                                    width: 120,
                                  ),
                                  const SizedBox(height: 24),
                                  RichText(
                                    text: TextSpan(
                                      text: 'HAUS',
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 2,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' Inventory',
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Haus Inventory Management System',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Right side - Register form
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 500,
                        maxHeight: Responsive.getHeight(context) * 0.9,
                      ),
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(48),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Header untuk desktop
                                Column(
                                  children: [
                                    Text(
                                      'Create Account',
                                      style: GoogleFonts.poppins(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 255, 0, 85),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Join our inventory management system',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                
                                // Form register yang lebih modern
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: _buildDesktopRegisterForm(),
                                  ),
                                ),
                                
                                const SizedBox(height: 32),
                                
                                // Divider
                                Row(
                                  children: [
                                    Expanded(child: Divider(color: Colors.grey.shade300)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        'or',
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Divider(color: Colors.grey.shade300)),
                                  ],
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Sign in link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account? ",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(autoFocusId: false),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: const Color.fromARGB(255, 255, 0, 85),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  // Form register khusus desktop yang lebih modern
  Widget _buildDesktopRegisterForm() {
    return Column(
      children: [
        // Step indicator
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _currentStep >= 1 
                    ? const Color.fromARGB(255, 255, 0, 85)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '1',
                  style: TextStyle(
                    color: _currentStep >= 1 ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 2,
                color: _currentStep >= 2 
                    ? const Color.fromARGB(255, 255, 0, 85)
                    : Colors.grey.shade300,
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _currentStep >= 2 
                    ? const Color.fromARGB(255, 255, 0, 85)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '2',
                  style: TextStyle(
                    color: _currentStep >= 2 ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Step content
        if (_currentStep == 1) _buildStep1Form(),
        if (_currentStep == 2) _buildStep2Form(),
      ],
    );
  }

  // Step 1 form untuk desktop
  Widget _buildStep1Form() {
    return Column(
      children: [
        Text(
          'Personal Information',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 24),
        
        // Employee ID field
        _buildDesktopInputField(
          controller: _employeeIdController,
          label: 'Employee ID',
          hint: 'Enter your employee ID',
          icon: Icons.badge_outlined,
        ),
        
        const SizedBox(height: 20),
        
        // Name field
        _buildDesktopInputField(
          controller: _nameController,
          label: 'Full Name',
          hint: 'Enter your full name',
          icon: Icons.person_outline,
        ),
        
        const SizedBox(height: 20),
        
        // Email field
        _buildDesktopInputField(
          controller: _emailController,
          label: 'Email Address',
          hint: 'Enter your email address',
          icon: Icons.email_outlined,
        ),
        
        const SizedBox(height: 20),
        
        // Phone field
        _buildDesktopInputField(
          controller: _phoneController,
          label: 'Phone Number',
          hint: 'Enter your phone number',
          icon: Icons.phone_outlined,
        ),
        
        const SizedBox(height: 32),
        
        // Next button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isStep1Valid 
                  ? const Color.fromARGB(255, 255, 0, 85)
                  : Colors.grey.shade300,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            onPressed: isStep1Valid ? () {
              setState(() {
                _currentStep = 2;
              });
            } : null,
            child: Text(
              'Next Step',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Step 2 form untuk desktop
  Widget _buildStep2Form() {
    return Column(
      children: [
        Text(
          'Account Security',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 24),
        
        // Password field
        _buildDesktopPasswordField(
          controller: _passwordController,
          label: 'Password',
          hint: 'Enter your password',
          isVisible: _showPassword,
          onToggle: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
        ),
        
        const SizedBox(height: 20),
        
        // Confirm password field
        _buildDesktopPasswordField(
          controller: _confirmPasswordController,
          label: 'Confirm Password',
          hint: 'Confirm your password',
          isVisible: _showConfirmPassword,
          onToggle: () {
            setState(() {
              _showConfirmPassword = !_showConfirmPassword;
            });
          },
        ),
        
        const SizedBox(height: 32),
        
        // Back and Sign Up buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 255, 0, 85),
                  side: BorderSide(color: const Color.fromARGB(255, 255, 0, 85)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  setState(() {
                    _currentStep = 1;
                  });
                },
                child: Text(
                  'Back',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isStep2Valid 
                      ? const Color.fromARGB(255, 255, 0, 85)
                      : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: isStep2Valid ? _handleSignUp : null,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Create Account',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper method untuk input field desktop
  Widget _buildDesktopInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.poppins(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color.fromARGB(255, 255, 0, 85),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // Helper method untuk password field desktop
  Widget _buildDesktopPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: GoogleFonts.poppins(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: const Color.fromARGB(255, 255, 0, 85),
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey.shade600,
              size: 20,
            ),
            onPressed: onToggle,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // Loading overlay yang bisa digunakan di mobile dan desktop
  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.78),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/loader.json',
              width: 220,
              height: 220,
              repeat: true,
              animate: true,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 0),
            Text(
              'Processing...',
              style: GoogleFonts.poppins(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.7,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Please wait while we complete your request.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      desktop: _buildDesktopLayout(),
    );
  }
}
