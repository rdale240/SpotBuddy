import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart' as random;
import 'dart:convert';
import './homepage.dart';
import './addInterest.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key, this.title, this.uid, this.name, this.uBio, this.location}) : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState();


  final String title;
  final String uid;
  final String name;
  final String uBio;
  final String location;
}

class _EditProfilePageState extends State<EditProfilePage> {
  String url = "http://3.18.95.167/updateProfile/";
  TextEditingController bio = TextEditingController();
  var list;
  String fname;
  String biography;
  List<String> interestList = [];

  
 

  void _initializePage(){
    bio.text =widget.uBio;
  }


  void _updatePage(){
    _initializePage();
  }

  void _saveChanges(String uid) {
    http.post(url, body: {
        "biography":bio.text,
        "uid":uid,
      } ).then((response) {
        print("Edit Profile  - " +"Response status: ${response.statusCode}");
        print("Edit Profile  - " +"Response body: ${response.body}");
        Navigator.of(context).pop('String');
    });
  }


  @override
  Widget build(BuildContext context) {

    var interestListings = () {
      if (interestList != null) {
        return <Widget>[
          Text("Food"+ "     ",
              style: Theme.of(context).textTheme.body1),
          Text("Music" + "     ",
              style: Theme.of(context).textTheme.body1),
          Text("Travel" + "     ",
              style: Theme.of(context).textTheme.body1),
        ];
      } else {
        return <Widget>[
          Text("Loading..." + "     ",
              style: Theme.of(context).textTheme.body1),
          Text("" + "      ",
              style: Theme.of(context).textTheme.body1),
          Text("" + "     ",
              style: Theme.of(context).textTheme.body1),
        ];
      }
    };
    //bio.text = random.randomAlpha(500);
    if (this.fname == null)
    {
    _updatePage();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF306856),
          actions: <Widget>[
            IconButton(
                icon: Icon(IconData(57697, fontFamily: 'MaterialIcons')),
                color: Colors.white,
                tooltip: 'Profile',
                onPressed: () {_saveChanges(widget.uid);})
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
                    Text(this.fname ?? widget.name),
                    SizedBox(height: 16.0),
                    Text(widget.location),
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
                  //onChanged: (t) => bio.text =t,
                  style: Theme.of(context).textTheme.body1,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                ),
                SizedBox(height: 16.0),
                InterestList(widget.uid, 5, true),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: interestListings(),
                ),
                  ],
                )
              ],
            ),
        );
  }
}
