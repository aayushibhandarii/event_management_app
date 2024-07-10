import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Updatepage extends StatefulWidget {
  List idlist;
  String oid;
  List list;
  var index;
  Updatepage({required this.idlist,required this.oid,required this.list,required this.index});

  @override
  State<Updatepage> createState() => _UpdatepageState(idlist: idlist,oid: oid,list :list,index:index);
}

class _UpdatepageState extends State<Updatepage> {
  final _databaseref = FirebaseDatabase.instance.ref("events");
  List idlist;
  String oid;
  List list;
  var index;

  _UpdatepageState({required this.idlist,required this.oid,required this.list,required this.index});

  TextEditingController _eventname = TextEditingController();
  TextEditingController _eventdescription = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _organisername = TextEditingController();
  TextEditingController _contactinfo = TextEditingController();
  TextEditingController _eventtype = TextEditingController();

  Future<void> _oldvalues ()async{
    _eventname.text = list[index]["Event name"];
    _eventdescription.text = list[index]["Event description"];
    _location.text = list[index]["Event Location"];
    _organisername.text = list[index]["Organizer Name"];
    _contactinfo.text = list[index]["Contact info"];
    _eventtype.text = list[index]["Event type"];
  }

  @override
  void initState() {
    _oldvalues();
  }

  @override
  void dispose() {
    _eventname.dispose();
    _eventdescription.dispose();
    _contactinfo.dispose();
    _location.dispose();
    _eventtype.dispose();
    _organisername.dispose();

  }

  DateTime? selectedDate;
  var selectedTime;

  updateEvent(String? date,String? time,String ename,String desc,String location,String oname,String contact,String eventtype)async{
    if( date == null || time == null || ename.isEmpty || desc.isEmpty || location.isEmpty || oname .isEmpty || contact.isEmpty || eventtype.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar((
          SnackBar(content: Text("Enter the required fields!!"),backgroundColor: Colors.red.shade900,behavior: SnackBarBehavior.floating,)
      ));
    }else {
      _databaseref.child(oid!).child(idlist[index]).update({
        "date" : date,
        "time" : time,
        "Event name" : ename,
        "Event description" : desc,
        "Event Location" : location,
        "Organizer Name" : oname,
        "Contact info" : contact,
        "Event type" : eventtype,
      })
          .then((onValue){
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text("EVENT UPDATED"),
                content: Text("Event has been successfully updated!!"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "UPDATE EVENT",
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
                SizedBox(height: 10,),
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
                TextField(
                  controller: _eventtype,
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "EVENT TYPE",
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
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade300,
                          width: 2,
                        ),
                      )
                  ),
                ),
                SizedBox(height: 10),
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
                        updateEvent(selectedDate == null ? null : DateFormat.yMMMEd().format(selectedDate!).toString(),selectedTime == null ? null : selectedTime!.format(context).toString(),_eventname.text.toString(), _eventdescription.text.toString(), _location.text.toString(), _organisername.text.toString(), _contactinfo.text.toString(), _eventtype.text.toString().toLowerCase());
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
