import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rink_now/pages/edit_post.dart';
import 'package:rink_now/scoped_models/main_model.dart';
import 'package:intl/intl.dart';
import '../types/post.dart';

//import 'scoped_models/posts_model.dart';
//import 'types/post.dart';

class PostDisplayer extends StatelessWidget {
  String filter;
  PostDisplayer(this.filter);

  //method
  Widget _buildPostItem(BuildContext context, int index) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Post currPost = model.allPosts[index];
      if (filter == null ||
          filter == "" ||
          currPost.selectedRink.toLowerCase().contains(filter.toLowerCase())) {
        return Card(
          child: Row(
            children: <Widget>[
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
                  Text(DateFormat.MMMd().format(currPost.date)),
                  Text(DateFormat.jm().format(currPost.date)),
                ],
              )),
              Expanded(child: Container()),
              Expanded(
                  child: Column(
                children: <Widget>[
                  Text('\$' + currPost.price.toString(),
                      style: TextStyle(color: Colors.green)),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                          color: Colors.lightBlueAccent,
                          child: Text('Book'),
                          onPressed: () {
                            model.selectPost(currPost.id);
                            Navigator.pushNamed<bool>(
                                context, '/post/' + currPost.id);
                          }
                          //specifying a page to push to stack?,
                          )
                    ],
                  ),
                ],
              ))
            ],
          ),
        );
      }
      return Card();
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
    return postCards;
  }

  //BUILD Method
  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      print("in builddddd");
      return _buildPostList(model.allPosts);
    });
  }
}

class EditPostPage {}
