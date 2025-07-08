import 'package:flutter/material.dart';
import 'package:miniproject_flutter/services/authService.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _feedbackMessage;
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _feedbackMessage = 'Silakan masukkan email Anda.';
        _isSuccess = false;
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _feedbackMessage = null;
    });
    final result = await AuthService().forgotPassword(email);
    setState(() {
      _isLoading = false;
      _isSuccess = result['status'] == true;
      _feedbackMessage = result['message'] ?? (_isSuccess ? 'Email reset password telah dikirim.' : 'Terjadi kesalahan.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color themeColor = const Color(0xFFFF2D8B); // Pink mencolok
    final Color gradientStart = const Color(0xFFFF5FA2); // Pink terang
    final Color gradientEnd = const Color(0xFFFF2D8B); // Pink gelap
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Lupa Password'),
        backgroundColor: themeColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ilustrasi digital modern
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [gradientStart, gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: themeColor.withOpacity(0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.lock_reset_rounded, size: 54, color: Colors.white),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      color: themeColor.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan email yang terdaftar untuk menerima link reset password.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              const SizedBox(height: 32),
              // Card Form
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: themeColor),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          prefixIcon: Icon(Icons.email_outlined, color: themeColor),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: themeColor, width: 2),
                          ),
                        ),
                        cursorColor: themeColor,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            backgroundColor: themeColor,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text('Kirim Email Reset'),
                        ),
                      ),
                      if (_feedbackMessage != null) ...[
                        const SizedBox(height: 20),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          decoration: BoxDecoration(
                            color: _isSuccess ? Colors.green[50] : Colors.red[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isSuccess ? Colors.green : Colors.red,
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isSuccess ? Icons.check_circle : Icons.error_outline,
                                color: _isSuccess ? Colors.green : Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _feedbackMessage!,
                                  style: TextStyle(
                                    color: _isSuccess ? Colors.green[900] : Colors.red[900],
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Kembali ke login
              TextButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                child: Text(
                  'Kembali ke Login',
                  style: TextStyle(color: themeColor, fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
