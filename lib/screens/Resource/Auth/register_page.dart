import 'package:flutter/material.dart';
import 'package:miniproject_flutter/services/authService.dart';
import 'package:miniproject_flutter/widgets/customPageRegister.dart';

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
                                child: buildTextField(
                                  label: 'Employee ID',
                                  icon: Icons.badge,
                                  controller: _employeeIdController,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: buildTextField(
                                  label: 'Full Name',
                                  icon: Icons.person,
                                  controller: _nameController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextField(
                                  label: 'Email',
                                  icon: Icons.email,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: buildTextField(
                                  label: 'Phone Number',
                                  icon: Icons.phone,
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextField(
                                  label: 'Password',
                                  icon: Icons.lock,
                                  controller: _passwordController,
                                  obscureText: !_showPassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      color: const Color.fromARGB(
                                        255,
                                        19,
                                        25,
                                        90,
                                      ),
                                      _showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () => setState(() {
                                      _showPassword = !_showPassword;
                                    }),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: buildTextField(
                                  label: 'Confirm Password',
                                  icon: Icons.lock,
                                  controller: _confirmPasswordController,
                                  obscureText: !_showConfirmPassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      color: const Color.fromARGB(
                                        255,
                                        19,
                                        25,
                                        90,
                                      ),
                                      _showConfirmPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () => setState(() {
                                      _showConfirmPassword =
                                          !_showConfirmPassword;
                                    }),
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
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Silakan isi semua field',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }

                                      if (password != confirmPassword) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Password tidak cocok',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
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
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Registrasi berhasil',
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                            Navigator.pop(context);
                                          }
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                e.toString().replaceFirst(
                                                  "Exception: ",
                                                  "",
                                                ),
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
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
                                onPressed: () => Navigator.pop(context),
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
        ],
      ),
    );
  }
}
