import 'package:flutter/material.dart';
import 'global.dart';
import 'package:intl/intl.dart';

class ForumListPage extends StatefulWidget {
  @override createState() => ForumListState();
}

class ForumListState extends State {


  var canCreate = false;

  var nMap = {};


  @override

  void initState() {
    super.initState();
    getRoles().then((_) => getForumList());
  }





  void getForumList() {
    Set roleSet, forumSet;
    if (roles2 != null) {
      roleSet = roles.values.toSet();
      forumSet = roles.keys.toSet(); }else{
      roleSet = Set();
      forumSet = Set();
    }
    forumSet.add('ALL');
    canCreate = roleSet.contains('teacher')
        || roleSet.contains('student')
        || roleSet.contains('administrator'); for (var c in forumSet) {
      var nRef = dbRef.child('forum/$c/forum');
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
      var forum = item['forum'];
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
              trailing: Text(forum.replaceAll(' ', '\n'),
                textAlign: TextAlign.right,),



              onTap: () {
                notificationSelection = item;
                Navigator.pushNamed(context, '/forumView');
              }


          )
      );
    }
    return Scaffold(

      floatingActionButton: (canCreate)?
      FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>Navigator.pushNamed(context, '/forumCreate'),
      ) : null,

      appBar: AppBar(title: Text('Forum'),),
      body: ListView(
        children: widgetList,
        padding: EdgeInsets.all(20.0),
      ),
    );
  }
}