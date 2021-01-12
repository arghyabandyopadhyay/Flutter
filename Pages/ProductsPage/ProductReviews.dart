import 'package:ArghyaBandyopadhyay/GlobalClass.dart';
import 'package:ArghyaBandyopadhyay/Model/ListItemModel.dart';
import 'package:ArghyaBandyopadhyay/Model/ProductDetailModel.dart';
import 'package:ArghyaBandyopadhyay/Widgets/GetRatingAndReviews.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../theme.dart';

class ProductReviews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ListItemModel item=UserDetail.item;
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Ratings & Reviews",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
            GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                  decoration:BoxDecoration(color:Colors.white,border: Border.all(color: MyColors.primaryText.withOpacity(0.2),width: 1,style: BorderStyle.solid),),
                  child:Text("Rate Product",textScaleFactor:1,style: TextStyle(fontSize:15,color: MyColors.primaryColor,fontWeight: FontWeight.bold)),
                ),
                onTap:(){
                  Navigator.push(context, CupertinoPageRoute(builder: (context1) => GetRatingAndReviews(item: item,)));
                })
          ],
        )
      ],
    );
  }
}
