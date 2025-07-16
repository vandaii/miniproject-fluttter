// import 'package:flutter/material.dart';
// import 'dart:ui';
// import 'package:miniproject_flutter/services/authService.dart';
// import 'package:miniproject_flutter/widgets/customPageRegister.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:miniproject_flutter/screens/Resource/Auth/loginPage.dart';
// import 'custom.dart';

// class RegisterCobaPage extends StatefulWidget {
//   const RegisterCobaPage({super.key});

//   @override
//   State<RegisterCobaPage> createState() => _RegisterCobaPageState();
// }

// class _RegisterCobaPageState extends State<RegisterCobaPage> {
//   final _employeeIdController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   static const primaryColor = Color.fromARGB(255, 255, 0, 85);

//   bool _showPassword = false;
//   bool _showConfirmPassword = false;
//   bool _isLoading = false;
//   int _currentStep = 1;

//   @override
//   void initState() {
//     super.initState();
//     _employeeIdController.addListener(_onStep1FieldChanged);
//     _nameController.addListener(_onStep1FieldChanged);
//     _emailController.addListener(_onStep1FieldChanged);
//     _phoneController.addListener(_onStep1FieldChanged);
//     _passwordController.addListener(_onStep2FieldChanged);
//     _confirmPasswordController.addListener(_onStep2FieldChanged);
//   }

//   void _onStep1FieldChanged() {
//     setState(() {});
//   }

//   void _onStep2FieldChanged() {
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     _employeeIdController.removeListener(_onStep1FieldChanged);
//     _nameController.removeListener(_onStep1FieldChanged);
//     _emailController.removeListener(_onStep1FieldChanged);
//     _phoneController.removeListener(_onStep1FieldChanged);
//     _passwordController.removeListener(_onStep2FieldChanged);
//     _confirmPasswordController.removeListener(_onStep2FieldChanged);
//     super.dispose();
//   }

//   void showSweetAlert(
//     BuildContext context,
//     String title,
//     String desc,
//     DialogType type, {
//     VoidCallback? onOk,
//   }) {
//     AwesomeDialog(
//       context: context,
//       dialogType: type,
//       animType: AnimType.rightSlide,
//       title: title,
//       desc: desc,
//       btnOkOnPress: () {
//         FocusScope.of(context).unfocus();
//         if (onOk != null) onOk();
//       },
//     ).show();
//   }

//   bool get isStep1Valid =>
//       _employeeIdController.text.isNotEmpty &&
//       _nameController.text.isNotEmpty &&
//       _emailController.text.isNotEmpty &&
//       _phoneController.text.isNotEmpty;

//   bool get isStep2Valid =>
//       _passwordController.text.isNotEmpty &&
//       _confirmPasswordController.text.isNotEmpty &&
//       _passwordController.text == _confirmPasswordController.text;

//   Future<void> _handleSignUp() async {
//     final employeeId = _employeeIdController.text.trim();
//     final name = _nameController.text.trim();
//     final email = _emailController.text.trim();
//     final phone = _phoneController.text.trim();
//     final password = _passwordController.text;
//     final confirmPassword = _confirmPasswordController.text;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       bool isRegistered = await AuthService().register(
//         employeeId: employeeId,
//         name: name,
//         email: email,
//         phone: phone,
//         password: password,
//         confirmedPassword: confirmPassword,
//         storeLocation: '1',
//       );

//       if (isRegistered) {
//         if (mounted) {
//           showSweetAlert(
//             context,
//             "Sukses",
//             "Registrasi berhasil",
//             DialogType.success,
//             onOk: () {
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => LoginPage()),
//                 (route) => false,
//               );
//             },
//           );
//         }
//       } else {
//         showSweetAlert(
//           context,
//           "Registrasi Gagal",
//           "ID, email, atau nomor telepon sudah terdaftar.",
//           DialogType.error,
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         if (e.toString().toLowerCase().contains("failed host lookup") ||
//             e.toString().toLowerCase().contains("socketexception")) {
//           showSweetAlert(
//             context,
//             "Gagal Terhubung",
//             "Tidak dapat terhubung ke server.",
//             DialogType.warning,
//           );
//         } else {
//           showSweetAlert(
//             context,
//             "Error",
//             e.toString().replaceFirst("Exception: ", ""),
//             DialogType.error,
//           );
//         }
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//       body: Stack(
//         children: [
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//               child: Column(
//                 children: [
//                   HeaderWithLogo(
//                     logoSize: _currentStep == 1 ? 80 : 50,
//                     fontSize: _currentStep == 1 ? 20 : 16,
//                     subtitleSize: _currentStep == 1 ? 14 : 12,
//                   ),
//                   const SizedBox(height: 40),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           if (_currentStep == 1)
//                             Step1Form(
//                               employeeIdController: _employeeIdController,
//                               nameController: _nameController,
//                               emailController: _emailController,
//                               phoneController: _phoneController,
//                               isValid: isStep1Valid,
//                               onNext: isStep1Valid
//                                   ? () {
//                                       setState(() {
//                                         _currentStep = 2;
//                                       });
//                                     }
//                                   : null,
//                               buttonColor:
//                                   primaryColor, // tombol menyala jika valid
//                             ),
//                           if (_currentStep == 2)
//                             Step2Form(
//                               passwordController: _passwordController,
//                               confirmPasswordController:
//                                   _confirmPasswordController,
//                               showPassword: _showPassword,
//                               showConfirmPassword: _showConfirmPassword,
//                               onTogglePassword: () {
//                                 setState(() {
//                                   _showPassword = !_showPassword;
//                                 });
//                               },
//                               onToggleConfirmPassword: () {
//                                 setState(() {
//                                   _showConfirmPassword = !_showConfirmPassword;
//                                 });
//                               },
//                               isValid: isStep2Valid,
//                               onSignUp: isStep2Valid ? _handleSignUp : null,
//                             ),
//                           if (_currentStep == 2)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 16.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   TextButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         _currentStep = 1;
//                                       });
//                                     },
//                                     child: const Text(
//                                       'Kembali',
//                                       style: TextStyle(color: primaryColor),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   const Text('Sudah punya akun?'),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pushReplacement(
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               LoginPage(autoFocusId: false),
//                                         ),
//                                       );
//                                     },
//                                     child: const Text(
//                                       'Sign In',
//                                       style: TextStyle(color: primaryColor),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           if (_currentStep == 1)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 20.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Text('Sudah punya akun?'),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pushReplacement(
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               LoginPage(autoFocusId: false),
//                                         ),
//                                       );
//                                     },
//                                     child: const Text(
//                                       'Sign In',
//                                       style: TextStyle(color: primaryColor),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           const SizedBox(height: 50),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           FooterImage(),
//           if (_isLoading)
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black.withOpacity(0.78),
//                 alignment: Alignment.center,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Lottie.asset(
//                       'assets/lottie/loader.json',
//                       width: 220,
//                       height: 220,
//                       repeat: true,
//                       animate: true,
//                       fit: BoxFit.contain,
//                     ),
//                     const SizedBox(height: 0),
//                     Text(
//                       'Processing...',
//                       style: GoogleFonts.poppins(
//                         fontSize: 21,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                         letterSpacing: 0.7,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       'Please wait while we complete your request.',
//                       style: GoogleFonts.poppins(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.white70,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
