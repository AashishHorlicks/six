import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';



class OptionTile extends StatefulWidget {
  
  final String option, description, correctAnswer, optionSelected;
  
  
  OptionTile({this.optionSelected,  this.option, this.correctAnswer, this.description});
  

  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
       child: SizedBox(
                height: 24,
                child: ListView(
           scrollDirection: Axis.horizontal,
           children:[
             Container(
               width: 20,
               height: 20,
               alignment: Alignment.center,
               decoration: BoxDecoration(
border: Border.all(
                      color: widget.optionSelected == widget.description
                          ? widget.description == widget.correctAnswer
                              ? Colors.green.withOpacity(0.7)
                              : Colors.red.withOpacity(0.7)
                          : Colors.grey,
                      width: 1.5),
                  color: widget.optionSelected == widget.description
                      ? widget.description == widget.correctAnswer
                      ? Colors.green.withOpacity(0.7)
                      : Colors.red.withOpacity(0.7)
                      : Colors.white,
                borderRadius: BorderRadius.circular(24)            
                 ),
               
               child: AutoSizeText(
                widget.option,
                style: TextStyle(
                  color: widget.optionSelected == widget.description
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
            ),
             SizedBox(width: 10,),

             AutoSizeText(
              '${widget.description}',
              style: TextStyle(fontSize: 17),
              minFontSize: 10,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              )
           ],
         ),
       ),
    );
  }
}

class NoOfQuestionTile extends StatefulWidget {
  final String text;
  final int number;

  NoOfQuestionTile({this.text, this.number});

  @override
  _NoOfQuestionTileState createState() => _NoOfQuestionTileState();
}

class _NoOfQuestionTileState extends State<NoOfQuestionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(30)
              ),
              color: Colors.green
            ),
            child: AutoSizeText(
              "${widget.number}",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
              color: Colors.black54
            ),
            child: Text(
              widget.text,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}