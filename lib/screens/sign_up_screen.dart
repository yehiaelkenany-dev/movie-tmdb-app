import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:streamr/auth/auth_service.dart';
import 'package:streamr/screens/home_screen.dart';

import '../database_services/user_service.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Map<String, bool> _validationResults = {};
  final AuthService _authService = AuthService();
  bool _isVisible = false;
  final _formKey = GlobalKey<FormState>();
  RegExp upperCaseRegEx = RegExp(r'^(?=.*[A-Z])');
  RegExp lowerCaseRegEx = RegExp(r'^(?=.*[a-z])');
  RegExp numberRegEx = RegExp(r'^(?=.*?[0-9])');
  RegExp specialCharacterRegEx = RegExp(r'^(?=.*?[!@#$&*~])');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late double _deviceHeight;
  late double _deviceWidth;

  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(
        _onPasswordChanged); // Call the method when the screen loads
  }

  void _onPasswordChanged() {
    setState(() {
      _validationResults = _validatePassword(_passwordController.text);
    });
  }

  // Method to fetch user data using the UserService class
  Future<void> _fetchUserData() async {
    final currentUser = _authService.getCurrentUser();

    // If no user is logged in, do not proceed
    if (currentUser == null) {
      setState(() {
        userData = null;
        isLoading = false;
      });
      return;
    }

    UserService userService = UserService();
    Map<String, dynamic>? data =
        await userService.getUserDataByID(currentUser.uid);

    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.sizeOf(context).height;
    _deviceWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: _deviceWidth * 0.03,
                      vertical: _deviceHeight * 0.02,
                    ),
                    height: _deviceHeight * 0.97,
                    width: _deviceWidth * 0.98,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset(
                              "assets/images/movie.png",
                              width: MediaQuery.sizeOf(context).width * 0.65,
                            ),
                          ),
                          TextFormField(
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                            cursorColor: Colors.white,
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
                              filled: true,
                              hintText: 'Enter Your Name',
                              hintStyle:
                                  GoogleFonts.montserrat(color: Colors.white54),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              prefixIcon: const HugeIcon(
                                icon: HugeIcons.strokeRoundedUser,
                                color: Color.fromRGBO(131, 56, 236, 1.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: _deviceHeight * 0.0125,
                          ),
                          TextFormField(
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                            cursorColor: Colors.white,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
                              filled: true,
                              hintText: 'Email',
                              hintStyle:
                                  GoogleFonts.montserrat(color: Colors.white54),
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
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: _deviceHeight * 0.0125,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }

                              final result = _validatePassword(value);
                              final allValid =
                                  result.values.every((isValid) => isValid);

                              if (!allValid) {
                                return 'Password does not meet all requirements.';
                              }

                              return null;
                            },
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                            obscureText: !_isVisible,
                            cursorColor: Colors.white,
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
                                        color:
                                            Color.fromRGBO(131, 56, 236, 1.0),
                                        size: 24.0,
                                      )
                                    : const HugeIcon(
                                        icon:
                                            HugeIcons.strokeRoundedViewOffSlash,
                                        color:
                                            Color.fromRGBO(131, 56, 236, 1.0),
                                        size: 24.0,
                                      ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
                              filled: true,
                              hintText: 'Password',
                              hintStyle:
                                  GoogleFonts.montserrat(color: Colors.white54),
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
                          SizedBox(
                            height: _deviceHeight * 0.0125,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            style: GoogleFonts.montserrat(color: Colors.white),
                            obscureText: !_isVisible,
                            cursorColor: Colors.white,
                            controller: _confirmPasswordController,
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
                                        color:
                                            Color.fromRGBO(131, 56, 236, 1.0),
                                        size: 24.0,
                                      )
                                    : const HugeIcon(
                                        icon:
                                            HugeIcons.strokeRoundedViewOffSlash,
                                        color:
                                            Color.fromRGBO(131, 56, 236, 1.0),
                                        size: 24.0,
                                      ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
                              filled: true,
                              hintText: 'Confirm Password',
                              hintStyle:
                                  GoogleFonts.montserrat(color: Colors.white54),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              prefixIcon: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedLockPassword,
                                  color: Color.fromRGBO(131, 56, 236, 1.0)),
                            ),
                          ),
                          SizedBox(
                            height: _deviceHeight * 0.0125,
                          ),
                          for (var entry in _validationResults.entries)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    HugeIcon(
                                        icon: entry.value
                                            ? HugeIcons
                                                .strokeRoundedCheckmarkCircle02
                                            : HugeIcons
                                                .strokeRoundedCancelCircle,
                                        color: entry.value
                                            ? Colors.green
                                            : const Color.fromRGBO(
                                                255, 0, 110, 1.0)),
                                    const SizedBox(
                                      width: 10,
                                      height: 5,
                                    ),
                                    Expanded(
                                      child: Text(entry.key,
                                          style: GoogleFonts.montserrat(
                                            color: entry.value
                                                ? Colors.green
                                                : const Color.fromRGBO(
                                                    255, 0, 110, 1.0),
                                          )),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          SizedBox(
                            height: _deviceHeight * 0.025,
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final email = _emailController.text;
                                final name = _nameController.text;
                                final password = _passwordController.text;

                                final usersRef = FirebaseFirestore.instance
                                    .collection('users');

                                try {
                                  // Step 1: Check if email already exists in Firestore
                                  final existingUserQuery = await usersRef
                                      .where('email', isEqualTo: email)
                                      .limit(1)
                                      .get();

                                  if (existingUserQuery.docs.isNotEmpty) {
                                    // Email already registered in Firestore
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                            'Account Already Exists'),
                                        content: const Text(
                                          'An account with this email already exists. Please log in instead.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  }

                                  // Step 2: Create Firebase Auth user
                                  final credential = await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password);

                                  final uid = credential.user!.uid;

                                  // Step 3: Store user data in Firestore
                                  await usersRef.doc(uid).set({
                                    'uid': uid,
                                    'email': email,
                                    'name': name,
                                    'createdAt': Timestamp.now(),
                                  });

                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen()),
                                    );
                                  }
                                } on FirebaseAuthException catch (e) {
                                  String errorMessage;
                                  switch (e.code) {
                                    case 'email-already-in-use':
                                      errorMessage =
                                          'This email is already associated with an account.';
                                      break;
                                    case 'invalid-email':
                                      errorMessage = 'Invalid email address.';
                                      break;
                                    case 'weak-password':
                                      errorMessage =
                                          'The password provided is too weak.';
                                      break;
                                    default:
                                      errorMessage =
                                          'Registration failed. Please try again.';
                                  }

                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Signup Error'),
                                        content: Text(errorMessage),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Unexpected Error'),
                                        content: Text(e.toString()),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            color: const Color.fromRGBO(58, 134, 255, 1.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            height: 56,
                            minWidth: double.infinity,
                            child: Text(
                              'Create Account',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
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
                                          builder: (context) =>
                                              const LoginScreen()));
                                },
                                child: Text(
                                  "Login Now",
                                  style: GoogleFonts.montserrat(
                                      color: const Color.fromRGBO(
                                          255, 0, 110, 1.0),
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
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
      'Passwords don\'t match':
          password.isNotEmpty && _confirmPasswordController.text.isNotEmpty
              ? password == _confirmPasswordController.text
              : false,
    };

    return validationResults;
  }
}
