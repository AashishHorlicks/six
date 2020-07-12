import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:five_test_pointer/Database/data.dart';
import 'package:five_test_pointer/widgets/play_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './result.dart';



import './question_model.dart';

import 'dart:async';


class PlayQuiz extends StatefulWidget {
  
  final String quizId;
  PlayQuiz(this.quizId);

  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int total = 0;
int _attempted = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

class _PlayQuizState extends State<PlayQuiz> {

  DatabaseService databaseService = new DatabaseService() ;
  QuerySnapshot questionSnapshot;
  
  

  

  QuestionModel getQuestionModelFromDatasnapshot(DocumentSnapshot questionSnapshot){

    QuestionModel questionModel = new QuestionModel();

    questionModel.question = questionSnapshot.data["question"];

    List <String> option = [

      

      questionSnapshot.data["option1"],
      questionSnapshot.data["option2"],
      questionSnapshot.data["option3"],
      questionSnapshot.data["option4"],

    ];
  option.shuffle();
  
  questionModel.option1 = option[0];
  questionModel.option2 = option[1];
  questionModel.option3 = option[2];
  questionModel.option4 = option[3];
  questionModel.correctOption = questionSnapshot.data["option1"];
  questionModel.answered = false;

  

  return questionModel;
  }

  bool isLoading = true;
  

  @override
  void initState() {
    databaseService.gettestData(widget.quizId).then((value) {
      questionSnapshot = value;
      _notAttempted = questionSnapshot.documents.length;
      _attempted = 0;
      _correct = 0;
      _incorrect = 0;
      isLoading = false;
      total = questionSnapshot.documents.length;
      setState(() {});
      print("init don $total ${widget.quizId} ");
    });

    if(infoStream == null){
      infoStream = Stream<List<int>>.periodic(
        Duration(milliseconds: 100), (x){
          print("this is x $x");
          return [_attempted, _correct, _incorrect] ;
      });
    }

    super.initState();
  }
  int timer = 30;
  String showtimer = "30";


  
  
  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return  Scaffold(
        appBar: AppBar(
          title: Text("test 1.1"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          elevation: 0.0,
          actions: <Widget>[
           IconButton(
             icon: Icon(Icons.done_outline), 
             onPressed: (){
               Navigator.of(context).push(MaterialPageRoute(builder: (_){ return Results(
                    correct: _correct,
                    incorrect: _incorrect,
                    total: total,
                    notattempted: _notAttempted,
                    
                  ); 
               })); 
             }
             ), 
          ]          
        ),
        body: isLoading
            ? Container(
          child: Center(child: CircularProgressIndicator()),
        )
            : Column(
              children: <Widget>[
                Expanded(flex: 1,
                child: Container(
                  child: Column(
                    children: [
                      InfoHeader(
                          length: questionSnapshot.documents.length,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                    ],
                  ),
                ),
                ),
                Expanded(flex: 9,
                child: SingleChildScrollView(
                 // scrollDirection: Axis.vertical, 
                child: Container(
                    child: Column(
                      children: [
                        
                        questionSnapshot.documents == null
                            ? Container(
                          child: Center(child: Text("No Data"),),
                        )
                            : ListView.builder(
                                 scrollDirection: Axis.vertical,
                                 
                                itemCount: questionSnapshot.documents.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return QuizPlayTile(
                                    questionModel: getQuestionModelFromDatasnapshot(
                                        questionSnapshot.documents[index]),
                                    index: index,
                                  );
                                })
                      ],
                    ),
                  ),
              ),
                ),
              ],
                        
            ),
            floatingActionButton: FloatingActionButton(
              
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Results(
                    correct: _correct,
                    incorrect: _incorrect,
                    total: total,
                    notattempted: _notAttempted,
                    
                  ) 
                  ));
              }, 
              ),
      );
  }
  
}


Stream infoStream;

class InfoHeader extends StatefulWidget {

  final int length;

  InfoHeader({@required this.length});
  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: infoStream,
      builder: (context, snapshot){
        return snapshot.hasData ? Container(
          height: 40,
          margin: EdgeInsets.only(left: 14),
          child: ListView(
           scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              NoOfQuestionTile(
                text: "Total",
                number: widget.length,
              ),
              NoOfQuestionTile(
                text: "Attempted",
                number: _attempted,
              ),
              
              NoOfQuestionTile(
                text: "NotAttempted",
                number: _notAttempted,
              ),
            ],
          ),
        ) : Container();
      }
    );
  }
}

class QuizPlayTile extends StatefulWidget {
  
  final  QuestionModel questionModel;
  final int index;
  QuizPlayTile({this.questionModel, this.index});
  
  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         
         children: [
           AutoSizeText("Q${widget.index+1} ${widget.questionModel.question}", style: TextStyle(fontSize: 16, color: Colors.black),),
           SizedBox(height: 12,),
          
           GestureDetector(
             onTap: (){
               if(!widget.questionModel.answered){
                 if(widget.questionModel.option1== widget.questionModel.correctOption){
                      
                      setState(() {
                        optionSelected = widget.questionModel.option1;
                      widget.questionModel.answered= true;
                      _correct = _correct + 1;
                      _notAttempted = _notAttempted - 1;
                      _attempted = _attempted +1;
                      print(AutoSizeText("${widget.questionModel.correctOption}"),);
                      });
                 }else{
                   
                      setState(() {
                        optionSelected = widget.questionModel.option1;
                      widget.questionModel.answered= true;
                      _incorrect = _incorrect +1;
                      _notAttempted = _notAttempted - 1;
                      _attempted = _attempted +1;

                      });
                 }
               }
             },
            
               child: 
                OptionTile(
                description: "${widget.questionModel.option1}",
               correctAnswer: widget.questionModel.correctOption,              
               option: "A",
               optionSelected: optionSelected,
              ),
            ),
           SizedBox(height: 20),
           GestureDetector(             
             onTap: (){
               if(!widget.questionModel.answered){
                 if(widget.questionModel.option2== widget.questionModel.correctOption){
                      optionSelected = widget.questionModel.option2;
                      widget.questionModel.answered= true;
                      _correct = _correct + 1;
                      _notAttempted = _notAttempted - 1;
                      _attempted = _attempted +1;
                      setState(() {
                                                
                      });
                 }else{
                   optionSelected = widget.questionModel.option2;
                      widget.questionModel.answered= true;
                      _incorrect = _incorrect +1;
                      _notAttempted = _notAttempted - 1;
                      _attempted = _attempted +1;
                      setState(() {
                        
                      });
                 }
               }
             },
               child: OptionTile(
               correctAnswer: widget.questionModel.correctOption,
               description: widget.questionModel.option2,
               option: "B",
               optionSelected: optionSelected,
             ),
           ),
           SizedBox(height: 20,),
           GestureDetector(
             onTap: (){
               if(!widget.questionModel.answered){
                 if(widget.questionModel.option3== widget.questionModel.correctOption){
                      optionSelected = widget.questionModel.option3;
                      widget.questionModel.answered= true;
                      _correct = _correct + 1;
                      _notAttempted = _notAttempted - 1;
                      _attempted = _attempted +1 ;
                      setState(() {
                        
                      });
                 }else{
                   optionSelected = widget.questionModel.option3;
                      widget.questionModel.answered= true;
                      _incorrect = _incorrect +1;
                      _notAttempted = _notAttempted - 1;
                      _attempted = _attempted +1;
                      setState(() {
                        
                      });
                 }
               }
             },
               child: OptionTile(
               correctAnswer: widget.questionModel.correctOption,
               description: widget.questionModel.option3,
               option: "C",
               optionSelected: optionSelected,
             ),
           ),
           SizedBox(height: 20,),
           GestureDetector(
              onTap: (){
               if(!widget.questionModel.answered){
                 if(widget.questionModel.option4== widget.questionModel.correctOption){
                      optionSelected = widget.questionModel.option4;
                      widget.questionModel.answered= true;
                      _correct = _correct + 1;
                      _notAttempted = _notAttempted - 1;
                      _attempted = _attempted + 1;
                      setState(() {
                        
                      });
                 }else{
                   optionSelected = widget.questionModel.option4;
                      widget.questionModel.answered= true;
                      _incorrect = _incorrect +1;
                      _notAttempted = _notAttempted - 1;
                      _attempted = _attempted + 1;
                      setState(() {
                        
                      });
                 }
               }
             },
               child: OptionTile(
               correctAnswer: widget.questionModel.correctOption,
               description: widget.questionModel.option4,
               option: "D",
               optionSelected: optionSelected,
               
             ),
           ),
           SizedBox(height: 20)
         ],
       ),
    );
  }
}