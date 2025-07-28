import 'package:flutter/material.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/RegisterPage.dart';
import 'package:miniproject_flutter/screens/DashboardPage.dart';
import 'package:miniproject_flutter/widgets/Login/HeaderForLogin.dart';
import 'package:miniproject_flutter/widgets/Login/FormLogin.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/ForgetPasswordPage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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

class LoginPage extends StatefulWidget {
  final String? initialId;
  final String? initialPassword;
  final bool autoFocusId;

  const LoginPage({
    super.key,
    this.initialId,
    this.initialPassword,
    this.autoFocusId = false,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _rememberMe = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _autoFocusId = false;

  @override
  void initState() {
    super.initState();
    _autoFocusId = widget.autoFocusId;
    _loadRememberedCredentials();
    _idController.addListener(_handleInputFocusLost);
    _passwordController.addListener(_handleInputFocusLost);
  }

  void _loadRememberedCredentials() async {
    final credentials = await AuthService().getRememberedCredentials();
    final loginId = credentials['loginId'];
    final password = credentials['password'];

    if (mounted) {
      if (loginId != null && password != null) {
        setState(() {
          _idController.text = loginId;
          _passwordController.text = password;
          _rememberMe = true;
          _autoFocusId = false;
        });
      } else {
        _idController.text = widget.initialId ?? '';
        _passwordController.text = widget.initialPassword ?? '';
        _autoFocusId = widget.autoFocusId;
      }
    }
  }

  void _handleInputFocusLost() {
    if (!FocusScope.of(context).hasFocus) {
      if (mounted && _autoFocusId) {
        setState(() {
          _autoFocusId = false;
        });
      }
      // Unfocus semua field agar tampilan kembali ke posisi awal
      _idFocusNode.unfocus();
      _passwordFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _idController.removeListener(_handleInputFocusLost);
    _passwordController.removeListener(_handleInputFocusLost);
    _idController.dispose();
    _passwordController.dispose();
    _idFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void showSweetAlert(
    BuildContext context,
    String title,
    String desc,
    DialogType type, {
    VoidCallback? onOk,
    String? lottieAsset, 
  }) {
    AwesomeDialog(
      context: context,
      dialogType: lottieAsset != null ? DialogType.noHeader : type,
      animType: AnimType.rightSlide,
      title: title,
      desc: desc,
      body: lottieAsset != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  lottieAsset,
                  width: 120,
                  height: 120,
                  repeat: true,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : null,
      btnOkOnPress: () {
        FocusScope.of(context).unfocus();
        if (onOk != null) onOk();
      },
    ).show();
  }

  // Widget untuk tampilan mobile
  Widget _buildMobileLayout() {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                HeaderForLogin(),
                const SizedBox(height: 60),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FormLogin(
                      idController: _idController,
                      idFocusNode: _idFocusNode,
                      passwordController: _passwordController,
                      passwordFocusNode: _passwordFocusNode,
                      autoFocusId: _autoFocusId,
                      isPasswordVisible: _isPasswordVisible,
                      onPasswordToggle: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      rememberMe: _rememberMe,
                      onRememberMeChanged: (val) =>
                          setState(() => _rememberMe = val!),
                      isLoading: _isLoading,
                      onLoginPressed: _handleLogin,
                      onForgetPasswordPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetPasswordPage(),
                          ),
                        );
                      },
                      onSignUpPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                if (!keyboardVisible)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Image.asset(
                      'assets/images/icons-logoDekoration.png',
                      width: double.infinity,
                      height: 140,
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
              ],
            ),
          ),
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
              
              // Right side - Login form
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 450,
                        maxHeight: Responsive.getHeight(context) * 0.8,
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
                                      'Welcome Back',
                                      style: GoogleFonts.poppins(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 255, 0, 85),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Sign in to your account',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                
                                // Form login yang lebih modern
                                _buildDesktopLoginForm(),
                                
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
                                
                                // Sign up link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account? ",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const RegisterPage(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Sign Up',
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

  // Form login khusus desktop yang lebih modern
  Widget _buildDesktopLoginForm() {
    return Column(
      children: [
        // Email/ID field
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: TextField(
            controller: _idController,
            focusNode: _idFocusNode,
            autofocus: _autoFocusId,
            style: GoogleFonts.poppins(fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Employee ID / Email / Phone',
              labelStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
              hintText: 'Enter your credentials',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.person_outline,
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
        ),
        
        const SizedBox(height: 20),
        
        // Password field
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: TextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            obscureText: !_isPasswordVisible,
            style: GoogleFonts.poppins(fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
              hintText: 'Enter your password',
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
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Remember me dan forgot password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (val) => setState(() => _rememberMe = val!),
                  activeColor: const Color.fromARGB(255, 255, 0, 85),
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Text(
                  'Remember me',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgetPasswordPage(),
                  ),
                );
              },
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 255, 0, 85),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Login button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 0, 85),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              shadowColor: const Color.fromARGB(255, 255, 0, 85).withOpacity(0.3),
            ),
            onPressed: _isLoading ? null : _handleLogin,
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Sign In',
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

  // Handle login logic
  void _handleLogin() async {
    final id = _idController.text.trim();
    final password = _passwordController.text;

    if (id.isEmpty || password.isEmpty) {
      showSweetAlert(
        context,
        "Gagal",
        "Silakan isi ID dan Password.",
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
          lottieAsset: 'assets/lottie/error404.json',
        );
        return;
      }

      final authService = AuthService();
      final isLoggedIn = await authService.login(
        id,
        password,
        _rememberMe,
      );
      
      if (isLoggedIn) {
        // Simpan credentials jika remember me dicentang
        await authService.saveCredentials(id, password, _rememberMe);
        
        showSweetAlert(
          context,
          "Sukses",
          "Login berhasil!",
          DialogType.success,
        );
        Future.delayed(
          const Duration(milliseconds: 900),
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  var selectedIndex = 0;
                  return DashboardPage(
                    selectedIndex: selectedIndex,
                  );
                },
              ),
            );
          },
        );
      } else {
        showSweetAlert(
          context,
          "Login Gagal",
          "ID atau Password salah.",
          DialogType.error,
          lottieAsset: 'assets/lottie/failedinput.json',
        );
      }
    } catch (e) {
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_autoFocusId) {
      // Setelah build pertama, matikan autoFocus agar keyboard tidak auto muncul lagi
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) setState(() => _autoFocusId = false);
      });
    }
  }
}
