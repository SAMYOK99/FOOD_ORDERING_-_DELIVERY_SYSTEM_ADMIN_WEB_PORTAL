import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VerifiedUsers extends StatefulWidget {
  const VerifiedUsers({super.key});

  @override
  State<VerifiedUsers> createState() => _VerifiedUsersState();
}

class _VerifiedUsersState extends State<VerifiedUsers> {
  QuerySnapshot? allUsers;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("users")
        .where("status", isEqualTo: "approved")
        .where("role", isEqualTo: "user")
        .get().then((verifiedUsers) {
          setState(() {
            allUsers = verifiedUsers;

          });

    });
  }
  @override
  Widget build(BuildContext context) {
    Widget displayVerifiedUsers(){
      if(allUsers != null)
        {
          return ListView.builder(
            itemCount: allUsers!.docs.length,
            itemBuilder: (context, i){
              return  Card(
                margin: const EdgeInsets.all(15.0),
                child: Container(
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0,3),

                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    ListTile(
                      leading:CachedNetworkImage(
                        imageUrl: allUsers!.docs[i].get("staffAvatarUrl"),
                        placeholder: (context, url) => const CircularProgressIndicator(), // Placeholder while the image loads
                        errorWidget: (context, url, error) => const Icon(Icons.error), // Widget displayed on error
                      ),
                      // Container(
                      //   height: 65,
                      //   width: 65,
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //
                      //     image: CachedNetworkImage(
                      //       imageUrl: allUsers!.docs[i].get("staffAvatarUrl"),
                      //       placeholder: (context, url) => CircularProgressIndicator(), // Placeholder while the image loads
                      //       errorWidget: (context, url, error) => Icon(Icons.error), // Widget displayed on error
                      //     ),
                      //     // image: DecorationImage(
                      //     //   image: NetworkImage(allUsers!.docs[i].get("staffAvatarUrl")),
                      //     //   fit: BoxFit.fill,
                      //     // ),
                      // ),
                      // ),
                      title: Text(
                        allUsers!.docs[i].get("staffName"),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.email),
                          const SizedBox(width: 10,),
                          Text(
                            allUsers!.docs[i].get("staffEmail"),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(onPressed: ()
                        {
                        },
                        icon: const Icon(
                          Icons.person_off_rounded,
                          color: Colors.red,
                    ),
                    label: Text("Block this account".toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black
                      ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),

                  ],
                ),
              ),
              ));
            },

          );
        }
      else{
        return const Center(
          child: Text(
            "No user found.",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        );
      }
    }
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0,3),
              )
            ],
          ),
        ),
        centerTitle: true,
        title: const Text(
          "VERIFIED USERS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (c)=>const AdminHomeScreen()));
          },
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * .5,
          child: displayVerifiedUsers(),
        ),
      ),

    );

  }
}
