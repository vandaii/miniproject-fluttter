import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:ui';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;
  bool _success = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // Tambahan untuk OTP/token
  bool _emailSent = false;
  List<TextEditingController> _tokenControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  FocusNode? _firstTokenFocus;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
    _firstTokenFocus = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    for (var c in _tokenControllers) {
      c.dispose();
    }
    _firstTokenFocus?.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Sembunyikan keyboard
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _message = 'Email tidak boleh kosong!';
        _success = false;
      });
      _showDialog(_success, _message!);
      return;
    }
    setState(() {
      _isLoading = true;
      _message = null;
    });
    final result = await AuthService().forgotPassword(email);
    setState(() {
      _isLoading = false;
      _message = result['message'];
      _success = result['status'] == true;
      if (_success) {
        _emailSent = true;
        // Jangan requestFocus otomatis ke OTP, biarkan user klik sendiri
        // Future.delayed(const Duration(milliseconds: 300), () {
        //   _firstTokenFocus?.requestFocus();
        // });
      }
    });
    _showDialog(_success, _message!);
  }

  void _showDialog(bool success, String message, {String? lottieOverride}) {
    // Bersihkan pesan error agar user friendly
    String displayMessage = message;
    String lottieAsset = lottieOverride ?? '';

    if (message.toLowerCase().contains('formatexception') ||
        message.toLowerCase().contains('<!doctype') ||
        message.toLowerCase().contains('gagal menghubungkan') ||
        message.toLowerCase().contains('unexpected character')) {
      displayMessage =
          'Tidak dapat menghubungkan ke server. Silakan coba lagi nanti.';
      lottieAsset = 'assets/lottie/error404.json';
    } else if (message.toLowerCase().contains('not found') ||
        message.toLowerCase().contains('tidak ditemukan') ||
        message.toLowerCase().contains(
          'kode tidak valid atau sudah digunakan',
        )) {
      displayMessage =
          'Data yang kamu masukkan tidak ditemukan atau kode tidak valid.';
      lottieAsset = 'assets/lottie/failedinput.json';
    } else if (success) {
      lottieAsset = 'assets/lottie/success.json';
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (lottieAsset.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Lottie.asset(
                    lottieAsset,
                    width: 80,
                    repeat: true, // selalu repeat
                    animate: true,
                  ),
                ),
              Text(
                success ? 'Berhasil' : 'Gagal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: success ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                displayMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onTokenChanged(int idx, String value) {
    if (value.length == 1 && idx < 5) {
      FocusScope.of(context).nextFocus();
    } else if (value.isEmpty && idx > 0) {
      FocusScope.of(context).previousFocus();
    }
  }

  void _verifyToken() async {
    // Sembunyikan keyboard
    FocusScope.of(context).unfocus();

    final token = _tokenControllers.map((c) => c.text).join();
    if (token.length < 6) {
      setState(() {
        _message = 'Kode token harus 6 digit!';
        _success = false;
      });
      _showDialog(
        false,
        'Kode token harus 6 digit.',
        lottieOverride: 'assets/lottie/failedinput.json',
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    // Validasi OTP ke backend
    final result = await AuthService().verifyOtp(
      email: _emailController.text.trim(),
      token: token,
    );
    setState(() {
      _isLoading = false;
    });
    if (result['status'] == true) {
      // OTP valid, lanjut ke reset password
      _showDialog(
        true,
        result['message'] ?? 'OTP valid',
        lottieOverride: 'assets/lottie/success.json',
      );
      await Future.delayed(const Duration(milliseconds: 800));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordPageWithArgs(
            email: _emailController.text.trim(),
            token: token,
          ),
        ),
      );
    } else {
      // OTP tidak valid
      _showDialog(
        false,
        result['message'] ?? 'Kode token tidak valid.',
        lottieOverride: 'assets/lottie/failedinput.json',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      appBar: AppBar(
        title: const Text('Lupa Password'),
        backgroundColor: const Color.fromARGB(255, 233, 30, 99),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Lottie.asset(
                      !_emailSent
                          ? 'assets/lottie/email.json'
                          : 'assets/lottie/PasswordAuthentication.json',
                      width: !_emailSent ? 140 : 90,
                      repeat: true,
                      animate: true,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.pinkAccent.withOpacity(0.2),
                      ),
                    ),
                    child: !_emailSent
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Enter your registered email to reset your password.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Colors.pinkAccent,
                                  ),
                                  labelText: 'Email',
                                  labelStyle: const TextStyle(
                                    color: Colors.pinkAccent,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: Colors.pinkAccent,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Colors.pinkAccent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pinkAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                onPressed: _isLoading ? null : _submit,
                                child: const Text(
                                  'Send Reset Link',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Enter the 6 digit token code sent to your email.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(6, (i) {
                                  return SizedBox(
                                    width: 44,
                                    child: TextField(
                                      controller: _tokenControllers[i],
                                      focusNode: i == 0
                                          ? _firstTokenFocus
                                          : null,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      maxLength: 1,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.pinkAccent,
                                      ),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.pinkAccent
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.pinkAccent,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      onChanged: (val) =>
                                          _onTokenChanged(i, val),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pinkAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                onPressed: _verifyToken,
                                child: const Text(
                                  'Verifycation Reset Token',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16,
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
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5), // full opacity overlay
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(
                          'assets/lottie/loader.json',
                          width: 80,
                          height: 80,
                          repeat: true,
                          animate: true,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Memproses...',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
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

class _ModernButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onTap;
  const _ModernButton({
    required this.text,
    required this.icon,
    // ignore: unused_element_parameter
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<_ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<_ModernButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _scale = 0.96);
      },
      onTapUp: (_) {
        setState(() => _scale = 1.0);
      },
      onTapCancel: () {
        setState(() => _scale = 1.0);
      },
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF06292), Color(0xFFE91E63)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.pinkAccent.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            height: 54,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: Colors.white, size: 26),
                const SizedBox(width: 10),
                Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontFamily: 'Roboto',
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

// Widget pengganti ResetPasswordPage agar bisa menerima email & token
class ResetPasswordPageWithArgs extends StatelessWidget {
  final String email;
  final String token;
  const ResetPasswordPageWithArgs({
    required this.email,
    required this.token,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResetPasswordPageWithPrefill(email: email, token: token);
  }
}

// Widget ResetPasswordPage yang menerima email & token
class ResetPasswordPageWithPrefill extends StatefulWidget {
  final String email;
  final String token;
  const ResetPasswordPageWithPrefill({
    required this.email,
    required this.token,
    Key? key,
  }) : super(key: key);

  @override
  State<ResetPasswordPageWithPrefill> createState() =>
      _ResetPasswordPageWithPrefillState();
}

class _ResetPasswordPageWithPrefillState
    extends State<ResetPasswordPageWithPrefill> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  String? _message;
  bool _success = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FF),
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animasi Lottie di atas form
                  // (Bisa tambahkan animasi jika ingin)
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.85),
                          Colors.pink.shade50.withOpacity(0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.shade100.withOpacity(0.18),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      backgroundBlendMode: BlendMode.overlay,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Masukkan password baru Anda',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            labelText: 'Password Baru',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Colors.pinkAccent,
                                width: 2,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            labelText: 'Konfirmasi Password',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Colors.pinkAccent,
                                width: 2,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _isLoading ? null : _submit,
                            child: const Text('Reset Password'),
                          ),
                        ),
                        if (_message != null) ...[
                          // Feedback diganti ke SweetAlert, tidak perlu widget di sini
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Loading overlay dengan Lottie untuk ResetPasswordPage
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(
                          'assets/lottie/loader.json',
                          width: 120,
                          height: 120,
                          repeat: true,
                          animate: true,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Memproses...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
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
