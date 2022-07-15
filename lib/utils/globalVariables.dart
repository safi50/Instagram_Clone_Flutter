import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/appPostScreen.dart';
import 'package:instagram_clone/screens/feedScreen.dart';
import 'package:instagram_clone/screens/profileScreen.dart';
import 'package:instagram_clone/screens/searchScreen.dart';

const webScreenSize = 600;

 List<Widget> homeScreenItems = [
const  FeedScreen(),
 const  SearchScreen(),
  const AddPostScreen(),
 const  Text("4"),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
