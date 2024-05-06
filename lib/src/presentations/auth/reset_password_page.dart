import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cuatro_application/src/core/components/button.dart';
import 'package:cuatro_application/src/core/components/textfield.dart';
import 'package:cuatro_application/src/core/helpers/ui_helpers.dart';
import 'package:cuatro_application/src/core/helpers/validator/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

final TextEditingController emailController = TextEditingController();

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Reset Password',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(100),
            Text(
              'Receive an email to reset your password',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 28,
              ),
            ),
            verticalSpace(20),
            Text(
              'Enter your email',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            verticalSpace(4),
            KTextField(
              maxLines: 1,
              minLines: 1,
              isDense: true,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              borderColor: Colors.black,
              controller: emailController,
              validator: Validator.emailValidator.call,
            ),
            verticalSpace(20),
            Button(
              isLoading: isLoading,
              isDisabled: isLoading,
              onPressed: () {
                resetPassword();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                  ),
                  horizontalSpace(20),
                  Text(
                    'Reset Password',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future resetPassword() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      // ignore: use_build_context_synchronously
      AnimatedSnackBar.material('Password Reset Email Send', type: AnimatedSnackBarType.success).show(context);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      AnimatedSnackBar.material(e.message ?? '', type: AnimatedSnackBarType.warning).show(context);
    }
    setState(() {
      isLoading = false;
    });
  }
}
