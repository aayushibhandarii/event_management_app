import 'dart:math';

import 'package:flutter/material.dart';
import 'package:practice/Editevents.dart';
import 'package:practice/EventDetailPage.dart';
import 'package:practice/EventImage.dart';
import 'package:practice/LogInPage.dart';
import 'package:practice/SearchPage.dart';
import 'package:practice/SignUpPage.dart';
import 'package:practice/about.dart';
import 'package:practice/verification.dart';
import 'package:practice/eventPAge.dart';
import 'package:practice/firebase_options.dart';
import 'package:practice/logo.dart';
import 'package:practice/userOrOrganizer.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practice/OrganizerHome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'about.dart';
import 'firebase_options.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
          scaffoldBackgroundColor: Colors.white12,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white12),

      ),
      home: logo()














































    );
  }
}

