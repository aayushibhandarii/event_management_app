import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:practice/OrganizerHome.dart';

class Editevents extends StatefulWidget{
  String? oid;
  var selectedImages;
  var idlist;
  var index;

  Editevents({required this.oid, this.selectedImages,this.idlist,this.index});
  @override
  State<Editevents> createState() => EditeventsState( oid : oid,selectedImages : selectedImages,idlist: idlist,index : index);
}
class EditeventsState extends State<Editevents>{

  String? oid;
  var selectedImages;
  var idlist;
  var index;
  var Eventtype  = "EVENT TYPE";
  EditeventsState({this.oid,this.selectedImages,this.idlist,this.index});

  final FirebaseStorage storage = FirebaseStorage.instance;
  final _databaseref = FirebaseDatabase.instance.ref("events");

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  addEvent(String? date,String? time,String ename,String desc,String location,String oname,String contact,String eventtype ,var url)async{
    if( ename.isEmpty || desc.isEmpty || location.isEmpty || oname .isEmpty || contact.isEmpty || eventtype == "EVENT TYPE"){
      ScaffoldMessenger.of(context).showSnackBar((
          SnackBar(content: Text("Enter the required fields!!"),backgroundColor: Colors.red.shade900,behavior: SnackBarBehavior.floating,)
      ));
    }else {
      print(url);
      _databaseref.child(oid!).child(DateTime.now().microsecondsSinceEpoch.toString()).set({
        "date" : date,
        "time" : time,
        "Event name" : ename,
        "Event description" : desc,
        "Event Location" : location,
        "Organizer Name" : oname,
        "Contact info" : contact,
        "Event type" : eventtype,
        "Image url" : url
      })
      .then((onValue){
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text("EVENT ADDED"),
                content: Text("Event has been successfully added!!"),
                actions: [
                  ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text("OK"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade300
                    ),
                  )
                ],
              );
            }
        );

      });
    }
  }


  DateTime? selectedDate;
  var selectedTime;
  TextEditingController _eventname = TextEditingController();
  TextEditingController _eventdescription = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _organisername = TextEditingController();
  TextEditingController _contactinfo = TextEditingController();
  TextEditingController _eventtype = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "CREATE EVENT",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30
              ),

            ),
          ),
          backgroundColor: Colors.blue.shade300,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 20,left: 20,top: 10),
          child: Column(
            children: [
              TextButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.blue.shade300,
                      size: 30,
                    ),
                    SizedBox(width: 10,),
                    Text(selectedDate == null ?
                      "ENTER EVENT DATE" :
                      "Event Date :${DateFormat.yMMMEd().format(selectedDate!)}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        fontSize: 15
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.blue.shade300,
                      size: 30,
                    ),

                  ],
                ),
                onPressed: ()async{
                  DateTime? datepicked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now().subtract(Duration(days : 1)),
                          lastDate: DateTime.now().add(Duration(days: 365))
                      );
                      if(datepicked != null){
                        setState(() {
                          selectedDate = datepicked;
                        });
                      };
                }
              ),
              TextButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        color: Colors.blue.shade300,
                        size: 30,
                      ),
                      SizedBox(width: 10,),
                Text(
                    selectedTime == null
                        ? 'ENTER EVENT TIME'
                        : 'Event time: ${selectedTime!.format(context)}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),)
                    ],
                  ),
                  onPressed: ()async{
                    TimeOfDay? timepicked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      initialEntryMode : TimePickerEntryMode.input
                    );
                      setState(() {
                        selectedTime = timepicked;
                      });
                  }
              ),
              TextField(
                controller: _eventname,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                ),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(

                    labelText: "EVENT NAME",
                    errorStyle: TextStyle(
                        color: Colors.red
                    ),
                    labelStyle: TextStyle(
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.bold,
                        fontSize: 13
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(9)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue.shade300,
                        width: 2,
                      ),
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: _eventdescription,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                ),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "EVENT DESCRIPTION",
                    errorStyle: TextStyle(
                        color: Colors.red
                    ),
                    labelStyle: TextStyle(
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.bold,
                        fontSize: 13
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(9)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue.shade300,
                        width: 2,
                      ),
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: _location,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                ),
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                    labelText: "EVENT LOCATION",
                    errorStyle: TextStyle(
                        color: Colors.red
                    ),
                    labelStyle: TextStyle(
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.bold,
                        fontSize: 13
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(9)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue.shade300,
                        width: 2,
                      ),
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: _organisername,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                ),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(

                    labelText: "ORGANISER NAME",
                    errorStyle: TextStyle(
                        color: Colors.red
                    ),
                    labelStyle: TextStyle(
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.bold,
                        fontSize: 13
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(9)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue.shade300,
                        width: 2,
                      ),
                    )
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _contactinfo,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                ),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelText: "CONTACT INFORMATION",
                    errorStyle: TextStyle(
                        color: Colors.red
                    ),
                    labelStyle: TextStyle(
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.bold,
                        fontSize: 13
                    ),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(9)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue.shade300,
                        width: 2,
                      ),
                    )
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                      child: TextField(
                        controller: _eventtype,
                        cursorColor: Colors.white,

                        style: TextStyle(
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: Eventtype,
                            enabled: false,
                            hintText: "workshop,social event, etc.",
                            hintStyle: TextStyle(
                                color: Colors.grey
                            ),
                            errorStyle: TextStyle(
                                color: Colors.red
                            ),
                            labelStyle: TextStyle(
                                color: Colors.grey.shade300,
                                fontWeight: FontWeight.bold,
                                fontSize: 13
                            ),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(9)
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue.shade300,
                                width: 2,
                              ),
                            )
                        ),
                      ),
                  ),
                  Expanded(
                    flex: 1,
                      child: PopupMenuButton(
                        child: Icon(Icons.more_vert,color: Colors.white,),
                        onSelected: ((valueSelected){

                          print(valueSelected.title);
                          setState(() {
                            Eventtype = valueSelected.title;
                          });

                        }),
                        itemBuilder: (BuildContext context){
                          return popupitemslist.map((popupItemsClass items){
                            return PopupMenuItem(
                                value : items,
                                child : Container(
                                  child: Text(items.title)

                                )
                            );
                          }).toList();
                        },
                      ),
                  )

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("CANCEL",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey
                    ),
                  ),
                  SizedBox(width: 20,),
                  ElevatedButton(
                    onPressed: (){
                      print(selectedDate?.toIso8601String());
                      print(DateFormat('HH:mm:ss').format(DateTime(0,0,0,selectedTime.hour,selectedTime.minute)));
                      addEvent(selectedDate == null ? null : selectedDate?.toIso8601String(),selectedTime == null ? null : DateFormat('HH:mm:ss').format(DateTime(0,0,0,selectedTime.hour,selectedTime.minute)),_eventname.text.toString(), _eventdescription.text.toString(), _location.text.toString(), _organisername.text.toString(), _contactinfo.text.toString(), Eventtype, selectedImages);
                    },
                    child: Text("SAVE",style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade400
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }

}
class popupItemsClass{
  final String title;
  popupItemsClass({required this.title});
}
List<popupItemsClass> popupitemslist = [
  popupItemsClass(title: "WORKSHOP"),
  popupItemsClass(title: "SOCIAL EVENT"),
  popupItemsClass(title: "MEETINGS",)
];