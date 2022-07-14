import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postID;
  final DateTime datePublished;
  final String photoUrl;
  final String profileImage;
  final likes;

  Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postID,
    required this.datePublished,
    required this.photoUrl,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'username': username,
        'postID': postID,
        'datePublished': datePublished,
        'photoUrl': photoUrl,
        'profileImage': profileImage,
        'likes': likes,
      };
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      description: snapshot['description'],
      postID: snapshot['postID'],
      datePublished: snapshot['datePublished'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
      photoUrl: snapshot['photoUrl'],
    );
  }
}
