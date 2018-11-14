import 'package:flutter/material.dart';
import 'global.dart';
import 'package:intl/intl.dart';

class NotificationListPage extends StatefulWidget {
  @override createState() => NotificationListState();
}

  class NotificationListState extends State {


    var canCreate = false;

    var nMap = {};


    @override

    void initState() {
    super.initState();
    getRoles().then((_) => getNotificationList());
    }





    void getNotificationList() {
      Set roleSet, courseSet;
      if (roles != null) {
        roleSet = roles.values.toSet();
        courseSet = roles.keys.toSet(); }else{
        roleSet = Set();
        courseSet = Set();
      }
      courseSet.add('ALL');
      canCreate = roleSet.contains('teacher')
          || roleSet.contains('administrator'); for (var c in courseSet) {
        var nRef = dbRef.child('courses/$c/notifications');
        nRef.onValue.listen((event) {
          if (event.snapshot.value == null) nMap.remove(c);
          else nMap[c] = (event.snapshot.value as Map).values.toList();

          if (mounted) setState(() {});
        });
      }
    }








  @override Widget build(BuildContext context) {

  var widgetList = <Widget>[];



  var data = List();
  data.sort((a, b) => b['createdAt'] - a['createdAt']);
  for (List c in nMap.values)
    data.addAll(c);

// for(vari=1;i<=20;i++){
    //      var item = 'Notification $i';
    for (var i=0; i<data.length; i++){
      var item = data[i];
      var title = item['title'];
      var course = item['course'];
      var datetime = DateTime.fromMillisecondsSinceEpoch(item['createdAt']);
      var createdAt = DateFormat('EEE, MMMM d, y H:m:s',
          'en_US').format(datetime);





      widgetList.add(
           ListTile(
           leading: Icon(Icons.notifications),



               title: Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: <Widget>[
                   Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
                   Text(createdAt,
                     style: TextStyle(fontSize: 10.0, color: Colors.blueGrey),),
                 ],
               ),
               trailing: Text(course.replaceAll(' ', '\n'),
                 textAlign: TextAlign.right,),



               onTap: () {
                 notificationSelection = item;
                 Navigator.pushNamed(context, '/notificationView');
               }


           )
    );
  }
  return Scaffold(

    floatingActionButton: (canCreate)?
    FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: ()=>Navigator.pushNamed(context, '/notificationCreate'),
    ) : null,

    appBar: AppBar(title: Text('Notifications'),),
    body: ListView(
      children: widgetList,
      padding: EdgeInsets.all(20.0),
          ),
      );
    }
  }