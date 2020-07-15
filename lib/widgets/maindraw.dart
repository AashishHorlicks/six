import 'package:firebase_auth/firebase_auth.dart';
import 'package:five_test_pointer/Freetype/page_view.dart';
import 'package:five_test_pointer/OtherField/register.dart';
import 'package:five_test_pointer/models/model_user.dart';
import 'package:five_test_pointer/utils/dialog/z_imports_dialog.dart';
import 'package:five_test_pointer/utils/firebase/firebase_service.dart';
import 'package:five_test_pointer/utils/preference_manager.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';
import '../profile/profile.dart';

class CustomDrawer extends StatefulWidget {
  final Widget child;

  const CustomDrawer({Key key, @required this.child}) : super(key: key);

  static CustomDrawerState of(BuildContext context) =>
      context.findAncestorStateOfType<CustomDrawerState>();

  @override
  CustomDrawerState createState() => new CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  static const Duration toggleDuration = Duration(milliseconds: 250);
  static const double maxSlide = 225;
  static const double minDragStartEdge = 60;
  static const double maxDragStartEdge = maxSlide - 16;
  AnimationController _animationController;
  bool _canBeDragged = false;

  //TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: CustomDrawerState.toggleDuration,
    );
  }

  void close() => _animationController.reverse();

  void open() => _animationController.forward();

  void toggleDrawer() => _animationController.isCompleted ? close() : open();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_animationController.isCompleted) {
          close();
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: AnimatedBuilder(
          animation: _animationController,
          child: widget.child,
          builder: (context, child) {
            double animValue = _animationController.value;
            final slideAmount = maxSlide * animValue;
            final contentScale = 1.0 - (0.3 * animValue);
            return Stack(
              children: <Widget>[
                MyDrawer(),
                Transform(
                  transform: Matrix4.identity()
                    ..translate(slideAmount)
                    ..scale(contentScale, contentScale),
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: _animationController.isCompleted ? close : null,
                    child: child,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = _animationController.isDismissed &&
        details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromRight = _animationController.isCompleted &&
        details.globalPosition.dx > maxDragStartEdge;

    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      _animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    //I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (_animationController.isDismissed || _animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      _animationController.fling(velocity: visualVelocity);
    } else if (_animationController.value < 0.5) {
      close();
    } else {
      open();
    }
  }
}

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String userId;
  Razorpay razorpay;
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
    return Material(
      color: Colors.white,
      elevation: .8,
      child: SafeArea(
        child: Theme(
          data: ThemeData(brightness: Brightness.light),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Image.asset(
              //   'asset/logo(infinite).jpg',
              //   width: 200,
              //   height: 200,
              // ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                ),
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
                child: ListTile(
                  leading: Icon(Icons.new_releases),
                  title: Text('crunch'),
                ),
              ),
              InkWell(
                onTap: () async{
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
                child: ListTile(
                  leading: Icon(Icons.move_to_inbox),
                  title: Text('Mock Test'),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Payment()),
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Pay'),
                ),
              ),
              InkWell(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  Future<FirebaseUser> getCurrentFirebaseUser() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser;
  }

  Future<void> signOut() async {
    await PreferenceManager.clear();
    FirebaseAuth.instance.signOut();
  }
}
