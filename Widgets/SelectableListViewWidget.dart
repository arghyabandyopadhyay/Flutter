import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ArghyaBandyopadhyay/Models/ReportsModel/MasterReportDataModel.dart';
import 'package:ArghyaBandyopadhyay/Models/ListItemModel.dart';
import 'package:ArghyaBandyopadhyay/Modules/ApiHandler.dart';
import 'package:ArghyaBandyopadhyay/Modules/CreatePdfHandler.dart';
import 'package:ArghyaBandyopadhyay/Modules/UniversalModule.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../../../Global.dart';
import '../../ConfirmationDialog.dart';
import 'SelectableCardWidget.dart';
class SelectableListViewWidget extends StatefulWidget {
  SelectableListViewWidget({Key key, this.list,this.reportType,this.screenWidth,this.scaffoldKey,this.onTapList,this.onLongPressed}) : super(key: key);
  final List list;
  final String reportType;
  final double screenWidth;
  final Function onTapList;
  final Function onLongPressed;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  _SelectableListViewWidgetState createState() => new _SelectableListViewWidgetState();
}
class _SelectableListViewWidgetState extends State<SelectableListViewWidget>
{
  bool isLoading,isShareLoading,isDownloadLoading;
  Future<void> createPdf(bool isShare,ListItemModel item) async {
    setState(() {
      if(isShare)isShareLoading=true;
      else isDownloadLoading=true;
    });
    //the getpdf here is just a function responsible for api calls.
    String base64String=await getPdf(UserDetail.uid, item.id.toString());
    Uint8List bytes = base64Decode(base64String);
    final output = await localPath;
    String fileName="PDF_"+item.particulars.replaceAll(new RegExp("\\W"), "");
    final file = File("$output/$fileName.pdf");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    if(isShare)Share.shareFiles(['$output/$fileName.pdf'], text: 'Your PDF!');
    else await OpenFile.open("$output/$fileName.pdf");
    setState(() {
      if(isShare)isShareLoading=false;
      else isDownloadLoading=false;
    });
  }
  @override
  void initState()
  {
    super.initState();
    isLoading = false;
    isShareLoading = false;
    isDownloadLoading = false;
    _loadMore();
  }
  List displayList=new List();
  int currentLength = 0;
  final int increment = 100;
  Future _loadMore() async {
    setState(() {
      isLoading = true;
    });
    int end=currentLength+increment;
    displayList.addAll(widget.list.getRange(currentLength, end>=widget.list.length?widget.list.length:end));
    setState(() {
      isLoading = false;
      currentLength = displayList.length;
    });
  }
  GlobalKey<ScaffoldState> scaffoldKey=new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: LazyLoadScrollView(
          isLoading: isLoading,
          scrollOffset: 500,
          onEndOfPage: () => _loadMore(),
          child: ListView.builder(
            itemCount: displayList.length,
            itemBuilder: (BuildContext context, int index) {
              return Slidable(
                  closeOnScroll: true,
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: SelectableCardWidget(
                    key: ObjectKey((displayList[index].id.toString())+widget.reportType),
                    item: displayList[index],
                    size:widget.screenWidth ,
                    scaffoldKey: scaffoldKey,
                    onTapList: (index){
                      widget.onTapList(index);
                    },
                      index: index,
                    onLongPressed: (index){
                      widget.onLongPressed(index);
                    }
                  ),
                secondaryActions: <Widget>[
                  isShareLoading?Center(child: Container(height:40,width:40,padding:EdgeInsets.all(10),child: CircularProgressIndicator(strokeWidth: 3,backgroundColor: CurrentTheme.progressBarBackground,),),):IconSlideAction(
                    closeOnTap: false,
                    caption: 'Share',
                    color: CurrentTheme.primaryColor,
                    icon: Icons.share,
                    onTap: () async {
                      try{
                        Connectivity connectivity=Connectivity();
                        await connectivity.checkConnectivity().then((value)async => {
                          if(value!=ConnectivityResult.none)
                            {
                              await createPdf(true,widget.list[index]),
                            }
                          else{
                            globalShowInSnackBar(widget.scaffoldKey,"No Internet Connection!!")
                          }
                        });
                      }
                      catch(E)
                      {
                        globalShowInSnackBar(widget.scaffoldKey,"Something Went Wrong");
                      }
                    },
                  ),
                  isDownloadLoading?Center(child: Container(height:40,width:40,padding:EdgeInsets.all(10),child: CircularProgressIndicator(strokeWidth: 3,backgroundColor: CurrentTheme.progressBarBackground,),),):IconSlideAction(
                    closeOnTap: false,
                    caption: 'Download',
                    color: CurrentTheme.primaryColor,
                    icon: Icons.download_sharp,
                    onTap: () async {
                      try{
                        Connectivity connectivity=Connectivity();
                        await connectivity.checkConnectivity().then((value)async => {
                          if(value!=ConnectivityResult.none){await createPdf(false,widget.list[index]),
                          }
                          else{
                            globalShowInSnackBar(widget.scaffoldKey,"No Internet Connection!!")
                          }
                        });
                      }
                      catch(E)
                      {
                        globalShowInSnackBar(widget.scaffoldKey,"Something Went Wrong");
                      }
                    },
                  ),
                ],
              );
            },)),
    );
  }
  @override
  void didChangeDependencies() {
    Provider.of<int>(context);
    displayList.clear();
    currentLength = 0;
    _loadMore();
    super.didChangeDependencies();
  }

}