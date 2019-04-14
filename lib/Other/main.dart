import 'package:flutter/material.dart';
import 'package:rink_now/pages/auth.dart';
import 'package:rink_now/pages/edit_post.dart';
import 'package:rink_now/pages/info_page.dart';
import 'package:rink_now/pages/manage_posts.dart';
import 'package:rink_now/pages/my_bookings.dart';
import 'package:rink_now/pages/post_page.dart';
import 'package:rink_now/pages/post_list.dart';
import 'package:rink_now/pages/profile_page.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:rink_now/scoped_models/main_model.dart';
import 'package:stripe_payment/stripe_payment.dart';

// import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
        //passes scoped model down widget tree
        model: model,
        child: MaterialApp(
          // debugShowMaterialGrid: true,
          theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blueGrey,
              accentColor: Colors.grey,
              fontFamily: "assets/Oswald-Bottfld.ttf"),
          // home: AuthPage(),
          routes: {
            //This allows you to specify these keys from other classes to navigate
            '/': (BuildContext context) => AuthPage(),
            '/posts': (BuildContext context) => PostListPage(model),
            '/bookings': (BuildContext context) => MyBookingsPage(model),
            '/admin': (BuildContext context) => ManagePosts(model),
            '/info': (BuildContext context) => InfoPage(),
            '/profile': (BuildContext context) => ProfilePage(model),
          },
          //below gets called when name not in routes, dynamically pass data too post page....
          onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');
            print(pathElements);
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1] == 'post') {
              final String postID = pathElements[2];
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => PostPage(postID, model),
              );
            } else if (pathElements[1] == 'edit') {
              final String postID = pathElements[2];
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => PostEditPage(postID, model),
              );
            }
            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) => PostListPage(model));
          },
        ));
  }
}
