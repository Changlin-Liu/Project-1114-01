import 'global.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NotificationCreationPage extends StatefulWidget {
  @override createState() => NotificationCreationState();
}


class NotificationCreationState extends State {

  var images = [];
  var selectedCourse = roles.keys.first;
  var title = '';
  var content = '';

  void attach(source) {
    ImagePicker.pickImage(source: source).then((file){
      if (file != null)
        setState(() => images.add(file));
    });
  }

  void post() {
    var ref = dbRef.child('courses/$selectedCourse/notifications').push();

    ref.set({
      'key' : ref.key,
      'course' : selectedCourse,
      'title' : title,
      'content' : content,
      'createdAt' : DateTime.now().millisecondsSinceEpoch,
      'createdBy' : userID,
    });

    for (var i=0; i < images.length; i++) {
      var fRef = storageRef.child(ref.key + '/$i');
      var task = fRef.putFile(images[i]);
      task.future.then((snapshot) =>
          ref.child('images/$i').set(snapshot.downloadUrl.toString())
      );
    }

    Navigator.pop(context);
  }

  @override Widget build(BuildContext context) {
    var items = <DropdownMenuItem>[];
    for (var k in roles.keys) {
      var v = roles[k];
      if (['teacher', 'administrator'].contains(v))
        items.add(DropdownMenuItem(value: k, child: Text(k)));
    }

    var ddButton = DropdownButton(
      value: selectedCourse,
      items: items,
      onChanged: (course) => setState(() => selectedCourse = course),
    );

    var widgets = <Widget>[
      Text('Post to'),

      ddButton,

      TextField(
        decoration: InputDecoration(hintText: 'Title',),
        onChanged: (text) => setState(() => title = text),
      ),

      Divider(color: Colors.transparent,),

      TextField(
        decoration: InputDecoration(hintText: 'Content',),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        onChanged: (text) => setState(() => content = text),
      ),
    ];

    var width = MediaQuery.of(context).size.width - 120;

    for (var f in images) {
      widgets.add(Divider(color: Colors.transparent,));

      widgets.add(

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Image.file(f, width: width),
              IconButton(icon: Icon(Icons.cancel), iconSize: 32.0,
                onPressed: () => setState(() => images.remove(f)),
              )
            ],
          )
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Compose Notification'),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => attach(ImageSource.camera),
          ),
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: () => attach(ImageSource.gallery),
          ),

          IconButton(icon: Icon(Icons.send), onPressed: () => post(),),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[Column(children: widgets)],
      ),
    );


  }
}