import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../notifications_api.dart';

class FirstPage extends StatefulWidget {
  final String? payload;
  const FirstPage({Key? key,this.payload}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with WidgetsBindingObserver {
  AppLifecycleState? appLifecycleState;
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    var androidInitialize =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    localNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void dispose() {
    debugPrint("dispose cagırıldı");
    WidgetsBinding.instance?.removeObserver(this);

    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    setState(() {
      appLifecycleState = state;
      debugPrint("[MyAppState] $appLifecycleState");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("First Page"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  =>
           NotificationApi.showNotification(
              title: "Title", body: "Oww yeah", payload: "PayLoad Area")
        ,
        child: const Icon(Icons.padding),
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.payload??"",style:const TextStyle(fontSize:36),),
           const SizedBox(height:20,),
            Text(
              appLifecycleState.toString(),
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
