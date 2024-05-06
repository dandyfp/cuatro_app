import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cuatro_application/src/core/components/button.dart';
import 'package:cuatro_application/src/core/components/textfield.dart';
import 'package:cuatro_application/src/core/helpers/ui_helpers.dart';
import 'package:cuatro_application/src/core/helpers/validator/validator.dart';
import 'package:cuatro_application/src/data/auth_datasource.dart';
import 'package:cuatro_application/src/data/complain_datasource.dart';
import 'package:cuatro_application/src/presentations/auth/register_page.dart';
import 'package:cuatro_application/src/presentations/auth/reset_password_page.dart';
import 'package:cuatro_application/src/presentations/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
GlobalKey<FormState> formKey = GlobalKey<FormState>();

class _LoginPageState extends State<LoginPage> {
  bool isLoadingLogin = false;
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              verticalSpace(100),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  fit: BoxFit.cover,
                  'assets/cuatro_logo.jpeg',
                  height: 200,
                  width: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpace(50),
                    Text(
                      'Email',
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
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.none,
                      controller: emailController,
                      borderColor: Colors.black,
                      validator: Validator.emailValidator.call,
                    ),
                    verticalSpace(30),
                    Text(
                      'Password',
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
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.none,
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
                      isLoading: isLoadingLogin,
                      isDisabled: isLoadingLogin,
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          setState(() {
                            isLoadingLogin = true;
                          });
                          final response = await AuthDataSource().login(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          setState(() {
                            response.fold(
                              (l) => AnimatedSnackBar.material(l, type: AnimatedSnackBarType.error).show(context),
                              (r) => AnimatedSnackBar.material('Success', type: AnimatedSnackBarType.success).show(context),
                            );
                            isLoadingLogin = false;
                          });
                          if (response.isRight()) {
                            String uid = response.getOrElse(() => '');
                            Navigator.pushReplacement(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  idUser: uid,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: Center(
                        child: Text(
                          'Login',
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account yet?",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        horizontalSpace(5),
                        InkWell(
                          onTap: () {
                            ComplainDataSource().getAllComplaint();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(
                                  isForgotPassword: false,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "Register here",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(30),
                    InkWell(
                      onTap: () {
                        ComplainDataSource().getAllComplaint();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResetPasswordPage(),
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          "Forgor Password? ",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
