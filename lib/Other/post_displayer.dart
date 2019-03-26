import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rink_now/pages/edit_post.dart';
import 'package:rink_now/scoped_models/main_model.dart';
import 'package:intl/intl.dart';
import '../types/post.dart';

//import 'scoped_models/posts_model.dart';
//import 'types/post.dart';

class PostDisplayer extends StatelessWidget {
  String searchFilter;
  List selectedCities;
  PostDisplayer(this.searchFilter, this.selectedCities);

  //method
  Widget _buildPostItem(BuildContext context, int index) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Post currPost = model.allPosts[index];
      if ((searchFilter == null ||
                  searchFilter == "" ||
                  currPost.selectedRink
                      .toLowerCase()
                      .contains(searchFilter.toLowerCase())) &&
              selectedCities.contains(currPost.city) ||
          selectedCities.length == 0) {
        return Card(
          borderOnForeground: true,
          color: Colors.white54,
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
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Theme(
                      data: new ThemeData.dark(),
                      child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          child: Center(
                              child: Row(
                            children: <Widget>[
                              Icon(Icons.arrow_forward),
                              Text('    Book'),
                            ],
                          )),
                          onPressed: () {
                            model.selectPost(currPost.id);
                            Navigator.pushNamed<bool>(
                                context, '/post/' + currPost.id);
                          }
                          //specifying a page to push to stack?,
                          ))
                ],
              ))
            ],
          ),
        );
      }
      return Container();
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
      return _buildPostList(model.allPosts);
    });
  }
}

class EditPostPage {}
