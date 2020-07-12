import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:five_test_pointer/Freetype/page_view.dart';
import 'package:five_test_pointer/home.dart';



class Results extends StatefulWidget {
  final int total, correct, incorrect, notattempted;
  Results({@required this.incorrect, @required this.total, @required this.correct, @required this.notattempted});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            AutoSizeText( "Total number of question:\n${widget.total}" "\nAnswered:\n${widget.correct + widget.incorrect}" "\ncorrect answer: \n${widget.correct}"
            "\nWrong answer: \n${widget.incorrect}""\nResult = ${widget.correct*2 - widget.incorrect*0.66}/${widget.total*2}", 
             style: TextStyle(fontSize: 25),),
              //SizedBox(height: 2,),
              //Container(
               // padding: EdgeInsets.symmetric(horizontal: 24),
                //child: Text(
                  //  "correct answer ${widget.correct} "
                    //  "\n${widget.correct}"
                    //" wrong answer ${widget.incorrect} answeres incorrectly",
                //textAlign: TextAlign.center,),

              //), 
              SizedBox(height: 24,),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) =>MockTest())
                  );
                  
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Go to Test Page", style: TextStyle(color: Colors.white, fontSize: 19),),
                ),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) =>HomePage())
                  );
                  
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Go to MAIN PAGE", style: TextStyle(color: Colors.white, fontSize: 19),),
                ),
              )
          ],),
        ),
      ),
    );
  }
}