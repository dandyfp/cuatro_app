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
    DocumentReference<Map<String, dynamic>> documentReference = FirebaseFirestore.instance.doc('complaints/${complaintData.uid}');

    DocumentSnapshot<Map<String, dynamic>> result = await documentReference.get();
    if (result.exists) {
      await documentReference.update({
        'status': complaintData.status,
      });
      return right('Success');
    } else {
      return left('Failed');
    }
  }

  Future<Either<String, ComplainData>> createComplain(
      {required String location,
      required String description,
      required String image,
      required String idUser,
      String? latitude,
      String? longitude,
      String? imgDate}) async {
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
        'status': 'Waiting',
        'latitude': latitude,
        'longitude': longitude,
        'imgDate': imgDate,
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
    String? latitude,
    String? longitude,
    String? imageDate,
  }) async {
    String fileName = basename(imageFile.path);

    Reference reference = FirebaseStorage.instance.ref().child(fileName);

    try {
      await reference.putFile(imageFile);
      String downloadUrl = await reference.getDownloadURL();
      var createComplaint = await createComplain(
        description: description,
        location: location,
        image: downloadUrl,
        idUser: idUser,
        latitude: latitude,
        longitude: longitude,
        imgDate: imageDate,
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
}
