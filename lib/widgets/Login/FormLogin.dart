import 'package:flutter/material.dart';

class FormLogin extends StatelessWidget {
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

  static const Color primaryColor = Color.fromARGB(255, 255, 0, 85);

  const FormLogin({
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          child: Padding(
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
                    hintText: 'Enter your ID, Email, or Phone',
                    prefixIcon: Icon(Icons.person, size: 22, color: primaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: primaryColor, width: 1.7),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red, width: 1.1),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  onChanged: (value) {
                    // Trigger validation on change
                    if (value.isNotEmpty) {
                      // Clear any error state
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock, size: 22, color: primaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: primaryColor, width: 1.7),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red, width: 1.1),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: const Color.fromARGB(255, 19, 25, 90),
                      ),
                      onPressed: onPasswordToggle,
                    ),
                  ),
                  onChanged: (value) {
                    // Trigger validation on change
                    if (value.isNotEmpty) {
                      // Clear any error state
                    }
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe, 
                          onChanged: onRememberMeChanged,
                          activeColor: primaryColor,
                          checkColor: Colors.white,
                        ),
                        const Text(
                          'Remember me?',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: onForgetPasswordPressed,
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: isLoading ? null : onLoginPressed,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16, 
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account?",
              style: TextStyle(fontSize: 14),
            ),
            TextButton(
              onPressed: onSignUpPressed,
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
