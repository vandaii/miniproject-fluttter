import 'package:awesome_dialog/awesome_dialog.dart'
    show AwesomeDialog, DialogType, AnimType;
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/ForgetPasswordPage.dart';
import 'package:miniproject_flutter/services/authService.dart';

// Widget ResetPasswordPage yang menerima email & token
class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String token;
  final Color primaryColor = Color.fromARGB(255, 255, 0, 85);

  ResetPasswordPage({required this.email, required this.token, Key? key})
    : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  String? _message;
  bool _success = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  // Tambahkan variabel untuk menyimpan sementara password dan confirm password
  String? _tempPassword;
  String? _tempConfirmPassword;

  Future<void> _submit() async {
    // Sembunyikan keyboard
    FocusScope.of(context).unfocus();

    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _message = 'Semua field wajib diisi!';
        _success = false;
      });
      _showDialog(_success, _message!);
      return;
    }
    if (password != confirmPassword) {
      setState(() {
        _message = 'Password tidak sama!';
        _success = false;
      });
      _showDialog(_success, _message!);
      return;
    }
    setState(() {
      _isLoading = true;
      _message = null;
    });
    final result = await AuthService().resetPassword(
      email: widget.email,
      token: widget.token,
      password: password,
      passwordConfirmation: confirmPassword,
    );
    setState(() {
      _isLoading = false;
      _message = result['message'];
      _success = result['status'] == true;
    });
    _showDialog(_success, _message!);
    if (_success) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    }
  }

  void _showDialog(bool success, String message) {
    AwesomeDialog(
      context: context,
      dialogType: success ? DialogType.success : DialogType.error,
      animType: AnimType.rightSlide,
      title: success ? 'Berhasil' : 'Gagal',
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }

  // Fungsi untuk menampilkan dialog input password/confirm password dengan AwesomeDialog
  Future<void> _showPasswordDialog({required bool isConfirm}) async {
    final TextEditingController controller = TextEditingController(
      text: isConfirm
          ? _confirmPasswordController.text
          : _passwordController.text,
    );
    bool isVisible = false;
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      dismissOnTouchOutside: true,
      body: StatefulBuilder(
        builder: (context, setStateDialog) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isConfirm ? 'Konfirmasi Password Baru' : 'Password Baru',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  obscureText: !isVisible,
                  autofocus: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color:widget.primaryColor,
                    ),
                    hintText: isConfirm
                        ? 'Konfirmasi password'
                        : 'Password baru',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:widget.primaryColor == Colors.transparent
                          ? BorderSide.none
                          : BorderSide(color: widget.primaryColor, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colors.pinkAccent,
                        width: 2,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setStateDialog(() {
                          isVisible = !isVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 0, 85),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (isConfirm) {
                        setState(() {
                          _confirmPasswordController.text = controller.text;
                        });
                      } else {
                        setState(() {
                          _passwordController.text = controller.text;
                        });
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromARGB(255, 255, 0, 85);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Konten utama scrollable dibungkus LayoutBuilder
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                reverse: true,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        // Logo dan Judul
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/icons-haus.png',
                              width: 55,
                              height: 55,
                            ),
                            const SizedBox(width: 8),
                            RichText(
                              text: TextSpan(
                                text: 'Haus',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' Inventory',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 255, 0, 85),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Judul besar dan subjudul
                        const Text(
                          'Reset Your Password',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'The password must be different than before',
                          style: TextStyle(fontSize: 15, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 36),
                        // Lottie animasi verification
                        Lottie.asset(
                          'assets/lottie/PasswordAuthentication.json',
                          width: 170,
                          height: 170,
                          repeat: true,
                          animate: true,
                        ),
                        const SizedBox(height: 36),
                        // Form input
                        Container(
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // InkWell untuk password
                              InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () =>
                                    _showPasswordDialog(isConfirm: false),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.lock_outline,
                                        color: Colors.pinkAccent,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          _passwordController.text.isEmpty
                                              ? 'New password'
                                              : '••••••••',
                                          style: TextStyle(
                                            color:
                                                _passwordController.text.isEmpty
                                                ? Colors.grey
                                                : Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.edit,
                                        color: Colors.pinkAccent,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // InkWell untuk confirm password
                              InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () =>
                                    _showPasswordDialog(isConfirm: true),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.lock_outline,
                                        color: Colors.pinkAccent,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          _confirmPasswordController
                                                  .text
                                                  .isEmpty
                                              ? 'Confirm password'
                                              : '••••••••',
                                          style: TextStyle(
                                            color:
                                                _confirmPasswordController
                                                    .text
                                                    .isEmpty
                                                ? Colors.grey
                                                : Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.edit,
                                        color: Colors.pinkAccent,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: Colors.pinkAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'password must be at least 8 characters long',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Tombol sticky di bawah layar, tidak naik saat keyboard muncul
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 0, 85),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _isLoading ? null : _submit,
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgetPasswordPage(),
                                ),
                              );
                            },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Loading overlay menutupi seluruh layar
          if (_isLoading)
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.48), // overlay lebih gelap
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 56,
                  ), // padding lebih proporsional
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      38,
                    ), // border radius lebih besar
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 22,
                        sigmaY: 22,
                      ), // blur lebih nyata
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(
                          maxWidth: 370,
                          minHeight: 260,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 36,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.22),
                              Colors.white.withOpacity(0.10),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(38),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.28),
                            width: 1.6,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.13),
                              blurRadius: 48,
                              offset: Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Inner shadow effect (simulasi)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(38),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withOpacity(0.08),
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.04),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/lottie/loader.json',
                                  width: 150,
                                  height: 150,
                                  repeat: true,
                                  animate: true,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 24),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
