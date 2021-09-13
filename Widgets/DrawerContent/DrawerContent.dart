import 'package:ArghyaBandyopadhyay/Models/DrawerActionModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../Global.dart';

class DrawerContent extends StatelessWidget {
  DrawerContent({Key key, this.drawerItems,this.alternativeName,this.alternativeMno,this.onCompanyChange}) : super(key: key);
  final List<DrawerActionModel> drawerItems;
  final String alternativeName;
  final String alternativeMno;
  final Function onCompanyChange;
  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: <Widget>
        [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: UserDetail.currentCompany.userLoginData.image!=null&&UserDetail.currentCompany.userLoginData.image!=""?CachedNetworkImage(
                        imageUrl: UserDetail.currentCompany.userLoginData.image,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 50,
                          width: 50,
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
                                  width:50,
                                  height: 50,
                                  color: Colors.white,
                                ),
                              ),
                            )
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ):
                      Image(height:50,width:50,fit: BoxFit.fitHeight,image: Image.asset(
                        'assets/img/profile.png',
                      ).image)
                      ,)
                ),
                SizedBox(height: 2,),
                GestureDetector(
                  onTap: (){
                    onCompanyChange(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(UserDetail.currentCompany.userLoginData.firstName!=null&&UserDetail.currentCompany.userLoginData.firstName!=""?UserDetail.currentCompany.userLoginData.firstName:alternativeName,textScaleFactor:1,style: TextStyle(fontSize: 15,color: CurrentTheme.appBarTextColor,),),
                          Text(UserDetail.currentCompany.userLoginData.emailID!=null&&UserDetail.currentCompany.userLoginData.emailID!=""?UserDetail.currentCompany.userLoginData.emailID:alternativeMno,textScaleFactor:1,style: TextStyle(fontSize: 15,color: CurrentTheme.appBarTextColor,),),
                          Text(UserDetail.currentCompany.clientName!=null&&UserDetail.currentCompany.clientName!=""?UserDetail.currentCompany.clientName:alternativeMno,textScaleFactor:1,style: TextStyle(fontSize: 15,color: CurrentTheme.appBarTextColor,),)
                        ],
                      ),),
                      IconButton(icon: Icon(Icons.arrow_drop_down,color: CurrentTheme.appBarTextColor,), onPressed: (){
                        onCompanyChange(context);
                      })
                    ],
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: CurrentTheme.primaryColor,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: drawerItems.length,
            itemBuilder: (BuildContext context, int index)
            {
              return ListTile(
                leading: Icon(drawerItems[index].iconData),
                title: Text(drawerItems[index].title,textScaleFactor:1),
                onTap: drawerItems[index].onTap,
              );
            }
          ),
        ]
    );
  }
}

