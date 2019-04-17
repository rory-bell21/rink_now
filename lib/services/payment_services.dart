import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rink_now/scoped_models/main_model.dart';
import 'package:rink_now/types/post.dart';

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

  buyItem(Post currPost, MainModel model) {
    double purchasePrice = currPost.price * 100; //stripe uses cent amount
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('cards')
          .document(user.uid)
          .collection('charges')
          .add({
        'chargeid': "null",
        'currency': 'cad',
        'amount': purchasePrice,
        'description': currPost.description
      });
      model.updatePost(
          currPost.city,
          currPost.description,
          currPost.selectedRink,
          currPost.date,
          currPost.price,
          model.authenticatedUser.id);
    });
  }
}
