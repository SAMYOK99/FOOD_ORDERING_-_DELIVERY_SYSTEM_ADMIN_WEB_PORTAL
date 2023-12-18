import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginKey = GlobalKey<FormState>();

  String adminEmail = "";
  String adminPassword = "";
  bool isObscure = true;

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  void onEmailChanged(String value) {
    setState(() {
      adminEmail = value;
      autovalidateMode = AutovalidateMode.onUserInteraction;
    });
  }

  void onPasswordChanged(String value) {
    setState(() {
      adminPassword = value;
      autovalidateMode = AutovalidateMode.onUserInteraction;
    });
  }

  checkLogin() async {
    SnackBar snackBar = const SnackBar(content: Center(
      child: Text(
        "Authenticating..., Please Wait",
        style:  TextStyle(
          fontSize: 25,
color: Colors.red,
        ),
      ),
    ),
      backgroundColor: Colors.white,
      duration: Duration(seconds: 5) ,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    User? currentAdmin;
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: adminEmail,
        password: adminPassword).then((fAuth) => {
      currentAdmin = fAuth.user
    }).catchError((onError){
      // Error message
      final snackBar = SnackBar(content: Center(
        child: Text(
          "Something Went Wrong  $onError",
          style: const TextStyle(
            fontSize: 25,
color: Colors.red,
          ),
        ),
      ),
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 5) ,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    if(currentAdmin!= null){
      // check if that the record also exists in the admin collection
      await FirebaseFirestore.instance.collection("admin").doc(currentAdmin!.uid).get().then((snap) {
        if(snap.exists) {
          Navigator.push(context, MaterialPageRoute(builder: (c)=>const AdminHomeScreen()));
        }
        else{
          SnackBar snackBar = const SnackBar(content: Center(
            child: Text(
              "No, record found, You're not an Admin.",
              style:  TextStyle(
                fontSize: 25,
                color: Colors.red,
              ),
            ),
          ),
            backgroundColor: Colors.white,
            duration: Duration(seconds: 5) ,);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _loginKey,
        autovalidateMode: autovalidateMode,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/1.png"),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "ADMIN",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        onChanged: onEmailChanged,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.grey),
                          icon: Icon(
                            Icons.email,
                            color: Colors.black87,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        onChanged: onPasswordChanged,
                        obscureText: isObscure,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.grey),
                          suffixIcon: IconButton(
                            padding: const EdgeInsetsDirectional.only(end: 12.0),
                            icon: isObscure
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                          ),
                          icon: const Icon(
                            Icons.lock,
                            color: Colors.black87,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password field mustnot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        if (_loginKey.currentState!.validate()) {
                          checkLogin();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(30, 6, 30, 6),
                          child: InkWell(
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
