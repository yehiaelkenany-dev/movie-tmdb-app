import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose;
    super.dispose();
  }

  Future passwordReset() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailController.text);
  }

  late double _deviceHeight;

  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.sizeOf(context).height;
    _deviceWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: Colors.purpleAccent,
            size: 30.0,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight * 0.97,
        width: _deviceWidth * 0.98,
        margin: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: _deviceHeight * 0.125,
            ),
            Image.asset(
              "assets/images/reset-password.png",
            ),
            Text(
              "Reset Password",
              style: GoogleFonts.acme(
                fontSize: 35,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            Text(
              "Enter your Email and we will send you a password reset link",
              textAlign: TextAlign.center,
              style: GoogleFonts.acme(
                fontSize: 20,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            SizedBox(
              height: _deviceHeight * 0.025,
            ),
            TextFormField(
              style: GoogleFonts.acme(
                color: Colors.white,
              ),
              cursorColor: Colors.white,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
                filled: true,
                hintText: 'Email',
                hintStyle: GoogleFonts.acme(color: Colors.white),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                prefixIcon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedMailAccount01,
                    color: Colors.white54),
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
              height: _deviceHeight * 0.025,
            ),
            MaterialButton(
              minWidth: 200,
              height: 50,
              color: Colors.purpleAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: passwordReset,
              child: Text(
                "Reset Password",
                style: GoogleFonts.acme(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
