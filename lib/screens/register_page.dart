import 'package:flutter/material.dart';
import 'package:miniproject_flutter/widgets/custom_page_register.dart'; // Mengimpor HeaderWithLogo dan buildTextField

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                  // Menggunakan HeaderWithLogo di sini
                  HeaderWithLogo(),
                  const SizedBox(height: 40),

                  // Form Input
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: buildTextField(
                                  // Panggil fungsi buildTextField
                                  label: 'Employee ID',
                                  icon: Icons.badge,
                                  controller: _employeeIdController,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: buildTextField(
                                  // Panggil fungsi buildTextField
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
                                  // Panggil fungsi buildTextField
                                  label: 'Email',
                                  icon: Icons.email,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: buildTextField(
                                  // Panggil fungsi buildTextField
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
                                  // Panggil fungsi buildTextField
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
                                  // Panggil fungsi buildTextField
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
                          // Tombol Sign Up
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Todo: Handle register logic
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
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
                              const Text('Already have an account?'),
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
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: IgnorePointer(
          //     child: Image.asset(
          //       'assets/images/icons-logoDekoration.png',
          //       width: size.width,
          //       height: 115,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
