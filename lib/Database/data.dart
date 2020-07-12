import "package:cloud_firestore/cloud_firestore.dart";


class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  

  

  getprofileview()async{
    return Firestore.instance.collection("users").snapshots();
  }

  getQuizData() async{
    return await Firestore.instance.collection("Quiz").snapshots();
  }

  gettestData(String quizId) async {
    return await Firestore.instance
    .collection("Quiz")
    .document(quizId).collection("QNA").getDocuments();
  }
  
}