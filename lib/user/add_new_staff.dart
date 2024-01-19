//
// import 'dart:typed_data';
// import 'package:admin_web_portal/homeScreen/home_screen.dart';
// import 'package:admin_web_portal/widgets/custom_text_field.dart';
// import 'package:admin_web_portal/widgets/error_dialog.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart' as fStorage;
//
// class AddNewStaffScreen extends StatefulWidget {
//   const AddNewStaffScreen({super.key});
//
//   @override
//   State<AddNewStaffScreen> createState() => _AddNewStaffScreenState();
// }
//
// class _AddNewStaffScreenState extends State<AddNewStaffScreen> {
//   final GlobalKey<FormState> _formkey=  GlobalKey<FormState>();
//   TextEditingController namecontroller = TextEditingController();
//   TextEditingController passwordcontroller = TextEditingController();
//   TextEditingController confirmpassordcontroller = TextEditingController();
//   TextEditingController emailcontroller = TextEditingController();
//   TextEditingController phonecontroller = TextEditingController();
//   TextEditingController locationcontroller = TextEditingController();
//   XFile? imageXFile;
//
//   Position? position;
//   String completeAddress ='';
//   String userImageUrl ='';
//   LocationPermission? permission;
//   List<Placemark>? placeMarks;
//   Uint8List webImage = Uint8List(8);
//
//   final ImagePicker _picker = ImagePicker();
//   Future<void> _getImage() async {
//     try {
//       if (kIsWeb) {
//         XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//         var f = await image?.readAsBytes();
//         setState(() {
//           webImage = f!;
//           imageXFile = image;
//         });
//       }
//     } catch (e) {
//       print('Error loading image: $e');
//     }
//   }
//
//   // getCurrentLocation() async {
//   //   try {
//   //     permission = await Geolocator.requestPermission();
//   //     Position newPosition = await Geolocator.getCurrentPosition(
//   //       desiredAccuracy: LocationAccuracy.high,
//   //     );
//   //
//   //     List<Placemark> placeMarks = await placemarkFromCoordinates(
//   //       newPosition.latitude,
//   //       newPosition.longitude,
//   //     );
//   //
//   //     Placemark pMark = placeMarks[0]; // Get the first placemark
//   //
//   //     String completeAddress =
//   //         '${pMark.subThoroughfare}, ${pMark.thoroughfare}, ${pMark.subLocality}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.postalCode}, ${pMark.country}';
//   //
//   //     setState(() {
//   //       locationcontroller.text = completeAddress;
//   //     });
//   //   } catch (e) {
//   //     print(e);
//   //   }
//   //
//   //   // Position newPosition = await Geolocator.getCurrentPosition(
//   //   //   desiredAccuracy: LocationAccuracy.high,
//   //   // );
//   //   // position= newPosition;
//   //   // placeMarks = await placemarkFromCoordinates(
//   //   //     position!.latitude,
//   //   //     position!.longitude
//   //   // );
//   //   // Placemark pMark = placeMarks![0];// return from 0 th index
//   //   //
//   //   // String completeAddress = '${pMark.subThoroughfare}, ${pMark.thoroughfare}, ${pMark.subLocality}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.postalCode}, ${pMark.country}';
//   //   // locationcontroller.text= completeAddress;
//   // }
// // for number validation
//   bool isNumeric(String value) {
//
//     final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
//
//     return numericRegex.hasMatch(value);
//   }
//
//   Future<void> formValidation() async{
//     if(imageXFile==null){
//       showDialog(
//           context: context,
//           builder: (c) {
//             return const ErrorDialog(
//               message: 'Please select an image',
//             );
//           }
//       );
//     }
//     else
//     {
//       if(passwordcontroller.text==confirmpassordcontroller.text)
//       {
//         if(confirmpassordcontroller.text.isNotEmpty && namecontroller.text.isNotEmpty && emailcontroller.text.isNotEmpty && phonecontroller.text.isNotEmpty) {
//           if (isNumeric(phonecontroller.text)) {
//             // start uploading data at first image
//             SnackBar snackBar = const SnackBar(content: Center(
//               child: Text(
//                 "Adding..., Please wait.",
//                 style:  TextStyle(
//                   fontSize: 25,
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//               backgroundColor: Colors.white,
//               duration: Duration(seconds: 4) ,);
//             ScaffoldMessenger.of(context).showSnackBar(snackBar);
//             String fileName = DateTime
//                 .now()
//                 .millisecondsSinceEpoch
//                 .toString();
//             fStorage.Reference reference = fStorage.FirebaseStorage.instance
//                 .ref().child('staffs').child('fileName');
//             fStorage.UploadTask uploadTask = reference.putFile(
//                 File(imageXFile!.path));
//             fStorage.TaskSnapshot taskSnapshot = await uploadTask
//                 .whenComplete(() =>
//             {
//             }); // It provides information and status updates about the ongoing task.
//             await taskSnapshot.ref.getDownloadURL().then((url) {
//               userImageUrl = url;
//
//               //to save info to firestore
//               authenticateAndSignUp();
//             });
//           } else {
//             showDialog(
//                 context: context,
//                 builder: (c) {
//                   return const ErrorDialog(
//                     message: 'Please enter valid phone number',
//                   );
//                 }
//             );
//           }
//         } else {
//           showDialog(
//               context: context,
//               builder: (c) {
//                 return const ErrorDialog(
//                   message: 'All fields must be filled',
//                 );
//               }
//           );
//         }
//
//       }
//       else
//       {
//         showDialog(
//             context: context,
//             builder: (c) {
//               return const ErrorDialog(
//                 message: 'Please Enter same password',
//               );
//             }
//         );
//       }
//     }
//   }
//   void authenticateAndSignUp() async{
//     User?  currentUser;
//     await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: emailcontroller.text.trim(),
//       password: passwordcontroller.text.trim(),
//     ).then((auth){
//       currentUser = auth.user;
//     }).catchError((error){
//       Navigator.pop(context);
//       showDialog(
//           context: context,
//           builder:(c)
//           {
//             return ErrorDialog(
//               message:error.message.toString(),
//             );
//           });
//     });
//     if(currentUser!=null)
//     {
//       saveDataToFirestore(currentUser!).then((value){
//         Navigator.pop(context);
//         // sending user to home page
//         Route newRoute = MaterialPageRoute(builder: (c)=>const  AdminHomeScreen());
//         Navigator.pushReplacement(context, newRoute);
//       });
//     }
//   }
//   //To store data in firestore
//   Future saveDataToFirestore (User currentUser) async{
//     FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
//       'userId':currentUser.uid,
//       'userEmail':currentUser.email,
//       'userName':namecontroller.text.trim(),
//       'userPhone':phonecontroller.text.trim(),
//       'userImageUrl':userImageUrl,
//       'userAddress':completeAddress,
//       'status': "approved",
//       'earnings':0.0,
//       'lat':position?.latitude,
//       'lng':position?.longitude,
//       'userCart':['garbageValue'],
//       'role':'staff',
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children:  [
//               const SizedBox(height:10,),
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.3,
//                 height: MediaQuery.of(context).size.height * 0.5,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 2,
//                       blurRadius: 10,
//                       offset: const Offset(0,3),
//
//                     )
//                   ],
//                 ),
//                 child: InkWell(
//                   onTap: (){
//                     _getImage();
//                   },
//
//                   child: CircleAvatar(
//                     radius: MediaQuery.of(context).size.width * 0.20,
//                     backgroundColor: Colors.white,
//                     backgroundImage: imageXFile==null?null: MemoryImage(webImage,),
//                     // FileImage(File(imageXFile!.path)) ,
//                     child: imageXFile==null
//                         ?
//                     Icon(
//                       Icons.add_photo_alternate,
//                       size: MediaQuery.of(context).size.width * 0.20,
//                       color: Colors.grey,
//                     ):null,
//
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 5,),
//               Form(
//                   key: _formkey,
//                   child: Column(
//                     children: [
//                       Container(margin: const EdgeInsets.fromLTRB(15,10,15,10),
//                         child: CustomTextField(
//                           data: Icons.person,
//                           controller: namecontroller,
//                           hintText: 'Name',
//                           isObsecre: false,
//                         ),),
//                       Container(margin: const EdgeInsets.fromLTRB(15,10,15,10),
//                         child: CustomTextField(
//                           data: Icons.email,
//                           controller: emailcontroller,
//                           hintText: 'Email',
//                           isObsecre: false,
//                         ),),
//                       Container(margin: const EdgeInsets.fromLTRB(15,10,15,10),
//                         child: CustomTextField(
//                           data: Icons.lock,
//                           controller: passwordcontroller,
//                           hintText: 'Password',
//                           isObsecre: true,
//                         ),),
//                       Container(margin: const EdgeInsets.fromLTRB(15,10,15,10),
//                         child: CustomTextField(
//                           data: Icons.lock,
//                           controller: confirmpassordcontroller,
//                           hintText: 'Confirm password',
//                           isObsecre: true,
//                         ),),
//                       Container(margin: const EdgeInsets.fromLTRB(15,10,15,10),
//                         child: CustomTextField(
//                           data: Icons.phone,
//                           controller: phonecontroller,
//                           hintText: 'Phone',
//                           isObsecre: false,
//                         ),),
//                     ],
//                   )
//               ),
//               const SizedBox(height: 30,),
//               Container(
//                 width: MediaQuery.of(context).size.width*0.5,
//                 margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//                 child:  ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       elevation: 5,
//                       backgroundColor:Colors.white,
//                       padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 15),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)
//                       ),
//                     ),
//                     child: const Text(
//                       'SIGN UP',
//                       style: TextStyle(
//                         color: Colors.green,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//
//                       ),
//                     ),
//                     onPressed: ()=>{
//                       formValidation(),
//                     }
//                 ),
//               ),
//
//               const SizedBox(height: 30,),
//             ],
//           ),
//         ),
//       ),
//     ) ;
//
//
//
//   }
// }
import 'package:admin_web_portal/model/email.dart';
import 'package:admin_web_portal/widgets/change_role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ChangeRoleScreen extends StatefulWidget {
  const ChangeRoleScreen({Key? key}) : super(key: key);

  @override
  State<ChangeRoleScreen> createState() => _ChangeRoleScreenState();
}

Future<QuerySnapshot>? itemNameList;
String itemNameText = "";


initItemSearch(String textEntered) {
  itemNameList = FirebaseFirestore.instance
      .collection("users")
      .where("userEmail", isGreaterThanOrEqualTo: textEntered)
      .get();
}

class _ChangeRoleScreenState extends State<ChangeRoleScreen> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          size: 33,
          color: Colors.green,
        ),
        title: TextFormField(
          onChanged: (textEntered) {
            setState(() {
              itemNameText = textEntered;
            });
            initItemSearch(textEntered);
          },
          decoration: InputDecoration(
            hintText: 'Search user you want to change',
            hintStyle: const TextStyle(
              fontSize: 18,
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.green,
                size: 33,
              ),
              onPressed: () {
                initItemSearch(itemNameText);
              },
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: itemNameList,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Center(
                child: SizedBox(
                            width: 320,
                            height: MediaQuery.of(context).size.height * 1,
                            child: ListView(
                shrinkWrap: true,
                children: List.generate(
                    snapshot.data!.docs.length,
                        (index) {
                      Email model = Email.fromJson(
                        snapshot.data!.docs[index].data()!
                        as Map<String, dynamic>,
                      );
                      return Center(
                        child: ChangeRole(
                          model: model,
                        ),
                      );
                    }),
                            ),
                          ),
              )
              : const Center(child: Text("No User Found"));
        },
      ),
    );
  }
}

