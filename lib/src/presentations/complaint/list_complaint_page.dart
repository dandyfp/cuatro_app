// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuatro_application/src/presentations/complaint/complaint_page.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cuatro_application/src/core/components/style.dart';
import 'package:cuatro_application/src/core/helpers/ui_helpers.dart';
import 'package:cuatro_application/src/data/complain_datasource.dart';
import 'package:cuatro_application/src/data/models/user_data.dart';

class ListComplaintPage extends StatefulWidget {
  final UserData user;
  const ListComplaintPage({
    super.key,
    required this.user,
  });

  @override
  State<ListComplaintPage> createState() => _ListComplaintPageState();
}

class _ListComplaintPageState extends State<ListComplaintPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: widget.user.role != 'admin'
            ? ComplainDataSource().getAllComplaint(widget.user.uid ?? '')
            : ComplainDataSource().getAllComplaintForAdmin(),
        builder: (context, snapshot) {
          Future refresh() async {
            widget.user.role != 'admin'
                ? await ComplainDataSource().getAllComplaint(widget.user.uid ?? '')
                : await ComplainDataSource().getAllComplaintForAdmin();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: loadingPrimary(),
            );
          }
          return snapshot.data!.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: () => refresh(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        verticalSpace(50),
                        Text(
                          'Complaint List',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        verticalSpace(20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Hi, \nWelcome ${widget.user.name}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              var item = snapshot.data?[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color.fromARGB(255, 246, 246, 246),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ComplaintPage(
                                            idUser: widget.user.uid ?? "",
                                            user: widget.user,
                                            complainData: item,
                                            isEdit: true,
                                          ),
                                        ),
                                      );
                                    },
                                    leading: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: const BoxDecoration(
                                        color: Colors.amber,
                                      ),
                                      child: ExtendedImage.network(
                                        item?.image ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(
                                      'Location : ${item?.location}',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    subtitle: Text('Description : ${item?.description ?? ''}'),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: Text('No Complaint'),
                );
        },
      ),
    );
  }
}
