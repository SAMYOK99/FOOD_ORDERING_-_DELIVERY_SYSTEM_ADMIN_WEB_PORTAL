import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

  String adminEmail="";
  String adminPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width*.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text("ADMIN",style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                 const SizedBox(height: 10,),
                  // email text field
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
                          offset: const Offset(0,3),
                        ),
                      ],
                    ),
                    child:TextField(
                      onChanged: (value){
                        adminEmail = value;
                      },
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.grey),
                        icon: Icon(Icons.email,
                          color: Colors.black87,),


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
                        offset: const Offset(0,3),
                      ),
                    ],
                  ),
                child:TextField(
                  onChanged: (value){
                    adminEmail = value;
                  },
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey),
                    icon: Icon(Icons.lock,
                      color: Colors.black87,),



                  ),

                ),
                ),
                ],
              )


            ),
          )
        ],
      ),

    );
  }
}
