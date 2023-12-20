import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VerifiedRiders extends StatefulWidget {
  const VerifiedRiders({super.key});

  @override
  State<VerifiedRiders> createState() => _VerifiedRidersState();
}

class _VerifiedRidersState extends State<VerifiedRiders> {
  QuerySnapshot? allRiders;

  dialogBoxForBlockingUserAccount(userDocId) {
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text(
              "Block Account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                letterSpacing: 2,
              ),
            ),
            content: const Text(
              "Do you want to block this Account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 2,
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
              ElevatedButton(
                  onPressed: (){
                    Map<String, dynamic> userDataMap = {
                      "status": "blocked"
                    };
                    FirebaseFirestore.instance.collection("riders")
                        .doc(userDocId)
                        .update(userDataMap)
                        .then((value) {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>const AdminHomeScreen()));
                      SnackBar snackBar = const SnackBar(content: Center(
                        child: Text(
                          "Rider has been Blocked.",
                          style:  TextStyle(
                            fontSize: 25,
                            color: Colors.red,
                          ),
                        ),
                      ),
                        backgroundColor: Colors.white,
                        duration: Duration(seconds: 2) ,);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });

                  },
                  child: const Text("Yes")),
            ],
          );
        }
    );

  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("riders")
        .where("status", isEqualTo: "approved")
        .where("role", isEqualTo: "rider")
        .get().then((verifiedUsers) {
      setState(() {
        allRiders = verifiedUsers;

      });

    });
  }
  @override
  Widget build(BuildContext context) {
    Widget displayVerifiedUsers(){
      if (allRiders != null && allRiders!.docs.isNotEmpty) {
        return ListView.builder(
          itemCount: allRiders!.docs.length,
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
                            imageUrl: allRiders!.docs[i].get("riderAvatarUrl"),
                            placeholder: (context, url) => const CircularProgressIndicator(), // Placeholder while the image loads
                            errorWidget: (context, url, error) => const Icon(Icons.person,
                              size: 30,), // Widget displayed on error
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
                            allRiders!.docs[i].get("riderName"),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.email),
                              const SizedBox(width: 10,),
                              Text(
                                allRiders!.docs[i].get("riderEmail"),
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
                          dialogBoxForBlockingUserAccount(allRiders!.docs[i].id);

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
      } else if (allRiders != null && allRiders!.docs.isEmpty) {
        return const Center(
          child: Text(
            "No user found.",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(), // Display circular progress indicator
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
          "VERIFIED RIDERS",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 3
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: displayVerifiedUsers(),
        ),
      ),

    );

  }
}
