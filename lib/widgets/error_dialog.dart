import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;
  const ErrorDialog({super.key, this.message});
  


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 64, 132, 66),
          ),
          onPressed: (){
              Navigator.pop(context);
          },
            child: const  Center(
              child: Text('Ok',style: TextStyle(
                color: Colors.black,
              ),),
            ),
        )
      ],
    );
  }
}
