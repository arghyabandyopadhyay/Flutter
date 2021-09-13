//This Page should be use as the Main page of you application
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:arghyaBandyopadhyay/Global.dart';
import 'package:arghyaBandyopadhyay/Modules/SharedPreferencesHandler.dart';
import 'package:arghyaBandyopadhyay/Modules/UniversalModule.dart';
import 'package:arghyaBandyopadhyay/Models/MotherJsonModel.dart';
import 'package:arghyaBandyopadhyay/Pages/SplashPage.dart';
import 'package:arghyaBandyopadhyay/Pages/UniversalPages/PageToBeDirectedTo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Brightness brightness;
  brightness = await getIsDark() ? Brightness.dark: Brightness.light;
  runApp(App(brightness: brightness,));
}
class App extends StatefulWidget {
  final Brightness brightness;
  const App({Key key, this.brightness}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}
class _AppState extends State<App> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(debugLabel:"navigator");
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  void initialise()  async {
    if (Platform.isIOS) {
      // request permissions if we're on android
      _fcm.requestNotificationPermissions(IosNotificationSettings());
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      UserDetail.deviceModel=iosInfo.model;
      UserDetail.deviceID=iosInfo.identifierForVendor;
    }
    else if(Platform.isAndroid){
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      UserDetail.deviceModel=androidInfo.model;
      UserDetail.deviceID=androidInfo.androidId;
    }
    UserDetail.deviceToken=await FirebaseMessaging().getToken();
    androidInitializationSettings=AndroidInitializationSettings('@mipmap/ic_launcher');
    iosInitializationSettings=IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings=InitializationSettings(android: androidInitializationSettings,iOS: iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
  }
  Future<void> _serialiseAndNavigate(Map<String, dynamic> message) async {
    await fetchPage();
    var notificationData = message['data'];
    String view = notificationData['view'];
    if (view != null) {
      if (view == 'PageToBeDirectedTo') {
        navigatorKey.currentState.push(CupertinoPageRoute(builder: (context)=>PageToBeDirectedTo()));
      }
    }
  }
  Future<void> _showNotifications(Map<String, dynamic> message) async {
    await fetchPage();
    await notification(message);
  }
  Future<void> notification(Map<String, dynamic> message) async {
    AndroidNotificationDetails androidNotificationDetails=AndroidNotificationDetails(
        "FLUTTER_NOTIFICATION_CLICK",
        "channel Title",
        "channel body",
        priority: Priority.high,
        importance: Importance.max,
        ticker: 'test');
    IOSNotificationDetails iosNotificationDetails=IOSNotificationDetails();
    NotificationDetails notificationDetails=NotificationDetails(android: androidNotificationDetails,iOS: iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(0, message['notification']['title'], message['notification']['body'], notificationDetails,payload: message['data']['view']+"|"+message['data']['uid'].toString()+"|"+message['data']['particulars']);
  }
  Future<void> onSelectNotification(String payload){
    if(payload!=null)
    {
      List a=payload.split("|");
      if(a[0]=="voucherPage")navigatorKey.currentState.push(CupertinoPageRoute(builder: (context)=>PageToBeDirectedTo()));
    }
  }

  Future onDidReceiveLocalNotification(int id, String title,String body, String payload) async{
    return CupertinoAlertDialog(title: Text(title),content: Text(body),actions: [CupertinoDialogAction(child: Text("Okay"),isDefaultAction: true,onPressed: (){print("dfsdf");},)],);
  }
  @override
  void initState() {
    super.initState();
    initialise();
    _fcm.configure(
      // Called when the app is in the foreground and we receive a push notification
      onMessage: (Map<String, dynamic> message) async {
        _showNotifications(message);
      },
      onBackgroundMessage: Platform.isIOS?null:myBackgroundMessageHandler,
      // Called when the app has been closed comlpetely and it's opened
      // from the push notification.
      onLaunch: (Map<String, dynamic> message) async {
        _serialiseAndNavigate(message);
      },
      // Called when the app is in the background and it's opened
      // from the push notification.
      onResume: (Map<String, dynamic> message) async {
        _serialiseAndNavigate(message);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
          appBarTheme: AppBarTheme(
              color: CurrentTheme.primaryColor,
              textTheme: TextTheme(
                bodyText1: UserDetail.appBarTextStyle,
                bodyText2: UserDetail.appBarTextStyle,
                button: UserDetail.appBarTextStyle,
                caption: UserDetail.appBarTextStyle,
                subtitle2: UserDetail.appBarTextStyle,
                subtitle1: UserDetail.appBarTextStyle,
                headline1: UserDetail.appBarTextStyle,
                headline2: UserDetail.appBarTextStyle,
                headline3: UserDetail.appBarTextStyle,
                headline4: UserDetail.appBarTextStyle,
                headline5: UserDetail.appBarTextStyle,
                headline6: UserDetail.appBarTextStyle,
              ),
              iconTheme: IconThemeData(color: CurrentTheme.appBarTextColor)
          ),
          brightness: widget.brightness,
          primaryColor: Colors.white,
          backgroundColor: CurrentTheme.backgroundColor,
          accentColor: CurrentTheme.primaryColor,
        ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              theme: theme,
              home: SplashPage()
          );
        });
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  return _AppState()._serialiseAndNavigate(message);
}