import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rink_now/Other/myBookings_displayer.dart';
import 'package:rink_now/services/payment_services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rink_now/scoped_models/main_model.dart';

import '../types/post.dart';

class PostPage extends StatelessWidget {
  final String postID;
  final MainModel model;

  PostPage(this.postID, this.model);

  _showWarningDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('This action cannot be undone!'),
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
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print("in post build");
    return WillPopScope(
      onWillPop: () {
        print('Back button pressed!');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
        model.selectPost(postID);
        final Post currPost = model.selectedPost;
        return Scaffold(
          appBar: AppBar(
            title: Text("Book Now!"),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.network(
                  'https://i1.wp.com/www.benaco.ca/wp-content/uploads/2015/10/05.jpg?fit=954%2C537'),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text("Title" + currPost.city),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text("Price" + currPost.price.toString()),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text("Description" + currPost.description),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    child: Text('PAY'),
                    onPressed: () => print("Uncomment Below")
                    //PaymentService(model).buyItem(currPost.price),
                    ),
              )
            ],
          ),
        );
      }),
    );
  }
}
