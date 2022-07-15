import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storageMethods.dart';
import 'package:instagram_clone/utils/utils.dart';

class AuthMethods {
  //Creating Instances of Firebase and Firestore to store Data
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  // Sign Up with Email and Password
  //This takes in parameters from signupUser Method in SignUpscreen.dart and creates a new user in Firebase.
  //Stores email and password using authentication
  //Stores user data in Database
  //Stores images in Storage
  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    String bio = "",
    required Uint8List file,
  }) async {
    String res = 'Error! Something unexpected happened.';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          file != null) {
        // Registering user with Firebase Auth
        //Storing Data in AUthentication
        UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(credentials.user!.uid);

        //This gets the download url of our images by calling uploadImagetoStorage method, then stores this url in Firebase Storage and finally returns the Url
        //The url is then stored in string photourl and then the url is uploaded to Firebase Databse too.
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('ProfilePictures', file, false);
        print('storage method called');

        model.User user = model.User(
          username: username,
          uid: credentials.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        //Here, we are inserting data in the Firestore database
        await _firestore
            .collection('users')
            .doc(credentials.user!.uid)
            .set(user.toJson());
        res = 'Success!';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Log In with Email and Password
  //This takes in parameters from loginUser Method in LoginScreen.dart and authenticates the user in Firebase.
  //Stores email and password using authentication
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Error! Something unexpected happened.';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'Success!';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
  await _auth.signOut();
}
 }
