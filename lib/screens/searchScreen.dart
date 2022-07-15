import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/profileScreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool showUsers = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          decoration: InputDecoration(
              hintText: 'Search',
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              border: InputBorder.none),
          onFieldSubmitted: (String value) {
            print(value);
            setState(() {
              showUsers = true;
            });
          },
        ),
      ),
      body: showUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(uid: (snapshot.data as dynamic).docs[index]['uid'],
                    ),
                    ),
                    ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              (snapshot.data as dynamic).docs[index]['photoUrl']),
                        ),
                        title: Text(
                            (snapshot.data as dynamic).docs[index]['username']),
                        // onTap: () {
                        //   Navigator.pushNamed(context, '/profile',
                        //       arguments: snapshot.data.docs[index].data());
                        // },
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshots.data as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      (snapshots.data as dynamic).docs[index]['photoUrl'],
                      fit: BoxFit.cover,
                    );
                  },
                  staggeredTileBuilder: (index) => StaggeredTile.count(
                      index % 5 == 0 ? 2 : 1, index % 5 == 0 ? 2 : 1),
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                );
              },
            ),
    );
  }
}
