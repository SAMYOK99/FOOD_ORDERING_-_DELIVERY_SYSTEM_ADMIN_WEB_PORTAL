import 'dart:async';

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

    if(this.mounted){
      setState(() {
        timeString = liveTime;
        dateString = liveDate;
      });
    }
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("This is home screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              timeString,
              style: TextStyle(
                fontSize: 20 ,
                fontWeight: FontWeight.bold,
                letterSpacing: 3
              ),
            ),
            Text(
              dateString,
              style: TextStyle(
                fontSize: 20 ,
                fontWeight: FontWeight.bold,
                letterSpacing: 3
              ),
            ),
          ],
        ),
      ),
    );
  }
}
