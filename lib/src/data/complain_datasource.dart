import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuatro_application/src/data/models/complain_data.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ComplainDataSource {
  Future<Either<String, ComplainData>> createComplain({
    required String location,
    required String description,
    required String image,
    required String idUser,
    String? status,
  }) async {
    String date = DateTime.now().toString();
    String id = 'cpl-$date-$idUser';
    CollectionReference<Map<String, dynamic>> complaint = FirebaseFirestore.instance.collection('complaints');
    await complaint.doc(id).set({
      'location': location,
      'idUser': idUser,
      'image': image,
      'description': description,
      'uid': id,
      'status': status,
    });

    DocumentSnapshot<Map<String, dynamic>> result = await complaint.doc(id).get();
    if (result.exists) {
      return right(
        ComplainData.fromJson(result.data()!),
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
      );

      return createComplaint;
    } catch (e) {
      return left("Failed upload image");
    }
  }

  Future<List<ComplainData>> getAllComplaint() async {
    QuerySnapshot<Map<String, dynamic>> complaints = await FirebaseFirestore.instance.collection('complaints').get();
    List<ComplainData> data = complaints.docs.map((e) => ComplainData.fromJson(e.data())).toList();
    return data;
  }
}
