import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart' as random;
import 'dart:convert';
import './homepage.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key, this.title}) : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState();

  final String title;
}

class _EditProfilePageState extends State<EditProfilePage> {
  String url = "http://18.222.171.109/updateProfile/";
  TextEditingController bio = TextEditingController();
  var list;
  String fname;
  String biography;

  void _initializePage(){
    http.get(url + '?uid='+'14' ).then((response) {
      list = json.decode(response.body);
        print(list[0]["first_name"]);
          fname = list[0]["first_name"];
          bio = list[0]["biography"];        
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
    });
  }

  void _updatePage(){
    _initializePage();
    setState(() {
      
    });
  }

  void _saveChanges() {
    http.post(url, body: {
        "biography":bio.text,
        "uid":"14",
      } ).then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        Navigator.pop(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    //bio.text = random.randomAlpha(500);
    
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF306856),
          actions: <Widget>[
            IconButton(
                icon: Icon(IconData(57697, fontFamily: 'MaterialIcons')),
                color: Colors.white,
                tooltip: 'Profile',
                onPressed: () {_saveChanges();})
          ],
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  "assets/user.png",
                  height: 100.0,
                ),
                SizedBox(width: 48.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Name"),
                    SizedBox(height: 16.0),
                    Text("Age Gender"),
                    SizedBox(height: 16.0),
                    Text("Focused Location"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "About Me",
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: bio,
                  onChanged: (text) => bio.text=text,
                  style: Theme.of(context).textTheme.body1,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                ),
                SizedBox(height: 16.0),
                Text(
                  "Interests",
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(random.randomAlpha(8) + "     ",
                        style: Theme.of(context).textTheme.body1),
                    Text(random.randomAlpha(8) + "      ",
                        style: Theme.of(context).textTheme.body1),
                    Text(random.randomAlpha(8) + "     ",
                        style: Theme.of(context).textTheme.body1),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
