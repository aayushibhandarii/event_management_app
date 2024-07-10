import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice/LogInPage.dart';

class check extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "LOGIN / SIGNUP AS ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                ),
              ),
              SizedBox(height: 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage(organizer: false)
                              )
                          );
                      },
                      child: Text(
                          "USER",
                        style: TextStyle(
                            color: Colors.white,
                          fontSize: 20
                        ),),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade400,
                          fixedSize: Size(150, 20)
                        ),
                  ),
                  ElevatedButton(
                      onPressed: (){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(organizer: true)
                            )
                        );
                      },
                      child: Text(
                          "ORGANIZER",
                           style: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                         ),),
                       style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade400
                            ),
                      )
                ],
              )
            ],
          ),
    );
  }
}
