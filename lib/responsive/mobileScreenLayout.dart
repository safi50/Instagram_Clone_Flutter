// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/userProvider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/globalVariables.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/models/user.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  String username = "";
  // initState() {
  //   super.initState();
  //   getUsername();
  // }

  // void getUsername() async {
  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   setState(() {
  //     username = (snap.data() as Map<String, dynamic>)["username"];
  //   });
  // }
  int _page = 0;
  late PageController pageController;

  @override
  initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void changePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        // physics: NeverScrollableScrollPhysics(),  // This stops the page changes with swiping.
        controller: pageController,
        onPageChanged: changePage,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? primaryColor : secondaryColor,
            ),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,
                color: _page == 1 ? primaryColor : secondaryColor),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle,
                color: _page == 2 ? primaryColor : secondaryColor),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite,
                color: _page == 3 ? primaryColor : secondaryColor),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _page == 4 ? primaryColor : secondaryColor),
            label: "",
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
