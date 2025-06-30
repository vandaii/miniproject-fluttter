import 'package:flutter/material.dart';
import 'package:miniproject_flutter/screens/Resource/Auth/register_page.dart';
import 'package:miniproject_flutter/screens/DashboardPage.dart';
import 'package:miniproject_flutter/widgets/CustomPage_Login.dart';
import 'package:miniproject_flutter/services/authService.dart';

class LoginPage extends StatefulWidget {
  final String? initialId;
  final String? initialPassword;

  const LoginPage({super.key, this.initialId, this.initialPassword});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _idController.text = widget.initialId ?? '';
    _passwordController.text = widget.initialPassword ?? '';
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const LogoSection(),
            const SizedBox(height: 60),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LoginForm(
                  idController: _idController,
                  passwordController: _passwordController,
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Silakan isi ID dan Password.'),
                          backgroundColor: Colors.red,
                        ),
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
                      );
                      if (isLoggedIn) {
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
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.toString().replaceFirst("Exception: ", ""),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  onForgetPasswordPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lupa Password diklik')),
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
    );
  }
}
