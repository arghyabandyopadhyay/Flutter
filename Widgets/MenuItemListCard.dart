import 'dart:convert';
import 'package:ArghyaBandyopadhyay/Model/MenuItemModel.dart';
import 'package:ArghyaBandyopadhyay/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ArghyaBandyopadhyay/GlobalClass.dart';
import 'AddButton.dart';
class MenuItemListCard extends StatefulWidget{
  MenuItemModel item;
  final onTapAdd;
  final onTapRemove;
  final onLongPressedAdd;
  final onLongPressedRemove;
  final onDoubleTap;
  final onMiddleTap;
  MenuItemListCard({Key key, this.item, this.onTapAdd, this.onLongPressedAdd, this.onLongPressedRemove, this.onTapRemove,this.onDoubleTap,this.onMiddleTap}) : super(key: key);
  @override
  _MenuItemListCardState createState() => _MenuItemListCardState();
}
class _MenuItemListCardState extends State<MenuItemListCard> {
  Widget build(BuildContext context) {
    List<String> tagList=(widget.item.Tags!=null)?widget.item.Tags.split("|"):new List();
    if(widget.item.Discount!=null&&widget.item.Discount!=0)tagList.insert(0,widget.item.Discount.toString()+"% Off");
    double screenWidth=MediaQuery.of(context).size.width;
    return Card(
        elevation: 0,
        color: Colors.transparent,
        margin: EdgeInsets.only(bottom: 2),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 0,vertical: 3),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                (widget.item.ItemImage!=null&&widget.item.ItemImage!="")?Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 5),
                    width: MediaQuery.of(context).size.width/7,
                    child:CachedNetworkImage(
                      width: 40,
                      height: 40,
                      imageUrl: widget.item.ItemImage,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            //colorFilter:ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                          width: double.infinity,
                          child: Center(
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300].withOpacity(0.3),
                              highlightColor: Colors.white,
                              enabled: true,
                              child: Container(
                                width:MediaQuery.of(context).size.width/7,
                                height: 40,
                                color: Colors.white,
                              ),
                            ),
                          )
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                ):Container(height: 0,width: 0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    widget.item.IsVeg!=null?Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(top: 8),
                                      child: widget.item.IsVeg? new Image.asset('assets/img/veg.png',height: 15,width: 15,):new Image.asset('assets/img/nonveg.png',height: 15,width: 15,),
                                    ):Container(),
                                    SizedBox(width: 5,),
                                    Container(
                                      width: screenWidth/1.5-((widget.item.ItemImage!=null&&widget.item.ItemImage!="")?screenWidth/7:0)+((widget.item.IsVeg!=null)?0:15),
                                      child: Text(
                                        widget.item.Item,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textScaleFactor: 1,
                                        style: TextStyle( fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: screenWidth/1.5-((widget.item.ItemImage!=null&&widget.item.ItemImage!="")?screenWidth/7:0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "₹"+widget.item.Rate.toStringAsFixed((((widget.item.Rate*100)%100)!=0)?2:0).replaceAllMapped(UserDetail.commaRegex, UserDetail.matchFunc),
                                        textAlign: TextAlign.end,
                                        textScaleFactor: 1,
                                        style: TextStyle( fontSize: 17),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(
                                        (widget.item.Discount!=null&&widget.item.Discount!=0)?"₹"+widget.item.RateBeforeDiscount.toString():"",
                                        textAlign: TextAlign.end,
                                        textScaleFactor: 1,
                                        style: TextStyle( fontSize: 15,color: MyColors.primaryText,decoration: TextDecoration.lineThrough),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onDoubleTap: widget.onDoubleTap,
                          onTap: widget.onMiddleTap
                          ,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            AddButton(
                              item: widget.item,
                              onLongPressedRemove:widget.onLongPressedRemove,
                              onLongPressedAdd:widget.onLongPressedAdd,
                              onTapRemove: widget.onTapRemove,
                              onTapAdd: widget.onTapAdd,
                            ),
                            SizedBox(height: 2,),
                            Container(
                              height: (widget.item.Customizable.length!=0)?null:0,
                              padding: EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.orange,width: 1.0,style: BorderStyle.solid)
                              ),
                              child: (widget.item.Customizable.length!=0)?Text(" Customizable ",
                                textScaleFactor: 1,
                                style: TextStyle(fontSize: 10,color: Colors.orange),
                              ):null,
                            ),
                            Container(
                              height: (widget.item.CommentForKOT.isNotEmpty)?null:0,
                              padding: EdgeInsets.symmetric(horizontal: 1),
                              child: (widget.item.CommentForKOT.isNotEmpty)?Icon(Icons.comment,color: MyColors.primaryColor,):null,
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 5,),
                    Container(
                      height: (tagList.length>0)?20:0,
                      width: screenWidth/1.12-((widget.item.ItemImage!=null&&widget.item.ItemImage!="")?screenWidth/7:0),
                      child: (tagList.length>0)?ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: tagList.length,
                        itemBuilder: (context, id) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 1),
                            alignment: Alignment.center,
                            height: 20,
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color:MyColors.primaryColor,width: 1.0,style: BorderStyle.solid),
                                color: MyColors.primaryColor
                            ),
                            child: Text(tagList[id],
                              textScaleFactor: 1,
                              style: TextStyle(fontSize: 10,color: Colors.white),
                            ),
                          );},
                      ):Container(height: 0,width: 0,),
                    ),
                    Container(
                      width: screenWidth/1.1-((widget.item.ItemImage!=null&&widget.item.ItemImage!="")?screenWidth/7:0),
                      child:(widget.item.ItemDescription!=null)?
                      Text(
                        widget.item.ItemDescription,
                        textScaleFactor: 1,
                        style: TextStyle( color:MyColors.primaryText,fontSize: 13,),
                        maxLines: 3,
                      ):null,
                    ),
                  ],
                )
              ],
            )
        )
    );
  }
}