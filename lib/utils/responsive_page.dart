import 'package:flutter/widgets.dart';

class Responsive {
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide;
  }

  // Breakpoints untuk responsive design
  static bool isMobile(BuildContext context) {
    return getWidth(context) < 600;
  }

  static bool isTablet(BuildContext context) {
    return getWidth(context) >= 600 && getWidth(context) < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return getWidth(context) >= 1200;
  }

  static bool isWeb(BuildContext context) {
    return getWidth(context) >= 600;
  }

  // Helper untuk mendapatkan padding yang responsif
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  // Helper untuk mendapatkan max width yang responsif
  static double getMaxWidth(BuildContext context) {
    if (isMobile(context)) {
      return getWidth(context);
    } else if (isTablet(context)) {
      return 600;
    } else {
      return 800;
    }
  }
}

// Widget untuk responsive layout
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 600) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

// Utility untuk validasi form
class FormValidator {
  // Validasi email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validasi password
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // Validasi phone number
  static bool isValidPhone(String phone) {
    return RegExp(r'^[0-9]{10,13}$').hasMatch(phone);
  }

  // Validasi employee ID
  static bool isValidEmployeeId(String employeeId) {
    return employeeId.isNotEmpty && employeeId.length >= 3;
  }

  // Validasi nama
  static bool isValidName(String name) {
    return name.isNotEmpty && name.length >= 2;
  }

  // Get error message untuk email
  static String? getEmailError(String email) {
    if (email.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!isValidEmail(email)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Get error message untuk password
  static String? getPasswordError(String password) {
    if (password.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (!isValidPassword(password)) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  // Get error message untuk phone
  static String? getPhoneError(String phone) {
    if (phone.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (!isValidPhone(phone)) {
      return 'Format nomor telepon tidak valid';
    }
    return null;
  }

  // Get error message untuk employee ID
  static String? getEmployeeIdError(String employeeId) {
    if (employeeId.isEmpty) {
      return 'Employee ID tidak boleh kosong';
    }
    if (!isValidEmployeeId(employeeId)) {
      return 'Employee ID minimal 3 karakter';
    }
    return null;
  }

  // Get error message untuk nama
  static String? getNameError(String name) {
    if (name.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (!isValidName(name)) {
      return 'Nama minimal 2 karakter';
    }
    return null;
  }
}
