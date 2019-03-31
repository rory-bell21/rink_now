import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class PaymentService {
  addCard(token) {
    print(FirebaseAuth.instance.currentUser().toString() + "************");
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('cards')
          .document(user.uid)
          .collection('tokens')
          .add({'tokenId': token}).then((val) {
        print('saved');
      });
    });
  }
}
