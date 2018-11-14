import 'package:flutter/material.dart';
import 'home.dart';
import 'notification_list.dart';
import 'notification_view.dart';
import 'notification_create.dart';
import 'forum_create.dart';
import 'forum_list.dart';
import 'forum_view.dart';
import 'global.dart';
import 'appointment_create.dart';
import 'appointment_list.dart';
import 'appointment_view.dart';

void main() {


  firebaseInit();


  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: <String, WidgetBuilder>{


        '/notificationCreate':
            (BuildContext context) => NotificationCreationPage(),
        '/notificationList':
            (BuildContext context) => NotificationListPage(),
        '/notificationView':
            (BuildContext context) => NotificationViewPage(),


        '/forumCreate':
            (BuildContext context) => ForumCreatePage(),
        '/forumList':
            (BuildContext context) => ForumListPage(),
        '/forumView':
            (BuildContext context) => ForumViewPage(),

        '/appointmentView':
            (BuildContext context) => AppointmentViewPage(),
        '/appointmentCreate':
            (BuildContext context) => AppointmentCreatePage(),
        '/appointmentList':
            (BuildContext context) => AppointmentListPage(),
      },
    );
  }


}