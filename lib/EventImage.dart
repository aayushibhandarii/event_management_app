import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Editevents.dart';

class Eventimage extends StatefulWidget {
  final String type;
  final String? oid;
  bool loading =false;
  Eventimage({required this.type,required this.oid});

  @override
  State<Eventimage> createState() => _EventimageState(type : type, oid : oid);
}

class _EventimageState extends State<Eventimage> {
  final String type;
  final String? oid;
  _EventimageState({required this.type,required this.oid});
  final FirebaseStorage storage = FirebaseStorage.instance;

  List<XFile?> selectedImages = [null,null,null,null];
  List<String?> url = [null,null,null,null];
  ImagePicker _picker = ImagePicker();

  Future<void> Validate (List<XFile?> selectedImages)async{
    print("yesss");
    int noOfNull =0;

    for(int i= 0;i<selectedImages.length;){
      print("uuuu");
      if( selectedImages[i] != null){
        print(i);
        UploadTask uploadTask = storage.ref("Event Images").child(oid!).child(DateTime.now().microsecondsSinceEpoch.toString()).putFile(File(selectedImages[i]!.path));

        TaskSnapshot taskSnapshot = await uploadTask;
         String link =await taskSnapshot.ref.getDownloadURL();
         url[i] = link;
         i++;
         print("image downloaded $url");
        print("image downloaded $link");
      }else{
        noOfNull++;
        selectedImages.removeAt(i);
        url.removeAt(i);
      }
    }
    if(noOfNull == 4){
      showErrorBox("Atleast one image is required");
    }else{
      print(url);
      Navigator.pushReplacement(
          context,
        MaterialPageRoute(
          
            builder: (context) => Editevents(oid : oid,selectedImages : url)
        )
      );
    }
  }
  void showErrorBox(String error){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("${error}"),
            actions: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("OK")
              )
            ],
          );
        });
  }
  showAlertBox(int index){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("PICK IMAGE FROM"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("Camera"),
                  onTap: (){
                    imagePicker(ImageSource.camera,index);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text("Gallery"),
                  onTap: (){
                    imagePicker(ImageSource.gallery,index);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
    }

    imagePicker(ImageSource source,int index)async {
      try {
        final XFile? photo = await _picker.pickImage(source: source);
        setState(() {
          selectedImages[index] = photo;
        });
      } catch (e) {
        showErrorBox(e.toString());
      }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
        "SELECT EVENT IMAGES",
        style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 30
    ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade300,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: TextButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo,
                        color: Colors.blue.shade300,
                        size: 30,
                      ),
                      SizedBox(width: 10,),
                      Text(
                          selectedImages[0] == null ? "ADD IMAGE1" : selectedImages[0]!.path.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  onPressed: (){
                    showAlertBox(0);
                  }
              ),
            ),
            Divider(
              height: 40,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: TextButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo,
                        color: Colors.blue.shade300,
                        size: 30,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        selectedImages[1] == null ? "ADD IMAGE2" : selectedImages[1]!.path.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          overflow: TextOverflow.fade
                        ),
                      ),
                    ],
                  ),
                  onPressed: (){
                    showAlertBox(1);
                  }
              ),
            ),
            Divider(
              height: 40,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: TextButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo,
                        color: Colors.blue.shade300,
                        size: 30,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        selectedImages[2] == null ? "ADD IMAGE3" : selectedImages[2]!.path.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  onPressed: (){
                    showAlertBox(2);
                  }
              ),
            ),
            Divider(
              height: 40,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: TextButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo,
                        color: Colors.blue.shade300,
                        size: 30,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        selectedImages[3] == null ? "ADD IMAGE3" : selectedImages[3]!.path.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  onPressed: (){
                    showAlertBox(3);
                  }
              ),
            ),
            SizedBox(height: 40,),
            ElevatedButton(
              onPressed: (){
                 Validate(selectedImages);
                 },
              child: Text("CONTINUE",style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade400,
              ),

            ),
            ]),
      )
      );
  }
}
