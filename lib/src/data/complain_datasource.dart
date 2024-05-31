import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuatro_application/src/data/models/complain_data.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ComplainDataSource {
  Future<Either<String, String>> deleteComplaint(String uid) async {
    DocumentReference<Map<String, dynamic>> documentReference = FirebaseFirestore.instance.doc('complaints/$uid');
    DocumentSnapshot<Map<String, dynamic>> result = await documentReference.get();

    if (result.exists) {
      await documentReference.delete();

      return right('Success Delete');
    } else {
      return left('Failed delete');
    }
  }

  Future<Either<String, String>> updateComplaintData(ComplainData complaintData) async {
    String fileName = basename(complaintData.imageFeedback!.path);
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    await reference.putFile(complaintData.imageFeedback!);
    String downloadUrl = await reference.getDownloadURL();

    DocumentReference<Map<String, dynamic>> documentReference = FirebaseFirestore.instance.doc('complaints/${complaintData.uid}');

    DocumentSnapshot<Map<String, dynamic>> result = await documentReference.get();
    if (result.exists) {
      await documentReference.update({
        'status': complaintData.status,
        'imageFeedback': downloadUrl,
        'descFeedback': complaintData.feedbackDescription,
        'dateFeedback': complaintData.feedbackDate,
        'rating': complaintData.rating,
      });
      return right('Success');
    } else {
      return left('Failed');
    }
  }

  Future<Either<String, String>> updateComplaintDataRating(ComplainData complaintData) async {
    DocumentReference<Map<String, dynamic>> documentReference = FirebaseFirestore.instance.doc('complaints/${complaintData.uid}');

    DocumentSnapshot<Map<String, dynamic>> result = await documentReference.get();
    if (result.exists) {
      await documentReference.update({
        'status': complaintData.status,
        'imageFeedback': complaintData.feedbackImage,
        'descFeedback': complaintData.feedbackDescription,
        'dateFeedback': complaintData.feedbackDate,
        'rating': complaintData.rating,
      });
      return right('Success');
    } else {
      return left('Failed');
    }
  }

  Future<Either<String, ComplainData>> createComplain({
    required String location,
    required String description,
    required String image,
    required String idUser,
    required String name,
    required String whatsapp,
    String? latitude,
    String? longitude,
    String? imgDate,
    String? imageFeedback,
    String? descFeedback,
    String? dateFeedback,
    String? typeTrash,
  }) async {
    String date = DateTime.now().toString();
    String id = 'cpl-$date-$idUser';
    CollectionReference<Map<String, dynamic>> complaint = FirebaseFirestore.instance.collection('complaints');
    await complaint.doc(id).set(
      {
        'location': location,
        'idUser': idUser,
        'image': image,
        'description': description,
        'uid': id,
        'status': 'Pending',
        'latitude': latitude,
        'longitude': longitude,
        'imgDate': imgDate,
        'imageFeedback': imageFeedback,
        'descFeedback': descFeedback,
        'dateFeedback': dateFeedback,
        'name': name,
        'whatsapp': whatsapp,
        'typeTrash': typeTrash,
      },
    );

    DocumentSnapshot<Map<String, dynamic>> result = await complaint.doc(id).get();
    if (result.exists) {
      return right(
        ComplainData.fromJson(
          result.data()!,
        ),
      );
    } else {
      return left('failed to create complaint');
    }
  }

  Future<Either<String, ComplainData>> uploadProfilePicture({
    required File imageFile,
    required String location,
    required String description,
    required String idUser,
    required String name,
    required String whatsapp,
    String? latitude,
    String? longitude,
    String? imageDate,
    File? imageFeedback,
    String? descFeedback,
    String? dateFeedback,
    required String typeTrash,
  }) async {
    String fileName = basename(imageFile.path);

    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    /*  Reference? referenceImageFeedback;
    if (imageFeedback != null) {
      String fileNameImageFeedback = basename(imageFeedback.path);
      referenceImageFeedback = FirebaseStorage.instance.ref().child(fileNameImageFeedback);
    } */

    try {
      await reference.putFile(imageFile);
      /*  if (referenceImageFeedback != null) {
        await referenceImageFeedback.putFile(imageFile);
      } */
      String downloadUrl = await reference.getDownloadURL();
      // String downloadUrlImageFeedback = await referenceImageFeedback!.getDownloadURL();
      var createComplaint = await createComplain(
        description: description,
        location: location,
        image: downloadUrl,
        idUser: idUser,
        latitude: latitude,
        longitude: longitude,
        imgDate: imageDate,
        imageFeedback: '',
        descFeedback: '',
        dateFeedback: '',
        name: name,
        whatsapp: whatsapp,
        typeTrash: typeTrash,
      );

      return createComplaint;
    } catch (e) {
      return left("Failed upload image");
    }
  }

  Future<List<ComplainData>> getAllComplaint(String userId) async {
    QuerySnapshot<Map<String, dynamic>> complaints =
        await FirebaseFirestore.instance.collection('complaints').where('idUser', isEqualTo: userId).get();
    List<ComplainData> data = complaints.docs.map((e) => ComplainData.fromJson(e.data())).toList();
    return data;
  }

  Future<List<ComplainData>> getAllComplaintForAdmin() async {
    QuerySnapshot<Map<String, dynamic>> complaints = await FirebaseFirestore.instance.collection('complaints').get();
    List<ComplainData> data = complaints.docs.map((e) => ComplainData.fromJson(e.data())).toList();
    return data;
  }

  Future<List<ComplainData>> getAllComplaintComplete() async {
    QuerySnapshot<Map<String, dynamic>> complaints =
        await FirebaseFirestore.instance.collection('complaints').where('status', isEqualTo: 'Complete').get();
    List<ComplainData> data = complaints.docs.map((e) => ComplainData.fromJson(e.data())).toList();
    return data;
  }

  Future<List<ComplainData>> getAllComplaintReject() async {
    QuerySnapshot<Map<String, dynamic>> complaints =
        await FirebaseFirestore.instance.collection('complaints').where('status', isEqualTo: 'reject').get();
    List<ComplainData> data = complaints.docs.map((e) => ComplainData.fromJson(e.data())).toList();
    return data;
  }
}
