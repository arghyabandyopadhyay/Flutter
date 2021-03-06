import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ArghyaBandyopadhyay/Models/YoutubeAddModalOptionsModel.dart';
import 'package:shimmer/shimmer.dart';
//YoutubeAddModalBottomSheet is a Stateless widget
class YoutubeAddModalBottomSheet extends StatelessWidget {
	//list of options you want to show in the bottom sheet
  final List<YoutubeAddModalOptionsModel> list;
  const YoutubeAddModalBottomSheet({Key key, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 0,
        title: Text("Create"),
        leading: IconButton(
          icon: Icon(Icons.add_circle),
          onPressed: (){},
        ),
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.clear), onPressed:(){
          //closes the modal on pressing the Icons Button
            Navigator.pop(context);
          }),
        ],
      ),
      body: Column(
        children: [
          Expanded(child:ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(list[index].particulars!=null?list[index].particulars:""),
                leading: CircleAvatar(
                  radius: 35,
                  child: CachedNetworkImage(
                    imageUrl: list[index].icon,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 40,
                      width: 40,
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
                              width:40,
                              height: 40,
                              color: Colors.white,
                            ),
                          ),
                        )
                    ),
                    //shows an error sign on the problem faced to fetch the image using the url
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                onTap: list[index].onTap,
              );
            },
          ),)
        ],
      ),
    );

  }
}
