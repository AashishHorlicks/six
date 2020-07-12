import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'Intro/Neet.dart';
import 'Freetype/page_view.dart';

import 'OtherField/feedback.dart';
import 'widgets/maindraw.dart';
import 'widgets/widget.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<String> tx = [
    "Gives user an overview about Neet & Modules provided by our team..",
    "50",
    "description",
    "Users Feedback",
  ];

  Widget child = HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => CustomDrawer.of(context).open(),
                );
              },
            ),
        title: Text('pointer'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
          
        ],
        
      ),
      drawer: CustomDrawer(child: child),
        body:
        ListView(children: <Widget>[
          InkWell(
            onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Neet()),
          );
        },
            child: customcard("NEET ", tx[0]),
          ),
          
          InkWell(
              onTap: () {
          
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MockTest()),
          );
        },
              child: customcard("Test", tx[1])),
          
          InkWell(
              onTap: () {
          
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FeedBack()),
          );
        },
              child: customcard("Competetive Scale", tx[1])),
          
         
          InkWell(
              onTap: () {
          
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FeedBack()),
          );
        },
              child: customcard("Feedback", tx[3])),
        ])
    );
  }
}