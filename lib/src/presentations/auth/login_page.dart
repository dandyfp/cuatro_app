import 'package:cuatro_application/src/core/components/button.dart';
import 'package:cuatro_application/src/core/components/textfield.dart';
import 'package:cuatro_application/src/core/helpers/ui_helpers.dart';
import 'package:cuatro_application/src/data/auth_datasource.dart';
import 'package:cuatro_application/src/data/complain_datasource.dart';
import 'package:cuatro_application/src/presentations/auth/register_page.dart';
import 'package:cuatro_application/src/presentations/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
            verticalSpace(100),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 213, 228, 244),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(60),
                ),
              ),
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpace(100),
                    Text(
                      'Email',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    verticalSpace(4),
                    KTextField(
                      controller: emailController,
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
                      controller: passwordController,
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
                      onPressed: () async {
                        final response = await AuthDataSource().login(email: emailController.text, password: passwordController.text);
                        if (response.isRight()) {
                          String uid = response.getOrElse(() => '');
                          Navigator.pushReplacement(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  idUser: uid,
                                ),
                              ));
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
                                builder: (context) => const RegisterPage(),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
