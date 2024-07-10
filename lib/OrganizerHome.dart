import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practice/Editevents.dart';
import 'package:practice/EventImage.dart';
import 'package:practice/UpdatePage.dart';
import 'package:practice/userOrOrganizer.dart';

class Organizerhome extends StatefulWidget {
  String? email;
  bool isSignup;
  String? username;
  Organizerhome({this.email,this.isSignup = false, this.username});

  @override
  State<Organizerhome> createState() => _OrganizerhomeState(email : email ,isSignup : isSignup,username : username);
}

class _OrganizerhomeState extends State<Organizerhome> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final String oid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final _databaseref = FirebaseDatabase.instance.ref("events");

  String? _imageUrl;
  String? email;
  bool isSignup;
  String? username;
  _OrganizerhomeState({this.email,this.isSignup = false,this.username});
  @override
  void initState() {
    if(isSignup){
      FirebaseDatabase.instance.ref("users").child(oid!).set({
        "email" : email,
        "role" : "organizer"
      });
    }
    _fetchurl();
  }
  Future<void> _fetchurl() async{
    String downloadURl = await storage.ref("Event Images").child(oid!).child("image1").getDownloadURL();
    setState(() {
      _imageUrl = downloadURl;
      print(_imageUrl);
    });
  }
  showAlertBox(var id){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
              title: Text("DELETE",style: TextStyle(fontWeight: FontWeight.bold),),
            content: Text("Delete 1 Event",style: TextStyle(fontSize: 15),),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            alignment: Alignment.center,
            actions: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Cancel",style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                    _databaseref.child(oid).child(id).remove();
                    Navigator.pop(context);
                  },
                  child: Text("Delete",style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade400
                ),
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    print(DateTime.now().toIso8601String());
    var _orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text("ORGANIZER",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30
          ),
        ),
        backgroundColor: Colors.blue.shade300,
        iconTheme: IconThemeData(color: Colors.white),
      ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "Aayushi",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,

                ),
              ),
              accountEmail: Text(
                "aayushib@gmail.com" ,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                ),
              ),
              currentAccountPicture: Icon(
                Icons.face,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                  color: Colors.blue.shade400
              ),
            ),
            ListTile(
              title: Text("settings"),
            ),
            ListTile(
              title: Text("Logout"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => check()
                    )
                );
              },
            )
          ]
          )
        ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue.shade300,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.all(10),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape:CircleBorder(),
        tooltip: "Add Events",
        backgroundColor: Colors.white,
        child: Icon(Icons.add,color: Colors.blue.shade300,size: 30,),
        onPressed: ()async{
                Navigator.push(
                    context, 
                    MaterialPageRoute(
                        builder: (context) => Eventimage(type: "CREATE EVENT",oid : oid)
                    )
                );
        },
      ),
        body:
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: StreamBuilder(
            stream: _databaseref.onValue,
            builder: (context,AsyncSnapshot<DatabaseEvent> snapshot) {
              if(snapshot.connectionState ==ConnectionState.active){
                if(! snapshot.data!.snapshot.hasChild(oid!)){
                  return Center(child: Text("NO EVENTS ARE CREATED!!",style: TextStyle(color: Colors.grey),));
                }
                if(snapshot.hasData){
                  var data = snapshot.data!.snapshot.child(oid!).value;
                  if(data == null){
                    return Center(child: Text("NO EVENTS ARE CREATED!!"));
                  }
                  Map<dynamic , dynamic> map = data as dynamic;
                  print(map);
                  List<dynamic> list = [];
                  list.clear();
                  List<dynamic> idlist = [];
                  idlist.clear();

                  map.forEach((id,value){
                    idlist.add(id);
                    final event = Map<dynamic,dynamic>.from(value);
                    list.add(event);
                  });
                  return GridView.builder(
                        itemBuilder: (context,index){
                          return Container(
                             width: _orientation == Orientation.portrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width/5,
                             height: _orientation == Orientation.portrait ? MediaQuery.of(context).size.height +200 : MediaQuery.of(context).size.height/4,
                              color: Colors.white,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: Colors.blue,
                                        child: _imageUrl != null ? Image.network(_imageUrl!,fit: BoxFit.fill) : CircularProgressIndicator(),
                                        height: _orientation == Orientation.portrait? MediaQuery.of(context).size.height /5 +10 : MediaQuery.of(context).size.height /6 ,
                                        width: double.infinity,
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${list[index]["Event name"]}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          PopupMenuButton(
                                            child: Icon(Icons.more_vert),
                                            onSelected: ((valueSelected){
                                              print(valueSelected.title);
                                              valueSelected.title == "Edit" ?
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => Updatepage(oid: oid,idlist:idlist,list:list,index :index)
                                                      )
                                                  ):
                                                  showAlertBox(idlist[index]);
                                            }),
                                            itemBuilder: (BuildContext context){
                                              return popupitemslist.map((popupItemsClass items){
                                                return PopupMenuItem(
                                                    value : items,
                                                    child : Container(
                                                      child: Row(
                                                          children : [
                                                            Icon(items.icon.icon),
                                                            SizedBox(width: 20,),
                                                            Text(items.title)
                                                          ]
                                                      ),
                                                      width: 100,
                                                    )
                                                );
                                              }).toList();
                                            },
                                          )
                                        ],
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
                                              Text("ORGANIZER : ${list[index]["Organizer Name"]}"),
                                              Text("HELD ON : ${DateFormat.yMMMEd().format(DateTime.parse(list[index]["date"]))}"),
                                              Text("EVENT TIME : ${list[index]["time"]}")
                                            ],
                                          )
                                
                                
                                    ],
                                  ),
                                ),
                              )
                          );

                        },
                      itemCount: snapshot.data!.snapshot.child(oid!).children.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _orientation == Orientation.portrait ? 1 : 2 ,
                        crossAxisSpacing: 50,
                        mainAxisSpacing: 50,
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
          )
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