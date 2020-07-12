import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title : Text("Profile",),
       ),
       body: StreamBuilder(
         stream: Firestore.instance.collection("users").snapshots(),
         builder: (context, snapshot) {
           if (!snapshot.hasData) return Text(" no data");
           return Column(
             children: <Widget>[
               Text(snapshot.data.documents[0]["username"]),
               Text(snapshot.data.documents[0]["email"]),
             ],
           );
         }
         ),
    );
  }
}
