import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

//This method is used to upload the image to the storage.
class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
      //Takes parameters from SignUpUser method in SignupScreen.dart and returns a Future String which is the download url of the file
      String childName,
      Uint8List file,
      bool isPost) async {
    Reference reference =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      reference = reference.child(id);
    }
    UploadTask uploadTask = reference.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    print("Upload Image to Storage was called");
    return downloadUrl;
  }
}
