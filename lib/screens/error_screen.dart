import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        foregroundColor: Colors.white,
        title: Text("Error", style: GoogleFonts.montserrat()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/error-image.png", height: 200),
            SizedBox(height: 20.h),
            Text(
              message,
              style: GoogleFonts.montserrat(color: Colors.red, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to previous screen
              },
              child: Text(
                "Go Back",
                style: GoogleFonts.montserrat(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
