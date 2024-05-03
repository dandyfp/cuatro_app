// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cuatro_application/src/data/models/complain_data.dart';
import 'package:cuatro_application/src/data/models/user_data.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cuatro_application/src/core/components/button.dart';
import 'package:cuatro_application/src/core/components/textfield.dart';
import 'package:cuatro_application/src/core/helpers/ui_helpers.dart';
import 'package:cuatro_application/src/data/complain_datasource.dart';

class ComplaintPage extends StatefulWidget {
  final UserData user;
  final ComplainData? complainData;
  final String idUser;
  final bool? isEdit;
  const ComplaintPage({
    super.key,
    required this.user,
    required this.idUser,
    this.isEdit,
    this.complainData,
  });

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  XFile? xFile;
  String? status;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text(
          'Add Complaint',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            verticalSpace(30),
            Text(
              'Add Image',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            verticalSpace(10),
            Center(
              child: widget.complainData?.image != null
                  ? Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.complainData?.image ?? '',
                            ),
                          ),
                        ),
                      ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (widget.complainData?.location != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        widget.complainData?.location ?? '',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  verticalSpace(4),
                  if (widget.user.role != "admin")
                    KTextField(
                      borderColor: Colors.black,
                      controller: locationController,
                    ),
                  verticalSpace(30),
                  Text(
                    'Description',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (widget.complainData?.description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        widget.complainData?.description ?? '',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  verticalSpace(4),
                  if (widget.user.role != "admin")
                    KTextField(
                      maxLines: 5,
                      minLines: 5,
                      controller: descriptionController,
                      borderColor: Colors.black,
                    ),
                  verticalSpace(30),
                  if (widget.user.role == "admin")
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
                        DropdownSearch(
                          selectedItem: widget.complainData?.status ?? 'Choose Status',
                          onChanged: (value) {
                            setState(() {
                              status = value;
                            });
                          },
                          items: const [
                            'Pending',
                            'Progress',
                            'Complete',
                            'Reject',
                          ],
                        ),
                        verticalSpace(30)
                      ],
                    ),
                  widget.isEdit == false
                      ? Button(
                          onPressed: () async {
                            final response = await ComplainDataSource().uploadProfilePicture(
                              imageFile: File(xFile!.path),
                              location: locationController.text,
                              description: descriptionController.text,
                              idUser: widget.idUser,
                            );

                            // ignore: use_build_context_synchronously
                            if (response.isRight()) AnimatedSnackBar.material('Success', type: AnimatedSnackBarType.success).show(context);
                            if (response.isLeft()) AnimatedSnackBar.material('Failed', type: AnimatedSnackBarType.success).show(context);
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
                      : Button(
                          onPressed: () async {
                            print("object");
                            ComplainData req = ComplainData(
                              description: widget.complainData?.description,
                              location: widget.complainData?.location,
                              image: widget.complainData?.image,
                              uid: widget.complainData?.uid,
                              status: status,
                            );
                            final response = await ComplainDataSource().updateComplaintData(req);
                            // ignore: use_build_context_synchronously
                            if (response.isRight()) AnimatedSnackBar.material(response.toString(), type: AnimatedSnackBarType.success).show(context);
                            setState(() {});
                          },
                          child: Center(
                            child: Text(
                              'Save Change',
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
          ],
        ),
      ),
    );
  }
}
