import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cuatro_application/src/core/components/button.dart';
import 'package:cuatro_application/src/core/components/textfield.dart';
import 'package:cuatro_application/src/core/helpers/ui_helpers.dart';
import 'package:cuatro_application/src/core/helpers/validator/validator.dart';
import 'package:cuatro_application/src/data/auth_datasource.dart';
import 'package:cuatro_application/src/data/models/request/auth_request.dart';
import 'package:cuatro_application/src/presentations/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

GlobalKey<FormState> formKey = GlobalKey<FormState>();

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Register',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  verticalSpace(50),
                  Text(
                    'Name',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  verticalSpace(4),
                  KTextField(
                    borderColor: Colors.black,
                    controller: nameController,
                  ),
                  verticalSpace(30),
                  Text(
                    'Email',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  verticalSpace(4),
                  KTextField(
                    borderColor: Colors.black,
                    controller: emailController,
                    validator: Validator.emailValidator.call,
                  ),
                  verticalSpace(30),
                  Text(
                    'Password',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  verticalSpace(4),
                  KTextField(
                    maxLines: 1,
                    minLines: 1,
                    controller: passwordController,
                    borderColor: Colors.black,
                    validator: Validator.insertPasswordValidator.call,
                    obscure: isObscure,
                    suffixIcon: InkWell(
                      onTap: () => setState(() {
                        isObscure = !isObscure;
                      }),
                      child: isObscure
                          ? const Icon(
                              Icons.remove_red_eye,
                            )
                          : const Icon(
                              Icons.visibility_off,
                            ),
                    ),
                  ),
                  verticalSpace(50),
                  Button(
                    isLoading: isLoading,
                    isDisabled: isLoading,
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        setState(() {
                          isLoading = true;
                        });
                        AuthRequest req = AuthRequest(
                          email: emailController.text,
                          password: passwordController.text,
                          name: nameController.text,
                        );
                        final response = await AuthDataSource().register(req: req);

                        if (response.isRight()) {
                          setState(() {
                            isLoading = false;
                          });
                          nameController.clear();
                          emailController.clear();
                          passwordController.clear();
                          // ignore: use_build_context_synchronously
                          AnimatedSnackBar.material('Success Register', type: AnimatedSnackBarType.success).show(context);
                        }
                        print(response.toString());
                      }
                    },
                    child: Center(
                      child: Text(
                        'Register',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  verticalSpace(50),
                  Row(
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      horizontalSpace(5),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Login here",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.blue,
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
    );
  }
}
