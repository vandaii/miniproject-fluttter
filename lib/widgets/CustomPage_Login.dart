import 'package:flutter/material.dart';

class LogoSection extends StatelessWidget {
  final Color primaryColor = Color.fromARGB(255, 255, 0, 85);

  LogoSection({super.key
  });

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
                    color: primaryColor,
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
  final FocusNode idFocusNode;
  final FocusNode passwordFocusNode;
  final bool isPasswordVisible;
  final VoidCallback onPasswordToggle;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onLoginPressed;
  final VoidCallback onForgetPasswordPressed;
  final VoidCallback onSignUpPressed;
  final bool isLoading;
  final bool autoFocusId;

  const LoginForm({
    super.key,
    required this.idController,
    required this.passwordController,
    required this.idFocusNode,
    required this.passwordFocusNode,
    required this.isPasswordVisible,
    required this.onPasswordToggle,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onLoginPressed,
    required this.onForgetPasswordPressed,
    required this.onSignUpPressed,
    this.isLoading = false,
    this.autoFocusId = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color.fromARGB(255, 255, 0, 85);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: idController,
            focusNode: idFocusNode,
            autofocus: autoFocusId,
            decoration: InputDecoration(
              labelText: 'EmployeeID / Email / Phone',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.person),
              hintText: 'Enter your ID, Email, or Phone',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIconColor: primaryColor,
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: passwordController,
            focusNode: passwordFocusNode,
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.lock),
              hintText: 'Enter your password',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIconColor: primaryColor,
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
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isLoading ? null : onLoginPressed,
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
