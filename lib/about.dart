import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class radio extends StatefulWidget {
  const radio({super.key});

  @override
  State<radio> createState() => _radioState();
}

class _radioState extends State<radio> {
  var _selectedSortOption ="";
  calling(String value){
    _selectedSortOption = value;
    setState(() {
      Navigator.pop(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                                calling(value!);
                                setState(() {
                                  _selectedSortOption =value!;
                                });
                              }
                          ),
                          RadioListTile(
                              value: "Time",
                              title: Text('Time'),
                              groupValue: _selectedSortOption,
                              onChanged: (value){

                                print(value);
                                calling(value!);

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
    );
  }
}
