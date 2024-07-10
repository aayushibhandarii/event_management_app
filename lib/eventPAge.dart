
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:practice/EventDetailPage.dart';
import 'package:practice/LogInPage.dart';
import 'package:practice/Meetings.dart';
import 'package:practice/SearchPage.dart';
import 'package:practice/SignUpPage.dart';
import 'package:practice/SocialEvent.dart';
import 'package:practice/Workshops.dart';
import 'package:practice/about.dart';
import 'package:practice/userOrOrganizer.dart';

class EventPage extends StatefulWidget{
  String? email;
  bool isSignup;
  String? username;
  EventPage({this.email,this.isSignup = false,this.username});
  @override
  State<EventPage> createState() => EventPageState(email : email , isSignup : isSignup,username : username);

}

class EventPageState extends State<EventPage>{
  String? email;
  String? SelectedCategory;
  String _selectedItem = 'Workshops';
  bool isSignup;
  String? username;
  var userid = FirebaseAuth.instance.currentUser!.uid;

  EventPageState({this.email,this.isSignup = false,this.username});

  final Map _categories = {
    'WORKSHOP' : Workshops(),
    'SOCIAL EVENT' :Socialevent(),
    'MEETINGS' : Meetings()
  };

  final List<String> _dropdownItems = ['WORKSHOP', 'SOCIAL EVENT', 'MEETINGS'];
  bool _isDropdownExpanded = false;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final _databaseref = FirebaseDatabase.instance.ref("events");

  var idList;
  var _selectedSortOption = "";


  getname()async{

    if(! isSignup){
      FirebaseDatabase.instance.ref("users").child(userid).child("email").once().then((value){
        email = value.snapshot.value.toString();
      });
      FirebaseDatabase.instance.ref("users").child(userid).child("name").once().then((value){
        username = value.snapshot.value.toString();
      });
    }
  }
  int compareTime(String a, String b){
    List timea = a.split(":");
    List timeb = b.split(":");
    if(int.parse(timea[0]) != int.parse(timeb[0])){
      return int.parse(timea[0]) - int.parse(timeb[0]);
    }else if(int.parse(timea[1]) != int.parse(timeb[1])){
      return int.parse(timea[1]) - int.parse(timeb[1]);
    }
    return 0;
  }


  @override
  void initState(){
    if(isSignup){
      FirebaseDatabase.instance.ref("users").child(userid).set({
        "email" : email,
        "role" : "user",
        "name" : username
      });
    }
  }

  @override
  Widget build(BuildContext context){
    getname();
    var _orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        appBar: AppBar(
          title: Text("EVENT",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30
            ),
          ),

          actions: [
            IconButton(
                icon: Icon(Icons.search),
                color: Colors.white,
              iconSize: 30,
              onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => Searchpage(),
                      )
                  );
              },
            ),
          ],
          backgroundColor: Colors.white12,
          forceMaterialTransparency: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                  accountName: Text(
                      "${username}",

                    style: TextStyle(
                        color: Colors.black87,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  accountEmail: Text(
                      "${email}" ,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                    ),
                  ),
                currentAccountPicture: Icon(
                    Icons.account_circle_outlined,
                  color: Colors.white,
                  size: 50,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade400
                ),
              ),
        ExpansionTile(
          title: Text('Categories'),
          trailing: Icon(
              _isDropdownExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down
          ),
          onExpansionChanged: (bool expanded) {
            setState(() {
              _isDropdownExpanded = expanded;
            });
          },
          children: _dropdownItems.map((String value) {
            return ListTile(
              title: Text(value),
              onTap: () {
                setState(() {
                  _selectedItem = value;
                  _isDropdownExpanded = false;
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => _categories[value]
                      )
                  );
                });
              },
            );
          }).toList(),
        ),
                ListTile(
                  title: Text("settings"),
                ),
                ListTile(
                  title: Text("Logout"),
                  onTap: (){
                    FirebaseAuth.instance.signOut().then((value){
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => check()
                          )
                      );
                    });
                  },
                )
    ],

          ),
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
                onPressed: (){
                  showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero)
                      ),
                      builder: (context){
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile(
                                  value: "Date",
                                  title: Text('Date'),
                                  groupValue: _selectedSortOption,
                                  onChanged: (value){
                                    print(value);
                                    setState(() {
                                      _selectedSortOption =value!;
                                      Navigator.pop(context);
                                    });
                                  }
                              ),
                              RadioListTile(
                                  value: "Time",
                                  title: Text('Time'),
                                  groupValue: _selectedSortOption,
                                  onChanged: (value){

                                    print(value);
                                    setState(() {
                                      _selectedSortOption =value!;
                                      Navigator.pop(context);
                                    });
                                  }
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Wrap(
                  children: [
                    Text("SORT BY ",style: TextStyle(color: Colors.blue),),
                    Icon(Icons.arrow_drop_down)
                  ],
                )
            ),
    )
            ,Expanded(
              child: StreamBuilder(
                stream: _databaseref.onValue,
                builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
                  if(snapshot.connectionState ==ConnectionState.active){

                    if(snapshot.hasData){
                      Map<dynamic , dynamic> map = snapshot.data!.snapshot.value as dynamic;
                      List<dynamic> list = [];
                      List<dynamic> idList = [];
                      List<dynamic> rollList = [];
                      idList.clear();
                      list.clear();
                      map.forEach((rollno,idsmap){
                        final ids = Map<dynamic, dynamic>.from(idsmap);

                        ids.forEach((ids,value){
                          rollList.add(rollno);
                          idList.add(ids);

                          final event = Map<dynamic,dynamic>.from(value);
                            list.add(event);
                        });

                      });

                      if(list.isEmpty){
                        return Center(child: Text("NO EVENTS FOUND",style: TextStyle(color: Colors.grey),),);
                      }
                      if(list.length >1){
                        if(_selectedSortOption == "Date"){
                          list.sort((a,b) => DateTime.parse(a["date"]).compareTo(DateTime.parse(b["date"])));
                        }else if(_selectedSortOption == "Time"){
                          list.sort((a,b) => compareTime(a["time"], b["time"]));
                        }
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
                              onTap: (){
                                print(rollList);
                                print(idList);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventDetail(index : index,eventname : list[index]["Event name"],list :list,idList : idList,rollList:rollList,username : username)
                                    )
                                );
                              },

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
        ],
      )

    );
  }
}
class popupItemsClass{
  final String title;
  final Icon icon;
  popupItemsClass({required this.title,required this.icon});
}
List<popupItemsClass> popupitemslist = [
  popupItemsClass(title: "Edit", icon: Icon(Icons.edit)),
  popupItemsClass(title: "Delete", icon: Icon(Icons.delete))
];