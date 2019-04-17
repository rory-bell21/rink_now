import 'package:flutter/material.dart';
import 'package:rink_now/scoped_models/main_model.dart';
import 'package:rink_now/services/payment_services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stripe_payment/stripe_payment.dart';

class HamburgerMenu extends StatelessWidget {
  final String currPage;

  HamburgerMenu(this.currPage);

  @override
  Widget build(BuildContext context) {
    return Container(child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              leading: Icon(Icons.burst_mode),
              title: Text('All Posts'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/posts');
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage Posts'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/admin');
              },
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text('My Bookings'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/bookings');
              },
            ),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Add Credit Card'),
              onTap: () {
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
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Info'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/info');
              },
            ),
            ListTile(
              leading: Icon(Icons.input),
              title: Text('Log Out'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      );
    }));
  }
}
