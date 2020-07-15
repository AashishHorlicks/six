import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:five_test_pointer/OtherField/register.dart';
import 'package:five_test_pointer/utils/dialog/z_imports_dialog.dart';
import 'package:five_test_pointer/utils/firebase/firebase_service.dart';
import 'package:five_test_pointer/utils/preference_manager.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';

import 'Intro/Neet.dart';
import 'Freetype/page_view.dart';

import 'OtherField/feedback.dart';
import 'models/model_user.dart';
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

  Razorpay razorpay;

  //TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    razorpay = new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    FirebaseUser user = await getCurrentFirebaseUser();
    DatabaseService<User> userDB = DatabaseService<User>("users",
        fromDS: (id, data) => User.fromJson(data),
        toMap: (user) => user.toJson());

    await userDB.updateData(user.uid, {"isPaidForTest": true});

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MockTest()),
    );
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Toast.show("Failed to complete payment", context, duration: 2);
  }

  void handleExternalWallet(ExternalWalletResponse response) {}

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

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
        body: ListView(children: <Widget>[
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
              onTap: () async {
                FirebaseUser user = await getCurrentFirebaseUser();

                DatabaseService<User> userDB = DatabaseService<User>("users",
                    fromDS: (id, data) => User.fromJson(data),
                    toMap: (user) => user.toJson());

                User userMain = await userDB.getSingle(user.uid);

                if (userMain.isPaidForTest) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MockTest()),
                  );
                } else {
                  DialogHelper().showConfirm(context, "",
                      "You need to pay 999 Rs before accessing TEST.", () {
                    openCheckout();
                  }, "PAY");
                }
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
        ]));
  }

  Future<FirebaseUser> getCurrentFirebaseUser() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser;
  }

  Future<void> signOut() async {
    await PreferenceManager.clear();
    FirebaseAuth.instance.signOut();
  }

  void openCheckout() async {
    FirebaseUser user = await getCurrentFirebaseUser();

    var options = {
      "key": "rzp_test_4Tq0aHyP3wJB5t",
      "amount": 99900,
      "name": user.displayName,
      "description": "add details",
      "prefill": {"contact": "91+", "email": user.email},
      "external": {
        "wallet": ["paytm"]
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }
}
