import 'package:cuatro_application/src/core/helpers/ui_helpers.dart';
import 'package:cuatro_application/src/data/complain_datasource.dart';
import 'package:cuatro_application/src/data/models/user_data.dart';
import 'package:cuatro_application/src/presentations/complaint/complaint_page.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportPage extends StatefulWidget {
  final UserData user;
  const ReportPage({
    super.key,
    required this.user,
  });

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text(
          'Complaint Report',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Text(
                    'Completed',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Reject',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FutureBuilder(
                      future: ComplainDataSource().getAllComplaintComplete(),
                      builder: (context, snapshot) {
                        return snapshot.connectionState == ConnectionState.waiting
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Column(
                                children: [
                                  verticalSpace(20),
                                  Text('Total Complete: ${snapshot.data!.length}'),
                                  verticalSpace(20),
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
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Description : ${item?.description ?? ''}'),
                                                  if (item?.rating != null)
                                                    RatingBar.builder(
                                                      initialRating: double.parse(item?.rating.toString() ?? '0'),
                                                      itemBuilder: (context, index) => const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate: (value) {},
                                                    )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  verticalSpace(100),
                                ],
                              );
                      },
                    ),
                    FutureBuilder(
                      future: ComplainDataSource().getAllComplaintReject(),
                      builder: (context, snapshot) {
                        return snapshot.connectionState == ConnectionState.waiting
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Column(
                                children: [
                                  verticalSpace(20),
                                  Text('Total Reject: ${snapshot.data!.length}'),
                                  verticalSpace(20),
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
                              );
                      },
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
