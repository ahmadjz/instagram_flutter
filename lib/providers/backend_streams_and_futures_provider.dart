import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/comment.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/models/user_model.dart';

class BackendStreamsAndFuturesProvider {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Stream<Iterable<Comment>> streamAllCommentsForPost(String postId) {
    final snapshots = _firebaseFirestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots();
    final mappedData = snapshots
        .asyncMap((event) => event.docs.map((e) => Comment.fromSnap(e)));
    return mappedData;
  }

  Stream<Iterable<Post>> streamAllPosts() {
    final snapshots = _firebaseFirestore.collection('posts').snapshots();
    final mappedData =
        snapshots.asyncMap((event) => event.docs.map((e) => Post.fromSnap(e)));
    return mappedData;
  }

  Future<List<UserModel>> searchForUser(String value) async {
    final snapshot = await _firebaseFirestore
        .collection('users')
        .where(
          'username',
          isGreaterThanOrEqualTo: value,
        )
        .get();
    final List<UserModel> users =
        snapshot.docs.map((user) => UserModel.fromSnap(user: user)).toList();
    return users;
  }

  Future<List<Post>> getAllPostsSortedByDate() async {
    final snapshot = await _firebaseFirestore
        .collection('posts')
        .orderBy('datePublished')
        .get();
    final List<Post> posts =
        snapshot.docs.map((post) => Post.fromSnap(post)).toList();
    return posts;
  }

  Future<List<Post>> getAllPostsForUid(String uid) async {
    final snapshot = await _firebaseFirestore
        .collection('posts')
        .where('uid', isEqualTo: uid)
        .get();
    final List<Post> posts =
        snapshot.docs.map((post) => Post.fromSnap(post)).toList();
    return posts;
  }

  Future<UserModel> getUserInfo(String uid) async {
    final user = await _firebaseFirestore.collection('users').doc(uid).get();
    return UserModel.fromSnap(user: user);
  }

  Future<UserModel> getUserInfoAndPosts(String uid) async {
    final userInfo = await getUserInfo(uid);
    final userPosts = await getAllPostsForUid(uid);

    return UserModel(
        username: userInfo.username,
        uid: userInfo.uid,
        photoUrl: userInfo.photoUrl,
        email: userInfo.email,
        bio: userInfo.bio,
        followers: userInfo.followers,
        following: userInfo.following,
        posts: userPosts);
  }
}
