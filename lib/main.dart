import 'package:app_lifecycle_notification/notifications_api.dart';
import 'package:flutter/material.dart';
import 'pages/first_page.dart';
import 'package:timezone/data/latest.dart' as tz;
void main() {
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    NotificationApi.init();
    listenNotifications();

  }


  void listenNotifications()=>NotificationApi.onNotifications.listen(onClickedNotification);

  void onClickedNotification(String? payload)=>Navigator.of(context).push(MaterialPageRoute(builder:(context)=>FirstPage(payload:payload,)));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Main Page',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(onPressed:()=>NotificationApi.showScheduledNotification(title:"Dinner Time",body:"Time is 8 pm",payload:"Wake up dude",scheduledDate: DateTime.now().add(const Duration(seconds:8))), child:const Text("scheduled"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  =>
        NotificationApi.showNotification(
        title: "Title", body: "Oww yeah", payload: "PayLoad Area")
    ,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
