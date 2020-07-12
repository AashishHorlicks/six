import 'package:five_test_pointer/Database/data.dart';
import 'package:flutter/material.dart';

import './play_quiz.dart';




class MockTest extends StatefulWidget {
  MockTest({Key key}) : super(key: key);

  @override
  _MockTestState createState() => _MockTestState();
}

class _MockTestState extends State<MockTest> {

  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();
  
  bool isLoading = true;
  

  Widget quizList(){
    return Container(
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot){
          return snapshot.data == null 
          ? Container():
          ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return QuizTile(
                quizId: snapshot.data.documents[index].data["quizId"], 
                title: snapshot.data.documents[index].data["quizTitle"],
                description: snapshot.data.documents[index].data["quizDescription"],);
            });         
        }),
    );
  }
  

  @override
  void initState() {
    databaseService.getQuizData().then((val){
      setState(() {
        quizStream = val;
      });
    });
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        elevation: 0.5,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: (){
              showSearch(context: context, 
              delegate: DataSearch());
            }),
        ],
      ),
      body:  quizList(),
    );
  }
  
}

class DataSearch extends SearchDelegate<String>{

  final cities = [
    "polity",
    "history",
    "geography",
  ];

  final recentCities = [
    "polity",
    "history",
    "geography",    
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: (){
      query ="";
    })
    ];  
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation,
        ), 
        onPressed: (){
          close(context, null);
        });
    
  }
  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();

  @override
  Widget buildResults(BuildContext quizlist) {
     return Container(
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot){
          return snapshot.data == null 
          ? Container():
          ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return QuizTile(
                quizId: snapshot.data.documents[index].data["quizId"], 
                title: snapshot.data.documents[index].data["quizTitle"],
                description: snapshot.data.documents[index].data["quizDescription"],);
            });         
        }),
    );
    
  }

  @override
  Widget buildSuggestions(BuildContext context) {
   final suggestionList = query.isEmpty?recentCities:cities.where((p) => p.startsWith(query)).toList();
   return ListView.builder(itemBuilder: (context,index) => ListTile(
     onTap: (){
       showResults(context);
     },
     leading: Icon(Icons.title),
     title: Text(suggestionList[index]) ,
   ),
   itemCount: suggestionList.length,
   );
    
  }
  
}
class QuizTile extends StatelessWidget {
  

  final String quizId;
  final String title;
  final String description;
  QuizTile({@required this.quizId, @required this.title, @required this.description });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => PlayQuiz(quizId)
          ));
      },
          child: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: 200,
        child: Stack(
          children:[         
            Card(
              
                child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[                   
                  Text(title, 
                  textAlign:TextAlign.left,
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 15,                   
                  ) ,
                  ),
                  SizedBox(height: 1,),
                  Text(description, 
                  textAlign:TextAlign.center,
                  style: 
                  TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),),
                ], ),
              ),
              color: Colors.transparent,
              elevation: 20.0,  
            ),
          ],
        ),
      ),
    );
  }
}
