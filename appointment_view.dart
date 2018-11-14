import 'global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';
class AppointmentViewPage extends StatefulWidget {
  @override createState() => AppointmentViewState();
}
class AppointmentViewState extends State {
  var images = [];
  @override
  void initState() {
    super.initState();
    if (notificationSelection['images'] != null)
      for (var url in notificationSelection['images']) {
        http.get(url).then((response){
          images.add(response.bodyBytes);
          if (mounted)
            setState((){});
        });
      }
  }
  @override
  Widget build(BuildContext context) {
    var data = notificationSelection;
    var title = data['title'];
    var appointment = data['appointment'];
    var content = data['content'];
    var createdBy = data['createdBy'];
    var datetime = DateTime.fromMillisecondsSinceEpoch(data['createdAt']);
    var createdAt = DateFormat('EEE, MMMM d, y H:m:s', 'en_US').format(datetime);
    var childWidgets = <Widget>[
      Text(appointment, style: TextStyle(color: Colors.blue),),
      Divider(color: Colors.transparent,),
      Text(content),
    ];
    var width = MediaQuery.of(context).size.width - 120;
    for (var i in images) {
      childWidgets.add(Divider(color: Colors.transparent));
      childWidgets.add(Image.memory(i, width: width));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Column(
            children: childWidgets,
          ),
        ],
      ),
      persistentFooterButtons: <Widget>[
        Text('$createdAt by $createdBy'),
        (['teacher', 'student','administrator'].contains(roles3[appointment]))?
        IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () => delete(),
        ):null,
      ],
    );
  }
  void delete() {
    var key = notificationSelection['key'];
    var appointment = notificationSelection['appointment'];
    dbRef.child('appointment/$appointment/notifications/$key').remove();
    for (var i = 0; i < images.length; i++)
      storageRef.child('$key/$i').delete();
    Navigator.pop(context);
  }
}