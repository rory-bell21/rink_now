import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rink_now/scoped_models/main_model.dart';

class PaymentService {
  MainModel model;
  PaymentService(this.model) {}
  addCard(token) {
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('cards')
          .document(model.authenticatedUser.id)
          .collection('tokens')
          .add({'tokenid': token}).then((val) {
        print(model.authenticatedUser.id);
        print('saved');
      });
    });
  }
}
