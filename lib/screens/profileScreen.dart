import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text('username'),
          centerTitle: false,
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                       CircleAvatar(
                        backgroundImage:
                            NetworkImage('https://picsum.photos/200'),
                        backgroundColor: Colors.grey,
                        radius: 35,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
    Column buildStatColumn(int num, String label) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
  }
}
