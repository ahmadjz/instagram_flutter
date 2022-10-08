import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String text;
  final String name;
  final String uid;
  final String profilePic;
  final String commentId;
  final DateTime datePublished;

  const Comment({
    required this.text,
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.commentId,
    required this.datePublished,
  });

  static Comment fromSnap(QueryDocumentSnapshot<Map<String, dynamic>> snap) {
    var snapshot = snap.data();

    return Comment(
        text: snapshot["text"],
        uid: snapshot["uid"],
        commentId: snapshot["commentId"],
        datePublished: (snapshot["datePublished"] as Timestamp).toDate(),
        profilePic: snapshot["profilePic"],
        name: snapshot['name']);
  }

  Map<String, dynamic> toMap() => {
        "text": text,
        "uid": uid,
        "commentId": commentId,
        "datePublished": datePublished,
        "profilePic": profilePic,
        "name": name,
      };
}
