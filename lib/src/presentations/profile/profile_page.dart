import 'package:cuatro_application/src/core/components/button.dart';
import 'package:cuatro_application/src/core/components/style.dart';
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

  @override
  Widget build(BuildContext context) {
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
            : Column(
                children: [
                  verticalSpace(30),
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
                        ],
                      )
                    ],
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
                ],
              ),
      ),
    );
  }
}
