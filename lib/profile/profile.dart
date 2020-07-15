import 'package:firebase_auth/firebase_auth.dart';
import 'package:five_test_pointer/models/model_user.dart';
import 'package:five_test_pointer/utils/firebase/firebase_service.dart';
import 'package:five_test_pointer/widgets/row_lable_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User userMain;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserData();
  }

  Future<User> getUserData() async {
    FirebaseUser user = await getCurrentFirebaseUser();

    DatabaseService<User> userDB = DatabaseService<User>("users",
        fromDS: (id, data) => User.fromJson(data),
        toMap: (user) => user.toJson());

    return await userDB.getSingle(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
        ),
      ),
      body: FutureBuilder<User>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text(" no data");
            return Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(2.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  RowLabelWidget(
                    labelText: "User name",
                    valueText: snapshot.data.username,
                    dividerColor: Colors.black,
                    endIntend: 10,
                    isDividerVisible: true,
                  ),
                  RowLabelWidget(
                    labelText: "Email",
                    valueText: snapshot.data.email,
                    dividerColor: Colors.black,
                    endIntend: 10,
                  ),
                  RowLabelWidget(
                    labelText: "Payment status",
                    valueText: snapshot.data.isPaidForTest ? "DONE" : "PENDING",
                    isDividerVisible: false,
                    endIntend: 10,
                  ),
                ],
              ),
            );
          }),
    );
  }

  Future<FirebaseUser> getCurrentFirebaseUser() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser;
  }
}
