import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart' as random;
import 'dart:convert';
import './homepage.dart';
import './editProfile.dart';
import './showInterests.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title, this.uid}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();

  final String title;
  final String uid;
}

class _ProfilePageState extends State<ProfilePage> {
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
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Color(0xFF306856),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EditProfilePage(
                                        title: "Edit Profile",
                                        uid: widget.uid,
                                        name: this.fname ?? '',
                                        uBio: this.bio ?? '',
                                      ))).then((v) {
                                          _updatePage();
                                      });
                        })
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
                InterestView(widget.uid, 5, true),
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
