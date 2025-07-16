import 'package:flutter/material.dart';

class Step1Form extends StatelessWidget {
  final TextEditingController employeeIdController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final VoidCallback? onNext;
  final bool isValid;
  final Color? buttonColor;
  static const Color primaryColor = Color.fromARGB(255, 255, 0, 85);

  const Step1Form({
    Key? key,
    required this.employeeIdController,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.onNext,
    required this.isValid,
    this.buttonColor,
  }) : super(key: key);

  // Ganti dialog input menjadi custom bottom sheet ala ForgetPasswordPage
  Future<void> _showBottomInputDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required ValueChanged<String> onSubmitted,
    TextInputType? keyboardType,
    bool unfocusAfterSubmit = false,
  }) async {
    final controller = TextEditingController(text: initialValue);
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
                        constraints: const BoxConstraints(
                          minHeight: 180,
                          maxHeight: 320,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: controller,
                              autofocus: true,
                              keyboardType: keyboardType,
                              decoration: InputDecoration(
                                hintText: title,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Colors.pinkAccent,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 255, 0, 85),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      onSubmitted(controller.text);
                                      Navigator.pop(context);
                                      if (unfocusAfterSubmit) {
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
            child: Column(
              children: [
                TextField(
                  controller: employeeIdController,
                  readOnly: true,
                  onTap: () {
                    _showBottomInputDialog(
                      context: context,
                      title: 'Enter Employee ID',
                      initialValue: employeeIdController.text,
                      onSubmitted: (value) => employeeIdController.text = value,
                      keyboardType: TextInputType.text,
                      unfocusAfterSubmit: false,
                    );
                  },
                  decoration: InputDecoration(
                    labelText: 'Employee ID',
                    hintText: 'Enter Employee ID',
                    prefixIcon: Icon(
                      Icons.badge,
                      size: 22,
                      color: primaryColor,
                    ),
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
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  readOnly: true,
                  onTap: () {
                    _showBottomInputDialog(
                      context: context,
                      title: 'Enter Full Name',
                      initialValue: nameController.text,
                      onSubmitted: (value) => nameController.text = value,
                      keyboardType: TextInputType.text,
                      unfocusAfterSubmit: false,
                    );
                  },
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter Full Name',
                    prefixIcon: Icon(
                      Icons.person,
                      size: 22,
                      color: primaryColor,
                    ),
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
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  readOnly: true,
                  onTap: () {
                    _showBottomInputDialog(
                      context: context,
                      title: 'Enter Email',
                      initialValue: emailController.text,
                      onSubmitted: (value) => emailController.text = value,
                      keyboardType: TextInputType.emailAddress,
                      unfocusAfterSubmit: false,
                    );
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter Email',
                    prefixIcon: Icon(
                      Icons.email,
                      size: 22,
                      color: primaryColor,
                    ),
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
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  readOnly: true,
                  onTap: () {
                    _showBottomInputDialog(
                      context: context,
                      title: 'Enter Phone Number',
                      initialValue: phoneController.text,
                      onSubmitted: (value) => phoneController.text = value,
                      keyboardType: TextInputType.phone,
                      unfocusAfterSubmit: true,
                    );
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter Phone Number',
                    prefixIcon: Icon(
                      Icons.phone,
                      size: 22,
                      color: primaryColor,
                    ),
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
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: isValid
                          ? LinearGradient(
                              colors: [
                                primaryColor,
                                primaryColor.withOpacity(0.8),
                              ],
                            )
                          : LinearGradient(
                              colors: [
                                Colors.grey.shade200,
                                Colors.grey.shade200,
                              ],
                            ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isValid
                          ? [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.13),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: ElevatedButton(
                      onPressed: isValid ? onNext : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Step2Form extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool showPassword;
  final bool showConfirmPassword;
  final VoidCallback? onTogglePassword;
  final VoidCallback? onToggleConfirmPassword;
  final VoidCallback? onSignUp;
  final bool isValid;
  final Color? buttonColor;

  const Step2Form({
    Key? key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.showPassword,
    required this.showConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onSignUp,
    required this.isValid,
    this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 56),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              obscureText: !showPassword,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter Password',
                prefixIcon: Icon(Icons.lock, size: 22, color: Step1Form.primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: onTogglePassword,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Step1Form.primaryColor, width: 1.7),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: !showConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock, size: 22, color: Step1Form.primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: onToggleConfirmPassword,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Step1Form.primaryColor, width: 1.7),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            // Informasi validasi
            if (passwordController.text.isEmpty ||
                confirmPasswordController.text.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Password and Confirm Password are required',
                  style: TextStyle(color: Colors.red, fontSize: 13),
                ),
              )
            else if (passwordController.text != confirmPasswordController.text)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Password and Confirm Password must match',
                  style: TextStyle(color: Colors.red, fontSize: 13),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Password and Confirm Password match',
                  style: TextStyle(color: Colors.green, fontSize: 13),
                ),
              ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: isValid
                      ? LinearGradient(
                          colors: [Step1Form.primaryColor, Step1Form.primaryColor.withOpacity(0.8)],
                        )
                      : LinearGradient(
                          colors: [Colors.grey.shade200, Colors.grey.shade200],
                        ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isValid
                      ? [
                          BoxShadow(
                            color: Step1Form.primaryColor.withOpacity(0.13),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: ElevatedButton(
                  onPressed: isValid ? onSignUp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
