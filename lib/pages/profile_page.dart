import 'package:flutter/material.dart';
import 'package:rink_now/scoped_models/main_model.dart';
import 'package:rink_now/services/payment_services.dart';

import 'package:rink_now/widgets/hamburger_menu.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  final MainModel model;
  ProfilePage(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HamburgerMenu("My Profile Page"),
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Container(child: Text(model.authenticatedUser.name)),
          //Container(child: Text(model.authenticatedUser.email)),
          RaisedButton(
            child: Text('Add Card'),
            onPressed: () {
              print("button");
              StripeSource.addSource().then((String token) {
                print(token);
                PaymentService(model)
                    .addCard(token); //your stripe card source token
              });
              /* Firestore.instance
                  .collection('books')
                  .document()
                  .setData({'title': 'title', 'author': 'author'}); */
            },
          )
        ],
      )),
    );
  }
}
