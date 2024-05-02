import 'package:cuatro_application/src/core/components/style.dart';
import 'package:cuatro_application/src/core/helpers/ui_helpers.dart';
import 'package:cuatro_application/src/data/complain_datasource.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListComplaintPage extends StatelessWidget {
  const ListComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: ComplainDataSource().getAllComplaint(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: loadingPrimary(),
            );
          }
          return snapshot.data!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      verticalSpace(50),
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
                                  subtitle: Text('Location : ${item?.description ?? ''}'),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
