import 'package:flutter/material.dart';
import 'global.dart';
import 'package:intl/intl.dart';

class AppointmentListPage extends StatefulWidget {
  @override createState() => AppointmentListState();
}
class AppointmentListState extends State {


  var canCreate = false;
  var nMap = {};

  @override
  void initState() {
    super.initState();
    getRoles().then((_) => getAppointmentList());
  }

  void getAppointmentList() {
    Set role3Set, appointmentSet;
    if (roles3 != null) {
      role3Set = roles3.values.toSet();
      appointmentSet = roles3.keys.toSet();
    } else {
      role3Set = Set();
      appointmentSet = Set();
    }
    appointmentSet.add('ALL');
    canCreate = role3Set.contains('teacher')
        || role3Set.contains('student')
        || role3Set.contains('administrator');

    for (var c in appointmentSet) {

      print(c);
      var nRef = dbRef.child('appointment/$c/notifications');
      nRef.onValue.listen((event) {
        if (event.snapshot.value == null) nMap.remove(c);
        else nMap[c] = (event.snapshot.value as Map).values.toList();
        if (mounted) setState(() {});

        print(nMap);
      });
    }
  }

  @override Widget build(BuildContext context) {
    var widgetList = <Widget>[];

    var data = List();
    for (List c in nMap.values)
      data.addAll(c);
    data.sort((a, b) => b['createdAt'] - a['createdAt']);
// for (var i = 1; i <= 20; i++) {
// var item = 'Notification $i';
    for (var i=0; i<data.length; i++){
      var item = data[i];
      var title = item['title'];
      var appointment = item['appointment'];
      var datetime = DateTime.fromMillisecondsSinceEpoch(item['createdAt']);
      var createdAt = DateFormat('EEE, MMMM d, y H:m:s',
          'en_US').format(datetime);

      widgetList.add(
          ListTile(
              leading: Icon(Icons.notifications),

              // title: Text('Item $i'),
              // trailing: Icon(Icons.face),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(createdAt,
                    style: TextStyle(fontSize: 10.0, color: Colors.blueGrey),),
                ],
              ),
              trailing: Text(appointment.replaceAll(' ', '\n'),
                textAlign: TextAlign.right,),

              onTap: () {

                notificationSelection = item;
                Navigator.pushNamed(context, '/appointmentView');
              }



          )
      );
    }
    return Scaffold(

      floatingActionButton: (canCreate)?
      FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>Navigator.pushNamed(context, '/appointmentCreate'),
      ) : null,

      appBar: AppBar(title: Text('Appointment List'),),
      body: ListView(
        children: widgetList,
        padding: EdgeInsets.all(20.0),
      ),
    );
  }
}