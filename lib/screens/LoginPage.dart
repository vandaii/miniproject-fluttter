import 'package:flutter/material.dart';
import 'package:miniproject_flutter/screens/dashboard_page.dart';
import 'package:miniproject_flutter/screens/register_page.dart';
import 'package:miniproject_flutter/widgets/CustomPage_Login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isPasswordVisible = false;

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

            // by Logo + Title
            const LogoSection(),

            const SizedBox(height: 60),

            //  by Form Login
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
                  onLoginPressed: () {
                    final id = _idController.text.trim();
                    final password = _passwordController.text;

                    if (id.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter both ID and Password'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardPage(),
                      ),
                    );
                  },
                  onForgetPasswordPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Forget Password clicked')),
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

            // by Footer Dekorasi (tampil jika keyboard tidak muncul)
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
