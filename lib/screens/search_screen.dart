import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/models/user_model.dart';
import 'package:instagram_flutter/providers/backend_streams_and_futures_provider.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/global_variable.dart';
import 'package:instagram_flutter/widgets/loading_screen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration:
                const InputDecoration(labelText: 'Search for a user...'),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
      ),
      body: isShowUsers ? usersBuilder() : postsBuilder(),
    );
  }

  Widget postsBuilder() {
    return FutureBuilder<List<Post>>(
      future: Provider.of<BackendStreamsAndFuturesProvider>(context)
          .getAllPostsSortedByDate(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingScreen();
        }

        return StaggeredGridView.countBuilder(
          crossAxisCount: 3,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) => Image.network(
            snapshot.data![index].postUrl,
            fit: BoxFit.cover,
          ),
          staggeredTileBuilder: (index) =>
              MediaQuery.of(context).size.width > webScreenSize
                  ? StaggeredTile.count(
                      (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                  : StaggeredTile.count(
                      (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        );
      },
    );
  }

  Widget usersBuilder() {
    return FutureBuilder<List<UserModel>>(
      future: Provider.of<BackendStreamsAndFuturesProvider>(context)
          .searchForUser(searchController.text),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }
        if (!snapshot.hasData) {
          return const LoadingScreen();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    uid: snapshot.data![index].uid,
                  ),
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    snapshot.data![index].photoUrl,
                  ),
                  radius: 16,
                ),
                title: Text(
                  snapshot.data![index].username,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
