// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/userProvider.dart';
import 'package:instagram_clone/resources/firestoreMethods.dart';
import 'package:instagram_clone/screens/commentsScreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/likeAnimation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/models/user.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentCount = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postID'])
          .collection('comments')
          .get();

      setState(() {
        commentCount = snap.docs.length;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            //HEADER SECTION
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profileImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: Colors.blueGrey,
                          child: ListView(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shrinkWrap: true,
                            children: ['Delete Post']
                                .map(
                                  (e) => InkWell(
                                    onTap: () async {
                                      FirestoreMethods()
                                          .deletePost(widget.snap['postID']);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    }),
              ],
            ),
            //IMAGE SECTION
          ),
          GestureDetector(
            onDoubleTap: () async {
              setState(() {
                isLikeAnimating = true;
              });
              await FirestoreMethods().likePost(
                widget.snap['postID'],
                user.uid,
                widget.snap['likes'],
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['photoUrl'],
                    fit: BoxFit.scaleDown,
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),

          // FOOTER SECTION
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                      widget.snap['postID'],
                      user.uid,
                      widget.snap['likes'],
                    );
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(Icons.favorite_border),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                      snap: widget.snap,
                    ),
                  ),
                ),
                icon: Icon(Icons.comment_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.send),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.bookmark_border),
                  ),
                ),
              ),
            ],
          ),
          //DESCRIPTION AND COMMENT SECTION
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w900),
                  child: Text(
                    widget.snap['likes'].length.toString() + ' likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['description']}',
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      commentCount == 0
                          ? ''
                          : 'View all $commentCount comments',
                      style: TextStyle(
                        fontSize: 15,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap['datePublished'].toDate(),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
