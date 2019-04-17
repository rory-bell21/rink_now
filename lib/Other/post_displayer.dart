import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rink_now/services/payment_services.dart';
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

  _confirmBook(BuildContext context, MainModel model, Post currPost) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
                'Please confirm that you would like to purchase this ice, your credit card will be charged'),
            actions: <Widget>[
              FlatButton(
                child: Text('DISCARD'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('CONTINUE'),
                onPressed: () {
                  PaymentService(model).buyItem(currPost, model);
                  sleep(const Duration(seconds: 1));
                  Navigator.pop(context);

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          //backgroundColor: Colors.transparent,
                          title: Text(
                            "Payment Successful!",
                            style: TextStyle(
                                fontFamily: 'Oswald',
                                //color: Colors.blue,
                                fontSize: 20.0),
                            textAlign: TextAlign.center,
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(
                                    context, '/posts');
                              },
                            )
                          ],
                        );
                      });
                },
              ),
            ],
          );
        });
  }

  Widget _buildPostItem(BuildContext context, int index) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Post currPost = model.allPosts[index];
      if ((searchFilter == null ||
              searchFilter == "" ||
              currPost.selectedRink
                  .toLowerCase()
                  .contains(searchFilter.toLowerCase())) &&
          (selectedCities.contains(currPost.city) ||
              selectedCities.length == 0) &&
          currPost.bookedBy == "none") {
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
                  Text(
                      '\$' +
                          currPost.price.toStringAsFixed(
                              currPost.price.truncateToDouble() ==
                                      currPost.price
                                  ? 2
                                  : 2),
                      style: TextStyle(
                          //color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Theme(
                      data: ThemeData.dark(),
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
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
                            _confirmBook(context, model, currPost);
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
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return _buildPostList(model.allPosts);
    });
  }
}

class EditPostPage {}
