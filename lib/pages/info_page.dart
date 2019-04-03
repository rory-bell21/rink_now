import 'package:flutter/material.dart';

import 'package:rink_now/widgets/hamburger_menu.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HamburgerMenu("in info page"),
      appBar: AppBar(
        title: Text('Information'),
      ),
      body: Center(
          child: Column(children: <Widget>[
        Container(
            alignment: Alignment.topCenter,
            child: Image(
              image: AssetImage('assets/RinkNowLogo.png'),
              height: 400,
              width: 600,
            )),
        Text("Information regarding the app and business will go here",
            textAlign: TextAlign.center)
      ])),
    );
  }
}
