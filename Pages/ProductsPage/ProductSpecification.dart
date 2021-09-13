import 'package:ArghyaBandyopadhyay/GlobalClass.dart';
import 'package:ArghyaBandyopadhyay/Model/ListItemModel.dart';
import 'package:ArghyaBandyopadhyay/Model/ProductDetailModel.dart';
import 'package:ArghyaBandyopadhyay/Widgets/GetRatingAndReviews.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../theme.dart';

class ProductSpecification extends StatelessWidget {
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
            Text("Specifications",textScaleFactor:1,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
          ],
        )
      ],
    );
  }
}
