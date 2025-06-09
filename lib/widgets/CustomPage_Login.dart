import 'package:flutter/material.dart';

/// Widget Logo dan Judul HAUS
class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/icons-haus.png', height: 100),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              text: 'HAUS',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text: ' Inventory',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'HAUS Inventory Management System',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

/// Widget Form Login
class LoginForm extends StatelessWidget {
  final TextEditingController idController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final VoidCallback onPasswordToggle;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onLoginPressed;
  final VoidCallback onForgetPasswordPressed;
  final VoidCallback onSignUpPressed;

  const LoginForm({
    super.key,
    required this.idController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.onPasswordToggle,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onLoginPressed,
    required this.onForgetPasswordPressed,
    required this.onSignUpPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: idController,
            decoration: InputDecoration(
              labelText: 'EmployeeID / Email / Phone',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.person),
              hintText: 'Enter your ID, Email, or Phone',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIconColor: Colors.pink,
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: passwordController,
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.lock),
              hintText: 'Enter your password',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIconColor: Colors.pink,
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color.fromARGB(255, 19, 25, 90),
                ),
                onPressed: onPasswordToggle,
              ),
            ),
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(value: rememberMe, onChanged: onRememberMeChanged),
                  const Text('Remember me?'),
                ],
              ),
              TextButton(
                onPressed: onForgetPasswordPressed,
                child: const Text('Forget Password'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onLoginPressed,
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Do not have account?'),
              TextButton(
                onPressed: onSignUpPressed,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
