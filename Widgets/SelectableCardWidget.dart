import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ArghyaBandyopadhyay/Models/ListItemModel.dart';

import '../Global.dart';
//The ListItemModel should definitely have the member isSelected
class SelectableCardWidget extends StatefulWidget {
  final Key key;
  final ListItemModel item;
  final double size;
  final Function onTapList;
  final Function onLongPressed;
  final int index;

  SelectableCardWidget({this.item, this.key,this.size,this.onTapList,this.index,this.onLongPressed});

  @override
  _SelectableCardWidgetState createState() => _SelectableCardWidgetState();
}

class _SelectableCardWidgetState extends State<SelectableCardWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
            widget.onTapList(widget.index);
        },
      onLongPress: (){
        widget.onLongPressed(widget.index);
      },
      child: Card(
        elevation: 0.2,
        margin: EdgeInsets.symmetric(horizontal: 0,vertical: 0.1),
        child: Container(
          color: widget.item.isSelected?CurrentTheme.primaryColor.withOpacity(0.2):Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          //the child can be changed according to the requirement.
          child: Column(
            children: [
              SizedBox(height: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width:widget.size*0.42,child: Text(widget.item.particulars!=null?widget.item.particulars:""),),
                  Container(width:widget.size*0.42,child: Text(widget.item.info!=null?widget.item.info:"",textAlign: TextAlign.right,style: TextStyle(fontWeight: FontWeight.bold,color: HexColor(widget.item.hexColor),),))
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width:widget.size*0.42,child: Text(widget.item.subParticulars!=null?widget.item.subParticulars:"",style: TextStyle(fontSize:12,color: CurrentTheme.primaryText),),),
                  Container(width:widget.size*0.42,child: Text(widget.item.subInfo!=null?widget.item.subInfo:"",style: TextStyle(fontSize:12,color: CurrentTheme.primaryText),textAlign: TextAlign.right,))
                ],
              ),
              SizedBox(height: 2,),
            ],
          ),
        ),
      ),
    );
  }
}