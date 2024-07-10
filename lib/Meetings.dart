import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'EventDetailPage.dart';

class Meetings extends StatefulWidget {
  const Meetings({super.key});

  @override
  State<Meetings> createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final _databaseref = FirebaseDatabase.instance.ref("events");
  final FirebaseStorage storage = FirebaseStorage.instance;


  @override
  Widget build(BuildContext context) {
    var _orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        appBar: AppBar(
          title: Text("MEETINGS",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30
            ),
          ),
          backgroundColor: Colors.white12,
          forceMaterialTransparency: true,
        ),

        body: Expanded(
            child: StreamBuilder(
              stream: _databaseref.onValue,
              builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
                if(snapshot.connectionState ==ConnectionState.active){
            
                  if(snapshot.hasData){
            
            
                    Map<dynamic , dynamic> map = snapshot.data!.snapshot.value as dynamic;
                    List<dynamic> list = [];
                    list.clear();
                    map.forEach((rollno,idsmap){
            
                      final ids = Map<dynamic, dynamic>.from(idsmap);
                      ids.forEach((ids,value){
                        final event = Map<dynamic,dynamic>.from(value);
                        if(event["Event type"].toString().toLowerCase() == "meetings"){
                          list.add(event);
            
                        }
                      });
                    });
                    if(list.isEmpty){
                      return Center(child: Text("NO EVENTS FOUND",style: TextStyle(color: Colors.grey),),);
                    }
            
                    return GridView.builder(
                        padding: EdgeInsets.all(40),
                        itemBuilder: (context,index){
                          return GestureDetector(
                            child: Container(
                              width: _orientation == Orientation.portrait ? MediaQuery.of(context).size.width -100 : MediaQuery.of(context).size.width/5,
                              height: _orientation == Orientation.portrait ? MediaQuery.of(context).size.height/2 : 100,
                              color: Colors.white,
                              child:Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: Colors.blue,
                                      child: list[index]["Image url"][0] != null ? Image.network(list[index]["Image url"][0],fit: BoxFit.cover) : CircularProgressIndicator(),
                                      height: _orientation == Orientation.portrait? MediaQuery.of(context).size.height /4: 250 ,
                                      width: double.infinity ,
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      "${list[index]["Event name"]}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    _orientation == Orientation.landscape ?
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${list[index]["Event Location"]}"),
                                        Text("HELD ON : ${DateFormat.yMMMEd().format(DateTime.parse(list[index]["date"]))}"),
                                      ],
                                    ) :
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${list[index]["Event description"]}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ) ,
                                        Text("${list[index]["Event Location"]}"),
                                        Text("HELD ON : ${DateFormat.yMMMEd().format(DateTime.parse(list[index]["date"]))}"),
                                        Text("EVENT TIME : ${list[index]["time"]}")
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),

                          );

                        },
                        itemCount: list.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _orientation == Orientation.portrait ? 1 : 2 ,
                          crossAxisSpacing: 50,
                          mainAxisSpacing: 50,
                          childAspectRatio: 0.9,
                        )
                    );
                  }else if(snapshot.hasError){
                    return Center(child: Text("${snapshot.hasError.toString()}"));
                  }
                  else{
                    return Center(child: Text("NO EVENTS ARE CREATED!!"));
                  }
                }else{
                  return Center(child: CircularProgressIndicator(),);
                }
              },
            ),
          ),
    );
  }
}
