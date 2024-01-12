import 'dart:async';
import 'package:admin_web_portal/authencation/login.dart';
import 'package:admin_web_portal/homeScreen/change_earnings.dart';
import 'package:admin_web_portal/user/add_new_staff.dart';
import 'package:admin_web_portal/user/blocked_riders.dart';
import 'package:admin_web_portal/user/blocked_staff.dart';
import 'package:admin_web_portal/user/blocked_user.dart';
import 'package:admin_web_portal/user/verified_riders.dart';
import 'package:admin_web_portal/user/verified_staff.dart';
import 'package:admin_web_portal/user/verified_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  String timeString = "";
  String dateString = "";
  double totalEarning = 0.0;

  String formatCurrentTime(DateTime time){
    return DateFormat("hh:mm:ss a").format(time);
  }
  String formatCurrentDate(DateTime date){
    return DateFormat("yyyy, dd MMMM").format(date);
  }
  getCurrentTime(){
    final DateTime timeNow = DateTime.now();
    final String liveTime = formatCurrentTime(timeNow);
    final String liveDate = formatCurrentDate(timeNow);

    if(mounted){
      setState(() {
        timeString = liveTime;
        dateString = liveDate;
      });
    }
  }
  retrieveTotalEarning() async
  {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("orders").get();
    double tempTotalEarning = 0.0;
    for (var doc in querySnapshot.docs) {
      if(doc.exists){
        var data = doc.data() as Map<String, dynamic>?;
        if (data != null && data['totalAmount'] != null) {
          double orderAmount = data['totalAmount'];
          tempTotalEarning += orderAmount;
        }      }
    }
    setState(() {
      totalEarning = tempTotalEarning;
    });
  }
  @override
  void initState() {
    super.initState();
    //date
    formatCurrentDate(DateTime.now());
    //time
    formatCurrentTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (timer) {
      getCurrentTime();
    });
    retrieveTotalEarning();

  }
  @override
  Widget build(BuildContext context) {
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
        title:  const Center(child: Text("ADMIN WEB PORTAL",style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: 3,
        ),)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeString,
                  style: const TextStyle(
                    fontSize: 20 ,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "Total Earnings: ",style: TextStyle(
                      letterSpacing: 2,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,

                    ),
                    ),
                    Text(
                      "\$ $totalEarning",
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),

                  ],
                ),

                Text(
                  dateString,
                  style: const TextStyle(
                    fontSize: 20 ,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3
                  ),
                ),
              ],
            ),
          ),
          // for user
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
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
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.person_add, color: Colors.black),
                  label: Text(
                    "Verified Users".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      letterSpacing: 3,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const VerifiedUsers()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30.0),

                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),
              const SizedBox(width: 20,),
              Container(
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
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.block, color: Colors.black),
                  label: Text(
                    "Blocked Users".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      letterSpacing: 3,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const BlockedUsers()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30.0),

                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              )

            ],
          ),
          const SizedBox(height: 20.0 ,),
          //for staff
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
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
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.person_add, color: Colors.black),
                  label: Text(
                    "Verified Staffs".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      letterSpacing: 3,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const VerifiedStaffs()));

                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30.0),

                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),
              const SizedBox(width: 20,),
              Container(
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
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.block, color: Colors.black),
                  label: Text(
                    "Blocked Staffs".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      letterSpacing: 3,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const BlockedStaffs()));

                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30.0),

                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              )

            ],
          ),
          const SizedBox(height: 20.0 ,),
          // for rider
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
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
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.person_add, color: Colors.black),
                  label: Text(
                    "Verified Riders".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      letterSpacing: 3,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const VerifiedRiders()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30.0),

                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),
              const SizedBox(width: 20,),
              Container(
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
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.block, color: Colors.black),
                  label: Text(
                    "Blocked Rider".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      letterSpacing: 3,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const BlockedRiders()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30.0),

                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              )

            ],
          ),
          const SizedBox(height: 20.0 ,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(10.0),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey.withOpacity(0.5),
                  //         spreadRadius: 3,
                  //         blurRadius: 10,
                  //         offset: const Offset(0,3),
                  //       ),
                  //     ],
                  //   ),
                  //   child: ElevatedButton.icon(
                  //     icon: const Icon(Icons.person_add, color: Colors.black),
                  //     label: Text(
                  //       "Add New Staff".toUpperCase(),
                  //       style: const TextStyle(
                  //         color: Colors.black,
                  //         fontSize: 16,
                  //         letterSpacing: 3,
                  //       ),
                  //     ),
                  //     onPressed: () {
                  //       Navigator.push(context, MaterialPageRoute(builder: (c) => const AddNewStaffScreen()));
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       padding: const EdgeInsets.all(30.0),
                  //
                  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 20.0,),
                  Container(
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
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.price_change_outlined, color: Colors.black),
                      label: Text(
                        "\$ per ride".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          letterSpacing: 3,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) => const ChangeEarningScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(30.0),

                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Container(
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
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.black),
                  label: Text(
                    "Logout".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      letterSpacing: 3,
                    ),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30.0),

                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}
