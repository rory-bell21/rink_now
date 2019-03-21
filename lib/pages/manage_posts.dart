import 'package:flutter/material.dart';
import 'package:rink_now/pages/create_post.dart';
import 'package:rink_now/pages/edit_post.dart';
import 'package:rink_now/pages/my_posts.dart';
import 'package:rink_now/scoped_models/main_model.dart';

import 'package:rink_now/widgets/hamburger_menu.dart';

class ManagePosts extends StatefulWidget {
  final MainModel model;
  ManagePosts(this.model);
  @override
  createState() {
    return ManagePostsState();
  }
}

class ManagePostsState extends State<ManagePosts> {
  @override
  void initState() {
    widget.model.fetchPosts("Date");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("[manage post] build()");
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: HamburgerMenu("anuthing"),
        appBar: AppBar(
          title: Text('Manage Posts'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Create Post',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'My Posts',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[PostCreatePage(), MyPostsPage(widget.model)],
        ),
      ),
    );
  }
}
