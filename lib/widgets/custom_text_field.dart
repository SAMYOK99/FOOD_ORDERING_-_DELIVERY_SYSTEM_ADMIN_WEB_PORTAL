import 'package:flutter/material.dart';
class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;// for hint text
  bool isObsecre = true;// to secure password
  bool? enabled = true;// enable user to write in the textfield

CustomTextField({super.key,
this.controller,
this.data,
this.hintText,
required this.isObsecre,
this.enabled,
});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.6,
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
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(10.0),
      //   boxShadow: const [
      //     BoxShadow(
      //     color: Colors.black26,
      //     blurRadius: 4 ,
      //     offset: Offset(0,2)
      //   )
      //   ]
      //
      // ),
      height: 60 ,
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        enabled: widget.enabled,
        controller: widget.controller,
        obscureText: widget.isObsecre,
        cursorColor: Theme.of(context).primaryColor,
        decoration: widget.hintText=='Password'|| widget.hintText=='Confirm password'? InputDecoration(
         border: InputBorder.none,
         prefixIcon: Icon(
           widget.data,
             color: Colors.green,
         ),
            focusColor: Theme.of(context).primaryColor,
           suffixIcon: IconButton(
          padding: EdgeInsetsDirectional.only(end: 12.0),
             icon: widget.isObsecre==true? const Icon(Icons.visibility): const Icon(Icons.visibility_off),
            onPressed: (){
               setState((){
                 widget.isObsecre = !widget.isObsecre;
               });
            },
           ),
           hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Colors.black38,
          ),


        ): InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            widget.data,
            color: Colors.green,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Colors.black54,
          ),


        )
      ),
    );
  }
}

