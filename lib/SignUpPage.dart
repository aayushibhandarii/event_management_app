import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:practice/verification.dart';
import 'package:practice/LogInPage.dart';
import 'package:practice/eventPAge.dart';

class SignupPage extends StatefulWidget {
  bool organizer;
  SignupPage({required this.organizer});
  @override
  State<SignupPage> createState() => SignupState(organizer: organizer);
}

class SignupState extends State<SignupPage>{
  bool organizer;
  SignupState({required this.organizer});
  final GlobalKey<FormState> _key= GlobalKey<FormState>();
  var useremail;
  var userpass;
  var username ="";
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String? _validFirstName(String fname) {
    username = fname;
    return fname.isEmpty ? "First Name is Required" : null;
  }
  String? _validLastName(String lname) {
    username +=" " + lname;
    return lname.isEmpty ? "Last Name is Required" : null;
  }
  String? _validateEmail (String email){
    useremail = email;
    return email.isEmpty? "Email is Required" : null;
  }
  String? _validpassword(String pass) {
    if(pass.length <6){
      return "AtLeast 6 characters are required";
    }
    userpass = pass;
    return pass.isEmpty ? "Password is Required" : null;
  }
  void _valid() {
    if(_key.currentState!.validate()){
      _key.currentState!.save();
      _signup();
    }
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _signup() async{
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: useremail, password: userpass
      );
      if(! userCredential.user!.emailVerified){
            await userCredential.user!.sendEmailVerification();
            ScaffoldMessenger.of(context).showSnackBar((
            SnackBar(content: Text("Email is sent!!"),)
            )
            );
            User? user = userCredential.user;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VerificationScreen(organizer : organizer, email :useremail,username : username)
                )
            );
      }
    }on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar((
          SnackBar(content: Text("${e.message}"),backgroundColor: Colors.red.shade900,behavior: SnackBarBehavior.floating,)
      ));
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        forceMaterialTransparency: true,
        title: Center(

          child: Text(
            "Account",
            style: TextStyle(
                color: Colors.white,
              fontWeight: FontWeight.bold,
                fontSize: 30
            ),

          ),
        ),
        actions: [
          Icon(Icons.exit_to_app,color: Colors.blue.shade400,)
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: InkWell(
          child: Text(
                "Already have an account ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blue.shade400,
                  fontWeight: FontWeight.bold,
                    fontSize: 15
                ),
              ),
          onTap: (){
            Navigator.pushReplacement(
                context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(organizer: organizer,)
              )
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _key,
        
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Signup",
                          style: TextStyle(
                              color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ), ),
                        SizedBox(height:10,),
                        Text("To create your account, please enter the following details",
                            style: TextStyle(
                                color: Colors.white,
                              fontSize: 15
                            )),
                        SizedBox(height:20,),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.white,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              labelText: "FIRST NAME *",
                              errorStyle: TextStyle(
                                  color: Colors.red
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 13
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2
                                  )
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue.shade300,
                                      width: 2
                                  )
                              )
        
                          ),
                          validator: (fname) => _validFirstName(fname!),
                          onSaved: (value){} ,
                        ),
                        SizedBox(height: 15,),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.white,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              labelText: "LAST NAME *",
                              errorStyle: TextStyle(
                                  color: Colors.red
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue.shade300,
                                      width: 2
                                  )
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                    width: 2
                                  )
                              )
        
                          ),
                          validator: (lname) => _validLastName(lname!),
                          onSaved: (password){},
                        ),
                        SizedBox(height: 15,),
                        TextFormField(
                          cursorColor: Colors.white,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(

                              labelText: "EMAIL *",
                              errorStyle: TextStyle(
                                  color: Colors.red
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.grey.shade400,
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
                          validator: (email) => _validateEmail(email!),
                          onSaved: (password){},
                        ),
                        SizedBox(height: 15,),
                        TextFormField(
                          obscureText: true,
                          cursorColor: Colors.white,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              labelText: "PASSWORD *",
                              errorStyle: TextStyle(
                                  color: Colors.red
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue.shade300,
                                      width: 2
                                  )
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                    width: 2
                                  )
                              )
                          ),
                          validator: (pass) => _validpassword(pass!),
                          onSaved: (password){},
                        ),
                        SizedBox(height: 20,),
                        Center(
                          child: ElevatedButton(
                            onPressed: (){
                              _valid();
                            },
                            child: Text("CONTINUE",style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade400
                            ),
                          ),
                        ),
                      ],
              ),
            ),
          ),
      ),

    );
  }
}

