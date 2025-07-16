import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/ResetPasswordPage.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class OneTimePasswordPage extends StatefulWidget {
  final String email;
  final Color primaryColor;
  final bool showSuccess;
  const OneTimePasswordPage({
    required this.email,
    this.primaryColor = const Color.fromARGB(255, 255, 0, 85),
    this.showSuccess = false,
    Key? key,
  }) : super(key: key);

  @override
  State<OneTimePasswordPage> createState() => _OneTimePasswordPageState();
}

class _OneTimePasswordPageState extends State<OneTimePasswordPage> {
  String _otp = "";
  bool _isLoading = false;
  String? _errorMessage;
  bool _showingSuccessDialog = false;

  // Untuk resend OTP
  bool _isResending = false;
  int _resendCooldown = 0;

  void _onOtpChanged(String otp) {
    setState(() {
      _otp = otp;
    });
  }

  void _showDialog(bool success, String message, {VoidCallback? onOk}) {
    AwesomeDialog(
      context: context,
      dialogType: success ? DialogType.success : DialogType.error,
      animType: AnimType.rightSlide,
      title: success ? 'Berhasil' : 'Gagal',
      desc: message,
      btnOkOnPress: onOk ?? () {},
      dismissOnTouchOutside: false,
    ).show();
  }

  void _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final result = await AuthService().verifyOtp(
      email: widget.email,
      token: _otp,
    );
    setState(() {
      _isLoading = false;
    });
    if (result['status'] == true) {
      _showDialog(
        true,
        result['message'] ?? 'OTP valid',
        onOk: () {
          setState(() {
            _showingSuccessDialog = false;
          });
        },
      );
      await Future.delayed(const Duration(milliseconds: 800));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResetPasswordPage(email: widget.email, token: _otp),
        ),
      );
    } else {
      _showDialog(false, result['message'] ?? 'Kode OTP tidak valid.');
    }
  }

  void _resendOtp() async {
    setState(() {
      _isResending = true;
    });
    final result = await AuthService().resendOtp(widget.email);
    setState(() {
      _isResending = false;
      _resendCooldown = 60; // Ubah ke 60 detik
    });
    _showDialog(
      result['status'] == true,
      result['message'] ?? 'Gagal mengirim ulang kode OTP.',
    );
    // Mulai timer cooldown
    if (_resendCooldown > 0) {
      _startResendCooldown();
    }
  }

  void _startResendCooldown() {
    Future.doWhile(() async {
      if (_resendCooldown > 0) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          setState(() {
            _resendCooldown--;
          });
        }
        return _resendCooldown > 0;
      }
      return false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.showSuccess) {
      _showingSuccessDialog = true;
      Future.delayed(Duration.zero, () {
        _showDialog(
          true,
          'Kode OTP berhasil dikirim ke email Anda!',
          onOk: () {
            setState(() {
              _showingSuccessDialog = false;
            });
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Konten utama scrollable
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Padding(
              padding: const EdgeInsets.only(top: 64, left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 24),
                  // Judul & Subjudul
                  const Text(
                    'Verifikasi OTP',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 14),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'We have send a code to ',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Colors.black54,
                      ),
                      children: [
                        TextSpan(
                          text: widget.email,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 0, 85),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 45),
                  // OTP Field
                  _OtpField(
                    length: 4,
                    enabled: !_isLoading && !_showingSuccessDialog,
                    onChanged: _onOtpChanged,
                    primaryColor: widget.primaryColor,
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Tombol di bawah layar
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (_isLoading || _otp.length < 4)
                            ? Colors.grey
                            : widget.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _isLoading || _otp.length < 4
                          ? null
                          : _verifyOtp,
                      child: const Text(
                        'Verifikasi Kode',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Resend area ala gambar
                  Builder(
                    builder: (context) {
                      if (_resendCooldown > 0) {
                        return Text(
                          "Resend in ${_resendCooldown}s",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Didn't you receive any code? ",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: (_isResending || _isLoading)
                                  ? null
                                  : _resendOtp,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: _isResending
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              widget.primaryColor,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      "Resend Code",
                                      style: TextStyle(
                                        color: widget.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          // Loading overlay
      if (_isLoading)
            Positioned.fill(
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
            ),
        ],
      ),
    );
  }
}

class _OtpField extends StatefulWidget {
  final int length;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final Color primaryColor;
  const _OtpField({
    this.length = 4,
    required this.onChanged,
    this.enabled = true,
    this.primaryColor = const Color.fromARGB(255, 255, 0, 85),
    Key? key,
  }) : super(key: key);

  @override
  State<_OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<_OtpField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<bool> _isFocused;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _isFocused = List.generate(widget.length, (_) => false);
    for (int i = 0; i < widget.length; i++) {
      _focusNodes[i].addListener(() {
        setState(() {
          _isFocused[i] = _focusNodes[i].hasFocus;
        });
      });
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(int idx, String val) {
    if (val.length == 1 && idx < widget.length - 1) {
      _focusNodes[idx + 1].requestFocus();
    } else if (val.isEmpty && idx > 0) {
      _focusNodes[idx - 1].requestFocus();
    }
    final otp = _controllers.map((c) => c.text).join();
    widget.onChanged(otp);
    // Tambahan: Tutup keyboard jika semua field sudah terisi
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.length, (i) {
          final isFilled = _controllers[i].text.isNotEmpty;
          final isFocused = _isFocused[i];
          return AnimatedScale(
            scale: isFocused ? 1.12 : 1.0,
            duration: const Duration(milliseconds: 160),
            child: Container(
              width: 72,
              height: 56,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isFocused
                        ? widget.primaryColor.withOpacity(0.18)
                        : Colors.grey.withOpacity(0.08),
                    blurRadius: isFocused ? 16 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: isFocused ? widget.primaryColor : Colors.grey.shade300,
                  width: isFocused ? 2.2 : 1.2,
                ),
              ),
              child: Center(
                child: Focus(
                  onKey: (node, event) {
                    if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.backspace &&
                        _controllers[i].text.isEmpty &&
                        i > 0) {
                      _focusNodes[i - 1].requestFocus();
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: TextField(
                    controller: _controllers[i],
                    focusNode: _focusNodes[i],
                    enabled: widget.enabled,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.primaryColor,
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (val) => _onChanged(i, val),
                    onTap: () {
                      _controllers[i].selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _controllers[i].text.length,
                      );
                    },
                    onSubmitted: (_) {},
                    onEditingComplete: () {},
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
