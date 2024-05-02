import 'package:cuatro_application/firebase_options.dart';
import 'package:cuatro_application/src/core/components/style.dart';
import 'package:cuatro_application/src/data/auth_datasource.dart';
import 'package:cuatro_application/src/presentations/auth/login_page.dart';
import 'package:cuatro_application/src/presentations/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpalshScreen(),
    );
  }
}

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  bool isloading = false;
  @override
  void initState() {
    isloading = true;
    Future.delayed(const Duration(seconds: 2), () {
      checkUser();
      setState(() {});
    });
    super.initState();
  }

  void checkUser() {
    String? id = AuthDataSource().getInLoggedUser();
    if (id != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(idUser: id),
          ));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isloading ? loadingPrimary() : const LoginPage(),
      ),
    );
  }
}
