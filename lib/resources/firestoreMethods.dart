import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storageMethods.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profileImage) async {
    String res = "Something Unexpected Happened!";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);
      String postID = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postID: postID,
        datePublished: DateTime.now(),
        photoUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );

      _firestore.collection("posts").doc(postID).set(post.toJson());

      res = "Success";
    } catch (e) {
      res = res.toString();
    }
    return res;
  }

  Future<void> likePost(String postID, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postID).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
        print('photo unliked');
      } else {
        await _firestore.collection("posts").doc(postID).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
        print('photo liked');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postID, String text, String uid,
      String name, String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentID = const Uuid().v1();
        await _firestore
            .collection("posts")
            .doc(postID)
            .collection("comments")
            .doc(commentID)
            .set(
          {
            "text": text,
            "uid": uid,
            "name": name,
            "profilePic": profilePic,
            "commentID": commentID,
            "datePublished": DateTime.now(),
          },
        );
        return "Success";
      } else {
        return "Comment is empty";
      }
    } catch (e) {
      return e.toString();
    }
  }

  //Deleting Post
  Future<void> deletePost(String postID) async {
    try {
      await _firestore.collection("posts").doc(postID).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
