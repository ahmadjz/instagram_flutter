// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/add_post_screen.dart';
// import 'package:instagram_clone_flutter/screens/add_post_screen.dart';
// import 'package:instagram_clone_flutter/screens/feed_screen.dart';
// import 'package:instagram_clone_flutter/screens/profile_screen.dart';
// import 'package:instagram_clone_flutter/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  // const FeedScreen(),
  // const SearchScreen(),
  // const AddPostScreen(),
  const Text('notifications1'),
  const Text('notifications2'),
  const AddPostScreen(),
  const Text('notifications4'),
  const Text('notifications5'),
  // ProfileScreen(
  //   uid: FirebaseAuth.instance.currentUser!.uid,
  // ),
];
