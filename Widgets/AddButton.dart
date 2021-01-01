import 'package:ArghyaBandyopadhyay/MyTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class AddButton extends StatefulWidget {
  AddButton(
      {Key key,
      this.quantity,
      this.onTapAdd,
      this.onLongPressedAdd,
      this.onLongPressedRemove,
      this.onTapRemove})
      : super(key: key);
  final double quantity;
  final onTapAdd;
  final onLongPressedAdd;
  final onLongPressedRemove;
  final onTapRemove;
  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 70,
      alignment: Alignment.bottomRight,
      decoration: BoxDecoration(
        //for adding gradient to the button.
        //gradient: widget.quantity==0.0?LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors: MyTheme.primaryGradient):null,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
            color: MyTheme.primaryColor, width: 1, style: BorderStyle.solid),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: 35,
                width: widget.quantity == 0.0 ? 65 : null,
                color: Colors.transparent,
                child: widget.quantity == 0.0
                    ? Text(
                        "Add",
                        textAlign: TextAlign.center,
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontSize: 15, color: MyTheme.secondaryText),
                      )
                    : Icon(
                        Icons.remove,
                        size: 17,
                      ),
                padding: EdgeInsets.all(1),
              ),
              onTap: widget.quantity == 0.0
                  ? () {
                      setState(() {
                        widget.onTapAdd();
                      });
                    }
                  : () {
                      setState(() {
                        widget.onTapRemove();
                      });
                    },
              onLongPress: widget.quantity == 0.0
                  ? widget.onLongPressedAdd
                  : () {
                      setState(() {
                        widget.onLongPressedRemove();
                      });
                    }),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(0),
            width: widget.quantity == 0.0 ? 0 : 25,
            height: widget.quantity == 0.0 ? 0 : 35,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: MyTheme.primaryGradient),
            ),
            child: Text(
              widget.quantity.toStringAsFixed(
                  (((widget.quantity * 10) % 10) != 0) ? 1 : 0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 12.0,
                color: MyTheme.secondaryText,
              ),
            ),
          ),
          GestureDetector(
              child: Container(
                child: widget.quantity == 0.0
                    ? Text(
                        "",
                        textScaleFactor: 1,
                      )
                    : Icon(
                        Icons.add,
                        size: 17,
                        color: MyTheme.primaryColor,
                      ),
                height: widget.quantity == 0.0 ? 0 : 35,
                width: widget.quantity == 0.0 ? 0 : 20,
                color: Colors.transparent,
                padding: EdgeInsets.all(1),
              ),
              onTap: () {
                setState(() {
                  widget.onTapAdd();
                });
              },
              onLongPress: widget.onLongPressedAdd),
        ],
      ),
    );
  }
}
