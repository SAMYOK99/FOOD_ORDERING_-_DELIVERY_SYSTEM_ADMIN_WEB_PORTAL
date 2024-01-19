import 'package:admin_web_portal/model/email.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChangeRole extends StatefulWidget {
  final Email model;

  ChangeRole({Key? key, required this.model}) : super(key: key);

  @override
  State<ChangeRole> createState() => _ChangeRoleState();
}

class _ChangeRoleState extends State<ChangeRole> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 66,
        width: MediaQuery.of(context).size.width - 20,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.model.userEmail ?? 'admin2@gmail.com',
                  ),
                  GestureDetector(
                    child: const Icon(
                      Icons.change_circle,
                      size: 35,
                      color: Colors.green,
                    ),
                    onTap: () {
                      dialogBoxForUnBlockingUserAccount(widget.model.userId);
                    },
                  ),
                ],
              ),
              Center(
                child: Text(
                  widget.model.role.toString(),
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dialogBoxForUnBlockingUserAccount(userDocId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Change role",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              letterSpacing: 2,
            ),
          ),
          content: const Text(
            "Do you want to change the role of this Account?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 2,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                String newRole = (widget.model.role == "staff") ? "user" : "staff";
                Map<String, dynamic> userDataMap = {
                  "role": newRole,
                };
                FirebaseFirestore.instance.collection("users").doc(userDocId).update(userDataMap).then((value) {
                  setState(() {
                    widget.model.role = newRole;
                  });
                  Navigator.pop(context);
                  // Navigator.push(context, MaterialPageRoute(builder: (c) => const AdminHomeScreen()));
                  SnackBar snackBar = const SnackBar(
                    content: Center(
                      child: Text(
                        "Role has been changed.",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    duration: Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}

