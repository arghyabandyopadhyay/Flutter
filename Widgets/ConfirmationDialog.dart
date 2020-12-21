import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Global.dart';
class ConfirmationDialog extends StatelessWidget  {
  final onTapYes;
  final onTapNo;
  final question;
  final headerText;
  // This widget is the root of your application.
  const ConfirmationDialog({Key key, this.onTapYes,this.onTapNo,this.question,this.headerText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(headerText,textScaleFactor:1,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      content: Text(question,textScaleFactor:1,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 17),),
      actions: [
        CupertinoDialogAction(child: Text(
          "No", style: TextStyle(fontSize:20,color: Colors.grey),
        ),
          onPressed: onTapNo,
        ),
        CupertinoDialogAction(child: Text(
          "Yes", style: TextStyle(fontSize:20,color: Colors.blueAccent),
        ),
          onPressed: onTapYes,
        ),
      ],
    );
  }
}