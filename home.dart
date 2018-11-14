import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'global.dart';


class HomePage extends StatefulWidget {
  @override
  State createState() {
    return HomeState();
  }
}
class HomeState extends State {




  @override
  Widget build(BuildContext context) {
    if (userID != null)
      return menuScreen();
    else
      return splashScreen();
  }

  Widget splashScreen() {
    var title = 'REACH\nHKBU\n';
    var content = '\nuniversity, teachers, \nclassmates and group mates.\n\nby LIU Changlin\n\n\n';
    return Scaffold(
      backgroundColor:Colors.deepPurple,
        appBar: null,
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Text(title, style: TextStyle(fontSize: 48.0, fontFamily:
              'Times New Roman'), textAlign: TextAlign.center,),
              Text(content, style: TextStyle(fontSize: 20.0, fontFamily:
              'Times New Roman'), textAlign: TextAlign.center,),
              IconButton(
                icon: Icon(Icons.fingerprint),
                iconSize: 96.0,
                onPressed: ()=>signIn(context).then((success){
                  if (success) setState((){});
                }),

              ),

            ],
          ),
        )
    );
  }

  Widget menuScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('REACH HKBU'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_box),



            onPressed: () {
              signOut();
              setState((){});
            }
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          FlatButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.notifications, size: 48.0, color: Colors.white,),

                Text('Notifications',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),

              ],
            ),
            color: Colors.blue ,

            onPressed: () =>  Navigator.pushNamed(context, '/notificationList'),
          ),





          FlatButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.calendar_today, size: 48.0, color: Colors.white,),

                Text('Appointment',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),

              ],
            ),
            color: Colors.pink,
            onPressed: () => Navigator.pushNamed(context, '/appointmentList'),
          ),


          FlatButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.assessment, size: 48.0, color: Colors.white,),

                Text('Forum',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),

              ],
            ),
            color: Colors.deepOrange,
            onPressed: () => Navigator.pushNamed(context, '/forumList'),
          ),
        ], // <Widget>[]
      ), // GridView.count
    ); // Scaffold
  } // end of the menuScreen() method

}