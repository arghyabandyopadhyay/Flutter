import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ArghyaBandyopadhyay/Models/ListItemModel.dart';
import 'package:ArghyaBandyopadhyay/Modules/ApiHandler.dart';
import 'package:ArghyaBandyopadhyay/Modules/CreatePdfHandler.dart';
import 'package:ArghyaBandyopadhyay/Modules/DateCalculator.dart';
import 'package:ArghyaBandyopadhyay/Modules/UniversalModule.dart';
import 'package:ArghyaBandyopadhyay/Widgets/ListCardWidget.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../Global.dart';


class ListViewWidget extends StatefulWidget {
  ListViewWidget({Key key, this.list,this.onTapList,this.accountType,this.screenWidth,this.scaffoldKey}) : super(key: key);
  final List<ListItemModel> list;
  final Function onTapList;
  final String accountType;
  final double screenWidth;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  _AccountsListViewWidgetState createState() => new _AccountsListViewWidgetState();
}
class _AccountsListViewWidgetState extends State<ListViewWidget>
{
  _AccountsListViewWidgetState();
  List<ListItemModel> displayList=new List<ListItemModel>();
  int currentLength = 0;
  final int increment = 100;
  bool isLoading,isShareLoading,isDownloadLoading;
  @override
  void initState() {
    super.initState();
    isLoading=false;
    isShareLoading = false;
    isDownloadLoading = false;
    _loadMore();
  }
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
  Future<void> createPdf(bool isShare,ListItemModel item) async {
    setState(() {
      if(isShare)isShareLoading=true;
      else isDownloadLoading=true;
    });
    Map<String,String> toFromDate=calculateToFromDate("ThisFinancialYear");
    String base64String=await getLedgerPdf(UserDetail.currentCompany.guid, UserDetail.currentCompany.companyGUID, item.uID,toFromDate['fromDate'],toFromDate['toDate']);
    Uint8List bytes = base64Decode(base64String);
    final output = await localPath;
    String fileName=("LedgerAccount_")+item.particulars.replaceAll(new RegExp("\\W"), "");
    final file = File("$output/$fileName.pdf");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    if(isShare)Share.shareFiles(['$output/$fileName.pdf'], text: item.particulars!=null?item.particulars:"");
    else await OpenFile.open("$output/$fileName.pdf");
    setState(() {
      if(isShare)isShareLoading=false;
      else isDownloadLoading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LazyLoadScrollView(
          isLoading: isLoading,
          scrollOffset: 500,
          onEndOfPage: () => _loadMore(),
          child: ListView.builder(
            itemCount: displayList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  widget.onTapList(index);
                },
                child: Slidable(
                  closeOnScroll: true,
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: ListCardWidget(
                    key: ObjectKey(displayList[index].uID.toString()+widget.accountType),
                    item: displayList[index],
                    size:widget.screenWidth ,
                  ),
                  secondaryActions: <Widget>[
                    if(widget.accountType=="Ledger Account List")isShareLoading?Center(child: Container(height:40,width:40,padding:EdgeInsets.all(10),child: CircularProgressIndicator(strokeWidth: 3,backgroundColor: CurrentTheme.progressBarBackground,),),):IconSlideAction(
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
                                await createPdf(true,displayList[index]),
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
                    if(widget.accountType=="Ledger Account List")isDownloadLoading?Center(child: Container(height:40,width:40,padding:EdgeInsets.all(10),child: CircularProgressIndicator(strokeWidth: 3,backgroundColor: CurrentTheme.progressBarBackground,),),):IconSlideAction(
                      closeOnTap: false,
                      caption: 'Download',
                      color: CurrentTheme.primaryColor,
                      icon: Icons.download_sharp,
                      onTap: () async {
                        try{
                          Connectivity connectivity=Connectivity();
                          await connectivity.checkConnectivity().then((value)async => {
                            if(value!=ConnectivityResult.none){
                              await createPdf(false,displayList[index]),
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
                ),
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