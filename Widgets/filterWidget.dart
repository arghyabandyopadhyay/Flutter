import 'package:ArghyaBandyopadhyay/Global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  final Function()? onTap;
  final String? text;
  final bool isLoading;
  const FilterWidget({Key? key, this.onTap, this.text, required this.isLoading}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: [
          Container(
              height: 28,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0XFFC4C4C4),
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    padding: EdgeInsets.all(isLoading ? 5 : 2),
                    child: isLoading
                        ? CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0XFF888888),
                          )
                        : Icon(
                            Icons.filter_list_outlined,
                            color: Color(0XFF888888),
                          ),
                  ),
                  Text(
                    " $text ",
                    textScaleFactor: CurrentTheme.textScaleFactor,
                    style: TextStyle(color: Color(0XFF888888)),
                  )
                ],
              ))
        ],
      ),
      onTap: onTap,
    );
  }
}
