import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart' as random;
import 'dart:convert';
import './homepage.dart';
import './editProfile.dart';

class OtherProfilePage extends StatefulWidget {
  OtherProfilePage({Key key, this.title, this.uid, this.userUID}) : super(key: key);
  @override
  _OtherProfilePageState createState() => _OtherProfilePageState();

  final String title;
  final String uid;
  final String userUID;
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  String url = "http://3.18.95.167/getProfile/";
  String fname = "";
  String bio = "";
  List list = List();

   void initState() {
    super.initState();
    _initializePage();
  }

  void _initializePage() {
   http.get(url + '?uid=' + widget.uid).then((response){
      this.list = json.decode(response.body);
      print(this.list[0]["first_name"]);
      print("Profile - " +"Response status: ${response.statusCode}");
      print("Profile - " +"Response body: ${response.body}");
      setState(() {
        this.fname=list[0]["first_name"];
        this.bio=list[0]["biography"];
    });
    });

    
    
  }

  _updatePage(){
    _initializePage();
    print("Update List ${this.list}");
    
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile", style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF306856),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.person_add),
                color: Colors.white,
                tooltip: 'Add Friend',
                onPressed: () {
                  http.post('http://3.18.95.167/createFriendship', body: 
                   {
                     "sender": widget.userUID,
                     "receiver":widget.uid,
                   }).then((response){
                     //ui changes
                    print("Request Sent");
                   }
                );
                }
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Image.asset(
                      "assets/user.png",
                      height: 100.0,
                    ),
                    
                  ],
                ),
                SizedBox(width: 48.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(fname),
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
                Text(bio, style: Theme.of(context).textTheme.body1),
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
