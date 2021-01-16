import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ArghyaBandyopadhyay/Models/ListItemModel.dart';
import 'package:ArghyaBandyopadhyay/Models/OptionsMasterModel.dart';
import 'package:ArghyaBandyopadhyay/Widgets/ReportsListCardWidget.dart';
import 'package:shimmer/shimmer.dart';

import '../Global.dart';

List<ListTile> buildExpandedList(BuildContext context, List<ListItemModel> items,double screenWidth,int cardType,String accountType,Function onTapList) {
  List<ListTile> a=new List<ListTile>();
  a.add(ListTile(
    contentPadding: EdgeInsets.zero,
    title: Container(
        padding: EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    onTapList(items[index]);
                  },
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: ReportsCardWidget(
                      key: ObjectKey(items[index].uID.toString()+accountType),
                      item: items[index],
                      size:screenWidth ,
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Share',
                        color: CurrentTheme.primaryColor,
                        icon: Icons.share,
                        onTap: () => print('Share'),
                      ),
                    ],
                  ),
                );
              },),
          ],
        )
    ),
  ));
  return a;
}
List<ListTile> buildExpandedListFilter(BuildContext context, List<OptionsMasterModel> items,Function onToggleAction) {
  List<ListTile> a=new List<ListTile>();
  a.add(ListTile(
    contentPadding: EdgeInsets.zero,
    title: Container(
      child: ListView(
        children: items.getRange(0, items.length).map((group) {
          int index = items.indexOf(group);
          return CheckboxListTile(
            dense: true,
            title: Text(items[index].particulars),
            value: items[index].isSelected,
            onChanged: (bool value){
              onToggleAction(value,items[index]);
            },
          );
        }).toList(),
      ),
      height: items.length==1?50:items.length==2?100:items.length==3?150:200,
    ),
  ));
  return a;
}
Widget expandableHeader(String name,String folderName)=> Row(children: [
  CircleAvatar(
    radius: 25,
    child: name!=null?CachedNetworkImage(
      imageUrl: "https://Bandyopadhyays.com/ArghyaBandyopadhyay/$folderName/${name.replaceAll(new RegExp("\\W"), "")}.png",
      imageBuilder: (context, imageProvider) => Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.contain,
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
                width:30,
                height: 30,
                color: Colors.white,
              ),
            ),
          )
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    ):Image(height:30,fit: BoxFit.fitHeight,image: Image.asset('assets/img/arghyaBandyopadhyay.png').image,),
    backgroundColor: Colors.transparent,
  ),
  Expanded(child: Text(
    "$name",
    style: TextStyle(
        fontWeight: FontWeight.w600
    ),
  ))
],);
Widget expandableHeaderSearchable(String name,String folderName,bool isSearching,Widget widget)=> isSearching?widget:Row(children: [
  CircleAvatar(
    radius: 25,
    child: name!=null?CachedNetworkImage(
      imageUrl: "https://Bandyopadhyays.com/ArghyaBandyopadhyay/$folderName/${name.replaceAll(new RegExp("\\W"), "")}.png",
      imageBuilder: (context, imageProvider) => Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.contain,
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
                width:30,
                height: 30,
                color: Colors.white,
              ),
            ),
          )
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    ):Image(height:30,fit: BoxFit.fitHeight,image: Image.asset('assets/img/arghyaBandyopadhyay.png').image,),
    backgroundColor: Colors.transparent,
  ),
  Expanded(child: Text(
    "$name",
    style: TextStyle(
        fontWeight: FontWeight.w600
    ),
  ))
],);
Widget buildStaggeredTile(Widget child) {
  return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: CurrentTheme.primaryText.withOpacity(0.2),
      child: InkWell
        (
        // Do onTap() if it isn't null, otherwise do print()
          child: child
      )
  );
}