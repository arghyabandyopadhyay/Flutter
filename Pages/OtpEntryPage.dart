import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:ArghyaBandyopadhyay/Stores/login_store.dart';
import 'package:ArghyaBandyopadhyay/theme.dart';
import 'package:ArghyaBandyopadhyay/Widgets/LoadingIndicator.dart';

import 'package:ArghyaBandyopadhyay/Painters/LoginPagePainter.dart';

class OtpEntryPage extends StatefulWidget {
  const OtpEntryPage({Key key}) : super(key: key);
  @override
  _OtpEntryPageState createState() => _OtpEntryPageState();
}

class _OtpEntryPageState extends State<OtpEntryPage> {
  String text = '';
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoadingIndicator(
            inAsyncCall: loginStore.isOtpLoading,
            child: Scaffold(
              backgroundColor: CurrentTheme.backgroundColor,
              key: loginStore.otpScaffoldKey,
              resizeToAvoidBottomInset: false,
              body:CustomPaint(
                painter: LoginPagePainter(),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20),
                          child: Text(
                              'Enter 6 digits verification code sent to your number',textScaleFactor:1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: CurrentTheme.primaryText,
                                fontSize: 26,))),
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
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(2),
                                    child: OTPTextField(
                                      length: 6,
                                      keyboardType: TextInputType.number,
                                      width: MediaQuery.of(context).size.width*0.65,
                                      textFieldAlignment: MainAxisAlignment.spaceAround,
                                      fieldWidth: 40,
                                      fieldStyle: FieldStyle.box,
                                      style: TextStyle(
                                          fontSize: 17
                                      ),
                                      onCompleted: (pin) {
                                        text=pin;
                                        loginStore.validateOtpAndLogin(context, pin);
                                      },
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
                                      child:Icon(Icons.done,color: CurrentTheme.floatingButtonText,)
                                  ),
                                  onPressed: () {
                                    loginStore.validateOtpAndLogin(context, text);
                                  },
                                )
                              ])),
	              		SizedBox(height: 30,),
		                Container(
		                  margin: const EdgeInsets.symmetric(
		                      horizontal: 10),
		                  child: Text("Enter 6-digit code.",
		                    textScaleFactor: 1,maxLines: 2,overflow: TextOverflow.ellipsis,
		                    textAlign: TextAlign.center,
		                    style: new TextStyle(
		                      color: CurrentTheme.primaryText,
		                      fontSize: 15.0,
		                      height: 1.5,),
		                  ),)
                    ],
                  ),
                ),
              )
            ),
          ),
        );
      },
    );
  }
}