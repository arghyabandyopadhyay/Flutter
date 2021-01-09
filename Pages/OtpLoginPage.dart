import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ArghyaBandyopadhyay/Stores/login_store.dart';
import 'package:ArghyaBandyopadhyay/theme.dart';
import 'package:ArghyaBandyopadhyay/Widgets/LoadingIndicator.dart';

import '../../GlobalClass.dart';
import 'package:ArghyaBandyopadhyay/Painters/LoginPagePainter.dart';
import 'HomePage.dart';

class OtpLoginPage extends StatefulWidget {
  const OtpLoginPage({Key key}) : super(key: key);
  @override
  _OtpLoginPageState createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends State<OtpLoginPage> {
  TextEditingController phoneController = TextEditingController(text: "+91");
  String _validateName(String value) {
    if (value.isEmpty) {
      return "Value is empty!";
    }
    final nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return "Robots not allowed.!";
    }
    return null;
  }
  bool _autoValidate = false;
  var nameController=TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void _handleSubmitted() {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true; // Start validating on every change.
    }
    else {
      form.save();
      //Save Data
      Navigator.of(context).push(CupertinoPageRoute<void>(builder: (context) =>HomePage()));
    }
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoadingIndicator(
            inAsyncCall: loginStore.isLoginLoading,
            child: Scaffold(
              key: loginStore.loginScaffoldKey,
              resizeToAvoidBottomInset: false,
              body: CustomPaint(
                painter: LoginPagePainter(),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/img/ArghyaBandyopadhyay_complete_icon.png",height: 70,width: 70,),
                      SizedBox(height: 20,),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10),
                        child: Text("Enter Your Phone Number",
                          textScaleFactor: 1,maxLines: 1,overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 25.0,
                              height: 2.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[
                            Card(
                              color: CurrentTheme.backgroundColor,
                              elevation: 10,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight:  Radius.circular(40),bottomRight: Radius.circular(40)),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                width:MediaQuery.of(context).size.width/1.40,
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                      height: 40,
                                      child:CupertinoTextField(
                                        textCapitalization: TextCapitalization.words,
                                        cursorColor: CurrentTheme.primaryColor,
                                        style: TextStyle(),
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 0,style: BorderStyle.none)
                                        ),
                                        keyboardType: TextInputType.name,
                                        controller: nameController,
                                        placeholder: 'Name',
                                        placeholderStyle: TextStyle(color: CurrentTheme.primaryText),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      height: 40,
                                      child: CupertinoTextField(
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 0,style: BorderStyle.none)
                                        ),
                                        controller: phoneController,
                                        clearButtonMode:
                                        OverlayVisibilityMode.editing,
                                        keyboardType: TextInputType.phone,
                                        maxLines: 1,
                                        placeholder: '+91...',
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            ),
                            RaisedButton(
                              shape: CircleBorder(
                                  side: BorderSide(color: Colors.transparent)
                              ),
                              elevation: 10,
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(gradient: LinearGradient(begin:Alignment.centerLeft,end:Alignment.centerRight,colors: CurrentTheme.buttonGradient),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                  child:Icon(Icons.arrow_forward,color: CurrentTheme.floatingButtonText,)
                              ),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if(phoneController.text.substring(0,3)!='+91')phoneController.text="+91"+phoneController.text;
                                if (phoneController.text.isNotEmpty&&nameController.text.isNotEmpty) {
                                  UserDetail.name=nameController.text;
                                  UserDetail.mobileNumber=phoneController.text.replaceFirst("+91","");
                                  loginStore.getCodeWithPhoneNumber(context,
                                      phoneController.text.toString());
                                }
                                else if(phoneController.text.isEmpty){
                                  loginStore.loginScaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      'Please enter a phone number',textScaleFactor:1,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ));
                                }
                                else {
                                  loginStore.loginScaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      'Please enter Your Name',textScaleFactor:1,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ));
                                }
                              },
                            )
                          ])),
                      SizedBox(height: 30,),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10),
                        child: Text("We will send an SMS message to verify your phone number.",
                          textScaleFactor: 1,maxLines: 2,overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 15.0,
                              color: CurrentTheme.primaryText
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
