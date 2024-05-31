// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cuatro_application/src/core/components/button.dart';
import 'package:cuatro_application/src/core/components/textfield.dart';
import 'package:cuatro_application/src/core/helpers/ui_helpers.dart';
import 'package:cuatro_application/src/core/helpers/validator/validator.dart';
import 'package:cuatro_application/src/data/auth_datasource.dart';
import 'package:cuatro_application/src/data/models/request/auth_request.dart';
import 'package:cuatro_application/src/presentations/auth/login_page.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  final bool isForgotPassword;
  const RegisterPage({
    super.key,
    required this.isForgotPassword,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

GlobalKey<FormState> formKey = GlobalKey<FormState>();

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  bool isObscure = true;
  bool isLoading = false;
  bool isResetPassword = false;
  XFile? xFile;
  XFile? xFileIdentity;
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
                  verticalSpace(20),
                  Center(
                    child: Text(
                      widget.isForgotPassword ? 'Reset Password' : 'Register',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  verticalSpace(50),
                  if (!widget.isForgotPassword)
                    Center(
                      child: Text(
                        'Photo Profile',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  verticalSpace(20),
                  if (!widget.isForgotPassword)
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      xFile = await ImagePicker().pickImage(source: ImageSource.camera);

                                      setState(() {});
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.camera,
                                          size: 30,
                                        ),
                                        Text(
                                          'Camera',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                      setState(() {});
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.photo_size_select_actual_rounded,
                                          size: 30,
                                        ),
                                        Text(
                                          'Gallery',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: xFile == null
                              ? const Center(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 100,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(
                                        File(xFile!.path),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  verticalSpace(30),
                  if (!widget.isForgotPassword)
                    Center(
                      child: Text(
                        'Photo Identity Card',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  verticalSpace(20),
                  if (!widget.isForgotPassword)
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      xFileIdentity = await ImagePicker().pickImage(source: ImageSource.camera);

                                      setState(() {});
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.camera,
                                          size: 30,
                                        ),
                                        Text(
                                          'Camera',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      xFileIdentity = await ImagePicker().pickImage(source: ImageSource.gallery);
                                      setState(() {});
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.photo_size_select_actual_rounded,
                                          size: 30,
                                        ),
                                        Text(
                                          'Gallery',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: xFileIdentity == null
                              ? const Center(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 100,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(
                                        File(xFileIdentity?.path ?? ''),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  verticalSpace(30),
                  Text(
                    'Name',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  verticalSpace(4),
                  KTextField(
                    maxLines: 1,
                    minLines: 1,
                    isDense: true,
                    keyboardType: TextInputType.name,
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
                    maxLines: 1,
                    minLines: 1,
                    isDense: true,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    borderColor: Colors.black,
                    controller: emailController,
                    validator: Validator.emailValidator.call,
                  ),
                  verticalSpace(30),
                  if (!widget.isForgotPassword)
                    Text(
                      'Whatsapp',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  if (!widget.isForgotPassword) verticalSpace(4),
                  if (!widget.isForgotPassword)
                    KTextField(
                      maxLines: 1,
                      minLines: 1,
                      isDense: true,
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.none,
                      borderColor: Colors.black,
                      controller: whatsappController,
                      validator: Validator.requiredValidator.call,
                    ),
                  if (!widget.isForgotPassword) verticalSpace(30),
                  Text(
                    widget.isForgotPassword ? 'New password' : 'Password',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  verticalSpace(4),
                  KTextField(
                    maxLines: 1,
                    minLines: 1,
                    isDense: true,
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    borderColor: Colors.black,
                    textCapitalization: TextCapitalization.none,
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
                  widget.isForgotPassword
                      ? Button(
                          isLoading: isResetPassword,
                          isDisabled: isResetPassword,
                          onPressed: () async {
                            if (formKey.currentState?.validate() ?? false) {
                              setState(() {
                                isResetPassword = true;
                              });
                              AuthRequest req = AuthRequest(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                              );
                              final response = await AuthDataSource().resetPassword(req);

                              if (response.isRight()) {
                                setState(() {
                                  isResetPassword = false;
                                });
                                nameController.clear();
                                emailController.clear();
                                passwordController.clear();
                                whatsappController.clear();
                                // ignore: use_build_context_synchronously
                                AnimatedSnackBar.material('Success Reset Password', type: AnimatedSnackBarType.success).show(context);
                              }
                            }
                          },
                          child: Center(
                            child: Text(
                              'Reset Password',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Button(
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
                                imageFile: File(xFile!.path),
                                whatsapp: whatsappController.text,
                                identityFile: File(xFileIdentity!.path),
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
                              if (response.isLeft()) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
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
