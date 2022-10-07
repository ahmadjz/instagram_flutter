import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuple/tuple.dart';

class BackendStreamsAndFuturesProvider {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllCommentsForPost(
      String postId) {
    return _firebaseFirestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllPosts() {
    return _firebaseFirestore.collection('posts').snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> searchForUser(String value) {
    return _firebaseFirestore
        .collection('users')
        .where(
          'username',
          isGreaterThanOrEqualTo: value,
        )
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllPostsSortedByDate() {
    return _firebaseFirestore
        .collection('posts')
        .orderBy('datePublished')
        .get();
  }

  // Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(String userId) {
  //   return _firebaseFirestore.collection('users').doc(userId).get();
  // }

  // Future<QuerySnapshot<Map<String, dynamic>>> getAllPostsForUser(
  //     String userId) {
  //   return _firebaseFirestore
  //       .collection('posts')
  //       .where('uid', isEqualTo: userId)
  //       .get();
  // }

  Future<
      Tuple2<DocumentSnapshot<Map<String, dynamic>>,
          QuerySnapshot<Map<String, dynamic>>>> getAllUserInfo(
      String userId) async {
    final userInfo =
        await _firebaseFirestore.collection('users').doc(userId).get();
    final userPosts = await _firebaseFirestore
        .collection('posts')
        .where('uid', isEqualTo: userId)
        .get();

    return Tuple2(userInfo, userPosts);
  }
}
