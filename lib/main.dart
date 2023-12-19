import 'package:admin_web_portal/authencation/login.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyC8shK6qRmHUweLagNjJMtvgCVjLtr4O5Y",
        projectId: "my-tiffin-app-8266e",
        messagingSenderId: "300061634717",
        appId: "1:300061634717:web:2d6a481afc586c8195e474",
        ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null ? const LoginScreen() : const AdminHomeScreen(),
    );
  }
}

