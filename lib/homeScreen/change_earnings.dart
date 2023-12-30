import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChangeEarningScreen extends StatefulWidget {
  const ChangeEarningScreen({super.key});

  @override
  State<ChangeEarningScreen> createState() => _ChangeEarningScreenState();
}


class _ChangeEarningScreenState extends State<ChangeEarningScreen>{
  double currentPayPerDelivery = 0.0;
  double amtPerDelivery  = 0.0;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();



  void onAmountChanged(String value) {
    setState(() {
      amtPerDelivery = value as double;
      autovalidateMode = AutovalidateMode.onUserInteraction;
    });
  }
  retrieveTotalEarning() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("perDelivery")
          .doc("abc123")
          .get();
      Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;

      if (documentSnapshot.exists && data != null) {
        dynamic tempAmtPerDelivery = data['amount'];
        setState(() {
          currentPayPerDelivery = double.parse(tempAmtPerDelivery) ;
        });
      } else {
        setState(() {
          currentPayPerDelivery = 0.0;
        });
      }
    } catch (e) {
      print('Error retrieving total earning: $e');
    }
  }

  updateAmount(String amt){
    FirebaseFirestore.instance
        .collection("perDelivery")
        .doc("abc123").update({
      "amount" : amt,
    }).then((value) {
      SnackBar snackBar = const SnackBar(content: Center(
        child: Text(
          "New Amount Updated Successfully",
          style:  TextStyle(
            fontSize: 25,
            color: Colors.red,
          ),
        ),

      ),
        backgroundColor: Colors.white,
        duration: Duration(seconds: 3) ,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(context, MaterialPageRoute(builder: (c)=>const AdminHomeScreen()));

    });
  }
  @override
  void initState() {
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
        centerTitle: true,
        title: const Text(
          "CHANGE PER DELIVERY AMOUNT",
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
      body:  Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    "Amount Per Delivery: ",style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 30,

                  ),
                  ),
                  Text(
                    "\$ $currentPayPerDelivery",
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.red
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.2,
                    child: TextFormField(
                      controller: _textEditingController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Colors.black12
                          )
                        ),
                        icon: Icon(
                          Icons.attach_money_outlined,
                          color: Colors.black87,
                          size: 35,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the amount.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 25.0,),
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
                        "CHANGE".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          letterSpacing: 3,
                        ),
                      ),
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          String amt = _textEditingController.text;
                          updateAmount(amt);

                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                  ),


                ],
              ),
            ],
          ),
        ),
      ),

    );
  }
}
