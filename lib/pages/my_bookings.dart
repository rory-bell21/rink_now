import 'package:flutter/material.dart';
import 'package:rink_now/Other/post_displayer.dart';
import 'package:rink_now/scoped_models/main_model.dart';

import 'package:rink_now/widgets/hamburger_menu.dart';

class MyBookingsPage extends StatefulWidget {
  final MainModel model;
  MyBookingsPage(this.model);
  @override
  createState() {
    return MyBookingsPageState();
  }
}

class MyBookingsPageState extends State<MyBookingsPage> {
  @override
  void initState() {
    widget.model.fetchPosts("Date");
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HamburgerMenu("My Bookings"),
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: Center(
        child: Text(
          "COMING SOON!\nAll bookings a user has made will appear on this page",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
