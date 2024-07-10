import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:practice/OrganizerHome.dart';
import 'package:practice/SignUpPage.dart';
import 'package:practice/eventPAge.dart';

class LoginPage extends StatefulWidget {
  bool organizer;
  LoginPage({required this.organizer});
  @override
  State<LoginPage> createState() => LoginState(organizer: organizer);
}

class LoginState extends State<LoginPage>{
  bool organizer;
  LoginState({required this.organizer});

  final GlobalKey<FormState> _logkey= GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  var useremail;
  var userpass;
  String? _message;
  bool loading =false;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String? _validateEmail (String email){
    useremail = email;
    return email.isEmpty? "Email is Required" : null;
  }
  String? _validpassword(String pass) {
    userpass = pass;
    if(pass.isEmpty){
      return "Password is Required";
    }

  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _forgotPassword() async {
    try {
        await _auth.sendPasswordResetEmail(
            email: _emailController.text
        );
        ScaffoldMessenger.of(context).showSnackBar((
            SnackBar(content: Text("Password Reset Email is sent!!"),)
        ));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> _login() async{
    try{;
      setState(() {
        loading =true;
      });
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: useremail, password: userpass
      );
      User? user = userCredential.user;
      FirebaseDatabase.instance.ref("users").child(user!.uid).child("role").once().then((value){
        if(value.snapshot.value.toString() == "user" && !organizer){
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => EventPage()
              )
          );
        }else if(value.snapshot.value.toString() == "organizer" && organizer){
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Organizerhome()
              )
          );
        }else{
          print("object");
          loading = false;
          setState(() {

          });
          ScaffoldMessenger.of(context).showSnackBar((
              SnackBar(content: Text("${organizer ? "Organizer" : "User"} doesn't Exist !!"),backgroundColor: Colors.red.shade900,behavior: SnackBarBehavior.floating,)
          ));
        }
      });
    }on FirebaseAuthException catch(e){
      loading = false;
      setState(() {
        _message = "Wrong password or email";
      });
    }
  }

  void _valid() {
    if(_logkey.currentState!.validate()){
      _logkey.currentState!.save();
      _login();
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
        padding: const EdgeInsets.only(bottom: 20),
        child: InkWell(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "New user? ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ),
                children: [
                  TextSpan(
                      text: "Create an account",
                      style: TextStyle(
                          color: Colors.blue.shade400
                      )
                  )
                ]
            ),

          ),
          onTap: (){
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignupPage(organizer : organizer)
                  )
              );
          },
        )
      ),

      body: SingleChildScrollView(
        child: Form(
          key: _logkey,

          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ), ),
                SizedBox(height:10,),
                Text("Enter your email and password",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15
                    )),
                SizedBox(height:20,),
                TextFormField(
                  controller: _emailController,
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
                      errorText: _message,

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
                SizedBox(height: 40,),
                TextFormField(
                  obscureText: true,
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      labelText: "PASSWORD *",
                      errorText: _message,
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
                SizedBox(height: 40,),
                Center(
                  child: ElevatedButton(
                    onPressed: (){
                      _valid();
                    },
                    child: loading ?
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(color: Colors.white,),
                        ) :
                        Text("LOGIN",style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade400
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Center(
                  child: InkWell(
                    child: Text(
                      "FORGOT PASSWORD >",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                    onTap: (){
                      _forgotPassword();
                    }

                  ),
                )
              ],
            ),
          ),
        ),
      ),

    );
  }
}

