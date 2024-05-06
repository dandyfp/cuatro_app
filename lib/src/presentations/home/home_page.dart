// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuatro_application/src/data/auth_datasource.dart';
import 'package:cuatro_application/src/data/models/user_data.dart';
import 'package:cuatro_application/src/presentations/complaint/list_complaint_page.dart';
import 'package:cuatro_application/src/presentations/profile/profile_page.dart';
import 'package:flutter/material.dart';

import 'package:cuatro_application/src/presentations/complaint/complaint_page.dart';

class HomePage extends StatefulWidget {
  final String idUser;
  const HomePage({
    super.key,
    required this.idUser,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    getUserDetail();
    super.initState();
  }

  UserData? userData;

  PageController pageController = PageController();
  int selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: userData?.role != 'admin' && selectedPage == 0
          ? Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComplaintPage(
                      user: userData ?? UserData(),
                      idUser: widget.idUser,
                      isEdit: false,
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        'Add Complaint',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(),
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (value) => setState(
              () {
                selectedPage = value;
              },
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: ListComplaintPage(
                  user: userData ?? UserData(),
                ),
              ),
              ProfilePage(
                id: widget.idUser,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: const Color.fromARGB(199, 35, 93, 195),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 0,
                    offset: const Offset(0, -5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedPage = 0;
                      });
                      pageController.animateToPage(
                        selectedPage,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: selectedPage == 0 ? Colors.blue : Colors.black,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: selectedPage == 0 ? Colors.blue : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedPage = 1;
                      });
                      pageController.animateToPage(
                        selectedPage,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: selectedPage == 1 ? Colors.blue : Colors.black,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: selectedPage == 1 ? Colors.blue : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getUserDetail() async {
    var result = await AuthDataSource().getUser(widget.idUser);
    result.fold((l) => null, (r) => userData = r);
    setState(() {});
  }
}
