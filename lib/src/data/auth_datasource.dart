import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuatro_application/src/data/models/request/auth_request.dart';
import 'package:cuatro_application/src/data/models/user_data.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class AuthDataSource {
  String? getInLoggedUser() => FirebaseAuth.instance.currentUser?.uid;

  Future<Either<String, String>> resetPassword(
    AuthRequest req,
  ) async {
    await login(email: req.email ?? "", password: req.password ?? "");
    if (getInLoggedUser() != null) {
      await FirebaseAuth.instance.currentUser!.delete();

      return right('Success Reset Password');
    } else {
      return left('Failed to get in logged user');
    }
  }

  Future<Either<String, String>> register({
    required AuthRequest req,
  }) async {
    String fileName = basename(req.imageFile!.path);
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    await reference.putFile(req.imageFile!);
    String downloadUrl = await reference.getDownloadURL();

    String fileNameIdentity = basename(req.identityFile!.path);
    Reference referenceIdentity = FirebaseStorage.instance.ref().child(fileNameIdentity);
    await referenceIdentity.putFile(req.identityFile!);
    String downloadIdentityUrl = await referenceIdentity.getDownloadURL();

    var userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: req.email ?? "", password: req.password ?? '');
    late DocumentSnapshot<Map<String, dynamic>> resultGetUser;
    if (userCredential.user?.uid != null) {
      CollectionReference<Map<String, dynamic>> users = FirebaseFirestore.instance.collection("Users");
      await users.doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'name': req.name,
        'email': req.email,
        'password': req.password,
        'imageProfile': downloadUrl,
        'whatsapp': req.whatsapp,
        'imageIdentity': downloadIdentityUrl,
        'status': '',
      });

      DocumentSnapshot<Map<String, dynamic>> result = await users.doc(userCredential.user?.uid).get();
      resultGetUser = result;
    }

    if (resultGetUser.exists) {
      return right('Register success');
    } else {
      return left('login failed');
    }
  }

  Future<Either<String, String>> login({required String email, required String password}) async {
    try {
      var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(result.user?.uid ?? '');
    } on FirebaseAuthException catch (e) {
      return left(e.message ?? '');
    }
  }

  Future<Either<String, UserData>> getUser(String uid) async {
    DocumentReference<Map<String, dynamic>> documentReference = FirebaseFirestore.instance.doc('Users/$uid');

    DocumentSnapshot<Map<String, dynamic>> result = await documentReference.get();
    if (result.exists) {
      return right(UserData.fromJson(result.data()!));
    } else {
      return left("Failed to get user");
    }
  }

  Future<Either<String, String>> updateUser(UserData user) async {
    DocumentReference<Map<String, dynamic>> documentReference = FirebaseFirestore.instance.doc('Users/${user.uid}');

    DocumentSnapshot<Map<String, dynamic>> result = await documentReference.get();
    if (result.exists) {
      await documentReference.update({
        'email': user.email,
        'imageIdentity': user.imageIdentity,
        'imageProfile': user.imageProfile,
        'name': user.name,
        'role': user.role,
        'uid': user.uid,
        'whatsapp': user.whatsapp,
        'password': user.password,
        'status': user.status
      });
      return right('Success');
    } else {
      return left('Failed');
    }
  }
}
