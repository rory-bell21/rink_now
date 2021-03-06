import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rink_now/types/post.dart';
import 'package:rink_now/types/user.dart';
import 'package:http/http.dart' as http;

//CONNECTEDPOST MODEL*****************
mixin ConnectedPosts on Model {
  List<Post> posts = [];
  List<Post> myPosts = [];
  bool _isLoading = false;
  User authenticatedUser;
  int selPostIndex;
  int selMyPostIndex;
  String selPostID;
}

//*******************************************************POSTMODEL*******************************************************
mixin PostsModel on ConnectedPosts {
  Future<Null> addPost(String city, String description, String selectedRink,
      DateTime date, double price) {
    Post currPost = Post(
        bookedBy: 'none',
        userEmail: authenticatedUser.email,
        userID: authenticatedUser.id,
        city: city,
        description: description,
        selectedRink: selectedRink,
        date: date,
        price: price);
    final Map<String, dynamic> postData = {
      //convert to format for DB
      'city': currPost.city,
      'description': currPost.description,
      'price': currPost.price,
      'date': currPost.date.toString(),
      'selectedRink': currPost.selectedRink,
      'userEmail': authenticatedUser.email,
      'userID': authenticatedUser.id,
      'bookedBy': "none",
    };
    http
        .post('https://sportsnow-4e1cf.firebaseio.com/posts.json',
            body: json.encode(postData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final Post newPost = Post(
        id: responseData["name"],
        city: currPost.city,
        description: currPost.description,
        selectedRink: currPost.selectedRink,
        price: currPost.price,
        userEmail: authenticatedUser.email,
        userID: authenticatedUser.id,
        date: currPost.date,
        bookedBy: "none",
      );
      posts.add(newPost);
    });
  }

  void sortPosts(String sortBy) {
    switch (sortBy) {
      case "City":
        {
          posts.sort(
              (a, b) => a.city.toLowerCase().compareTo(b.city.toLowerCase()));
        }
        break;
      case "Date":
        {
          posts..sort((a, b) => a.date.compareTo(b.date));
        }
        break;
      case "Price":
        {
          posts..sort((a, b) => a.price.compareTo(b.price));
        }
        break;
      default:
        {}
        break;
    }
  }

  //get all the posts in a list
  List<Post> get allPosts {
    return List.from(posts); //pass by value
  }

  //returns the selected post
  Post get selectedPost {
    if (selPostID == null) {
      return null;
    }
    return posts.firstWhere((Post post) {
      return post.id == selPostID;
    });
  }

  //select a post based on the id
  void selectPost(String postId) {
    selPostID = postId;
  }

  Future<Null> updatePost(String city, String description, String selectedRink,
      DateTime date, double price, String bookedBy) {
    notifyListeners();
    final Map<String, dynamic> updateData = {
      //convert to format for DB
      'city': city,
      'description': description,
      'price': price,
      'date': date.toString(),
      'selectedRink': selectedRink,
      'userEmail': authenticatedUser.email,
      'userID': authenticatedUser.id,
      'bookedBy': bookedBy
    };
    return http
        .put(
            'https://sportsnow-4e1cf.firebaseio.com/posts/${selectedPost.id}.json',
            body: json.encode(updateData))
        .then((http.Response response) {
      final Post updatedPost = Post(
          id: selectedPost.id,
          city: city,
          description: description,
          date: selectedPost.date,
          selectedRink: selectedPost.selectedRink,
          price: price,
          userEmail: selectedPost.userEmail,
          userID: selectedPost.userID);
      posts[selectedPostIndex] = updatedPost;
      notifyListeners();
    });
  }

//--------------------------------
  void fetchPosts(String sortBy) {
    _isLoading = true;
    notifyListeners();
    print("Fetching Posts");
    http
        .get('https://sportsnow-4e1cf.firebaseio.com/posts.json')
        .then((http.Response response) {
      final List<Post> fetchedPosts = [];
      final Map<String, dynamic> postData = json.decode(response.body);
      postData.forEach((String postID, dynamic postData) {
        if (postID != null) {
          final Post currPost = Post(
              id: postID,
              city: postData['city'],
              description: postData['description'],
              selectedRink: postData['selectedRink'],
              price: postData['price'],
              date: DateTime.parse(postData['date']),
              userEmail: postData['userEmail'],
              userID: postData['userID'],
              bookedBy: postData['bookedBy']);
          fetchedPosts.add(currPost);
        }
      });
      posts = fetchedPosts;
      sortPosts(sortBy);
      _isLoading = false;
      notifyListeners();
    });
  }

//special ones for myposts list
  void selectMyPost(int index) {
    selMyPostIndex = index;
    notifyListeners();
  }

  //need
  int get selectedPostIndex {
    return selPostIndex;
  }

  void deletePost(String postID) {
    http
        .delete(
            'https://sportsnow-4e1cf.firebaseio.com/posts/${selectedPost.id}.json')
        .then((http.Response response) {
      //posts.removeAt(index);
    });
    notifyListeners();
  }
}

//USER MODEL********************************
mixin UserModel on ConnectedPosts {
  Future<Map<String, dynamic>> login(String email, String password) async {
    authenticatedUser =
        User(email: email, password: password, id: null, name: null);
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((usr) {
      _isLoading = false;
      notifyListeners();
      authenticatedUser = User(
        email: email,
        password: password,
        id: usr.uid, //responseData["localId"],
        name: usr.displayName,
      );

      return {'success': true, 'message': "a msg"};
    });
  }

  Future<Map<String, dynamic>> signup(
      String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'displayName': name,
      'returnSecureToken': true
    };
    final http.Response response = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyDXdle-9OnW8ZBFhCrHdq-0Jb9u10Df8k8',
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'},
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    }
    _isLoading = false;
    notifyListeners();
    authenticatedUser = User(
        email: email,
        password: password,
        id: responseData["localId"],
        name: name);

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((usr) {
      print(usr.email);
      Firestore.instance.collection('cards').document(usr.uid).setData({
        'custId': usr.uid,
        'email': email,
      });
    });
/*     FirebaseAuth.instance.currentUser().then((user) {
      print(user.uid);
      Firestore.instance.collection('cards').document(user.uid).setData({
        'custId': user.uid,
        'email': email,
      });
    }); */
    return {'success': !hasError, 'message': message};
  }
}
mixin UtilityModel on ConnectedPosts {
  bool get isLoading {
    return _isLoading;
  }
}
