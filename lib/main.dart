import 'package:flutter/material.dart';
import 'package:musicapp002/loading.dart';
import 'package:musicapp002/login.dart';
import 'homepage.dart';
import 'authenticatepage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Signuppage(),
      theme: ThemeData.dark(),
    );
  }
}
