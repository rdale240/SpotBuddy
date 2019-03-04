import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart' as random;
import 'dart:convert';
import './homepage.dart';
import './editProfile.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();

  final String title;
}

class _ProfilePageState extends State<ProfilePage> {
  String url = "http://18.222.171.109/getProfile/";
  String fname = "";
  String bio = "";
  List list;
  
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

  @override
  Widget build(BuildContext context) {
    _initializePage();
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile", style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF306856),
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
                    MaterialButton(
                      child:Text("Edit Profile", style: TextStyle(color:Colors.white),),
                      color:Color(0xFF306856),
                      onPressed: (){
                        Navigator.push(context, 
                         MaterialPageRoute(builder: (BuildContext context) => EditProfilePage(title: "Edit Profile")));
                      }                     
                    )
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
                Text(bio,
                    style: Theme.of(context).textTheme.body1),
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
