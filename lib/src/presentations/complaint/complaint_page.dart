// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cuatro_application/src/data/models/complain_data.dart';
import 'package:cuatro_application/src/data/models/user_data.dart';
import 'package:cuatro_application/src/presentations/complaint/feedback_page.dart';
import 'package:cuatro_application/src/presentations/home/home_page.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cuatro_application/src/core/components/button.dart';
import 'package:cuatro_application/src/core/components/textfield.dart';
import 'package:cuatro_application/src/core/helpers/ui_helpers.dart';
import 'package:cuatro_application/src/data/complain_datasource.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  XFile? xFile;
  String? status;
  bool isLoadingEdit = false;
  bool isLoading = false;
  bool isLoadingDelete = false;
  String? latitude;
  String? longitude;
  String? imgDate;
  String? typeTrash;

  @override
  void dispose() {
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

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
                      child: ExtendedImage.network(widget.complainData?.image ?? ''),
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
            verticalSpace(10),
            Text(
              'Create At :${imgDate ?? widget.complainData?.imgDate}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
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
                  if (widget.complainData?.location == null)
                    KTextField(
                      minLines: 1,
                      maxLines: 2,
                      isOption: true,
                      borderColor: Colors.black,
                      controller: locationController,
                      onTap: () async {
                        return showModalBottomSheet(
                          context: context,
                          builder: (context) => OpenStreetMapSearchAndPick(
                            buttonColor: Colors.blue,
                            buttonText: 'Set Location',
                            onPicked: (pickedData) {
                              setState(() {
                                locationController.text = pickedData.addressName;
                                longitude = pickedData.latLong.longitude.toString();
                                latitude = pickedData.latLong.latitude.toString();
                              });
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  verticalSpace(30),
                  if (widget.complainData?.name != null)
                    Column(
                      children: [
                        Text(
                          'Name',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            widget.complainData?.name ?? '',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  verticalSpace(4),
                  if (widget.user.role == "admin")
                    Column(
                      children: [
                        verticalSpace(20),
                        Text(
                          'WhatsApp',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            widget.complainData?.whatsapp ?? '-',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (widget.complainData?.whatsapp != null && widget.user.role != "admin")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpace(20),
                        Text(
                          'WhatsApp',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            widget.complainData?.whatsapp ?? '',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        verticalSpace(20),
                      ],
                    ),
                  verticalSpace(4),
                  Text(
                    'Description',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (widget.complainData?.description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        widget.complainData?.description ?? '',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  verticalSpace(4),
                  if (widget.complainData?.description == null)
                    KTextField(
                      maxLines: 5,
                      minLines: 5,
                      controller: descriptionController,
                      borderColor: Colors.black,
                    ),
                  verticalSpace(30),
                  Text(
                    'Classification',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  verticalSpace(4),
                  if (widget.user.role == "admin")
                    Text(
                      widget.complainData?.typeTrash ?? "",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  if (widget.user.role != "admin")
                    DropdownSearch(
                      selectedItem: widget.complainData?.typeTrash ?? 'Choose',
                      dropdownBuilder: (context, selectedItem) {
                        return Text(selectedItem.toString(), style: const TextStyle());
                      },
                      onChanged: (value) {
                        setState(() {
                          typeTrash = value;
                        });
                      },
                      items: const [
                        'LEGAL',
                        'ILEGAL',
                      ],
                    ),
                  verticalSpace(30),

                  /*  if (widget.user.role == "admin")
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
                    ), */
                  widget.isEdit == false && widget.user.role == null
                      ? Button(
                          isLoading: isLoading,
                          isDisabled: isLoading,
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            final response = await ComplainDataSource().uploadProfilePicture(
                              imageFile: File(xFile!.path),
                              location: locationController.text,
                              description: descriptionController.text,
                              idUser: widget.idUser,
                              latitude: latitude,
                              longitude: longitude,
                              imageDate: imgDate,
                              name: widget.user.name ?? '',
                              whatsapp: widget.user.whatsapp ?? '',
                              typeTrash: typeTrash ?? '',
                            );
                            setState(() {
                              isLoading = false;
                            });

                            // ignore: use_build_context_synchronously
                            if (response.isRight()) {
                              // ignore: use_build_context_synchronously
                              AnimatedSnackBar.material('Success', type: AnimatedSnackBarType.success).show(context);
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(
                                    idUser: widget.user.uid ?? '',
                                  ),
                                ),
                              );
                            }
                            // ignore: use_build_context_synchronously
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
                      : widget.user.role == null && widget.complainData != null
                          ? Column(
                              children: [
                                Button(
                                  isDisabled: widget.complainData?.feedbackImage == '' || widget.complainData?.feedbackImage == null,
                                  color: Colors.blue,
                                  onPressed: () {
                                    Navigator.push(
                                      // ignore: use_build_context_synchronously
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FeedBackPage(
                                          complainData: widget.complainData!,
                                          user: widget.user,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      'See Fedback',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                verticalSpace(10),
                                Button(
                                  color: const Color.fromARGB(255, 177, 21, 10),
                                  isLoading: isLoadingDelete,
                                  isDisabled: isLoadingDelete,
                                  onPressed: () async {
                                    setState(() {
                                      isLoadingDelete = true;
                                    });

                                    final response = await ComplainDataSource().deleteComplaint(widget.complainData?.uid ?? '');
                                    setState(() {
                                      isLoadingDelete = false;
                                    });
                                    if (response.isRight()) {
                                      // ignore: use_build_context_synchronously
                                      AnimatedSnackBar.material(response.toString(), type: AnimatedSnackBarType.success).show(context);
                                      Navigator.push(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(
                                            idUser: widget.user.uid ?? '',
                                          ),
                                        ),
                                      );
                                    }
                                    setState(() {});
                                  },
                                  child: Center(
                                    child: Text(
                                      'Delete Data',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Button(
                              isLoading: isLoadingEdit,
                              isDisabled: isLoadingEdit,
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FeedBackPage(
                                        complainData: widget.complainData!,
                                        user: widget.user,
                                      ),
                                    ));
                                /* setState(() {
                                  isLoadingEdit = true;
                                });

                                ComplainData req = ComplainData(
                                  description: widget.complainData?.description,
                                  location: widget.complainData?.location,
                                  image: widget.complainData?.image,
                                  uid: widget.complainData?.uid,
                                  status: status,
                                );
                                final response = await ComplainDataSource().updateComplaintData(req);
                                setState(() {
                                  isLoadingEdit = false;
                                });
                                // ignore: use_build_context_synchronously
                                if (response.isRight()) {
                                  // ignore: use_build_context_synchronously
                                  AnimatedSnackBar.material(response.toString(), type: AnimatedSnackBarType.success).show(context);
                                }
                                setState(() {}); */
                              },
                              child: Center(
                                child: Text(
                                  'Feedback',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                  verticalSpace(20),
                  if (widget.user.role != 'admin' && widget.complainData?.status == 'Complete')
                    Button(
                      isLoading: isLoadingEdit,
                      isDisabled: isLoadingEdit,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                verticalSpace(20),
                                Padding(
                                  padding: const EdgeInsets.only(left: 60.0),
                                  child: Text(
                                    'Rating',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                verticalSpace(20),
                                Center(
                                  child: RatingBar.builder(
                                    initialRating:
                                        widget.complainData?.rating == null ? 0 : double.parse(widget.complainData?.rating.toString() ?? '0'),
                                    itemBuilder: (context, index) {
                                      return const Icon(Icons.star);
                                    },
                                    onRatingUpdate: (value) async {
                                      ComplainData complainData = ComplainData(
                                        description: widget.complainData?.description,
                                        feedbackDate: widget.complainData?.feedbackDate,
                                        feedbackDescription: widget.complainData?.feedbackDescription,
                                        feedbackImage: widget.complainData?.feedbackImage,
                                        idUser: widget.complainData?.idUser,
                                        image: widget.complainData?.image,
                                        imgDate: widget.complainData?.imgDate,
                                        location: widget.complainData?.location,
                                        name: widget.complainData?.name,
                                        uid: widget.complainData?.uid,
                                        status: widget.complainData?.status,
                                        typeTrash: widget.complainData?.typeTrash,
                                        whatsapp: widget.complainData?.whatsapp,
                                        rating: value.toString(),
                                      );

                                      final response = await ComplainDataSource().updateComplaintDataRating(complainData);

                                      if (response.isRight()) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                        // ignore: use_build_context_synchronously
                                        AnimatedSnackBar.material(response.toString(), type: AnimatedSnackBarType.success).show(context);
                                      }
                                      setState(() {});
                                    },
                                  ),
                                ),
                                verticalSpace(10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 70.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Bad',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Good',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                verticalSpace(100),
                              ],
                            );
                          },
                        );
                      },
                      child: Center(
                        child: Text(
                          'Rating',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
