import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cuatro_application/src/core/components/button.dart';
import 'package:cuatro_application/src/core/components/textfield.dart';
import 'package:cuatro_application/src/core/helpers/ui_helpers.dart';
import 'package:cuatro_application/src/data/complain_datasource.dart';
import 'package:cuatro_application/src/data/models/complain_data.dart';
import 'package:cuatro_application/src/data/models/user_data.dart';
import 'package:cuatro_application/src/presentations/home/home_page.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class FeedBackPage extends StatefulWidget {
  final UserData user;
  final ComplainData complainData;
  const FeedBackPage({
    super.key,
    required this.user,
    required this.complainData,
  });

  @override
  State<FeedBackPage> createState() => _FeedBackPageState();
}

final TextEditingController feedbackDescController = TextEditingController();

class _FeedBackPageState extends State<FeedBackPage> {
  @override
  void initState() {
    feedbackDescController.text = widget.complainData.feedbackDescription ?? '';
    super.initState();
  }

  XFile? xFile;
  String? imgDate;
  bool isLoading = false;
  String? status;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text(
          'Create FeedBack',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(30),
              Center(
                child: widget.complainData.feedbackImage != '' || widget.complainData.feedbackImage == null
                    ? Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ExtendedImage.network(widget.complainData.feedbackImage ?? ''),
                      )
                    : GestureDetector(
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

                                      setState(() {
                                        imgDate = DateTime.now().toString();
                                      });
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

                                      setState(() {
                                        imgDate = DateTime.now().toString();
                                      });
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
              verticalSpace(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  if (widget.user.role != 'admin')
                    Text(
                      widget.complainData.status ?? '-',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  if (widget.user.role == 'admin')
                    DropdownSearch(
                      selectedItem: widget.complainData.status ?? 'Choose Status',
                      onChanged: (value) {
                        setState(() {
                          status = value;
                        });
                      },
                      items: const [
                        'Pending',
                        'Complete',
                        'Reject',
                      ],
                    ),
                  verticalSpace(30)
                ],
              ),
              Text(
                'Description',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              verticalSpace(5),
              widget.user.role == 'admin'
                  ? KTextField(
                      maxLines: 5,
                      minLines: 5,
                      controller: feedbackDescController,
                      borderColor: Colors.black,
                    )
                  : Text(
                      widget.complainData.feedbackDescription ?? '-',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
              verticalSpace(30),
              if (widget.user.role == 'admin')
                Button(
                  isLoading: isLoading,
                  isDisabled: widget.complainData.feedbackImage != "",
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    ComplainData req = ComplainData(
                      description: widget.complainData.description,
                      location: widget.complainData.location,
                      image: widget.complainData.image,
                      uid: widget.complainData.uid,
                      status: status,
                      feedbackDate: imgDate,
                      feedbackDescription: feedbackDescController.text,
                      imageFeedback: File(xFile!.path),
                    );
                    final response = await ComplainDataSource().updateComplaintData(req);
                    setState(() {
                      isLoading = false;
                    });
                    // ignore: use_build_context_synchronously
                    if (response.isRight()) {
                      await ComplainDataSource().getAllComplaint(widget.user.uid ?? "");
                      /* Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            idUser: widget.user.uid ?? '',
                          ),
                        ),
                      ); */
                      // ignore: use_build_context_synchronously
                      AnimatedSnackBar.material(response.toString(), type: AnimatedSnackBarType.success).show(context);
                    }
                    setState(() {});
                  },
                  child: Center(
                    child: Text(
                      'Submit',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
