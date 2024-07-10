import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'EventDetailPage.dart';


class Searchpage extends StatefulWidget {
  const Searchpage({super.key});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {

  TextEditingController _searchController = TextEditingController();
  final _databaseref = FirebaseDatabase.instance.ref("events");
  var _selectedSortOption = "";

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
  Widget build(BuildContext context){
    var _orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
          title: TextField(
            controller: _searchController,
            cursorColor: Colors.white,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20
            ),
            decoration: InputDecoration(
              hintText: "SEARCH..",
              hintStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 20
              ),
            ),
            onChanged: (String value){
              setState((){

              });
            },
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.dangerous,),
                  onPressed: (){
                    _searchController.clear();
                  },
                )
            )
          ],
          bottom: PreferredSize(
            child: Divider(
                thickness: 2
            ),
            preferredSize: Size.fromHeight(15),
          ),
          backgroundColor: Colors.blue.shade300,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true
      ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0,left: 20),
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
            ),
            Expanded(
              child: StreamBuilder(
                  stream: _databaseref.onValue,
                  builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
                    if(snapshot.connectionState ==ConnectionState.active){

                      if(snapshot.hasData){
                        Map<dynamic , dynamic> map = snapshot.data!.snapshot.value as dynamic;
                        List<dynamic> list = [];
                        list.clear();
                        List<dynamic> idList = [];
                        idList.clear();
                        List<dynamic> rollList =[];
                        rollList.clear();
                        var searchfilter = _searchController.text.toLowerCase();
                        if(_searchController.text.isEmpty){
                          print("oo");
                          return Container();
                        }
                        map.forEach((rollno,idsmap){
                          print(rollno);
                          print(idsmap);
                          rollList.add(rollno);
                          final ids = Map<dynamic, dynamic>.from(idsmap);
                          ids.forEach((ids,value){
                            idList.add(ids);
                            final event = Map<dynamic,dynamic>.from(value);
                            if(event["Event name"].toString().toLowerCase().contains(searchfilter) ||
                                event["Event Location"].toString().toLowerCase().contains(searchfilter) ||
                                event["date"].toString().toLowerCase().contains(searchfilter) ||
                                event["time"].toString().toLowerCase().contains(searchfilter) ||
                                event["Event description"].toString().toLowerCase().contains(searchfilter)
                            ){
                              idList.add(ids);
                              list.add(event);
                            }

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
                              String date = DateFormat.yMMMEd().format(DateTime.parse(list[index]["date"]));
                              if(list[index]["Event name"].toString().toLowerCase().contains(searchfilter) ||
                                  list[index]["Event Location"].toString().toLowerCase().contains(searchfilter) ||
                                  date.toString().toLowerCase().contains(searchfilter) ||
                                  list[index]["time"].toString().toLowerCase().contains(searchfilter) ||
                                  list[index]["Event description"].toString().toLowerCase().contains(searchfilter))
                              {
                                print("uuu");
                                return SingleChildScrollView(
                                  child:
                                      GestureDetector(
                                        child: Container(
                                            width: _orientation == Orientation.portrait ? MediaQuery.of(context).size.width -100 : MediaQuery.of(context).size.width/5,
                                            height: MediaQuery.of(context).size.height/2,
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    color: Colors.blue,
                                                    child: list[index]["Image url"][0] != null ? Image.network(list[index]["Image url"][0],fit: BoxFit.cover) : CircularProgressIndicator(),
                                                    height: _orientation == Orientation.portrait? MediaQuery.of(context).size.height /3 : MediaQuery.of(context).size.height /6 ,
                                                    width: MediaQuery.of(context).size.width ,
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
                                                          print("value selected ${valueSelected.title}");
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
                                                      Text("HELD ON : ${date}"),
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
                                                      Text("HELD ON : ${date}"),
                                                      Text("EVENT TIME : ${list[index]["time"]}")
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                        ),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => EventDetail(index : index,eventname : list[index]["Event name"],list :list,idList : idList,rollList: rollList,)
                                              )
                                          );
                                        },
                                      ),

                                );
                              }
                            },
                            itemCount: list.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _orientation == Orientation.portrait ? 1 : 2 ,
                              crossAxisSpacing: 50,
                              mainAxisSpacing: 50,
                              childAspectRatio: 0.5,
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
        ),


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
class popupItemssortClass{
  final String title;
  final Icon icon;
  popupItemssortClass({required this.title,required this.icon});
}
List<popupItemssortClass> popupitemssortlist = [
  popupItemssortClass(title: "Date", icon: Icon(Icons.date_range)),
  popupItemssortClass(title: "Time", icon: Icon(Icons.timelapse))
];