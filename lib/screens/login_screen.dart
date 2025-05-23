import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:streamr/screens/home_screen.dart';
import 'package:streamr/screens/sign_up_screen.dart';

import '../auth/auth_service.dart';
import '../components/login_button.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Map<String, bool> _validationResults = {};

  late double _deviceHeight;
  late double _deviceWidth;

  bool _isVisible = false;

  RegExp upperCaseRegEx = RegExp(r'^(?=.*[A-Z])');
  RegExp lowerCaseRegEx = RegExp(r'^(?=.*[a-z])');
  RegExp numberRegEx = RegExp(r'^(?=.*?[0-9])');
  RegExp specialCharacterRegEx = RegExp(r'^(?=.*?[!@#$&*~])');

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.sizeOf(context).height;
    _deviceWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          height: _deviceHeight,
          width: _deviceWidth,
          margin: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/movie.png",
                    width: MediaQuery.sizeOf(context).width * 0.65,
                  ),
                ),
                SizedBox(
                  height: _deviceHeight * 0.025,
                ),
                TextFormField(
                  cursorErrorColor: Colors.red,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                  ),
                  cursorColor: Colors.white54,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
                    filled: true,
                    hintText: 'Email',
                    hintStyle: GoogleFonts.montserrat(color: Colors.white54),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon: const HugeIcon(
                        icon: HugeIcons.strokeRoundedMailAccount01,
                        color: Color.fromRGBO(131, 56, 236, 1.0)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: _deviceHeight * 0.0125,
                ),
                TextFormField(
                  cursorErrorColor: Colors.red,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }

                    final result = _validatePassword(value);
                    final allValid = result.values.every((isValid) => isValid);

                    if (!allValid) {
                      return 'Password does not meet all requirements.';
                    }

                    return null;
                  },
                  obscureText: !_isVisible,
                  cursorColor: Colors.white54,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      },
                      icon: _isVisible
                          ? const HugeIcon(
                              icon: HugeIcons.strokeRoundedView,
                              color: Color.fromRGBO(131, 56, 236, 1.0),
                              size: 24.0,
                            )
                          : const HugeIcon(
                              icon: HugeIcons.strokeRoundedViewOffSlash,
                              color: Color.fromRGBO(131, 56, 236, 1.0),
                              size: 24.0,
                            ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
                    filled: true,
                    hintText: 'Password',
                    hintStyle: GoogleFonts.montserrat(color: Colors.white54),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon: const HugeIcon(
                        icon: HugeIcons.strokeRoundedLockPassword,
                        color: Color.fromRGBO(131, 56, 236, 1.0)),
                  ),
                  onChanged: (passwordController) {
                    setState(() {
                      _validationResults =
                          _validatePassword(passwordController);
                    });
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgetPasswordScreen()));
                      },
                      child: Text(
                        'Forget Password?',
                        style: GoogleFonts.montserrat(
                          color: const Color.fromRGBO(255, 0, 110, 1.0),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: _deviceHeight * 0.00125,
                ),
                for (var entry in _validationResults.entries)
                  Column(
                    children: [
                      Row(
                        children: [
                          HugeIcon(
                              icon: entry.value
                                  ? HugeIcons.strokeRoundedCheckmarkCircle02
                                  : HugeIcons.strokeRoundedCancelCircle,
                              color: entry.value
                                  ? Colors.green
                                  : const Color.fromRGBO(255, 0, 110, 1.0)),
                          const SizedBox(
                            width: 10,
                            height: 5,
                          ),
                          Text(entry.key,
                              style: GoogleFonts.montserrat(
                                color: entry.value
                                    ? Colors.green
                                    : const Color.fromRGBO(255, 0, 110, 1.0),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                SizedBox(
                  height: _deviceHeight * 0.0025,
                ),
                const SizedBox(height: 10.0),
                LoginButton(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      final authService = AuthService();

                      try {
                        await authService.signInWithEmailAndPassword(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );

                        // Only navigate after successful login
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        String errorMessage;

                        switch (e.code) {
                          case 'user-not-found':
                            errorMessage = 'No user found for that email.';
                            break;
                          case 'wrong-password':
                            errorMessage = 'Incorrect password.';
                            break;
                          case 'invalid-email':
                            errorMessage = 'Invalid email address.';
                            break;
                          case 'invalid-credential': // or 'invalid-login-credentials'
                          case 'invalid-login-credentials':
                            errorMessage = 'Invalid email or password.';
                            break;
                          default:
                            errorMessage = 'Login failed. Please try again.';
                        }

                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Login Error'),
                              content: Text(errorMessage),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      } catch (e) {
                        // Catch any other unexpected errors
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Unexpected Error'),
                              content: Text(e.toString()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don\'t have an account?",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Register Now",
                        style: GoogleFonts.montserrat(
                            color: const Color.fromRGBO(255, 0, 110, 1.0),
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, bool> _validatePassword(String password) {
    Map<String, bool> validationResults = {
      'Password must be longer than 8 characters.': password.length >= 8,
      'Uppercase letter is missing.': upperCaseRegEx.hasMatch(password),
      'Lowercase letter is missing.': lowerCaseRegEx.hasMatch(password),
      'Digit is missing.': numberRegEx.hasMatch(password),
      'Special character is missing.': specialCharacterRegEx.hasMatch(password),
    };

    return validationResults;
  }
}
