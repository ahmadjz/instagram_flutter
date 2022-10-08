import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/comment.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/models/user_model.dart';
import 'package:instagram_flutter/providers/backend_streams_and_futures_provider.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/screens/comments_screen.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/global_variable.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';
import 'package:instagram_flutter/widgets/loading_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return user?.uid == null
        ? const LoadingScreen()
        : StreamBuilder<Iterable<Comment>>(
            stream: Provider.of<BackendStreamsAndFuturesProvider>(context)
                .streamAllCommentsForPost(widget.post.postId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              }
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: width > webScreenSize
                        ? secondaryColor
                        : mobileBackgroundColor,
                  ),
                  color: mobileBackgroundColor,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16,
                      ).copyWith(right: 0),
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              uid: widget.post.uid,
                            ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                widget.post.profImage.toString(),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      widget.post.username.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            widget.post.uid.toString() == user!.uid
                                ? postOptionsDialog(context)
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    imageSection(user, context),
                    likeCommentSection(user, context),
                    descriptionAndNumberOfComments(context, snapshot),
                  ],
                ),
              );
            });
  }

  Widget descriptionAndNumberOfComments(
      BuildContext context, AsyncSnapshot<Iterable<Comment>> snapshot) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DefaultTextStyle(
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.w800),
              child: Text(
                '${widget.post.likes.length} likes',
                style: Theme.of(context).textTheme.bodyMedium,
              )),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: primaryColor),
                children: [
                  TextSpan(
                    text: widget.post.username.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' ${widget.post.description}',
                  ),
                ],
              ),
            ),
          ),
          viewAllCommentsSection(snapshot, context),
          dateSection(),
        ],
      ),
    );
  }

  Widget viewAllCommentsSection(
      AsyncSnapshot<Iterable<Comment>> snapshot, BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          'View all ${snapshot.data!.length} comments',
          style: const TextStyle(
            fontSize: 16,
            color: secondaryColor,
          ),
        ),
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CommentsScreen(
            postId: widget.post.postId.toString(),
          ),
        ),
      ),
    );
  }

  Widget dateSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        DateFormat.yMMMd().format(widget.post.datePublished),
        style: const TextStyle(
          color: secondaryColor,
        ),
      ),
    );
  }

  Widget likeCommentSection(UserModel user, BuildContext context) {
    return Row(
      children: <Widget>[
        LikeAnimation(
          isAnimating: widget.post.likes.contains(user.uid),
          smallLike: true,
          child: IconButton(
            icon: widget.post.likes.contains(user.uid)
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border,
                  ),
            onPressed: () => FireStoreMethods().likePost(
              widget.post.postId.toString(),
              user.uid,
              widget.post.likes,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.comment_outlined,
          ),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CommentsScreen(
                postId: widget.post.postId.toString(),
              ),
            ),
          ),
        ),
        IconButton(
            icon: const Icon(
              Icons.send,
            ),
            onPressed: () {}),
        Expanded(
            child: Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
              icon: const Icon(Icons.bookmark_border), onPressed: () {}),
        ))
      ],
    );
  }

  Widget imageSection(UserModel user, BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        FireStoreMethods().likePost(
          widget.post.postId.toString(),
          user.uid,
          widget.post.likes,
        );
        setState(() {
          isLikeAnimating = true;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              widget.post.postUrl.toString(),
              fit: BoxFit.cover,
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isLikeAnimating ? 1 : 0,
            child: LikeAnimation(
              isAnimating: isLikeAnimating,
              duration: const Duration(
                milliseconds: 400,
              ),
              onEnd: () {
                setState(() {
                  isLikeAnimating = false;
                });
              },
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget postOptionsDialog(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          useRootNavigator: false,
          context: context,
          builder: (context) {
            return Dialog(
              child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shrinkWrap: true,
                  children: [
                    'Delete',
                  ]
                      .map(
                        (e) => InkWell(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              child: Text(e),
                            ),
                            onTap: () {
                              deletePost(
                                widget.post.postId.toString(),
                              );
                              // remove the dialog box
                              Navigator.of(context).pop();
                            }),
                      )
                      .toList()),
            );
          },
        );
      },
      icon: const Icon(Icons.more_vert),
    );
  }
}
