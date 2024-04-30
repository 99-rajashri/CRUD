import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task/featchData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCE_Sj5ru8yLVb4GuPu2bpD6vSJr7x8_p8",
          appId: "1:238296617740:android:d689f074a90a7de3ed6f29",
          messagingSenderId: "238296617740",
          projectId: "task-e2b86"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.),
          // Add more theme configurations if needed
          ),
      home: const FetchData(),
    );
  }
}
