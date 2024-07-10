import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice/LogInPage.dart';
import 'package:practice/userOrOrganizer.dart';

import 'OrganizerHome.dart';
import 'eventPAge.dart';

class logo extends StatefulWidget {
  const logo({super.key});

  @override
  State<logo> createState() => _logoState();
}

class _logoState extends State<logo> {
  
  final user = FirebaseAuth.instance.currentUser;
  
  @override
  void initState() {
    super.initState();
    print(user);
    navigateUser();
  }

  void navigateUser(){
    if (user == null) {
      print("null");
      Timer(
          const Duration(seconds: 2),
              () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => check()
                )
            );
          }
      );
    } else {
      print("nope");
      Timer(
          const Duration(seconds: 2),
              () {
            FirebaseDatabase.instance.ref("users").child(user!.uid).child(
                "role").once().then((value) {
                  print(value.snapshot.value.toString());
              if (value.snapshot.value.toString() == "user") {
                print("object");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventPage()
                    )
                );
              } else if (value.snapshot.value.toString() == "organizer") {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Organizerhome()
                    )
                );
              }
            }
            );
          });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/images/logo.png",height: 200,width: 200,),
      ),
    );
  }
}
