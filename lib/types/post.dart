import 'package:flutter/material.dart';

class Post {
  final String id;
  final String city;
  final String description;
  final String selectedRink;
  final DateTime date;
  final double price;
  final String userEmail;
  final String userID;
  String bookedBy;

  Post(
      {this.id,
      @required this.city,
      @required this.description,
      @required this.selectedRink,
      @required this.date,
      @required this.price,
      @required this.userEmail,
      @required this.userID,
      this.bookedBy});
}
