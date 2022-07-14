import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/appPostScreen.dart';
import 'package:instagram_clone/screens/feedScreen.dart';
import 'package:instagram_clone/screens/profileScreen.dart';
import 'package:instagram_clone/screens/searchScreen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text("4"),
  ProfileScreen(),
];
