import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/LoginPage.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/ResetPasswordPage.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/OneTimePasswordPage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode(); // Tambahan untuk auto focus
  bool _isLoading = false;
  String? _message;
  bool _success = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  // Warna utama
  final Color primaryColor = const Color.fromARGB(255, 255, 0, 85);

  // Tambahan untuk OTP/token
  bool _emailSent = false;
  List<TextEditingController> _tokenControllers = List.generate(
    4, // Jumlah digit token
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
    _emailFocusNode.dispose(); // dispose focus node
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
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Gagal',
        desc: 'Email tidak boleh kosong!',
        btnOkOnPress: () {},
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Email tidak boleh kosong!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ).show();
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
    });
    if (_success) {
      // Routing ke halaman OTP
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OneTimePasswordPage(
            email: email,
            primaryColor: primaryColor,
            showSuccess: true,
          ),
        ),
      );
    } else {
      _showDialog(_success, _message!);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- Konten utama scrollable ---
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
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
                              const SizedBox(height: 8),
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
                                        color: const Color.fromARGB(
                                          255,
                                          255,
                                          0,
                                          25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Judul & Subjudul
                          Text(
                            'Forget Password',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter your email account to reset password',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 55),
                          // Ilustrasi
                          if (!_emailSent)
                            Lottie.asset(
                              'assets/lottie/MessageSent.json',
                              width: 300,
                              repeat: true,
                              animate: true,
                            ),
                          const SizedBox(height: 10),
                          // Card Form
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.blueGrey,
                                  width: 7,
                                ),
                                top: BorderSide(
                                  color: Colors.blueGrey,
                                  width: 1,
                                ),
                                left: BorderSide(
                                  color: Colors.blueGrey,
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: Colors.blueGrey,
                                  width: 1,
                                ),
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 16,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: !_emailSent
                                ? Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                              _emailFocusNode.requestFocus();
                                            },
                                          );
                                          await showGeneralDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierLabel:
                                                MaterialLocalizations.of(
                                                  context,
                                                ).modalBarrierDismissLabel,
                                            barrierColor: Colors.black54,
                                            transitionDuration: const Duration(
                                              milliseconds: 250,
                                            ),
                                            pageBuilder: (context, anim1, anim2) {
                                              final viewInsets = MediaQuery.of(
                                                context,
                                              ).viewInsets;
                                              final isKeyboardOpen =
                                                  viewInsets.bottom > 0;
                                              return GestureDetector(
                                                behavior:
                                                    HitTestBehavior.opaque,
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Stack(
                                                  children: [
                                                    // Form dialog
                                                    AnimatedPositioned(
                                                      duration: const Duration(
                                                        milliseconds: 250,
                                                      ),
                                                      curve: Curves.easeOut,
                                                      left: 0,
                                                      right: 0,
                                                      // Selalu menempel di atas keyboard
                                                      bottom: viewInsets.bottom,
                                                      child: Center(
                                                        child: GestureDetector(
                                                          onTap:
                                                              () {}, // Supaya tap di form tidak menutup dialog
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                    context,
                                                                  ).size.width,
                                                              constraints:
                                                                  const BoxConstraints(
                                                                    minHeight:
                                                                        180,
                                                                    maxHeight:
                                                                        320,
                                                                  ),
                                                              decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius.vertical(
                                                                      top:
                                                                          Radius.circular(
                                                                            18,
                                                                          ),
                                                                      bottom:
                                                                          Radius.circular(
                                                                            0,
                                                                          ),
                                                                    ),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        0,
                                                                    vertical:
                                                                        18,
                                                                  ),
                                                              child: SingleChildScrollView(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            20,
                                                                      ),
                                                                      child: Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          const Text(
                                                                            'Masukkan Email Anda',
                                                                            style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                16,
                                                                          ),
                                                                          TextField(
                                                                            controller:
                                                                                _emailController,
                                                                            focusNode:
                                                                                _emailFocusNode,
                                                                            keyboardType:
                                                                                TextInputType.emailAddress,
                                                                            autofocus:
                                                                                true,
                                                                            decoration: InputDecoration(
                                                                              prefixIcon: const Icon(
                                                                                Icons.email_outlined,
                                                                                color: Colors.pinkAccent,
                                                                              ),
                                                                              hintText: 'Enter your email',
                                                                              border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(
                                                                                  14,
                                                                                ),
                                                                                borderSide: const BorderSide(
                                                                                  color: Colors.pinkAccent,
                                                                                ),
                                                                              ),
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(
                                                                                  14,
                                                                                ),
                                                                                borderSide: const BorderSide(
                                                                                  color: Colors.pinkAccent,
                                                                                  width: 2,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                48,
                                                                            child: ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: const Color.fromARGB(
                                                                                  255,
                                                                                  255,
                                                                                  0,
                                                                                  85,
                                                                                ),
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(
                                                                                    12,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              onPressed: _isLoading
                                                                                  ? null
                                                                                  : () async {
                                                                                      Navigator.of(
                                                                                        context,
                                                                                      ).pop();
                                                                                      await _submit();
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
                                            },
                                          );
                                        }, // end onTap
                                        borderRadius: BorderRadius.circular(14),
                                        child: Container(
                                          width: double.infinity,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            color: Colors.white,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.email_outlined,
                                                color: Colors.pinkAccent,
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  _emailController.text.isEmpty
                                                      ? 'Enter your email'
                                                      : _emailController.text,
                                                  style: TextStyle(
                                                    color:
                                                        _emailController
                                                            .text
                                                            .isEmpty
                                                        ? Colors.grey
                                                        : Colors.black87,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // Tombol Cancel tetap
                                      SizedBox(
                                        width: double.infinity,
                                        height: 48,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage(),
                                            ),
                                          ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      // Tombol Cancel tetap
                                      SizedBox(
                                        width: double.infinity,
                                        height: 48,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () =>
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginPage(),
                                                ),
                                              ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54,
                                              fontSize: 16,
                                            ),
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
            },
          ),
          // Overlay loading, selalu di root Stack
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
