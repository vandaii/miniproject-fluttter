import 'package:flutter/material.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/register_page.dart';
import 'package:miniproject_flutter/screens/DashboardPage.dart';
import 'package:miniproject_flutter/widgets/Login/HeaderForLogin.dart';
import 'package:miniproject_flutter/widgets/Login/FormLogin.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/ForgetPasswordPage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

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

  @override
  Widget build(BuildContext context) {
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
                      onLoginPressed: () async {
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
                          final isLoggedIn = await AuthService().login(
                            id,
                            password,
                            _rememberMe,
                          );
                          if (isLoggedIn) {
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
                          if (e.toString().toLowerCase().contains(
                                "failed host lookup",
                              ) ||
                              e.toString().toLowerCase().contains(
                                "socketexception",
                              )) {
                            showSweetAlert(
                              context,
                              "Gagal Terhubung",
                              "Tidak dapat terhubung ke server.",
                              DialogType.warning,
                              lottieAsset: 'assets/lottie/error404.json',
                            );
                          } else {
                            showSweetAlert(
                              context,
                              "Error",
                              e.toString().replaceFirst("Exception: ", ""),
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
                      },
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
