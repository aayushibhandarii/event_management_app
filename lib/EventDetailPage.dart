import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:practice/FeedbackPage.dart';

import 'SearchPage.dart';

class EventDetail extends StatefulWidget {
  var index;
  String? eventname;
  List list;
  List idList;
  List rollList;
  String? username;
  EventDetail({required this.index,required this.eventname,required this.list,required this.idList,required this.rollList,this.username});
  @override
  State<EventDetail> createState() => _EventDetailState(index : index , eventname : eventname,list : list,idList: idList,rollList:rollList);
}

class _EventDetailState extends State<EventDetail> {
  var index;
  String? eventname;
  List list;
  List idList;
  List rollList;
  String? username;
  List<dynamic> url = [];
  num _averagerating =0;
  _EventDetailState({required this.index, required this.eventname,required this.list,required this.idList,required this.rollList,this.username});

  int _current = 0;
  bool _isExpanded = false;
  final CarouselController _controller = CarouselController();
  final _databaseref = FirebaseDatabase.instance.ref("feedback");
  _fetchurl(){
    url.clear();
    for(int i =0;i< (list[index]["Image url"]).length ;i++ ){
      url.add(list[index]["Image url"][i]);
    }
  }
  calcAverageRating(List list){
    for(int i=0;i<list.length;i++){

        _averagerating +=list[i]["rating"];

    }
    _averagerating /=list.length;
  }
  var fid;
  var fname;
  
  Future<String> getfname(var fid)async{
    await FirebaseDatabase.instance.ref("users").child(fid).child("name").once().then((value){
      return value.snapshot.value.toString();
    });
    return "";
  }

  @override
  Widget build(BuildContext context) {
    var _orientation = MediaQuery.of(context).orientation;
    var _averagerating =1.2;
    _fetchurl();
    print(url);

    return Scaffold(
      appBar: AppBar(
        title: Text("${eventname}",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30
          ),
        ),
        backgroundColor: Colors.blue.shade300,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
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
      ),

      backgroundColor: Colors.grey,
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.black87,

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarouselSlider(
                            items: url.map((item){
                              return Builder(
                                  builder: (BuildContext context){
                                    return Container(
                                      child: Image.network(item!,fit: BoxFit.cover),
                                      color: Colors.blue,
                                    );
                                  }
                              );
                            }).toList(),
                            options: CarouselOptions(
                                height: _orientation == Orientation.portrait? MediaQuery.of(context).size.height/2: MediaQuery.of(context).size.height /3,
                                enlargeCenterPage: true,
                                autoPlay: false,
                                onPageChanged: (index,reason){
                                  setState(() {
                                    _current = index;
                                  });
                                }
                            ),
                            carouselController: _controller,
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: url.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () => _controller.animateToPage(entry.key),
                                child: Container(
                                  width: 12.0,
                                  height: 12.0,
                                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (Colors.blue.shade300)
                                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 20,),
                           Row(
                              children: [
                                Text(list[index]["Event name"],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 5,),
                          Text(
                            list[index]["Event type"],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),

                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    color: Colors.black87,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Event Details",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25
                            ),
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Date",
                                style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 20
                                ),
                              ),
                              Text(
                                list[index]["date"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Time",
                                style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 20
                                ),
                              ),
                              Text(
                                list[index]["time"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Location",
                                style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 20
                                ),
                              ),
                              Text(
                                list[index]["Event Location"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                ),
                              ),

                            ],
                          ),
                      Divider(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Oraganizer",
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 20
                            ),
                          ),
                          Text(
                            list[index]["Organizer Name"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                ),
                              ),
                        ],
                      ),
                          Divider(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Contact",
                                style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 20
                                ),
                              ),
                              Text(
                                list[index]["Contact info"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 20,),
                   ] ),
                  )
                  ),
                  SizedBox(height: 5,),
                  Container(
                    color: Colors.black87,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Event Description",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text(
                            list[index]["Event description"],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            ),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    color: Colors.black87,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rating & Reviews",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.edit,color: Colors.white,),
                                onPressed: ()async{
                                    fid = await
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          fullscreenDialog: true,
                                            builder: (context) => Feedbackpage(index : index,idList : idList,rollList : rollList)
                                        )
                                    );
                                    if(fid !=null){
                                      final fetchedname = await getfname(fid);
                                      setState(() {
                                          fname = fetchedname;
                                      });
                                    }
                                    print(fname);
                                },
                              )
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              RatingBarIndicator(
                                  rating: _averagerating,
                                  itemBuilder: (context,index){
                                    return Icon(Icons.star,color: Colors.yellow.shade800,);
                                  },
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4),
                                  unratedColor: Colors.yellow.shade50
                              ),
                              list.length>1 ? TextButton(
                                  onPressed: (){

                                    setState(() {
                                      _isExpanded ? _isExpanded = false : _isExpanded =true;
                                    });
                                  },
                                  child: _isExpanded ? Text("- less",style: TextStyle(color: Colors.blue),) : Text("+more",style: TextStyle(color: Colors.blue),)
                              ) : Container()
                            ],
                          ),

                          Divider(
                            height: 40,
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          StreamBuilder(
                            stream: _databaseref.onValue,
                            builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
                              if(snapshot.connectionState ==ConnectionState.active){

                                if(snapshot.hasData){
                                  if(snapshot.data?.snapshot.value == null){
                                    return Center(
                                      child: Text(
                                        "NO REVIEWS YET !!",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    );
                                  }
                                  Map<dynamic , dynamic> map = snapshot.data?.snapshot.value as dynamic;

                                  List<dynamic> list = [];
                                  list.clear();
                                  map.forEach((rollno,idsmap){
                                    final ids = Map<dynamic, dynamic>.from(idsmap);
                                    ids.forEach((ids,value){
                                      final dates = Map<dynamic,dynamic>.from(value);
                                      dates.forEach((date,aboutfeedback){
                                        list.add(aboutfeedback);
                                      });
                                    });
                                  });
                                  if(list.isEmpty){
                                    return Center(child: Text("NO EVENTS FOUND",style: TextStyle(color: Colors.grey),),);
                                  }
                                  calcAverageRating(list);
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:(context,index){
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RatingBarIndicator(
                                              rating: list[index]["rating"] * 0.1,
                                              itemBuilder: (context,index){
                                                return Icon(Icons.star,color: Colors.yellow.shade800,size:2);
                                              },
                                              itemCount: 5,
                                              itemPadding: EdgeInsets.symmetric(horizontal: 2),
                                              unratedColor: Colors.yellow.shade50
                                          ),
                                          SizedBox(height: 15,),
                                          Text(list[index]["feedback"],style: TextStyle(color: Colors.white,fontSize: 20),),
                                          SizedBox(height: 15,),
                                          Text('${fname}',style: TextStyle(color: Colors.grey.shade400,fontSize: 20,fontWeight: FontWeight.bold),),
                                          SizedBox(height: 15,),
                                          Row(
                                            children: [
                                              SizedBox(width: 20,),
                                              Icon(Icons.lens_sharp,color: Colors.grey,size: 10,),
                                              SizedBox(width: 10,),
                                              Text(list[index]["date"],style: TextStyle(color: Colors.grey.shade400,fontSize: 20)),
                                            ],
                                          ),
                                          Divider(
                                            height: 20,
                                            color: Colors.grey,
                                            thickness: 1,
                                          )
                                        ],
                                      );
                                    },
                                    itemCount: _isExpanded ? list.length : 1,
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

                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5,)
                ],
              ),
            ),
          ),



    );
  }
}


