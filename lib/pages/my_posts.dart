import 'package:flutter/material.dart';
import 'package:rink_now/Other/myPost_displayer.dart';

import 'package:rink_now/scoped_models/main_model.dart';

class MyPostsPage extends StatefulWidget {
  final MainModel model;
  MyPostsPage(this.model);
  @override
  createState() {
    return MyPostsPageState();
  }
}

class MyPostsPageState extends State<MyPostsPage> {
  @override
  void initState() {
    widget.model
        .fetchPosts("Date"); //sets variable in model to this user's posts
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("in my post build");
    return Column(
      children: [Expanded(child: MyPostsDisplayer())],
    );
  }
}
