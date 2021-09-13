import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ArghyaBandyopadhyay/Global.dart';
import 'package:ArghyaBandyopadhyay/Models/ListItemModel.dart';

class ListCardWidget extends StatelessWidget
{
  final ListItemModel item;
  final double size;
  const ListCardWidget({Key key, this.item,this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.2,
      margin: EdgeInsets.symmetric(horizontal: 0,vertical: 0.1),
      child: Container(
        padding: EdgeInsets.only(left: 15,right:10,top: 5,bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2,),
            Text(item.particulars!=null?item.particulars:"",textAlign: TextAlign.start,),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(item.subParticulars!=null?item.subParticulars:"",style: TextStyle(fontSize:12,color: CurrentTheme.primaryText),),),
                Container(width:size*0.34,child: Text(item.subInfo!=null?item.subInfo:"",style: TextStyle(fontSize:12,color: HexColor(item.hexCode),fontWeight: FontWeight.bold),textAlign: TextAlign.right,))
              ],
            ),
            SizedBox(height: 2,),
          ],
        ),
      ),
    );
  }
}