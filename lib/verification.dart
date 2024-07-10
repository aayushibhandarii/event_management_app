import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice/OrganizerHome.dart';
import 'package:practice/eventPAge.dart';

class VerificationScreen extends StatefulWidget {
  bool organizer;
  String email;
  String username;
  VerificationScreen({required this.organizer, required this.email, required this.username});
  @override
  _VerificationScreenState createState() => _VerificationScreenState(organizer: organizer,email : email,username: username);
}

class _VerificationScreenState extends State<VerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isVerified = false;
  bool organizer;
  String email;
  bool isSignup = true;
  String username;
  _VerificationScreenState({required this.organizer,required this.email,required this.username});

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    checkEmailVerified();
  }

  Future<void> checkEmailVerified() async {
    user = _auth.currentUser;
    await user?.reload();
    user = _auth.currentUser;
    setState(() {
      isVerified = user?.emailVerified ?? false;
    });
    if (isVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
      builder: (context) => organizer ? Organizerhome(isSignup :true,email: email,username : username) : EventPage(isSignup :true,email: email,username : username)
    ),
      );// Replace with your next page
    } else {
      Future.delayed(Duration(seconds: 3), checkEmailVerified);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isVerified
            ? Text('Email is verified! Redirecting...')
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A verification email has been sent to ${user?.email}.'),
            SizedBox(height: 16),
            Text('Please verify your email to continue.'),
            CircularProgressIndicator(
            ),
          ],
        ),
      ),
    );
  }
}


