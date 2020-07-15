import 'package:five_test_pointer/Freetype/page_view.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Razorpay razorpay;
  //TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    razorpay = new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_SpV51wtxO2xnbZ",
      "amount": 50000,
      "name": "1",
      "description": "add details",
      "prefill": {"contact": "91+", "email": ""},
      "external": {
        "wallet": ["paytum"]
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess() {
    print("Payment Success");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MockTest()),
    );
  }

  void handlerErrorFailure() {
    print("Payment Failed");
  }

  void handlerExternalWallet() {
    print("External Wallet");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Gateway"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          RaisedButton(
              color: Colors.transparent,
              child: Center(
                child: Text(
                  "PAY HERE",
                ),
              ),
              onPressed: () {
                openCheckout();
              })
        ],
      ),
    );
  }
}
