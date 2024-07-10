import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class Feedbackpage extends StatefulWidget {

  var index;
  List idList;
  List rollList;
  Feedbackpage({required this.index, required this.idList, required this.rollList});
  @override
  State<Feedbackpage> createState() => _FeedbackpageState(index : index,idList : idList,rollList :rollList);
}

class _FeedbackpageState extends State<Feedbackpage> {
  TextEditingController _reviewcontroller = TextEditingController();

  var index;
  List idList;
  List rollList;
  var _eventrating;
  _FeedbackpageState({required this.index, required this.idList, required this.rollList});

  final _databaseref = FirebaseDatabase.instance.ref("feedback");

  addreview(var rating,String feedback){
    if(feedback.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter Required fields"),backgroundColor: Colors.red.shade900,behavior: SnackBarBehavior.floating,)
      );
    }else{
      print(index);
      print(rollList);
      print(idList);
      _databaseref.child(rollList[index]).child(idList[index]).child(DateTime.now().microsecondsSinceEpoch.toString()).set({
            "feedback" : feedback,
            "rating" :rating,
            "date" : DateFormat.yMMMEd().format(DateTime.now()).toString()
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser?.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text("REVIEW EVENT",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30
          ),
        ),
        backgroundColor: Colors.blue.shade300,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "RATE THE EVENT",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 10,),
                    RatingBar.builder(
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return Icon(Icons.star,color: Colors.yellow.shade800,);
                      },
                      unratedColor: Colors.yellow.shade100,
                      onRatingUpdate: (rating){
                        print(rating);
                        _eventrating = rating;
                      },
                    ),
                    Divider(
                      height: 100,
                    ),
          
                    Text(
                      "Write a Feedback",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextField(
                      maxLines: null,
                      minLines: 1,
                      keyboardType: TextInputType.streetAddress,
                      controller: _reviewcontroller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blue.shade200,
                                  width: 2
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue.shade600,
                              )
                          ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40,),
                ElevatedButton(
                    onPressed: (){
                      addreview(_eventrating,_reviewcontroller.text.toString());
                      Navigator.pop(context,FirebaseAuth.instance.currentUser?.uid);
                    },
                    child: Text("DONE"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
