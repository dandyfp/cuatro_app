import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cuatro_application/src/core/components/button.dart';
import 'package:cuatro_application/src/core/components/style.dart';
import 'package:cuatro_application/src/core/components/textfield.dart';
import 'package:cuatro_application/src/core/helpers/ui_helpers.dart';
import 'package:cuatro_application/src/data/auth_datasource.dart';
import 'package:cuatro_application/src/data/models/user_data.dart';
import 'package:cuatro_application/src/presentations/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  final String id;
  const ProfilePage({super.key, required this.id});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  UserData? userData;
  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future getProfile() async {
    isLoading = true;
    var dataUser = await AuthDataSource().getUser(widget.id);
    dataUser.fold((l) => null, (r) => userData = r);
    isLoading = false;
    setState(() {});
  }

  TextEditingController addStatusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    addStatusController.text = userData?.status ?? '';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: isLoading
            ? Center(
                child: loadingPrimary(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpace(30),
                    Center(
                      child: Text(
                        'Photo Profile',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    verticalSpace(10),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: userData?.imageProfile == null
                            ? const Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 100,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage(userData?.imageProfile ?? '')),
                                ),
                              ),
                      ),
                    ),
                    verticalSpace(20),
                    Center(
                      child: Text(
                        'Identity Card',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    verticalSpace(10),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: userData?.imageIdentity == null
                            ? const Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 100,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(userData?.imageIdentity ?? ''),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    verticalSpace(20),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              'Name',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            verticalSpace(30),
                            Text(
                              'Email',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            verticalSpace(30),
                            Text(
                              'Whatsapp',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        horizontalSpace(30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ': ${userData?.name ?? '-'}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            verticalSpace(30),
                            Text(
                              ': ${userData?.email ?? '-'}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            verticalSpace(30),
                            Text(
                              ': ${userData?.whatsapp ?? '-'}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    verticalSpace(30),
                    if (userData?.role == 'admin')
                      Text(
                        'Add Status',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (userData?.role == 'admin')
                      KTextField(
                        maxLines: 1,
                        minLines: 1,
                        isDense: true,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.none,
                        controller: addStatusController,
                        borderColor: Colors.black,
                        onFieldSubmitted: (value) async {
                          UserData user = UserData(
                            email: userData?.email,
                            name: userData?.name,
                            password: userData?.password,
                            imageIdentity: userData?.imageIdentity,
                            imageProfile: userData?.imageProfile,
                            role: userData?.role,
                            status: value,
                            uid: userData?.uid,
                            whatsapp: userData?.whatsapp,
                          );
                          final response = await AuthDataSource().updateUser(user);
                          setState(() {
                            response.fold(
                              (l) => AnimatedSnackBar.material(l, type: AnimatedSnackBarType.error).show(context),
                              (r) => AnimatedSnackBar.material('Success', type: AnimatedSnackBarType.success).show(context),
                            );
                          });
                        },
                      ),
                    verticalSpace(60),
                    Button(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (FirebaseAuth.instance.currentUser == null) {
                          Navigator.pushReplacement(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }
                      },
                      child: Center(
                        child: Text(
                          "Logout",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    verticalSpace(100),
                  ],
                ),
              ),
      ),
    );
  }
}
