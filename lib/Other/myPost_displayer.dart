import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rink_now/scoped_models/main_model.dart';

import '../types/post.dart';

//import 'scoped_models/posts_model.dart';
//import 'types/post.dart';

class MyPostsDisplayer extends StatelessWidget {
  //method
  Widget _buildPostItem(BuildContext context, int index) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      if (model.posts[index].userEmail == model.authenticatedUser.email) {
        final Post currPost = model.posts[index];
        return Card(
            borderOnForeground: true,
            color: Colors.white54,
            child: Row(children: <Widget>[
              Expanded(
                  child: Column(
                children: <Widget>[
                  Text(
                    currPost.selectedRink,
                    style: TextStyle(
                        fontFamily: 'Oswald',
                        color: Colors.blue,
                        fontSize: 15.0),
                    textAlign: TextAlign.left,
                  ),
                  Text(currPost.city),
                  Padding(padding: EdgeInsets.all(8.0)),
                  Text(DateFormat.MMMd().format(currPost.date),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(DateFormat.jm().format(currPost.date)),
                ],
              )),
              Expanded(child: Container()),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text('\$' + currPost.price.toString(),
                        style: TextStyle(
                            fontFamily: 'Oswald',
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    RaisedButton(
                        child: Text('Edit'),
                        onPressed: () {
                          model.selectPost(currPost.id);
                          Navigator.pushNamed<bool>(
                              context, '/edit/' + currPost.id);
                        }
                        //specifying a page to push to stack?,
                        )
                  ],
                ),
              )
            ]));
      } else {
        return Container();
      }
    });
  }

  //method
  Widget _buildPostList(List<Post> posts) {
    Widget postCards;
    if (posts.length > 0) {
      postCards = ListView.builder(
        itemBuilder: _buildPostItem,
        itemCount: posts.length,
      );
    } else {
      postCards = Container();
    }
    print(postCards.toString());
    return postCards;
  }

  //BUILD Method
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return _buildPostList(model.posts);
    });
  }
}
