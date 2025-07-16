import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:miniproject_flutter/widgets/customPageRegister.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/loginPage.dart';

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

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

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

  // Fungsi reusable untuk dialog input
  Future<void> _showInputDialog({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) async {
    final tempController = TextEditingController(text: controller.text);
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        final viewInsets = MediaQuery.of(context).viewInsets;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                left: 0,
                right: 0,
                bottom: viewInsets.bottom,
                child: Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        constraints: const BoxConstraints(minHeight: 180, maxHeight: 320),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Masukkan $label',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: tempController,
                              autofocus: true,
                              obscureText: isPassword,
                              keyboardType: keyboardType,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                hintText: 'Enter $label',
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  controller.text = tempController.text;
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Simpan',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ],
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
  }

  @override
  Widget build(BuildContext context) {
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
                  HeaderWithLogo(),

                  const SizedBox(height: 40),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _showInputDialog(
                                    label: 'Employee ID',
                                    controller: _employeeIdController,
                                  ),
                                  child: AbsorbPointer(
                                    child: buildTextField(
                                      label: 'Employee ID',
                                      icon: Icons.badge,
                                      controller: _employeeIdController,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _showInputDialog(
                                    label: 'Full Name',
                                    controller: _nameController,
                                  ),
                                  child: AbsorbPointer(
                                    child: buildTextField(
                                      label: 'Full Name',
                                      icon: Icons.person,
                                      controller: _nameController,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _showInputDialog(
                                    label: 'Email',
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  child: AbsorbPointer(
                                    child: buildTextField(
                                      label: 'Email',
                                      icon: Icons.email,
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _showInputDialog(
                                    label: 'Phone Number',
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                  ),
                                  child: AbsorbPointer(
                                    child: buildTextField(
                                      label: 'Phone Number',
                                      icon: Icons.phone,
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _showInputDialog(
                                    label: 'Password',
                                    controller: _passwordController,
                                    isPassword: true,
                                  ),
                                  child: AbsorbPointer(
                                    child: buildTextField(
                                      label: 'Password',
                                      icon: Icons.lock,
                                      controller: _passwordController,
                                      obscureText: !_showPassword,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          color: const Color.fromARGB(255, 19, 25, 90),
                                          _showPassword ? Icons.visibility : Icons.visibility_off,
                                        ),
                                        onPressed: () => setState(() {
                                          _showPassword = !_showPassword;
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _showInputDialog(
                                    label: 'Confirm Password',
                                    controller: _confirmPasswordController,
                                    isPassword: true,
                                  ),
                                  child: AbsorbPointer(
                                    child: buildTextField(
                                      label: 'Confirm Password',
                                      icon: Icons.lock,
                                      controller: _confirmPasswordController,
                                      obscureText: !_showConfirmPassword,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          color: const Color.fromARGB(255, 19, 25, 90),
                                          _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                        ),
                                        onPressed: () => setState(() {
                                          _showConfirmPassword = !_showConfirmPassword;
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      final employeeId = _employeeIdController
                                          .text
                                          .trim();
                                      final name = _nameController.text.trim();
                                      final email = _emailController.text
                                          .trim();
                                      final phone = _phoneController.text
                                          .trim();
                                      final password = _passwordController.text;
                                      final confirmPassword =
                                          _confirmPasswordController.text;

                                      if (employeeId.isEmpty ||
                                          name.isEmpty ||
                                          email.isEmpty ||
                                          phone.isEmpty ||
                                          password.isEmpty ||
                                          confirmPassword.isEmpty) {
                                        showSweetAlert(
                                          context,
                                          "Gagal",
                                          "Silakan isi semua field",
                                          DialogType.error,
                                        );
                                        return;
                                      }

                                      if (password != confirmPassword) {
                                        showSweetAlert(
                                          context,
                                          "Gagal",
                                          "Password tidak cocok",
                                          DialogType.error,
                                        );
                                        return;
                                      }

                                      setState(() {
                                        _isLoading = true;
                                      });

                                      try {
                                        bool isRegistered = await AuthService()
                                            .register(
                                              employeeId: employeeId,
                                              name: name,
                                              email: email,
                                              phone: phone,
                                              password: password,
                                              confirmedPassword:
                                                  confirmPassword,
                                              storeLocation: '1',
                                            );

                                        if (isRegistered) {
                                          if (mounted) {
                                            showSweetAlert(
                                              context,
                                              "Sukses",
                                              "Registrasi berhasil",
                                              DialogType.success,
                                              onOk: () {
                                                Navigator.of(
                                                  context,
                                                ).pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage(),
                                                  ),
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
                                          if (e
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(
                                                    "failed host lookup",
                                                  ) ||
                                              e
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(
                                                    "socketexception",
                                                  )) {
                                            showSweetAlert(
                                              context,
                                              "Gagal Terhubung",
                                              "Tidak dapat terhubung ke server.",
                                              DialogType.warning,
                                            );
                                          } else {
                                            showSweetAlert(
                                              context,
                                              "Error",
                                              e.toString().replaceFirst(
                                                "Exception: ",
                                                "",
                                              ),
                                              DialogType.error,
                                            );
                                          }
                                        }
                                      } finally {
                                        if (mounted) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Sudah punya akun?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(autoFocusId: false),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(color: Colors.pink),
                                ),
                              ),
                            ],
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
